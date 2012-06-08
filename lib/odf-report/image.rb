module ODFReport

class Image
  
  attr_accessor :name, :path
  
  def initialize(opts)
    @name = opts[:name]
    @path = opts[:path]
  end
  
  def replace!(doc)
    txt = doc.inner_html
    
    if node = doc.xpath("//draw:frame[@draw:name='#@name']/draw:image").first
      image_href = node.attribute('href').value
      new_image_href = ::File.join(Images::IMAGE_DIR_NAME, ::File.basename(path))
      
      txt.gsub!(image_href, new_image_href)
      doc.inner_html = txt
    end
    new_image_href
  end
  
end

end