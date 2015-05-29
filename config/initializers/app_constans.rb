ROLE_NAME = {
  :admin => "admin",
  :manager => "manager",
  :data_entry => "dataentry"
}

 

# => TIMEZONE ( for 1 store deployment. For multitenant => different story) 
UTC_OFFSET = 7 
LOCAL_TIME_ZONE = "Jakarta" 

EXT_41_JS = 'https://s3.amazonaws.com/weyewe-extjs/41/ext-all.js'

EXTENSIBLE = 'https://s3.amazonaws.com/weyewe-extjs/extensible-all.js'

VIEW_VALUE = {
  :week => 0, 
  :month => 1, 
  :year => 2 
}
 

IMAGE_ASSET_URL = {
  
  # MSG BOX
  :alert => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/alert.png',
  :background => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/background.png',
  :confirm => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/confirm.png',
  :error => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/error.png',
  :info => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/info.png',
  :question => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/question.png',
  :success => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/success.png',
  
  
  # FONT 
  :font_awesome_eot => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.eot',
  :font_awesome_svg => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svg',
  :font_awesome_svgz =>'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svgz',
  :font_awesome_ttf => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.ttf',
  :font_awesome_woff => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.woff',  
  
  
  # BOOTSTRAP SPECIFIC 
  :glyphicons_halflings_white => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings-white.png',
  :glyphicons_halflings_black => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings.png',
  
  # jquery UI-lightness 
  :ui_bg_diagonal_thick_18 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_18_b81900_40x40.png',
  :ui_bg_diagonal_thick_20 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_20_666666_40x40.png',
  :ui_bg_flat_10 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_flat_10_000000_40x100.png' , 
  :ui_bg_glass_100_f6f6f6 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_f6f6f6_1x400.png',
  :ui_bg_glass_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_fdf5ce_1x400.png',
  :ui_bg_glass_65 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_65_ffffff_1x400.png',
  :ui_bf_gloss_wave => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_75 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_75_ffe45c_1x100.png',
  :ui_icons_222222 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_222222_256x240.png',
  :ui_icons_228ef1 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_228ef1_256x240.png',
  :ui_icons_ef8c08 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ef8c08_256x240.png',
  :ui_icons_ffd27a => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffd27a_256x240.png',
  :ui_icons_ffffff => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffffff_256x240.png',
  :ui_bg_highlight_soft_100_eeeeee => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_100_eeeeee_1x100.png',
  
  
  # APP_APPLICATION.css 
  :jquery_handle => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle.png',
  :jquery_handle_vertical => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle-vertical.png',
  :login_bg => 'http://s3.amazonaws.com/salmod/app_asset/app_application/login-bg.png',
  :user_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/user.png',
  :password => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password.png',
  :password_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password_error.png',
  :check_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/check.png',
  :twitter => 'http://s3.amazonaws.com/salmod/app_asset/app_application/twitter_btn.png',
  :fb_button => 'http://s3.amazonaws.com/salmod/app_asset/app_application/fb_btn.png',
  :validation_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-error.png',
  :validation_success => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-success.png',
  :zoom => 'http://s3.amazonaws.com/salmod/app_asset/app_application/zoom.png',
  :logo => 'http://s3.amazonaws.com/salmod/app_asset/app_application/logo.png' 
}

# Application Specific 
REVISION_STATUS = {
  :base => 0,
  :major => 1,
  :minor => 2 
}

CLEARANCE_STATUS = {
  :approved =>1 ,
  :rejected => 2 
}

USER_JOB_STATUS = {
  :observer => 1 , 
  :worker => 2 
}

MAINTENANCE_CASE ={
  :scheduled => 1, 
  :emergency => 2 
}


DIAGNOSIS_CASE = {
  :all_ok => 1 ,
  :require_fix => 2,
  :require_replacement => 3  
}

SOLUTION_CASE = {
  :normal => 1 ,
  :pending => 2,
  :solved =>  3    # 
}

ADJUSTMENT_STATUS = {
  :addition => 1, 
  :deduction => 2 
}

TAX_CODE = {
  :code_01 => "01",
  :code_02 => "02",
  :code_03 => "03",
  :code_04 => "04",
  :code_05 => "05",
  :code_06 => "06",
  :code_07 => "07",
  :code_08 => "08",
  :code_09 => "09",
  }

TAX_VALUE = {
  :code_01 => 10,
  :code_02 => 10,
  :code_03 => 10,
  :code_04 => 1,
  :code_05 => 10,
  :code_06 => 10,
  :code_07 => 0,
  :code_08 => 0,
  :code_09 => 0,
  }

CONTACT_TYPE = {
  :customer => "Customer",
  :supplier => "Supplier",
  }

ITEM_CASE = {
  :ready => 1,
  :pending_receival => 2,
  :pending_delivery => 3,
  :virtual => 4 
  }

ITEM_TYPE_CASE = {
  :Accessory => "Accessory",	
  :AdhesiveBlanket => "AdhesiveBlanket",
  :AdhesiveRoller => "AdhesiveRoller",
  :Bar => "Bar",
  :Blanket => "Blanket",
  :Bearing => "Bearing",
  :RollBlanket => "RollBlanket",
  :Chemical => "Chemical",
  :Compound => "Compound",
  :Consumable => "Consumable",
  :Core => "Core",
  :Glue => "Glue",
  :Underpacking => "Underpacking",
  :Roller => "Roller",
  }

ACCOUNT_GROUP = {
  :asset => 1,
  :expense => 2,
  :liability => 3,
  :equity => 4,
  :revenue => 5
  }

STATUS_ACCOUNT = {
  :debet => 1,
  :credit => 2,
  }

STATUS_PEMBULATAN = {
  :debet => 1,
  :credit => 2,
  }

ACCOUNT_LEGACY_CODE = {
  :asset => "A1",
  :current_asset => "A11",
  :cash_bank => "A1101",
  :account_receivable => "A1102",
  :gbch_receivable => "A1103",
  :inventory => "A1104",
  :raw => "A1104001",
  :finished_goods => "A1104002",
  :piutang_lain_lain => "A1106",
  :ppn_masukan => "A1107",
  :pph_23 => "A11070002",
  :expense => "X2",
  :cogs_expense => "X21E",
  :cogs => "X21",
  :cos => "X22",
  :operational_expense => "X23",
  :manufacturing_expense => "X2301",
  :recovery_expense => "X2301001",
  :conversion_expense => "X2301002",
  :selling_general_and_administration_expense => "X2302",
  :cash_bank_adjustment_expense => "X2302001",
  :discount => "X2302002",
  :sales_allowance => "X2302003",
  :stock_adjustment_expense => "X2302004",
  :sample_and_trial_expense => "X2302005", 
  :non_operational_expense => "X24",
  :depreciation_expense => "X2401",
  :amortization => "X2402",
  :interest_expense => "X2403",
  :tax_expense => "X2404",
  :divident_expense => "X2405",
  :exchange_loss => "X25",
  :biaya_pembulatan => "X62020014",
  :biaya_admin_bank => "X62090002",
  :liability => "L3",
  :current_liability => "L31",
  :account_payable => "L3101",
  :gbch_payable => "L3102",
  :goods_pending_clearance => "L3103",
  :purchase_allowance => "L3105",
  :hutang_lain_lain => "L3107",
  :ppn_keluaran => "L3108",
  :hutang_pph_21 => "L21050001",
  :hutang_pph_23 => "L21050002",
  :non_current_liability => "L32",
  :equity => "E4",
  :owners_equity => "E41",
  :equity_adjustment => "E4101",
  :net_earning => "E4102",
  :exchange_gain => "E42",
  :revenue => "R5",
  :pendapatan_jasa_giro => "R71010001",
  :pendapatan_bunga_bank => "R71010002",
  }
             
ORDER_TYPE_CASE = {		
  :trial_order => 0,	
  :sample_order => 1,
  :consignment => 2,	
  :part_delivery_order => 3,	
  :sales_order => 4,	
  :sales_quotation => 5,		
  }		
       
