require 'spec_helper'

describe PayableMigration do
 before(:each) do
    @cg_1 = ContactGroup.create_object(
    :name => "Group1" ,
    :description => "Description1"
    )
    
  @ct_1 = Contact.create_object(
    :name => "name_1" ,
    :address => "address_1",
    :delivery_address => "delivery_address_1",
    :description => "description_1",
    :npwp => "npwp_1" ,
    :contact_no => "9928321",
    :sic => "sic_1",
    :sic_contact_no => "1232133",
    :email => "email1@email.com",
    :is_taxable => true,
    :tax_code => TAX_CODE[:code_01],
    :contact_type => CONTACT_TYPE[:supplier],
    :default_payment_term => 30,
    :nama_faktur_pajak => "nama_faktur_pajak_1",
    :contact_group_id => @cg_1.id
    )
    
    @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => "description_1",
    )
    
  end
  
  it "should be allowed to create payable_migration" do
      @pm = PayableMigration.create_object(
        :nomor_surat => "nomor_surat_1",
        :contact_id => @ct_1.id,
        :exchange_id => @exc_1.id,
        :amount_payable => BigDecimal("10000"),
        :exchange_rate_amount => BigDecimal("10"), 
        :invoice_date => DateTime.now 
          
          
        )
        
    @pm.errors.size.should ==  0
    @pm.should be_valid
  end
  
  context "Create PayableMigration" do
    before(:each) do
      @pm = PayableMigration.create_object(
        :nomor_surat => "nomor_surat_1",
        :contact_id => @ct_1.id,
        :exchange_id => @exc_1.id,
        :amount_payable => BigDecimal("10000"),
        :exchange_rate_amount => BigDecimal("10"), 
        :invoice_date => DateTime.now 
          
          
        )
    end
      
      it "should create PayableMigration" do
        @pm.errors.size.should == 0
      end
      
      it "should create TransactionData" do
        td = TransactionData.where(
          :transaction_source_type => @pm.class.to_s,
          :transaction_source_id => @pm.id
          )
        td.count.should == 1
        td.first.is_confirmed.should be_truthy
      end
        
      it "should create 1 payable" do
        payable = Payable.where(
          :source_id => @pm.id,
          :source_class => @pm.class.to_s
          )
        payable.count.should == 1
        payable.first.amount.should == @pm.amount_payable
      end
        
      
    end
end
