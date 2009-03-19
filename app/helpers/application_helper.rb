# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  %w(one_column two_columns three_columns).each_with_index do |method, index|
    eval <<-CODE
      def #{method}
        @number_of_columns = #{index + 1}
        yield
        haml_concat "<div class='clear'></div>"
        @number_of_columns = nil
      end
    CODE
  end
  
  def content_block(title = nil, opts = {}, &block)
    raise SyntaxError, "You should pass content_block as an argument to one_column, two_columns, or three_columns" if @number_of_columns.nil?
    output = "<div id=\"#{title || "dynamic"}_block\" class=\"block column_#{@number_of_columns}\"><div class=\"hr_head\"></div>"
    if title
      output = <<-HTML
        #{output}
          <h2 class="title">#{title.to_s.humanize.upcase}</h2>
          <div class="hr"></div>
        HTML
    end
    <<-HTML
      #{output}
        <div class="content">
          #{capture_haml(&block)}
        </div>
      </div>
    HTML
  end
end
