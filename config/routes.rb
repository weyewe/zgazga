Ticketie::Application.routes.draw do
  devise_for :users
  
  root :to => 'home#index' 
  resources :sales_orders
  resources :delivery_orders
  resources :sales_invoices
  resources :purchase_orders
  resources :purchase_receivals
  resources :purchase_invoices
  
  
  
  
  namespace :api do
    devise_for :users
    post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
    put 'update_password' , :to => "passwords#update" , :as => :update_password
    get 'search_role' => 'roles#search', :as => :search_role, :method => :get
    get 'search_user' => 'app_users#search', :as => :search_user, :method => :get
    get 'search_home' => 'homes#search', :as => :search_home, :method => :get 
    get 'search_home_type' => 'home_types#search', :as => :search_home_type, :method => :get
    get 'search_items' => 'items#search', :as => :search_item, :method => :get
    get 'search_item_compounds' => 'items#search_compound', :as => :search_item_compound, :method => :get
    get 'search_item_adhesive_rollers' => 'items#search_adhesive_roller', :as => :search_item_adhesive_roller, :method => :get
    get 'search_item_adhesive_blankets' => 'items#search_adhesive_blanket', :as => :search_item_adhesive_blanket, :method => :get
    get 'search_item_bars' => 'items#search_bar', :as => :search_item_bar, :method => :get
    get 'search_item_roll_blankets' => 'items#search_roll_blanket', :as => :search_item_roll_blanket, :method => :get
    get 'search_blankets' => 'blankets#search', :as => :search_blanket, :method => :get 
    get 'search_employees' => 'employees#search', :as => :search_employee, :method => :get
    get 'search_customers' => 'customers#search', :as => :search_customer, :method => :get
    get 'search_suppliers' => 'suppliers#search', :as => :search_supplier, :method => :get
    get 'search_cash_bank' => 'cash_banks#search', :as => :search_cash_bank, :method => :get
    get 'search_cash_bank_mutations' => 'cash_bank_mutations#search', :as => :search_cash_bank_mutations, :method => :get
    get 'work_customer_reports' => 'maintenances#customer_reports', :as => :work_customer_reports
    
    get 'search_contact_groups' => 'contact_groups#search', :as => :search_contact_group
    get 'search_ledger_accounts' => 'accounts#search_ledger', :as => :search_ledger_account
    get 'search_ledger_account_payables' => 'accounts#search_ledger_payable', :as => :search_ledger_account_payable
    get 'search_item_types' => 'item_types#search', :as => :search_item_type
    get 'search_sub_types' => 'sub_types#search', :as => :search_sub_type
    get 'search_uoms' => 'uoms#search', :as => :search_uom
    get 'search_exchanges' => 'exchanges#search', :as => :search_exchange
    get 'search_warehouses' => 'warehouses#search', :as => :search_warehouse
    get 'search_machines' => 'machines#search', :as => :search_machine
    get 'search_core_builders' => 'core_builders#search', :as => :search_core_builder
    get 'search_blending_recipes' => 'blending_recipes#search', :as => :search_blending_recipe
    get 'search_blending_recipe_details' => 'blending_recipe_details#search', :as => :search_blending_recipe_detail
    get 'search_blanket_orders' => 'blanket_orders#search', :as => :search_blanket_order
    get 'search_blanket_order_details' => 'blanket_order_details#search', :as => :search_blanket_order_detail
    
    get 'search_sales_orders' => 'sales_orders#search', :as => :search_sales_order
    get 'search_sales_order_details' => 'sales_order_details#search', :as => :search_sales_order_detail
    get 'search_delivery_orders' => 'delivery_orders#search', :as => :search_delivery_order
    get 'search_delivery_order_details' => 'delivery_order_details#search', :as => :search_delivery_order_detail
    get 'search_virtual_orders' => 'virtual_orders#search', :as => :search_virtual_order
    get 'search_virtual_order_details' => 'virtual_order_details#search', :as => :search_virtual_order_detail
    get 'search_virtual_delivery_orders' => 'virtual_delivery_orders#search', :as => :search_virtual_delivery_order
    get 'search_virtual_delivery_order_details' => 'virtual_delivery_order_details#search', :as => :search_virtual_delivery_order_detail
    get 'search_temporary_delivery_orders' => 'temporary_delivery_orders#search', :as => :search_temporary_delivery_order
    get 'search_temporary_delivery_order_details' => 'temporary_delivery_order_details#search', :as => :search_temporary_delivery_order_detail
    
    get 'search_purchase_orders' => 'purchase_orders#search', :as => :search_purchase_order
    get 'search_purchase_order_details' => 'purchase_order_details#search', :as => :search_purchase_order_detail
    get 'search_purchase_receivals' => 'purchase_receivals#search', :as => :search_purchase_receival
    get 'search_purchase_receival_details' => 'purchase_receival_details#search', :as => :search_purchase_receival_detail
    get 'search_roller_types' => 'roller_types#search', :as => :search_roller_type
    get 'search_payment_requests' => 'payment_requests#search', :as => :search_payment_request
    get 'search_payment_request_details' => 'payment_request_details#search', :as => :search_payment_request_detail
    get 'search_memorials' => 'memorials#search', :as => :search_memorial
    get 'search_memorial_details' => 'memorial_details#search', :as => :search_memorial_detail
    get 'search_closings' => 'closings#search', :as => :search_closing
    get 'search_closing_details' => 'closing_details#search', :as => :search_closing_detail
    get 'search_payables' => 'payables#search', :as => :search_payable
    get 'search_receivables' => 'receivables#search', :as => :search_receivable
    get 'search_payment_vouchers' => 'payment_voucher_details#search', :as => :search_payment_voucher
    get 'search_payment_voucher_details' => 'payment_voucher_details#search', :as => :search_payment_voucher_detail
    get 'search_receipt_vouchers' => 'receipt_voucher_details#search', :as => :search_receipt_voucher
    get 'search_receipt_voucher_details' => 'receipt_voucher_details#search', :as => :search_receipt_voucher_detail
   
   
    # master data 
    resources :app_users
    resources :contact_groups 
    resources :customers 
    resources :suppliers 
    resources :employees
    resources :machines
    resources :roller_types
    
    # ITEM DB
    resources :item_types  
    resources :sub_types
    resources :uoms 
    resources :items 

    
    #   warehousing
    resources :warehouses
  
    # accounting
    resources :memorials
    resources :memorial_details
    
    # finance
    resources :accounts
    resources :cash_banks
    resources :exchanges  
    resources :exchange_rates 
  
     
    # operation
    
    resources :payables
    resources :receivables
    resources :stock_adjustments
    resources :stock_adjustment_details
    
    resources :warehouse_mutations
    resources :warehouse_mutation_details
    
    resources :cash_bank_adjustments
    resources :cash_bank_mutations
    
    resources :sales_orders
    resources :sales_order_details
    
    resources :delivery_orders
    resources :delivery_order_details
    
    resources :virtual_orders
    resources :virtual_order_details
    
    resources :virtual_delivery_orders
    resources :virtual_delivery_order_details
    
    resources :temporary_delivery_orders
    resources :temporary_delivery_order_details
    
    resources :sales_invoices
    resources :sales_invoice_details
    
    resources :purchase_orders
    resources :purchase_order_details
    
    resources :purchase_receivals
    resources :purchase_receival_details
    
    resources :purchase_invoices
    resources :purchase_invoice_details
    
    resources :roller_builders
    resources :core_builders
    resources :blankets
    
    resources :payment_requests
    resources :payment_request_details
    
    resources :payment_vouchers
    resources :payment_voucher_details
    
    resources :receipt_vouchers
    resources :receipt_voucher_details
    
    resources :blending_recipes
    resources :blending_recipe_details
    
    resources :blanket_orders
    resources :blanket_order_details
    
    resources :closings
    resources :closing_details
    
  end
  
  
end
