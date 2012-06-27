module ODFReport

class Image
  
  attr_accessor :name, :path
  
  def initialize(opts)
    @name = opts[:name]
    @path = opts[:path]
    @width = opts[:width]
    @height = opts[:height]
  end
  
  def ratio
    if @width.nil? || @height.nil?
      return nil
    end
    
    @width.to_f / @height.to_f
  end
  
  def replace!(doc)
    if node = doc.xpath("//draw:frame[@draw:name='#@name']").first
      adjust_image_dimensions(node)
      if image_node = doc.xpath("//draw:frame[@draw:name='#@name']/draw:image").first
        new_image_href = replace_image_name(image_node)
      end
    end
    
    new_image_href
  end
  
  private
  
  def adjust_image_dimensions(node)
    unless ratio.nil?
      image_width = node['width']
      image_height = node['height']
      existing_ratio = image_width.to_f / image_height.to_f
      image_x = node['x']
      if ratio > existing_ratio
        adjusted_height = (parse_svg_dimension(image_width) * (1 / ratio)).round(3)
        node['svg:height'] = "#{adjusted_height}cm"
      else
        adjusted_width = (parse_svg_dimension(image_height) * ratio).round(3)
        
        total_width = parse_svg_dimension(image_width) + (parse_svg_dimension(image_x) * 2)
        new_x = (total_width - adjusted_width) / 2
        
        node['svg:width'] = "#{adjusted_width}cm"
        node['svg:x'] = "#{new_x}cm"
      end
    end
  end
  
  # rename image to unique name and return new path
  def replace_image_name node
    image_name = SecureRandom.hex(20)
    new_image_href = ::File.join(Images::IMAGE_DIR_NAME, image_name)
    node['xlink:href'] = new_image_href
    new_image_href
  end
  
  def parse_svg_dimension(value)
    value.to_f
  end
  
end

end