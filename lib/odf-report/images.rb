module ODFReport

  module Images

    IMAGE_DIR_NAME = "Pictures"
    
    def image_replace!(_node)
      
      FileUtils.mkdir(::File.join(file.tmp_dir, IMAGE_DIR_NAME))
      txt = _node.inner_html
      
      @images.each_pair do |image_name, path|
        if node = _node.xpath("//draw:frame[@draw:name='#{image_name}']/draw:image").first
          image_href = node.attribute('href').value
          new_image_href = ::File.join(IMAGE_DIR_NAME, "#{::File.basename(image_name)}#{::File.extname(path)}")
          txt.gsub!(image_href, new_image_href)
          @file.update(new_image_href) do |content|
            content.replace ::File.read(path)
          end
        end
      end
    end

    # def find_image_name_matches(content)
    #   @images.each_pair do |image_name, path|
    #     if node = content.xpath("//draw:frame[@draw:name='#{image_name}']/draw:image").first
    #       placeholder_path = node.attribute('href').value
    #       @image_names_replacements[path] = ::File.join(IMAGE_DIR_NAME, ::File.basename(placeholder_path))
    #     end
    #   end
    # 
    # end
    # 
    # def replace_images(file)
    # 
    #   return if @images.empty?
    #   FileUtils.mkdir(::File.join(file.tmp_dir, IMAGE_DIR_NAME))
    #   @image_names_replacements.each_pair do |path, template_image|
    #     file.update(template_image) do |content|
    #       content.replace ::File.read(path)
    #     end
    # 
    #   end
    # 
    # end # replace_images


  end

end