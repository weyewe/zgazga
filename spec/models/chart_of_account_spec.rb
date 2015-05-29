require 'spec_helper'

describe ChartOfAccount do
  before (:each) do
    @code_1 = "110101"
    @code_2 = "110102"
    @name_1 = "KAS DAN BANK"
    @name_2 = "AKTIVA LANCAR"
    @group_1 = ACCOUNT_GROUP[:asset]
    @group_2 = ACCOUNT_GROUP[:expense]
    @level_1 = 1
    @level_2 = 2
  end
  
  it "should be allowed to create contactgroup" do
    coa = ChartOfAccount.create_object(
      :code => @code_1,
      :name => @name_1,
      :group => @group_1,
      :level => @level_1
    )
    
    coa.should be_valid
    coa.errors.size.should == 0 
  end
  
  it "should not create object without code" do
    coa = ChartOfAccount.create_object(
      :code => nil,
      :name => @name_1,
      :group => @group_1,
      :level => @level_1
      )
    
    coa.errors.size.should_not == 0 
    coa.should_not be_valid
    
  end
  
  it "should create object if code present, but length == 0 " do
    coa = ChartOfAccount.create_object(
      :code => "",
      :name => @name_1,
      :group => @group_1,
      :level => @level_1
    )
    
    coa.errors.size.should_not == 0 
    coa.should_not be_valid
    
  end
  
  it "should not create object without name" do
    coa = ChartOfAccount.create_object(
      :code => @code_1,
      :name => nil,
      :group => @group_1,
      :level => @level_1
      )
    
    coa.errors.size.should_not == 0 
    coa.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    coa = ChartOfAccount.create_object(
      :code => @code_1,
      :name => "",
      :group => @group_1,
      :level => @level_1
    )
    
    coa.errors.size.should_not == 0 
    coa.should_not be_valid
    
  end
  
  
  context "Create New ChartOfAccount" do
    before (:each) do
      @coa = ChartOfAccount.create_object(
        :code => @code_1,
        :name => @name_1,
        :group => @group_1,
        :level => @level_1
      )
    end
    
    it "should create contactgroup" do
      @coa.errors.size.should == 0
      @coa.should be_valid
    end
    
    it "cannot update object if code not valid" do
     @coa.update_object(
      :code => nil,
      :name => @name_1,
      :group => @group_1,
      :level => @level_1
     )
     @coa.errors.size.should_not == 0 
     @coa.should_not be_valid
    end
    
    it "cannot update object if code present, but lenght == 0" do
     @coa.update_object(
      :code => "",
      :name => @name_i,
      :group => @group_1,
      :level => @level_1
     )
     @coa.errors.size.should_not == 0 
     @coa.should_not be_valid
    end   
    
    it "cannot update object if name not valid" do
     @coa.update_object(
      :code => @code_1,
      :name => nil,
      :group => @group_1,
      :level => @level_1
     )
     @coa.errors.size.should_not == 0 
     @coa.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @coa.update_object(
      :code => @code_1,
      :name => "",
      :group => @group_1,
      :level => @level_1
     )
     @coa.errors.size.should_not == 0 
     @coa.should_not be_valid
    end   
    
    it "should update object" do
      @coa.update_object(
        :code => @code_2,
        :name => @name_2,
        :group => @group_2,
        :level => @level_2
      )
      @coa.code.should == @code_2
      @coa.name.should == @name_2
      @coa.group.should == @group_2
      @coa.level.should == @level_2
    end
  
    it "should delete object" do
      @coa.delete_object
      ChartOfAccount.count.should == 0
    end
  end
end
