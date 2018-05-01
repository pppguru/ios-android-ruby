# Assists with table sorting
module SortHelper
  def sortable_columns
    %w[created_at]
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_link(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    icon = sort_direction == 'asc' ? 'glyphicon glyphicon-chevron-up' : 'glyphicon glyphicon-chevron-down'
    icon = column == sort_column ? icon : ''
    # rubocop:disable Rails/OutputSafety
    link_to "#{title} <span class='#{icon}'></span>".html_safe, column: column, direction: direction
    # rubocop:enable Rails/OutputSafety
  end
end
