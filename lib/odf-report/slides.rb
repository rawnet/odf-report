module ODFReport

  module Slides

    # Copy existing draw:page node for each slide and replace unique values
    def slide_extend!(_node, data_item = nil)
      return if @slides.length < 2

      if @single
        slide_node = _node.xpath('//draw:page').first()
        slice = 1..-1
      else
        slide_node = _node.xpath('//draw:page')[1]
        slice = 2..-1
      end

      return if slide_node.nil?
      slide_template = slide_node.to_s
      image_href = slide_node.xpath('//draw:image').attr("href").value
      @slides.slice(slice).each_with_index do |s, i|
        i += 1 if !@single

        node_txt = slide_template
        node_txt.gsub!("draw:name=\"page#{i+1}\"", "draw:name=\"page#{i+2}\"")
        node_txt.gsub!("draw:page-number=\"#{i+1}\"", "draw:page-number=\"#{i+2}\"")
        node_txt.gsub!("[TITLE#{i+1}]", "[TITLE#{i+2}]")
        node_txt.gsub!("[DESCRIPTION#{i+1}]", "[DESCRIPTION#{i+2}]")
        
        node_txt.gsub!("image#{i+1}", "image#{i+2}")
        node_txt.gsub!("draw:name=\"TABLE#{i+1}\"", "draw:name=\"TABLE#{i+2}\"")
        
        node_txt.gsub!("[PAGE#{i+1}]", "[PAGE#{i+2}]")
        
        unless s.image_path.nil?
          node_txt.gsub!(image_href, "Pictures/image#{i+2}#{::File.extname(s.image_path)}")
        end
        
        if @single
          slide_node.add_next_sibling(node_txt)
          # update slide_node so slides are added in correct order
          slide_node = _node.xpath('//draw:page').last
        else
          last_node = _node.xpath('//draw:page').last
          last_node.add_previous_sibling(node_txt)
          # update slide_node so slides are added in correct order
          slide_node = _node.xpath('//draw:page').last
        end

        slide_node
      end
      
      # Remove images or tables if not used
      @slides.slice(0..-1).each_with_index do |s, i|
        if s.type == :text
          _node.xpath("//draw:frame[@draw:name='TABLE#{i+1}']").remove
          _node.xpath("//draw:frame[@draw:name='image#{i+1}']").remove
        elsif s.type == :image
          _node.xpath("//draw:frame[@draw:name='TABLE#{i+1}']").remove
        elsif s.type == :table
          _node.xpath("//draw:frame[@draw:name='image#{i+1}']").remove
        end
      end
    end

  end
end


          
        