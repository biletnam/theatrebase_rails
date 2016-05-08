module Shared::MarkupHelper

  def join_arr array
    array.join('').to_s
  end

  def link_markup path, id, text
    "<a href='/#{path}/#{id}'>#{text}</a>"
  end

  def add_table_class element, element_class
    element == 'table' ? ['table', element_class.to_s].join(' ').strip : element_class
  end

  def bookend_tags element, markup, element_class=nil, colspan=nil
    element_class = add_table_class(element, element_class)
    element_class = element_class ? " class='#{element_class}'" : ''
    colspan = colspan ? " colspan='#{colspan}'" : ''
    "<#{element}#{element_class}#{colspan}>#{markup}</#{element}>"
  end

  def compile_header_markup header_values
    header_markup = join_arr(header_values.map { |v| bookend_tags('th', v[:content], nil, v[:colspan]) })
    bookend_tags('tr', header_markup)
  end

  def compile_colwidth_markup colwidth_values
    join_arr(colwidth_values.map { |v| "<col width=#{v[:width]}%>" })
  end

  def compile_rows row_values, header_values=nil, colwidth_values=nil
    rows_markup = row_values.map do |data_cell_values|
      data_cells_markup = join_arr(data_cell_values.map { |v| bookend_tags('td', v[:content], v[:class]) })
      bookend_tags('tr', data_cells_markup)
    end
    header_markup = header_values ? compile_header_markup(header_values) : ''
    coldwidth_markup = colwidth_values ? compile_colwidth_markup(colwidth_values) : ''
    coldwidth_markup + header_markup + rows_markup.join('')
  end

  def create_content_container row_values
    table_markup = bookend_tags('table', compile_rows(row_values), 'content-table')
    bookend_tags('div', table_markup, 'content-container').html_safe
  end

end
