module ODFReport

  module Images

    IMAGE_DIR_NAME = "Pictures"
    
    # Add new image files and update manifest
    def replace_images(file, collection)
      FileUtils.mkpath(::File.join(file.tmp_dir, Images::IMAGE_DIR_NAME))
      
      file.update('manifest.xml') do |manifest_file|
        txt = Nokogiri::XML(manifest_file)
        puts txt
        manifest_node = txt.xpath('//manifest:file-entry').first()
      
        collection.each_pair do |name, path|
          file.update(name) do |content|
            content.replace ::File.read(path)
          end
          file_text = '<manifest:file-entry manifest:full-path="' << path << '"/>'
          manifest_node.add_next_sibling file_text
        end
      end
    end
      
  end

end