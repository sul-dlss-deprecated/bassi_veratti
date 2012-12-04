require 'rsolr'
require 'ead_parser'
desc "Parse EAD File"
task :"parse-ead" do
  #solr = Blacklight.solr
  #solr.commit
  
  ead = EadParser.new("#{Rails.root}/data/bv-ead.xml")
#puts ead.reader.archdesc.dsc.c01s.first.c02s.first.did



  all_items(ead)
  
end

def all_items(ead)
  ead.reader.archdesc.dsc.c01s.each do |c01|
    c01.c02s.each do |c02|
      puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} | #{print_types(c02)}"
      c02.c03s.each do |c03|
        puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} -> #{c03.level}:#{c03.identifier} | #{print_types(c03)}"
        c03.c04s.each do |c04|
          puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} -> #{c03.level}:#{c03.identifier} -> #{c04.level}:#{c04.identifier} | #{print_types(c04)}"
        end
      end
    end
    puts "\n"
  end
end

def print_types(c)
  types = {}
  c.did.container_types.each_with_index do |type,ix|
    types[type] = c.did.containers[ix]
  end
  types.inspect
end