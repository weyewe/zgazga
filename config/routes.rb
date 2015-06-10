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
    get 'search_item' => 'items#search', :as => :search_item, :method => :get
    get 'search_customer' => 'customers#search', :as => :search_customer, :method => :get
    get 'search_vendor' => 'vendors#search', :as => :search_vendor, :method => :get
    get 'search_cash_bank' => 'cash_banks#search', :as => :search_cash_bank, :method => :get
    get 'search_payable' => 'payables#search', :as => :search_payable, :method => :get
    get 'search_receivable' => 'receivables#search', :as => :search_receivable, :method => :get
    get 'work_customer_reports' => 'maintenances#customer_reports', :as => :work_customer_reports
    
    get 'search_contact_groups' => 'contact_groups#search', :as => :search_contact_group
    get 'search_ledger_accounts' => 'accounts#search_ledger', :as => :search_ledger_account
    get 'search_item_types' => 'item_types#search', :as => :search_item_type
    get 'search_exchanges' => 'exchanges#search', :as => :search_exchange
    
    # master data 
    resources :app_users
    resources :contact_groups 
    resources :customers 
    resources :suppliers 
    
    
    
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
    
    
    
    resources :maintenances
    
    resources :home_types
    resources :homes
    resources :home_assignments
    resources :vendors
    resources :payment_requests
    resources :payment_vouchers
    resources :payment_voucher_details
    resources :cash_banks
    resources :cash_bank_adjustments
    resources :cash_bank_mutations
    resources :cash_mutations
    resources :invoices
    resources :advanced_payments
    resources :receipt_vouchers
    resources :monthly_generators
    resources :monthly_generator_invoices
    resources :deposit_documents
    
  end
  
  
end
