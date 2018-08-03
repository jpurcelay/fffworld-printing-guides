require 'csv'
require 'tilt'
require 'erb'

languages=["es","en","fr","it","pt","de"]
versions=["amazon" , "fffworld"]

if languages.include?(ARGV[0]) && versions.include?(ARGV[1]) 
  lang = ARGV[0]
  version = ARGV[1]
  strings_file = "translations/#{lang}/strings.aesv.csv"
  captions_strings_file = "translations/#{lang}/captions_strings.aesv.csv"
  template_file= "templates/main_template.erb"
  output_file= "#{lang.upcase}_Baobab_#{version.upcase}_Guide.tex"

  datasheet_table_strings_file = "translations/#{lang}/datasheet_table_strings.aesv.csv"
  printingtips_table_strings_file = "translations/#{lang}/printingtips_table_strings.aesv.csv"
  data_and_tips_section_template_file= "templates/data_and_tips_section_template.erb"
  data_and_tips_section_output_file= "data_and_tips_section.tex"
  data_and_tips_section_strings_file= "translations/#{lang}/data_and_tips_section_strings.aesv.csv"
  review_request_section_strings_file= "translations/#{lang}/review_request_section_strings.aesv.csv"
  review_request_section_template_file= "templates/review_request_section_template.erb"
  review_request_section_output_file= "review_request_section.tex"


  datasheet_table_strings=CSV.read(datasheet_table_strings_file , col_sep: "~" , headers: false)
  printingtips_table_strings=CSV.read(printingtips_table_strings_file , col_sep: "~" , headers: false)
  data_and_tips_section_strings=CSV.read(data_and_tips_section_strings_file, col_sep: "~" , headers: false)
  review_request_section_strings=CSV.read(review_request_section_strings_file, col_sep: "~" , headers: false)

  template = Tilt::ERBTemplate.new(data_and_tips_section_template_file)

  File.open(data_and_tips_section_output_file , 'w') do |file|
  file.write template.render(Object.new, strings:data_and_tips_section_strings , datasheet:datasheet_table_strings, printingtips:printingtips_table_strings) 
  end

  template = Tilt::ERBTemplate.new(review_request_section_template_file)

  File.open(review_request_section_output_file , 'w') do |file|
    file.write template.render(Object.new, strings:review_request_section_strings) 
  end


  strings=CSV.read(strings_file , col_sep: "~" , headers: false)
  captions_strings=CSV.read(captions_strings_file , col_sep: "~" , headers: false)
  template = Tilt::ERBTemplate.new(template_file)

  File.open(output_file , 'w') do |file|
    file.write template.render(Object.new, strings:strings , captions_strings:captions_strings , version:version) 
  end

  system "pdflatex #{output_file}"
  system "pdflatex #{output_file}"
  system "rm *.aux"
  system "rm *.log"
  system "rm *.out"
  system "rm *.tex"

else
	puts "not correct lang or version argument provided blyat"
	puts "[es , en , pt , fr , de , it] langs accepted"
	puts "[amazon, fffworld] versions accepted"
	puts "try: ruby guide_builder lang version"

end
