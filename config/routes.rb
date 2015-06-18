Ticketie::Application.routes.draw do
  devise_for :users
  
  root :to => 'home#index' 
 
  
  
  namespace :api do
    devise_for :users
    post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
    put 'update_password' , :to => "passwords#update" , :as => :update_password
    get 'search_role' => 'roles#search', :as => :search_role, :method => :get
    get 'search_user' => 'app_users#search', :as => :search_user, :method => :get
    get 'search_home' => 'homes#search', :as => :search_home, :method => :get 
    get 'search_home_type' => 'home_types#search', :as => :search_home_type, :method => :get
    get 'search_items' => 'items#search', :as => :search_item, :method => :get
    get 'search_customer' => 'customers#search', :as => :search_customer, :method => :get
    get 'search_vendor' => 'vendors#search', :as => :search_vendor, :method => :get
    get 'search_employees' => 'employees#search', :as => :search_employee, :method => :get
    get 'search_cash_bank' => 'cash_banks#search', :as => :search_cash_bank, :method => :get
    get 'search_payable' => 'payables#search', :as => :search_payable, :method => :get
    get 'search_receivable' => 'receivables#search', :as => :search_receivable, :method => :get
    get 'work_customer_reports' => 'maintenances#customer_reports', :as => :work_customer_reports
    
    get 'search_contact_groups' => 'contact_groups#search', :as => :search_contact_group
    get 'search_ledger_accounts' => 'accounts#search_ledger', :as => :search_ledger_account
    get 'search_item_types' => 'item_types#search', :as => :search_item_type
    get 'search_sub_types' => 'sub_types#search', :as => :search_sub_type
    get 'search_uoms' => 'uoms#search', :as => :search_uom
    get 'search_exchanges' => 'exchanges#search', :as => :search_exchange
    get 'search_warehouses' => 'warehouses#search', :as => :search_warehouse
    
    get 'search_sales_orders' => 'sales_orders#search', :as => :search_sales_order
    get 'search_sales_order_details' => 'sales_order_details#search', :as => :search_sales_order_detail
    get 'search_delivery_orders' => 'delivery_orders#search', :as => :search_delivery_order
    get 'search_delivery_order_details' => 'delivery_order_details#search', :as => :search_delivery_order_detail
    
    get 'search_purchase_orders' => 'purchase_orders#search', :as => :search_purchase_order
    get 'search_purchase_order_details' => 'purchase_order_details#search', :as => :search_purchase_order_detail
    get 'search_purchase_receivals' => 'purchase_receivals#search', :as => :search_purchase_receival
    get 'search_purchase_receival_details' => 'purchase_receival_details#search', :as => :search_purchase_receival_detail
    
    # master data 
    resources :app_users
    resources :contact_groups 
    resources :customers 
    resources :suppliers 
    resources :employees
    
    
    
    # ITEM DB
    resources :item_types  
    resources :sub_types
    resources :uoms 
    resources :items 

    
    #   warehousing
    resources :warehouses
  
    
    
    # finance
    resources :accounts
    resources :cash_banks
    resources :exchanges  
    resources :exchange_rates 
    
     
    # operation
    
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
    
    resources :sales_invoices
    resources :sales_invoice_details
    
    resources :purchase_orders
    resources :purchase_order_details
    
    resources :purchase_receivals
    resources :purchase_receival_details
    
    resources :purchase_invoices
    resources :purchase_invoice_details
    
  end
  
  
end
