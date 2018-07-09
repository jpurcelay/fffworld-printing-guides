require 'csv'
require 'tilt'
require 'erb'

strings_file = 'strings.aesv.csv'
template_file= 'baobab_template.erb'
output_file= 'latex-doc.tex'

datasheet_table_strings_file = 'datasheet_table_strings.aesv.csv'
printingtips_table_strings_file = 'printingtips_table_strings.aesv.csv'
data_and_tips_section_template_file= 'data_and_tips_section_template.erb'
data_and_tips_section_output_file= 'data_and_tips_section.tex'

datasheet_table_strings=CSV.read(datasheet_table_strings_file , col_sep: "~" , headers: false)
printingtips_table_strings=CSV.read(printingtips_table_strings_file , col_sep: "~" , headers: false)

template = Tilt::ERBTemplate.new(data_and_tips_section_template_file)

File.open(data_and_tips_section_output_file , 'w') do |file|
  file.write template.render(Object.new, datasheet:datasheet_table_strings, printingtips:printingtips_table_strings) 
end


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
