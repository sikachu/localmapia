require 'yaml'

%w(location event).each do |type|
  categories = YAML.load(File.read("#{RAILS_ROOT}/db/fixtures/#{type}_categories.yml"))

  if categories.is_a? Array
    categories.each do |row|
      if row.is_a? Hash
        parent, children = row.keys.first, row[row.keys.first]
      else
        parent, children = row, []
      end
      parent_category = Category.seed(:parent_id, :title, :category_type) do |s|
        s.title = parent
        s.navigation = parent
        s.category_type = type
      end
    
      children.each do |child|
        Category.seed(:parent_id, :title, :category_type) do |s|
          s.parent_id = parent_category.id
          s.title = child
          s.navigation = "#{parent} &gt; #{child}"
          s.category_type = type
        end
      end
    end
  end
end