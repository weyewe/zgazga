require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'



task :fix_blanket  => :environment  do |t, args|
 
	Blanket.where{ (right_bar_item_id.eq 0) | (adhesive2_id.eq 0) | (adhesive_id.eq 0) | (left_bar_item_id.eq 0)}.each do |blanket|
		blanket.right_bar_item_id = nil 
		
		blanket.left_bar_item_id = nil 
		
		blanket.adhesive2_id = nil
		
		blanket.adhesive2_id = nil
		
		blanket.save
		
		if blanket.errors.size != 0
		    blanket.errors.messages.each {|x| puts "error: #{x}" }
		end
	end
end
 