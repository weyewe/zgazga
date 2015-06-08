# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150608041959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",                                                        null: false
    t.integer  "rgt",                                                        null: false
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.boolean  "is_contra_account",                          default: false
    t.integer  "normal_balance",                             default: 1
    t.integer  "account_case",                               default: 2
    t.boolean  "is_base_account",                            default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_adjustments", force: true do |t|
    t.integer  "cash_bank_id"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.integer  "exchange_rate_id"
    t.integer  "status",                                         default: 1
    t.datetime "adjustment_date"
    t.datetime "confirmed_at"
    t.boolean  "is_confirmed",                                   default: false
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_mutations", force: true do |t|
    t.integer  "target_cash_bank_id"
    t.integer  "source_cash_bank_id"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.datetime "mutation_date"
    t.boolean  "is_confirmed",                                   default: false
    t.text     "description"
    t.datetime "confirmed_at"
    t.string   "no_bukti"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_banks", force: true do |t|
    t.string   "name"
    t.integer  "exchange_id"
    t.text     "description"
    t.boolean  "is_bank",                              default: true
    t.decimal  "amount",      precision: 14, scale: 2, default: 0.0
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_mutations", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",        precision: 14, scale: 2, default: 0.0
    t.integer  "status",                                 default: 1
    t.datetime "mutation_date"
    t.integer  "cash_bank_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "delivery_address"
    t.text     "description"
    t.string   "nama"
    t.string   "npwp"
    t.string   "contact_no"
    t.string   "pic"
    t.string   "pic_contact_no"
    t.string   "email"
    t.string   "is_taxable"
    t.string   "tax_code"
    t.string   "contact_type"
    t.integer  "default_payment_term"
    t.string   "nama_faktur_pajak"
    t.integer  "contact_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.string   "order_code"
    t.integer  "delivery_order_id"
    t.integer  "sales_order_detail_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "cogs",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_invoiced_amount", precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_invoiced",                                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "sales_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_cogs",           precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_confirmed",                                   default: false
    t.boolean  "is_invoice_completed",                           default: false
    t.datetime "confirmed_at"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "contact_no"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_rates", force: true do |t|
    t.integer  "exchange_id"
    t.datetime "ex_rate_date"
    t.decimal  "rate",         precision: 18, scale: 11, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "account_payable_id"
    t.integer  "account_receivable_id"
    t.integer  "gbch_payable_id"
    t.integer  "gbch_receivable_id"
    t.boolean  "is_base",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "source_id"
    t.string   "source_class"
    t.string   "source_code"
    t.string   "code"
    t.integer  "home_id"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.datetime "due_date"
    t.datetime "invoice_date"
    t.text     "description"
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.boolean  "is_paid",                               default: false
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_legacy",   default: false
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "item_type_id"
    t.string   "sku"
    t.string   "name"
    t.string   "description"
    t.boolean  "is_tradeable",                                default: false
    t.integer  "uom_id"
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery",   precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_receival",   precision: 14, scale: 2, default: 0.0
    t.decimal  "virtual",            precision: 14, scale: 2, default: 0.0
    t.decimal  "minimum_amount",     precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_amount",    precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",      precision: 14, scale: 2, default: 0.0
    t.integer  "exchange_id"
    t.integer  "price_mutation_id"
    t.decimal  "avg_price",          precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_avg_price", precision: 14, scale: 2, default: 0.0
    t.decimal  "price_list",         precision: 14, scale: 2, default: 0.0
    t.integer  "sub_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",                   precision: 14, scale: 2,  default: 0.0
    t.decimal  "remaining_amount",         precision: 14, scale: 2,  default: 0.0
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount",     precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.decimal  "pending_clearence_amount", precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_completed",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_request_details", force: true do |t|
    t.integer  "payment_request_id"
    t.integer  "account_id"
    t.integer  "status",                                      default: 1
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.boolean  "is_legacy",                                   default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_requests", force: true do |t|
    t.integer  "contact_id"
    t.string   "no_bukti"
    t.datetime "request_date"
    t.string   "code"
    t.integer  "account_id"
    t.integer  "exchange_id"
    t.text     "description"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.integer  "exchange_rate_id"
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_voucher_details", force: true do |t|
    t.integer  "payment_voucher_id"
    t.decimal  "amount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",        precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_21",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_23",             precision: 14, scale: 2,  default: 0.0
    t.integer  "payable_id"
    t.decimal  "rate",               precision: 18, scale: 11, default: 0.0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_vouchers", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "cash_bank_id"
    t.integer  "status_pembulatan"
    t.datetime "payment_date"
    t.decimal  "amount",              precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",         precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_23",        precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_21",        precision: 18, scale: 11, default: 0.0
    t.decimal  "biaya_bank",          precision: 18, scale: 11, default: 0.0
    t.decimal  "pembulatan",          precision: 18, scale: 11, default: 0.0
    t.string   "no_bukti"
    t.string   "gbch_no"
    t.boolean  "is_gbch",                                       default: false
    t.boolean  "is_reconciled",                                 default: false
    t.datetime "reconciliation_date"
    t.datetime "due_date"
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_invoice_details", force: true do |t|
    t.integer  "purchase_invoice_id"
    t.integer  "purchase_receival_detail_id"
    t.string   "code"
    t.decimal  "amount",                      precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                       precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_invoices", force: true do |t|
    t.integer  "purchase_receival_id"
    t.string   "description"
    t.string   "code"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.integer  "exchange_rate_id"
    t.decimal  "amount_payable",       precision: 14, scale: 2,  default: 0.0
    t.decimal  "discount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_taxable",                                     default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "invoice_date"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_order_details", force: true do |t|
    t.string   "code"
    t.integer  "purchase_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_received",                                  default: false
    t.decimal  "pending_receival_amount", precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_orders", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.datetime "purchase_date"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_receival_completed", default: false
    t.text     "description"
    t.boolean  "allow_edit_detail",     default: false
    t.boolean  "is_confirmed",          default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_receival_details", force: true do |t|
    t.string   "code"
    t.integer  "purchase_receival_id"
    t.integer  "purchase_order_detail_id"
    t.integer  "item_id"
    t.decimal  "amount",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_invoiced_amount",  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_invoiced",                                   default: false
    t.decimal  "cogs",                     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_receivals", force: true do |t|
    t.string   "code"
    t.integer  "purchase_order_id"
    t.datetime "receival_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "total_cogs",           precision: 14, scale: 2,  default: 0.0
    t.decimal  "total_amount",         precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.boolean  "is_invoice_completed",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_voucher_details", force: true do |t|
    t.integer  "receipt_voucher_id"
    t.decimal  "amount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",        precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_23",             precision: 14, scale: 2,  default: 0.0
    t.integer  "receivable_id"
    t.decimal  "rate",               precision: 18, scale: 11, default: 0.0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_vouchers", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "cash_bank_id"
    t.integer  "status_pembulatan"
    t.datetime "receipt_date"
    t.decimal  "amount",              precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",         precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_23",        precision: 18, scale: 11, default: 0.0
    t.decimal  "biaya_bank",          precision: 18, scale: 11, default: 0.0
    t.decimal  "pembulatan",          precision: 18, scale: 11, default: 0.0
    t.string   "no_bukti"
    t.string   "gbch_no"
    t.boolean  "is_gbch",                                       default: false
    t.boolean  "is_reconciled",                                 default: false
    t.datetime "reconciliation_date"
    t.datetime "due_date"
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receivables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",                   precision: 14, scale: 2,  default: 0.0
    t.decimal  "remaining_amount",         precision: 14, scale: 2,  default: 0.0
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount",     precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.decimal  "pending_clearence_amount", precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_completed",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.json     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_invoice_details", force: true do |t|
    t.integer  "sales_invoice_id"
    t.integer  "delivery_order_detail_id"
    t.string   "code"
    t.decimal  "amount",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "cos",                      precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_invoices", force: true do |t|
    t.integer  "delivery_order_id"
    t.text     "description"
    t.string   "code"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "total_cos",            precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_receivable",    precision: 14, scale: 2,  default: 0.0
    t.decimal  "discount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "dpp",                  precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.datetime "invoice_date"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_order_details", force: true do |t|
    t.string   "code"
    t.string   "order_code"
    t.integer  "sales_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_delivered",                                 default: false
    t.decimal  "pending_delivery_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_service",                                       default: false
    t.boolean  "is_confirmed",                                     default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.string   "order_code"
    t.integer  "contact_id"
    t.integer  "employee_id"
    t.datetime "sales_date"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_confirmed",          default: false
    t.boolean  "is_delivery_completed", default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_adjustment_details", force: true do |t|
    t.integer  "stock_adjustment_id"
    t.integer  "item_id"
    t.string   "code"
    t.integer  "status",                                       default: 1
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "price",               precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_adjustments", force: true do |t|
    t.integer  "warehouse_id"
    t.datetime "adjustment_date"
    t.text     "description"
    t.string   "code"
    t.decimal  "total",           precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                             default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_mutations", force: true do |t|
    t.integer  "item_id"
    t.integer  "warehouse_id"
    t.integer  "warehouse_item_id"
    t.integer  "item_case"
    t.integer  "status",                                     default: 1
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.datetime "mutation_date"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.datetime "updated_at"
  end

  create_table "sub_types", force: true do |t|
    t.string   "name"
    t.integer  "item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temporary_delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "temporary_delivery_order_id"
    t.integer  "sales_order_detail_id"
    t.integer  "item_id"
    t.boolean  "is_reconciled",                                        default: false
    t.boolean  "is_all_completed",                                     default: false
    t.decimal  "amount",                      precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_amount",                precision: 14, scale: 2, default: 0.0
    t.decimal  "restock_amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",               precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temporary_delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.integer  "delivery_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_waste_cogs",      precision: 14, scale: 2, default: 0.0
    t.boolean  "is_delivery_completed",                          default: false
    t.boolean  "is_reconciled",                                  default: false
    t.boolean  "is_pushed",                                      default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "push_date"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data", force: true do |t|
    t.integer  "transaction_source_id"
    t.string   "transaction_source_type"
    t.datetime "transaction_datetime"
    t.text     "description"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed"
    t.integer  "code"
    t.boolean  "is_contra_transaction",                            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data_details", force: true do |t|
    t.integer  "transaction_data_id"
    t.integer  "account_id"
    t.integer  "entry_case"
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.string   "description"
    t.boolean  "is_bank_transaction",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data_non_base_exchange_details", force: true do |t|
    t.integer  "transaction_data_detail_id"
    t.decimal  "amount",                     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data_non_base_exchanges", force: true do |t|
    t.integer  "transaction_data_id"
    t.integer  "exchange_id"
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uoms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "name"
    t.string   "username"
    t.string   "login"
    t.boolean  "is_deleted",             default: false
    t.boolean  "is_main_user",           default: false
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "virtual_delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_delivery_order_id"
    t.integer  "virtual_order_detail_id"
    t.integer  "item_id"
    t.boolean  "is_reconciled",                                      default: false
    t.boolean  "is_all_completed",                                   default: false
    t.decimal  "amount",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "restock_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",             precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.integer  "virtual_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_waste_cogs",      precision: 14, scale: 2, default: 0.0
    t.boolean  "is_delivery_completed",                          default: false
    t.boolean  "is_reconciled",                                  default: false
    t.boolean  "is_pushed",                                      default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "push_date"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_clearance_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_order_clearance_id"
    t.integer  "virtual_delivery_order_detail_id"
    t.decimal  "amount",                           precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",                    precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_clearances", force: true do |t|
    t.string   "code"
    t.integer  "virtual_delivery_order_id"
    t.datetime "clearance_date"
    t.decimal  "total_waste_cogs",          precision: 14, scale: 2, default: 0.0
    t.boolean  "is_waste",                                           default: false
    t.boolean  "is_confirmed",                                       default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_delivered",                                 default: false
    t.boolean  "is_confirmed",                                     default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_orders", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "order_type"
    t.datetime "order_date"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_confirmed",          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_delivery_completed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_items", force: true do |t|
    t.integer  "warehouse_id"
    t.integer  "item_id"
    t.decimal  "amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_receival", precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery", precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_amount",  precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_mutation_details", force: true do |t|
    t.integer  "warehouse_mutation_id"
    t.integer  "item_id"
    t.string   "code"
    t.decimal  "amount",                precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_mutations", force: true do |t|
    t.integer  "warehouse_from_id"
    t.integer  "warehouse_to_id"
    t.datetime "mutation_date"
    t.text     "description"
    t.string   "code"
    t.boolean  "is_confirmed",      default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
