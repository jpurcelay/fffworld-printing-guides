require 'csv'
require 'tilt'
require 'erb'

strings_file = 'strings.aesv.csv'
template_file= 'baobab_template.erb'
output_file= 'latex-doc.tex'

#array con los lenguajes disponibles
strings=CSV.read(strings_file , col_sep: "~" , headers: false)
strings.unshift("")
template = Tilt::ERBTemplate.new(template_file)

File.open(output_file , 'w') do |file|
  file.write template.render(Object.new, strings:strings) 
end

system "pdflatex #{output_file}"
system "pdflatex #{output_file}"
system "rm *.aux"
system "rm *.log"
system "rm *.out"
