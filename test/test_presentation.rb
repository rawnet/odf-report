require '../lib/odf-report'
require 'ostruct'
require 'pry'

report = ODFReport::Report.new("test_presentation.odp") do |r|
  
  title = "Test Title 1"
  description = "A description 1"
  image_path = File.join(Dir.pwd, 'cascade.svg')

  r.add_slide(title, description, image_path, {width: 764, height: 912})
  
  title = "Test Title 2"
  description = "A description 2"
  image_path = File.join(Dir.pwd, 'live_view.svg')
  
  r.add_slide(title, description, image_path, {width: 1308, height: 300})
end

report.generate("./result/test_presentation.odp")