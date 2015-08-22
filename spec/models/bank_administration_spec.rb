require 'spec_helper'

describe BankAdministration do
  before(:each) do
    @exc_1 = Exchange.create_object(
      :name => "@name_1",
      :description => "@description_1",
    )
    
    @exr_1 = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("5000")
    )
    
    
    @cb1 = CashBank.create_object(
      :name => "source name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
    )
    
    @cb2 = CashBank.create_object(
      :name => "target name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
    )
    
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )
    @coa_2 = Account.create_object(
      :code => "1110k3o",
      :name => "KAS3",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      ) 
    @coa_3 = Account.create_object(
      :code => "11102324124k3o",
      :name => "KAS233",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      ) 
    @coa_4 = Account.create_object(
      :code => "111230k3o",
      :name => "KA24123S3",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      ) 
    @administration_date_1 = DateTime.now
    @administration_date_2 = DateTime.now + 1.days
    @description_1 = "description_1"
    @description_2 = "description_2"
    @no_bukti_1 = "no_bukti_1"
    @no_bukti_2 = "no_bukti_2"
  end
  
  context "Create BankAdministration" do
    before(:each) do
      @ba = BankAdministration.create_object(
        :cash_bank_id => @cb1.id,
        :administration_date => @administration_date_1,
        :description => @description_1,
        :no_bukti => @no_bukti_1
        )
    end
    
    it "should create BankAdministration" do
      @ba.errors.size.should == 0
    end
    
    context "Create BankAdministrationDetail" do
      before(:each) do
        @bad = BankAdministrationDetail.create_object(
          :bank_administration_id => @ba.id,
          :account_id => @coa_1.id,
          :description => "description_1",
          :status => NORMAL_BALANCE[:debit],
          :amount => BigDecimal("20000")
          )
        @bad2 = BankAdministrationDetail.create_object(
          :bank_administration_id => @ba.id,
          :account_id => @coa_2.id,
          :description => "description_1",
          :status => NORMAL_BALANCE[:credit],
          :amount => BigDecimal("20000")
          )
         @bad3 = BankAdministrationDetail.create_object(
          :bank_administration_id => @ba.id,
          :account_id => @coa_3.id,
          :description => "description_1",
          :status => NORMAL_BALANCE[:credit],
          :amount => BigDecimal("20000")
          )
         @bad4 = BankAdministrationDetail.create_object(
          :bank_administration_id => @ba.id,
          :account_id => @coa_4.id,
          :description => "description_1",
          :status => NORMAL_BALANCE[:credit],
          :amount => BigDecimal("20000")
          )
          
      end
      
      it "should create BankAdministrationDetail" do
        @bad.errors.size.should == 0
        @bad2.errors.size.should == 0
      end
      
      context "Confirm BankAdministration" do
        before(:each) do
          @ba.reload
          @ba.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm BankAdministration" do
          @ba.errors.size.should == 0
          @ba.is_confirmed.should == true
        end
        
        it "should create 1 TransactionalData" do
         td = TransactionData.where(
            :transaction_source_type => @ba.class.to_s,
            :transaction_source_id => @ba.id
            )
          td.count.should == 1
        end
        
        context "Unconfirm BankAdministration" do
          before(:each) do
            @ba.unconfirm_object
          end
          
          it "should unconfirm BankAdministration" do
            @ba.errors.size.should == 0
            @ba.is_confirmed.should == false
          end
          
        end
      end
      
    end
  end
end
