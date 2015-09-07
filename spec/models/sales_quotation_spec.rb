require 'spec_helper'

describe SalesQuotation do
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
    :pic => "pic_1",
    :pic_contact_no => "1232133",
    :email => "email1@email.com",
    :is_taxable => true,
    :tax_code => TAX_CODE[:code_01],
    :contact_type => CONTACT_TYPE[:supplier],
    :default_payment_term => 30,
    :nama_faktur_pajak => "nama_faktur_pajak_1",
    :contact_group_id => @cg_1.id
    )
    
  @ct_2 = Contact.create_object(
    :name => "name_2" ,
    :address => "address_2",
    :delivery_address => "delivery_address_2",
    :description => "description_2",
    :npwp => "npwp_2" ,
    :contact_no => "9219312",
    :pic => "pic_2",
    :pic_contact_no => "123242133",
    :email => "email2@email.com",
    :is_taxable => true,
    :tax_code => TAX_CODE[:code_01],
    :contact_type => CONTACT_TYPE[:supplier],
    :default_payment_term => 30,
    :nama_faktur_pajak => "nama_faktur_pajak_1",
    :contact_group_id => @cg_1.id
    )
    
  @coa_1 = Account.create_object(
    :code => "1110ko2132",
    :name => "KAS",
    :account_case => ACCOUNT_CASE[:ledger],
    :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
 
    )
    
  @itp_1 = ItemType.create_object(
    :name => "ItemType_1241421412" ,
    :description => "Description1",
    :account_id => @coa_1.id
    )
  
  @sbp_1 = SubType.create_object(
    :name => "SubType_1421421" ,
    :item_type_id => @itp_1.id
    )
  
  @uom_1 = Uom.create_object(
    :name => "Uom_1" ,
    )
  
  @exc_1 = Exchange.create_object(
    :name => "IDR1444",
    :description => "description_1",
    )
  
  @exc_2 = Exchange.create_object(
    :name => "USD4444",
    :description => "description_2",
    )
  @item_1 = Item.create_object(
    :item_type_id => @itp_1.id,
    :sub_type_id => @sbp_1.id,
    :sku => "sku1232",
    :name => "itemname1",
    :description => "description_1",
    :is_tradeable => true,
    :uom_id => @uom_1.id,
    :minimum_amount => BigDecimal("10"),
    :selling_price => BigDecimal("1000"),
    :price_list => BigDecimal("500"),
    :exchange_id => @exc_1.id,
    )
    
    @quotation_date_1 = DateTime.now
    @quotation_date_2 = DateTime.now + 1.days
    @version_no_1 = "1"
    @version_no_2 = "2"
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  it "should not create SalesQuotation if contact_id is not valid" do
    so = SalesQuotation.create_object(
      :contact_id => 123123,
      :nomor_surat => @nomor_surat_1,
      :version_no => @version_no_1,
      :description => @description_1,
      :quotation_date => @quotation_date_1,
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  it "should not create SalesQuotation if quotation_date is not valid" do
    so = SalesQuotation.create_object(
      :contact_id => @ct_1.id,
      :nomor_surat => @nomor_surat_1,
      :version_no => @version_no_1,
      :description => @description_1,
      :quotation_date => nil,
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  it "should not create SalesQuotation if nomor_surat is not valid" do
    so = SalesQuotation.create_object(
      :contact_id => @ct_1.id,
      :nomor_surat => nil,
      :version_no => @version_no_1,
      :description => @description_1,
      :quotation_date => @quotation_date_1,
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  context "Create SalesQuotation" do
    before(:each) do
      @so = SalesQuotation.create_object(
        :contact_id => @ct_1.id,
        :nomor_surat => @nomor_surat_1,
        :version_no => @version_no_1,
        :description => @description_1,
        :quotation_date => @quotation_date_1,
        )
    end
    
    it "should create SalesQuotation" do
      @so.errors.size.should == 0
      @so.should be_valid
    end
    
    it "should update SalesQuotation" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :nomor_surat => @nomor_surat_2,
        :version_no => @version_no_2,
        :description => @description_2,
        :quotation_date => @quotation_date_2,
      )
      @so.contact_id.should == @ct_2.id
      @so.nomor_surat.should == @nomor_surat_2
      @so.version_no.should == @version_no_2
      @so.description.should ==  @description_2
      @so.quotation_date.should == @quotation_date_2
    end
    
    it "should not update SalesQuotation if contact_id is not valid" do
      @so.update_object(
        :contact_id => 1232132,
        :nomor_surat => @nomor_surat_2,
        :version_no => @version_no_2,
        :description => @description_2,
        :quotation_date => @quotation_date_2,
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should not update SalesQuotation if quotation_date is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :nomor_surat => @nomor_surat_2,
        :version_no => @version_no_2,
        :description => @description_2,
        :quotation_date => nil,
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should not update SalesQuotation if nomor_surat is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :nomor_surat => nil,
        :version_no => @version_no_2,
        :description => @description_2,
        :quotation_date => @quotation_date_2,
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should delete SalesQuotation" do
      @so.delete_object
      @so.errors.size.should == 0
    end
    
    context "Create SalesQuotationDetail" do
      before(:each) do
      @sod_1 = SalesQuotationDetail.create_object(
        :sales_quotation_id => @so.id,
        :item_id => @item_1.id,
        :amount => BigDecimal("10"),
        :quotation_price => BigDecimal("500"),
        )
      end
      
      it "should create SalesQuotationDetail" do
        @sod_1.errors.size.should == 0
        
      end
      
      it "should not update SalesQuotation if have details" do
        @so.update_object(
          :contact_id => @ct_2.id,
          :nomor_surat => nil,
          :version_no => @version_no_2,
          :description => @description_2,
          :quotation_date => @quotation_date_2,
          )
        @so.errors.size.should_not == 0
      end

      it "should not delete SalesQuotation if have details" do
        @so.delete_object
        @so.errors.size.should_not == 0
      end
      
      context "Confirm SalesQuotation" do
        before(:each) do
          @so.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm SalesQuotation" do
          @so.is_confirmed.should be true
        end
        
        it "should not double confirm" do
          @so.confirm_object(:confirmed_at => DateTime.now)
          @so.errors.size.should_not == 0
        end
        
        it "should change total_quote_amount,total_rrp,cost_saved,percentage_saved " do
          @so.total_quote_amount.should == BigDecimal('5000')
          @so.total_rrp_amount.should == BigDecimal('10000')
          @so.cost_saved.should == BigDecimal('5000')
          @so.percentage_saved.should == BigDecimal('50')
        end
        
        context "Unconfirm SalesQuotation" do
          before(:each) do
            @so.unconfirm_object
          end
          
          it "should unconfirm SalesQuotation" do
            @so.is_confirmed.should be false
            @so.confirmed_at.should == nil
            @so.errors.size.should == 0
          end
          
          it "should not unconfirm again" do
            @so.unconfirm_object
            @so.errors.size.should_not == 0
          end
          
          it "should change total_quote_amount,total_rrp,cost_saved,percentage_saved to 0" do
            @so.reload
            @so.total_quote_amount.should == 0
            @so.total_rrp_amount.should == 0 
            @so.cost_saved.should == 0
            @so.percentage_saved.should == 0
          end
          
        end
      end      
    end
  end 
end
