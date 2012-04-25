module ODFReport

  class Slide
    attr_accessor :title, :description, :image_path

    def initialize(opts)
      @title            = opts[:title]
      @description      = opts[:description]
      @image_path       = opts[:image_path]
    end
    
  end

end