require 'yaml'
categories = YAML.load(File.read("#{RAILS_ROOT}/db/fixtures/categories.yml"))

categories.each do |hash|
  parent, children = hash.keys.first, hash[hash.keys.first]
  parent_category = Category.seed(:parent_id, :title, :category_type) do |s|
    s.title = parent
    s.navigation = parent
    s.category_type = "location"
  end
  
  children.each do |child|
    Category.seed(:parent_id, :title, :category_type) do |s|
      s.parent_id = parent_category.id
      s.title = child
      s.navigation = "#{parent} &gt; #{child}"
      s.category_type = "location"
    end
  end
end