role = {
  'system' => {
    'administrator' => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

# admin_role = TheRole.create_admin!

# update admin_role
# https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md
# change role.rb 
#  admin_role.create_rule(:system, :administrator)
      # admin_role.rule_on(:system, :administrator)
# 

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



# if Rails.env.development?

  admin = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  admin = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
  admin = User.create_main_user(  :name => "Admin4", :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
data_entry = User.create_object(
  :name => "jojo",
  :email => "jojo@gmail.com",
  :password => "jojo1234",
  :password_confirmation => "jojo1234",
  :role_id => data_entry_role.id
  )

Account.create_base_objects



# creating contact group  
contact_group_array = [] 

(1.upto 5).each do |x|
  contact_group_array << ContactGroup.create_object(
      :name => "contact group name #{x}",
      :description => "description of the contact group #{x}"
    )
end

# creating supplier 

puts "contact_group_array: #{contact_group_array}"

supplier_array = [] 
(1.upto 5).each do |x|
  supplier_array << Contact.create_object(
      :name => "Supplier #{x}",
      :address =>"öffice address of #{x}",
      :contact_no => "tjeconcatnno_ #{x} supplier",
      :delivery_address =>" delivery address of #{x}",
      :description => "description of the contact group #{x}",
      :default_payment_term =>  x , 
      :npwp => "234234#{x}", 
      :is_taxable => true,  
      :tax_code => "23222afwea#{x}",
      :nama_faktur_pajak => "awesome supplier #{x}",
      :pic => "awesome supplier pic #{x}",
      :pic_contact_no => "2342#{x}",
      :email => "supplier_#{x}@gmail.com",
      :contact_type => CONTACT_TYPE[:supplier],
      :contact_group_id => contact_group_array[ rand(0..( contact_group_array.length - 1 ) )].id
    )
end

customer_array = [] 
(1.upto 5).each do |x|
  customer_array << Contact.create_object(
      :name => "Customer #{x}",
      :address =>"öffice address of customer #{x}",
      :contact_no => "tjeconcatnno_ #{x} customer",
      :delivery_address =>" delivery address of #{x}",
      :description => "description of the customer group #{x}",
      :default_payment_term =>  x , 
      :npwp => "2cust34234#{x}", 
      :is_taxable => true,  
      :tax_code => "23222acustfwea#{x}",
      :nama_faktur_pajak => "awesome customer #{x}",
      :pic => "awesome customer pic #{x}",
      :pic_contact_no => "2342#{x}",
      :email => "customer_#{x}@gmail.com",
      :contact_type => CONTACT_TYPE[:customer],
      :contact_group_id => contact_group_array[ rand(0..( contact_group_array.length - 1 ) )].id
    )
end


# creating item_type
ledger_account_array = [] 
Account.active_accounts.where(:account_case => ACCOUNT_CASE[:ledger] ).each do |account|
  ledger_account_array << account 
end


item_type_array = [] 
(1.upto 10).each do |x|
  
  item_type_array << ItemType.create_object(
      :name => "Item Type name #{x}",
      :description => "Item type description #{x}",
      :account_id => ledger_account_array[  rand( 0..(ledger_account_array.length - 1 ))].id 
      
    )
end

sub_type_array = [] 
(1.upto 10).each do |x|
  
  sub_type_array << SubType.create_object(
      :name => "Sub Type name #{x}", 
      :item_type_id => item_type_array[  rand( 0..(item_type_array.length - 1 ))].id 
      
    )
end

(1.upto 10).each do |x|
  
   Uom.create_object(
      :name => "unit of measurement #{x}",   
      
    )
end

(1.upto 10).each do |x|
  
   Warehouse.create_object(
      :name => "wh name #{x}",   
      :code => "wh code #{x}",   
      :description => "wh description #{x}",   
      
    )
end

(1.upto 10).each do |x|
  
   Exchange.create_object(
      :name => "exchanges name #{x}",   
      :description => "exchanges description #{x}",   
      
    )
end