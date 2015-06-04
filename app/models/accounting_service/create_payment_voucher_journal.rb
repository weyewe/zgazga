module AccountingService
  class CreatePaymentVoucherJournal
  def CreatePaymentVoucherJournal.create_confirmation_journal(payment_voucher) 
    message = "Payment Voucher"
      ta = TransactionData.create_object({
        :transaction_datetime => payment_voucher.payment_date,
        :description =>  message,
        :transaction_source_id => payment_voucher.id , 
        :transaction_source_type => payment_voucher.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payment_voucher_journal],
        :is_contra_transaction => false 
      }, true )
    
#     Credit GBCHPayable,Credit GBCH for BiayaBank,Credit/Debit GBCH for Pembulatan, Cash: Credit CashBank ,Debit BiayaBank
#     Debit Account Payable, Credit ExchangeGain or Debit ExchangeLost
#     Debit GBCH/CashBank, Credit HutangPPh21 Hutang PPh23


    if payment_voucher.is_gbch == true
#     Credit GBCHPayable
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => payment_voucher.cash_bank.exchange.gbch_payable_id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (payment_voucher.amount * payment_voucher.rate_to_idr).round(2),
        :description => message
        )
      if payment_voucher.biaya_bank > 0
#     Credit GBCH for biaya bank
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => payment_voucher.cash_bank.exchange.gbch_payable_id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (payment_voucher.biaya_bank * payment_voucher.rate_to_idr).round(2),
          :description => message
          )
      end
      
      #     Credit/Debit GBCH for Pembulatan
      if not payment_voucher.pembulatan == 0
        entry_case = NORMAL_BALANCE[:credit]  
        if payment_voucher.status_pembulatan == NORMAL_BALANCE[:credit]    
          entry_case =  NORMAL_BALANCE[:debit]
        end
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => payment_voucher.cash_bank.exchange.gbch_payable_id   ,
          :entry_case          => entry_case     ,
          :amount              => (payment_voucher.pembulatan * payment_voucher.rate_to_idr).round(2),
          :description => message
          ) 
      end
    else
#       Credit CashBank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => payment_voucher.cash_bank.account_id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (payment_voucher.amount * payment_voucher.rate_to_idr).round(2),
        :description => message
        )
      if payment_voucher.biaya_bank > 0
#     Credit CashBank for biaya bank
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => payment_voucher.cash_bank.account_id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => (payment_voucher.biaya_bank * payment_voucher.rate_to_idr).round(2),
          :description => message
          )
      end
      
      #     Credit/Debit CashBank for Pembulatan
      if not payment_voucher.pembulatan == 0
        entry_case = NORMAL_BALANCE[:credit]  
        if payment_voucher.status_pembulatan == NORMAL_BALANCE[:credit]    
          entry_case =  NORMAL_BALANCE[:debit]
        end
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => payment_voucher.cash_bank.account_id  ,
          :entry_case          => entry_case     ,
          :amount              => (payment_voucher.pembulatan * payment_voucher.rate_to_idr).round(2),
          :description => message
          ) 
      end
    end
    
#     Debit BiayaBank
    if payment_voucher.biaya_bank > 0 
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_administrasi_bank][:code]).id   ,
        :entry_case          => NORMAL_BALANCE[:debit]      ,
        :amount              => (payment_voucher.biaya_bank * payment_voucher.rate_to_idr).round(2),
        :description => message
        ) 
    end
    
    #     Credit/Debit Pembulatan
    if payment_voucher.biaya_bank > 0 
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => Account.find_by_code(ACCOUNT_CODE[:biaya_pembulatan][:code]).id   ,
        :entry_case          => payment_voucher.status_pembulatan ,
        :amount              => (payment_voucher.pembulatan * payment_voucher.rate_to_idr).round(2),
        :description => message
        ) 
    end    
    
    payment_voucher.payment_voucher_details.each do |pvd|
#     Debit Account Payable
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => pvd.payable.exchange.account_payable_id  ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (pvd.amount * pvd.payable.exchange_rate_amount).round(2),
        :description => message
      )
#       Credit ExchangeGain or Debit ExchangeLost
      if pvd.payable.exchange_rate_amount < payment_voucher.rate_to_idr
         TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:rugi_selish_kurs][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:debit]     ,
          :amount              => ((payment_voucher.rate_to_idr * pvd.rate * pvd.amount) - (pvp.payable.exchange_rate_amount * pvd.amount)).round(2),
          :description => message
          )   
      elsif pvd.payable.exchange_rate_amount > payment_voucher.rate_to_idr
         TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:pendapatan_selisih_kurs][:code]).id  ,
           :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => ((pvp.payable.exchange_rate_amount * pvd.amount) - (payment_voucher.rate_to_idr * pvd.rate * pvd.amount)).round(2),
          :description => message
          )     
      end
      
      if pvd.pph_21 > 0
#         Credit Hutang PPh 21
        pph_21 = (payment_voucher.rate_to_idr * pvd.pph_21).round(2)
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_pph_ps_21][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => pph_21,
          :description => message
          )  
        if payment_voucher.is_gbch == true
#           Debit GBCH for Hutang PPh 21 
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => pvd.payable.exchange.gbch_payable_id   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => pph_21,
            :description => message
            )  
        else
#           Debit CashBank for Hutang PPh 21
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => payment_voucher.cash_bank.account_id,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => pph_21,
            :description => message
            )  
        end
      end
      
      if pvd.pph_23 > 0
#         Credit Hutang PPh 23
        pph_23 = (payment_voucher.rate_to_idr * pvd.pph_23).round(2)
        TransactionDataDetail.create_object(
          :transaction_data_id => ta.id,        
          :account_id          => Account.find_by_code(ACCOUNT_CODE[:hutang_pph_ps_23][:code]).id  ,
          :entry_case          => NORMAL_BALANCE[:credit]     ,
          :amount              => pph_23,
          :description => message
          )  
        if payment_voucher.is_gbch == true
#           Debit GBCH for Hutang PPh 23
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => pvd.payable.exchange.gbch_payable_id   ,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => pph_23,
            :description => message
            )  
        else
#           Debit CashBank for Hutang PPh 23
          TransactionDataDetail.create_object(
            :transaction_data_id => ta.id,        
            :account_id          => payment_voucher.cash_bank.account_id,
            :entry_case          => NORMAL_BALANCE[:debit]     ,
            :amount              => pph_23,
            :description => message
            )  
        end
      end
      
    end    
    ta.confirm
  end
    
    def CreatePaymentVoucherJournal.undo_create_confirmation_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payment_voucher_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
    def CreatePaymentVoucherJournal.create_reconcile_journal(payment_voucher) 
      message = "Payment Request"
        ta = TransactionData.create_object({
          :transaction_datetime => payment_voucher.payment_date,
          :description =>  message,
          :transaction_source_id => payment_voucher.id , 
          :transaction_source_type => payment_voucher.class.to_s ,
          :code => TRANSACTION_DATA_CODE[:payment_voucher_journal],
          :is_contra_transaction => false 
        }, true )


  #      Credit CashBank, Debit GBCH
      biaya_pembulatan = 0 
      if payment_voucher.status_pembulatan == NORMAL_BALANCE[:credit]
        biaya_pembulatan = payment_voucher.pembulatan
      else
        biaya_pembulatan = payment_voucher.pembulatan * -1
      end
      total = payment_voucher.amount - (payment_voucher.total_pph_21 + payment_voucher.total_pph_23 - payment_voucher.biaya_bank + biaya_pembulatan)
  #     Credit CashBank
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => payment_voucher.cash_bank.account_id  ,
        :entry_case          => NORMAL_BALANCE[:credit]     ,
        :amount              => (total * payment_voucher.rate_to_idr).round(2),
        :description => message
        )

  #     Debit GBCH
      TransactionDataDetail.create_object(
        :transaction_data_id => ta.id,        
        :account_id          => payment_voucher.cash_bank.exchange.gbch_payable_id ,
        :entry_case          => NORMAL_BALANCE[:debit]     ,
        :amount              => (total * payment_voucher.rate_to_idr).round(2),
        :description => message
        )
      ta.confirm
    end
    
    def CreatePaymentVoucherJournal.undo_create_reconcile_journal(object)
      last_transaction_data = TransactionData.where(
        :transaction_source_id => object.id , 
        :transaction_source_type => object.class.to_s ,
        :code => TRANSACTION_DATA_CODE[:payment_voucher_journal],
        :is_contra_transaction => false
      ).order("id DESC").first 
      last_transaction_data.create_contra_and_confirm if not last_transaction_data.nil?
    end
    
  end
end