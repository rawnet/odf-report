module ODFReport

  class File

    attr_accessor :tmp_dir, :path

    def initialize(template)

      raise "Template [#{template}] not found." unless ::File.exists? template

      @template = template
      @extension = @template.to_s.slice(-3..-1)
      raise "Invalid template type [#{@extension}] not found." unless ['odt', 'odp'].include? @extension
      @tmp_dir = ::File.join(Dir.tmpdir, random_filename(:prefix=>"#{@extension}_"))
      Dir.mkdir(@tmp_dir) unless ::File.exists? @tmp_dir
      @last_entry = nil
    end
    
    def create(dest)
      if dest
        FileUtils.cp(@template, dest)
        @path = dest
      else
        FileUtils.cp(@template, @tmp_dir)
        @path = "#{@tmp_dir}/#{::File.basename(@template)}"
      end
    end

    def update(*content_files, &block)

      content_files.each do |content_file|

        update_content_file(content_file) do |txt|

          yield txt

        end

      end

    end

    private

    def update_content_file(content_file, &block)
      Zip::ZipFile.open(@path) do |z|
        tmp_file_path = "#{@tmp_dir}/#{content_file}"

        # create new file if necessary, or open existing
        if z.find_entry(content_file).nil?
          ::File.open(tmp_file_path, 'w') {}
        else
          z.extract(content_file, tmp_file_path)
        end

        txt = ''

        # read then wait for input
        ::File.open(tmp_file_path, "r") do |f|
          txt = f.read
        end

        yield(txt)

        ::File.open(tmp_file_path, "w") do |f|
           f.write(txt)
        end
        
        if z.find_entry(content_file).nil?
          z.add(content_file, tmp_file_path)
        else
          z.replace(content_file, tmp_file_path)
        end
      end
    end

    def random_filename(opts={})
      opts = {:chars => ('0'..'9').to_a + ('A'..'F').to_a + ('a'..'f').to_a,
              :length => 24, :prefix => '', :suffix => '',
              :verify => true, :attempts => 10}.merge(opts)
      opts[:attempts].times do
        filename = ''
        opts[:length].times { filename << opts[:chars][rand(opts[:chars].size)] }
        filename = opts[:prefix] + filename + opts[:suffix]
        return filename unless opts[:verify] && ::File.exists?(filename)
      end
      nil
    end

  end

end