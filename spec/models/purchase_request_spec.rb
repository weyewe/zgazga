require 'spec_helper'

describe PurchaseRequest do
  before(:each) do
    @request_date_1 = DateTime.now
    @request_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  context "Create PurchaseRequest" do
    before(:each) do
      @so = PurchaseRequest.create_object(
        :nomor_surat => @nomor_surat_1,
        :request_date => @request_date_1,
        )
    end
    
    it "should create PurchaseRequest" do
      @so.errors.size.should == 0
      @so.should be_valid
    end
    
    it "should update PurchaseRequest" do
      @so.update_object(
        :nomor_surat => @nomor_surat_2,
        :request_date => @request_date_2,
      )
      @so.nomor_surat.should == @nomor_surat_2
      @so.request_date.should == @request_date_2
    end
    
    it "should delete PurchaseRequest" do
      @so.delete_object
      @so.errors.size.should == 0
    end
    
    context "Create PurchaseRequestDetail" do
      before(:each) do
      @sod_1 = PurchaseRequestDetail.create_object(
        :purchase_request_id => @so.id,
        :name => "Name 1",
        :uom => "Uom 1",
        :description => "Description1",
        :category => 1,
        :amount => BigDecimal("500"),
        )
      end
      
      it "should create PurchaseRequestDetail" do
        @sod_1.errors.size.should == 0
        
      end
      
      it "should not update PurchaseRequest if have details" do
        @so.update_object(
           :nomor_surat => @nomor_surat_2,
           :request_date => @request_date_2,
          )
        @so.errors.size.should_not == 0
      end

      it "should not delete PurchaseRequest if have details" do
        @so.delete_object
        @so.errors.size.should_not == 0
      end
      
      context "Confirm PurchaseRequest" do
        before(:each) do
          @so.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm PurchaseRequest" do
          @so.is_confirmed.should be true
        end
        
        it "should not double confirm" do
          @so.confirm_object(:confirmed_at => DateTime.now)
          @so.errors.size.should_not == 0
        end
        
        context "Unconfirm PurchaseRequest" do
          before(:each) do
            @so.unconfirm_object
          end
          
          it "should unconfirm PurchaseRequest" do
            @so.is_confirmed.should be false
            @so.confirmed_at.should == nil
            @so.errors.size.should == 0
          end
          
          it "should not unconfirm again" do
            @so.unconfirm_object
            @so.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end 
  


end
