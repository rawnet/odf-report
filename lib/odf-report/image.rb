module ODFReport

class Image
  
  IMAGE_DIR_NAME = "Pictures"
  
  attr_accessor :name, :path
  
  def initialize(opts)
    @name = opts[:name]
    @path = opts[:path]
  end
  
  def replace!(doc, file)
    FileUtils.mkpath(::File.join(file.tmp_dir, IMAGE_DIR_NAME))
    txt = doc.inner_html
    
    if node = doc.xpath("//draw:frame[@draw:name='#@name']/draw:image").first
      image_href = node.attribute('href').value
      new_image_href = ::File.join(IMAGE_DIR_NAME, "#{::File.basename(@name)}#{::File.extname(@path)}")
      txt.gsub!(image_href, new_image_href)
      file.update(new_image_href) do |content|
        content.replace ::File.read(@path)
      end
    end
  end
  
end

end