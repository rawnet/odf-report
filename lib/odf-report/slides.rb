module ODFReport

  module Slides

    # Copy existing draw:page node for each slide and replace unique values
    def slide_extend!(_node, data_item = nil)
      return if @slides.length < 2
      slide_node = _node.xpath('//draw:page').first()
      return if slide_node.nil?
      slide_template = slide_node.to_s
      image_href = slide_node.xpath('//draw:image').attr("href").value
      @slides.slice(1..-1).each_with_index do |s, i|
        node_txt = slide_template
        node_txt.gsub!("draw:name=\"page1\"", "draw:name=\"page#{i+2}\"")
        node_txt.gsub!("draw:page-number=\"1\"", "draw:page-number=\"#{i+2}\"")
        node_txt.gsub!("[TITLE1]", "[TITLE#{i+2}]")
        node_txt.gsub!("[DESCRIPTION1]", "[DESCRIPTION#{i+2}]")
        node_txt.gsub!("image1", "image#{i+2}")
        node_txt.gsub!(image_href, "Pictures/image#{i+2}#{::File.extname(s.image_path)}")
        
        slide_node.add_next_sibling(node_txt)
      end
    end
    
  end
end