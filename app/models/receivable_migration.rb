class ReceivableMigration < ActiveRecord::Base
        belongs_to :exchange
    belongs_to :contact 
    
    validate :amount_base_and_amount_foreign_cant_both_zero
    
    def amount_base_and_amount_foreign_cant_both_zero
        zero_value  = BigDecimal("0")
        if amount_base_exchange == zero_value and amount_foreign_exchange == zero_value
            self.errors.add(:generic_errors, "Tidak boleh 0 untuk amount payable")
            return self 
        end
    end
    
    
    
    def self.create_object( params  ) 
        new_object = self.new 
        new_object.nomor_surat = params[:nomor_surat]
        new_object.contact_id = params[:contact_id]
        new_object.exchange_id = params[:exchange_id]
        new_object.amount_base_exchange  = BigDecimal( params[:amount_base_exchange] || '0') 
        new_object.amount_foreign_exchange =  BigDecimal( params[:amount_foreign_exchange] || '0')
        new_object.invoice_date = params[:invoice_date]
        new_object.tukar_faktur_date   = params[:tukar_faktur_date]
        
        if new_object.save
          
          new_object.calculate_amount_receivable_and_exchange_rate 
          
          
          new_object.reload
        
          new_object.generate_receivable
          
          AccountingService::CreateReceivableMigrationJournal.create_confirmation_journal(new_object)
        end
        
        return new_object  
            
            
            
    end
    
    def calculate_amount_receivable_and_exchange_rate
      exchange_rate = BigDecimal("1")
      if amount_foreign_exchange == BigDecimal("0")
        self.amount_receivable  = self.amount_base_exchange
      else
        
        puts "non IDR"
        if amount_base_exchange == BigDecimal("0")
          # no idea
        else
          
          exchange_rate =  ( amount_base_exchange /  (0.1 * amount_foreign_exchange ) ).round(7)
          
          self.amount_receivable = amount_foreign_exchange    + 
                  (amount_base_exchange/exchange_rate).round(2)
        end
        
      end
      
      self.exchange_rate_amount = exchange_rate
      self.save
      
      # puts "Exchange rate amount: #{self.exchange_rate_amount.to_s}"
    end
    
    def generate_receivable
 
 
    
        
      Receivable.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :source_date => self.invoice_date , 
        :contact_id => self.contact_id,
        :amount => self.amount_receivable ,  
        :due_date => self.invoice_date ,  
        :exchange_id => self.exchange_id,
        :exchange_rate_amount => self.exchange_rate_amount,
        :source_code => self.nomor_surat,
        :received_date => self.tukar_faktur_date
      ) 
    end
end
