# extends FormBuilder
class ActionView::Helpers::FormBuilder
  def field_for(method, opts = {})
    opts[:class] ||= :half
    text = eval "#{opts[:type] || 'text_field'} method, html_opts(opts)"
    render_row(method, text, opts)
  end
  
  def select_for(method, collection, opts = {})
    text = select method, collection, html_opts(opts)
    render_row(method, text, opts)
  end
  
  def date_select_for(method, opts = {})
    text = date_select method, html_opts(opts)
    render_row(method, text, opts)
  end
  
  def country_select_for(method, opts = {})
    text = country_select method, nil, html_opts(opts)
    render_row(method, text, opts)
  end
  
  def state_select_for(method, country='US', opts={})
    country = case country
      when "United States" then "US"
      when "Germany" then "GERMAN"
      else country
    end
      
    text = state_select method, country, html_opts(opts)
    render_row(method, text, opts)
  end
  
  def submit_row(value, opts={})
    opts[:class] = :submit
    text = submit(value, html_opts(opts))
    opts[:_type] = :submit
    render_row(nil, text, opts)
  end
  
  def check_box_for(method, opts={}, checked_value = "1", unchecked_value = "0")
    text = check_box(method, opts, checked_value, unchecked_value)
    opts[:_type] = :checkbox
    render_row(method, text, opts)
  end
  
  def row(text, opts={})
    opts[:_type] = :row
    opts[:after] = text
    render_row(nil, "", opts)
  end
  
  def field_row(opts = {}, &block)
    text = yield block
    opts[:label] ||= "Field"
    opts[:_type] = :row
    render_row(nil, text, opts)
  end
  
  protected
  
  def render_row(method, text, opts = {})
    opts[:required] = validation_fields.include?(method.to_s) if !method.blank? and opts[:required].nil?
    dom_object_id = "#{object_name}_#{method.to_s}"
    after = "%small##{dom_object_id}_after.after #{opts[:after]}" if opts[:after]
    after = "%small##{dom_object_id}_after.after.error #{opts[:label].nil? ? method.to_s.humanize : opts[:label].to_s} #{opts[:error]}" if opts[:error] # error handling
    below = "##{dom_object_id}_below.below #{opts[:below].gsub(/\n/, '<br />')}" if opts[:below]
    required = "<span class=\"required_field\">*</span>" if opts[:required]
    if opts[:no_label] or (%w(submit checkbox row).include? opts[:_type].to_s and opts[:label].nil?)
      label = ".field_space"
    else
      label = "%label{:for => :#{dom_object_id}} #{opts[:label].nil? ? method.to_s.humanize : opts[:label].to_s}:"
    end
    out = <<-outtext
.row
  #{label}
  .field
    #{text.gsub(/\n/, " ")}#{required}
    #{after}
    #{below}
  .clear
    outtext
    Haml::Engine.new(out).render
  end
  
  def html_opts(opts)
    hsh = opts.clone
    hsh.each do |key, value|
      hsh.delete(key) if %w(required after below label no_label).include? key.to_s
    end
    hsh
  end
  
  def validation_fields
    if @validation_fields.nil? and @object
      new_obj = @object.class.new
      new_obj.valid? # should be listing all validations
      @validation_fields = new_obj.errors.collect{|f| f[0]}.uniq
    end
    @validation_fields ||= []
  end
end

module ActionView::Helpers::FormOptionsHelper
  def self.supported_countries
    constants.grep(/_STATES$/)
  end
end
