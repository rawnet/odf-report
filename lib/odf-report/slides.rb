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
        node_txt.gsub!("draw:name=\"page#{i+1}\"", "draw:name=\"page#{i+2}\"")
        node_txt.gsub!("draw:page-number=\"#{i+1}\"", "draw:page-number=\"#{i+2}\"")
        node_txt.gsub!("[TITLE#{i+1}]", "[TITLE#{i+2}]")
        node_txt.gsub!("[DESCRIPTION#{i+1}]", "[DESCRIPTION#{i+2}]")
        unless s.image_path.nil?
          node_txt.gsub!("image#{i+1}", "image#{i+2}")
          node_txt.gsub!(image_href, "Pictures/image#{i+2}#{::File.extname(s.image_path)}")
        end
        node_txt.gsub!("draw:name=\"TABLE#{i+1}\"", "draw:name=\"TABLE#{i+2}\"")
        slide_node.add_next_sibling(node_txt)
        
        # update slide_node so slides are added in correct order
        slide_node = _node.xpath('//draw:page').last()
      end
      slide_node
    end
    
  end
end