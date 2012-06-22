require '../lib/odf-report'
require 'ostruct'
require 'pry'

data = []
data << {:Name => 'Default', :Description => 'Default Description', :"IF Names" => ''}
data << {:Name => 'ewrrwehi', :Description => '', :"IF Names" => 'weruio, weruiov'}
data << {:Name => 'svvdssd sdf', :Description => '', :"IF Names" => 'vjsrk, 00vjkorek'}
data << {:Name => '45g45g', :Description => 'bd dfg ', :"IF Names" => ''}
data << {:Name => 'rgber', :Description => 'sdfgu 89adfg u890asdfg 890asfdg98d0fg', :"IF Names" => ''}
data << {:Name => 'Default', :Description => 'Default Description', :"IF Names" => ''}
data << {:Name => 'Default', :Description => 'fgfg', :"IF Names" => ''}
data << {:Name => 'Default', :Description => '45grtbrth', :"IF Names" => ''}

data2 = []
(1..10).each do |i|
  data2 << {:"Name 1"=>"name #{i}",  :ID=>i,  :Address=>"this is address #{i}", :Other => "This is other info #{i}"}
end

report = ODFReport::Report.new("test_presentation_table.odp") do |r|
  
  title = "Test Title 1"
  description = "A description 1"

  r.add_slide_with_table(title, description, data)
  
  title = "Test Title 2"
  description = "A description 2"

  r.add_slide_with_table(title, description, data2)
  
  title = "Test Title 3"
  description = "A description 3"

  r.add_slide_with_table(title, description, data2)
end

report.generate("./result/test_presentation_table.odp")