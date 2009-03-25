module LocationsHelper
  def rating_stars(stars)
    output = "<span class=\"stars\">"
    5.times do
      if stars >= 1
        output << "<span class=\"fullstar\"></span>"
      elsif stars >= 0
        output << "<span class=\"halfstar\"></span>"
      else
        output << "<span class=\"blankstar\"></span>"
      end
      stars -= 1
    end
    "#{output}</span>"
  end
end
