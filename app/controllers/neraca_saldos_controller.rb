class NeracaSaldosController < ApplicationController 
  
 
  def download_report
    filename = "NeracaReport.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    
    end_date = DateTime.now
    start_date = end_date - 1.weeks 
    
    NeracaReport.create_report( filepath, start_date, end_date, Closing.find_by_id(params[:closing_id])  )
    # VendorPaymentReport.create_report( filepath, start_date, end_date )
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
  
  def download_posneraca_report
    filename = "PerincianNeraca.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    # if params[:date] == "null"
    #   date = DateTime.now
    # else
    #   date = params[:date].to_date 
    # end
    
    PosNeracaReport.create_report( filepath, Closing.find_by_id(params[:closing_id]))
    # VendorPaymentReport.create_report( filepath, start_date, end_date )
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
  def download_income_statement_report
    filename = "IncomeStatement.xlsx"
    filepath = Rails.root.join('public', 'images', filename )
    
    ProfitLossStatement.create_report( filepath, Closing.find_by_id(params[:closing_id]))
    
    file = File.open( filepath , "rb")
    contents = file.read
    file.close
    
    File.delete(filepath) if File.exist?(filepath)
    
    send_data(contents, :filename => filename)

  end
  
end