module ODFReport

  class Slide
    attr_accessor :title, :description, :image_path, :type

    def initialize(opts)
      @title            = opts[:title]
      @description      = opts[:description]
      @image_path       = opts[:image_path]
      @type             = opts[:slide_type]
    end
    
  end

end