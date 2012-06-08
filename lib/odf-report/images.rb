module ODFReport

  module Images

    IMAGE_DIR_NAME = "Pictures"
    
    # Add new image files and update manifest
    def replace_image_files(file, collection)
      FileUtils.mkpath(::File.join(file.tmp_dir, Images::IMAGE_DIR_NAME))
            
      collection.each do |name, path|
        file.update(name) do |content|
          content.replace ::File.read(path)
        end
      end
      file.update('META-INF/manifest.xml') do |manifest_file|
        txt = Nokogiri::XML(manifest_file)
        manifest_node = txt.xpath('manifest:manifest').first()
        collection.each do |name, _|
          file_text = '<manifest:file-entry manifest:full-path="' << name << '"/>'
          manifest_node.add_child file_text
        end
        manifest_file.replace txt.to_s
      end
    end
      
  end

end