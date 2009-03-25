# Methods added to this helper will be available to all templates in the application.
require 'uri'

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
    if title.is_a? Hash
      opts = title
      title = nil
    end
    output = "<div id=\"#{title || "dynamic"}_block\" class=\"block column_#{@number_of_columns} #{"border_bottom" if opts[:border]}\">"
    output << "<div class=\"hr_head\"></div>" unless opts[:header] == false
    button = "<div class=\"floatright button\">#{opts[:button]}</div>\n" if opts[:button]
    if title
      output = <<-HTML
        #{output}
          #{button}<h2 class="title">#{title.to_s.humanize.upcase}</h2>
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
