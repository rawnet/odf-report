module ODFReport

class Report
  include Fields, Images, Slides

  attr_accessor :fields, :tables, :images, :sections, :file, :slides

  def initialize(template_name, &block)

    @file = ODFReport::File.new(template_name)
    
    @fields = []
    @tables = []
    @images = {}
    @image_names_replacements = {}
    @sections = []
    @slides = []

    yield(self)

  end
  
  def add_field(field_tag, value='', &block)
    opts = {:name => field_tag, :value => value}
    field = Field.new(opts, &block)
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

  def add_image(name, path)
    @images[name] = path
  end

  def add_slide(title, description, image_path)
    opts= {:title => title, :description => description, :image_path => image_path}
    slide = Slide.new(opts)
    @slides << slide
    add_field("TITLE#{@slides.length}", title)
    add_image("image#{@slides.length}", image_path)
  end

  def generate(dest = nil)

    @file.create(dest)

    @file.update('content.xml', 'styles.xml') do |txt|

      parse_document(txt) do |doc|
        extend_slides!(doc)
        
        replace_fields!(doc)
        replace_sections!(doc)
        replace_tables!(doc)

        find_image_name_matches(doc)

      end

    end
    
    replace_images(@file)

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

end

end
