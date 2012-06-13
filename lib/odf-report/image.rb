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
      return 1
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
    unless ratio == 1    
      image_width = node['width']
      image_height = node['height']
      if ratio > 1
        adjusted_height = (parse_svg_dimension(image_height) * (1 / ratio)).round(3)
        node['svg:height'] = "#{adjusted_height}cm"
      else
        adjusted_width = (parse_svg_dimension(image_width) * ratio).round(3)
        node['svg:width'] = "#{adjusted_width}cm"
      end
    end
  end
  
  def replace_image_name node
    new_image_href = ::File.join(Images::IMAGE_DIR_NAME, ::File.basename(path))
    node['xlink:href'] = new_image_href
    new_image_href
  end
  
  def parse_svg_dimension(value)
    value.to_f
  end
  
end

end