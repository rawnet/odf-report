module ODFReport

class Report
  include Fields, Images, Slides

  attr_accessor :fields, :tables, :images, :sections, :file, :slides

  def initialize(template_name, &block)

    @file = ODFReport::File.new(template_name)
    
    @fields = []
    @tables = []
    @images = []
    @image_names_replacements = {}
    @sections = []
    @slides = []

    yield(self)

  end
  
  def add_field(field_tag, value='', &block)
    field = Field.new({:name => field_tag, :value => value}, &block)
    @fields << field
  end

  def add_table(table_name, collection, opts={}, &block)
    opts.merge!(:name => table_name, :collection => collection)
    tab = Table.new(opts)
    @tables << tab

    yield(tab)
  end

  def add_section(section_name, collection, opts={}, &block)
    opts.merge!(:name => section_name, :collection => collection)
    sec = Section.new(opts)
    @sections << sec

    yield(sec)
  end

  def add_image(name, path, opts={})
    opts.merge!(:name => name, :path => path)
    image = Image.new(opts)
    @images << image
  end

  def add_slide_with_image(title, description, image_path, image_options = {})
    slide = Slide.new({:title => title, :description => description, :image_path => image_path, :slide_type => :image})
    @slides << slide
    add_field("TITLE#{@slides.length}", title)
    add_field("DESCRIPTION#{@slides.length}", description)
    add_image("image#{@slides.length}", image_path, image_options)
  end
  
  def add_slide_with_table(title, description, table_data)
    slide = Slide.new({:title => title, :description => description, :slide_type => :table})
    @slides << slide
    add_field("TITLE#{@slides.length}", title)
    add_field("DESCRIPTION#{@slides.length}", description)
    add_table("TABLE#{@slides.length}", table_data, :add_header => true) do |t|
      table_data.first.keys.each_with_index do |key, index|
        t.add_column("field#{index}", key)
      end
    end
  end

  def generate(dest = nil)

    @file.create(dest)

    @file.update('content.xml', 'styles.xml') do |txt|
      parse_document(txt) do |doc|
        extend_slides!(doc)
        
        replace_fields!(doc)
        replace_sections!(doc)
        replace_tables!(doc)
        replace_images!(doc)
      end

    end
    
    replace_image_files(@file, @image_names_replacements)

    @file.path

  end

private

  def parse_document(txt)
    doc = Nokogiri::XML(txt)
    yield doc
    txt.replace(doc.to_s)
  end
  
  def extend_slides!(content)
    slide_extend!(content)
  end

  def replace_fields!(content)
    field_replace!(content)
  end

  def replace_tables!(content)
    @tables.each do |table|
      table.replace!(content)
    end
  end

  def replace_sections!(content)
    @sections.each do |section|
      section.replace!(content)
    end
  end
  
  def replace_images!(content)
    @images.each do |image|
      name = image.replace!(content)
      unless name.nil?
        # Add to collection which stores actual file path and name for use in Manifest
        @image_names_replacements[name] = image.path
      end
    end
  end

end

end
