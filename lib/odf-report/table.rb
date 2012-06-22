module ODFReport

class Table
  include Fields, Nested

  attr_accessor :fields, :rows, :name, :collection_field, :data, :header, :parent, :tables

  def initialize(opts)
    @name             = opts[:name]
    @collection_field = opts[:collection_field]
    @collection       = opts[:collection]
    @parent           = opts[:parent]

    @fields = []
    @tables = []

    @template_rows = []
    @header           = opts[:header] || false
    @skip_if_empty    = opts[:skip_if_empty] || false
    @add_header       = opts[:add_header] || false
  end

  def add_column(name, data_field=nil, &block)
    opts = {:name => name, :data_field => data_field}
    field = Field.new(opts, &block)
    @fields << field
  end

  def add_table(table_name, collection_field, opts={}, &block)
    opts.merge!(:name => table_name, :collection_field => collection_field, :parent => self)
    tab = Table.new(opts)
    @tables << tab

    yield(tab)
  end

  def populate!(row)
    @collection = get_collection_from_item(row, @collection_field) if row
  end

  def replace!(doc, row = nil)

    return unless table = find_table_node(doc)

    populate!(row)

    if (@skip_if_empty || !@header) && @collection.empty?
      table.remove
      return
    end
        
    @template_rows = table.xpath("table:table-row")
    
    @collection.each_with_index do |data_item, i|
      remove_unused_columns table, data_item
      
      if @add_header && i == 0
        # add header
        new_node = get_next_row
        replace_fields!(new_node, data_item, true)
        table.add_child(new_node)
      end
      
      new_node = get_next_row
      
      replace_fields!(new_node, data_item)
      
      @tables.each do |t|
        t.replace!(new_node, data_item)
      end

      table.add_child(new_node)
    end

    @template_rows.each_with_index do |r, i|
      r.remove if (get_start_node..template_length) === i
    end

  end # replace

private

  def get_next_row
    @row_cursor = get_start_node unless defined?(@row_cursor)

    ret = @template_rows[@row_cursor]
    if @template_rows.size == @row_cursor + 1
      @row_cursor = get_start_node
    else
      @row_cursor += 1
    end
    return ret.dup
  end

  def get_start_node
    @header ? 1 : 0
  end

  def reset
    @row_cursor = get_start_node
  end

  def template_length
    @tl ||= @template_rows.size
  end

  def find_table_node(doc)
    tables = doc.xpath("//draw:frame[@draw:name='#@name']/table:table")
    tables.empty? ? nil : tables.first
  end
  
  def remove_unused_columns(table, data_item)
    columns_total = data_item.keys.size
    
    columns = table.xpath("table:table-column")
    columns.each_with_index do |col, k|
      if k >= columns_total
        col.remove
      end
    end
    
    @template_rows.each do |r|
      cells = r.xpath("table:table-cell")
      cells.each_with_index do |cell, j|
        if j >= columns_total
          cell.remove
        end
      end
    end
  end

end

end
