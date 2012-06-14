require '../lib/odf-report'
require 'ostruct'
require 'pry'

report = ODFReport::Report.new("test_presentation.odp") do |r|
  
  title = "Test Title 1"
  description = "A description 1"
  image_path = File.join(Dir.pwd, 'cascade.svg')

  r.add_slide(title, description, image_path, {width: 912, height: 764})
  
  title = "Test Title 2"
  description = "A description 2"
  image_path = File.join(Dir.pwd, 'live_view.svg')
  
  r.add_slide(title, description, image_path, {width: 728, height: 150})
  
  title = "Test Title 3"
  description = "A description 3"
  image_path = File.join(Dir.pwd, 'piriapolis.jpg')
  
  r.add_slide(title, description, image_path)
  
  title = "Test Title 4"
  description = "A description 4"
  image_path = File.join(Dir.pwd, 'narrow_cascade.svg')
  
  r.add_slide(title, description, image_path, {width: 600, height:1400})
end

report.generate("./result/test_presentation.odp")