
text = "  555 people person"
puts text.index(/\d+ people/)
a = text.index(/\d+ people/)
result =  text[a..text.index(/\d people/)  ].to_i
puts result

if result > 2
    text = text.gsub(/\d+ people/,"people")
    text = text.gsub(/person/,"")
    text = text.strip!
    puts text
end


