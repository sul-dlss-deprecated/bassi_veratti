require 'rsolr'
require 'ead_parser'
desc "Parse EAD File"
task :"parse-ead" do
  
  ead = EadParser.new("#{Rails.root}/data/bv-ead.xml")

  solr = Blacklight.solr
  documents = solrize_ead ead
  unless documents.blank?
    documents.each{|doc| solr.add doc }
    solr.commit
  end
  #all_items(ead)
  
end

def all_items(ead)
  ead.reader.archdesc.dsc.c01s.each do |c01|
    c01.c02s.each do |c02|
      puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} -> #{c02.dao.try(:href)} | #{print_types(c02)}"
      c02.c03s.each do |c03|
        puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} -> #{c03.level}:#{c03.identifier} -> #{c03.dao.try(:href)} | #{print_types(c03)}"
        c03.c04s.each do |c04|
          puts "#{c01.level}:#{c01.identifier} -> #{c02.level}:#{c02.identifier} -> #{c03.level}:#{c03.identifier} -> #{c04.level}:#{c04.identifier} -> #{c04.dao.try(:href)} | #{print_types(c04)}"
        end
      end
    end
    puts "\n"
  end
end


def solrize_ead(ead)
  documents = []
  ead.reader.archdesc.dsc.c01s.each do |c01|
    c01.c02s.each do |c02|
      containers = containers_for_collection(c02)
      c02.c03s.each do |c03|
        containers = containers_for_collection(c03)
        c03.c04s.each do |c04|
          containers = containers_for_collection(c04)
          documents << document_from_contents(ead, c04, c03, c01, containers)
        end
        documents << document_from_contents(ead, c03, c02, c01, containers)
      end
      documents << document_from_contents(ead, c02, c01, c01, containers)
    end
    
    documents << {:id => c01.identifier,
                  :title_tsi => clean_string(c01.did.unittitle),
                  :level_ssim => c01.level,
                  :purl_ssi => c01.dao.try(:href)}
  end
  #puts documents.join("\n")
  documents
end

def print_types(c)
  containers_for_collection(c).inspect
end

def clean_string(s)
  s.gsub(/\s+/, " ").strip unless s.nil?
end

def containers_for_collection(c)
  types = {}
  c.did.container_types.each_with_index do |type,ix|
    types[type] = c.did.containers[ix]
  end
  types
end

def description(content)
  contents = []
  content.odd.each do |odd|
    contents << clean_string(odd.try(:p))
  end
  if contents.blank? and !content.scopecontent.nil?
    contents << content.scopecontent.ps.join(" ")
  end
  contents
end

def dates_from_unitdate(did)
  dates = OpenStruct.new
  normalized_dates = did.unitdate.try(:normal)
  if normalized_dates
    dates.date = did.unitdate.try(:value)
    dates.start_year = did.unitdate.normal.split("/").first
    dates.end_year = did.unitdate.normal.split("/").last
  end
  dates
end

def document_from_contents(ead, content, direct_parent, series, containers)
  unittitle_parts = ead.unittitle_parts(content.identifier)
  dates = dates_from_unitdate(content.did)
  {:id => content.identifier,
   :title_tsi => clean_string(content.did.unittitle),
   :level_ssim => content.level,
   :direct_parent_ssim => direct_parent.identifier,
   :direct_parent_level_ssim => direct_parent.level,
   :box_ssim => containers["Box"],
   :folder_ssim => containers["Folder"],
   :series_ssim => series.identifier,
   :purl_ssi => content.dao.try(:href),
   :extent_ssim => content.did.physdesc.extent,
   :description_tsim => description(content),
   :personal_name_ssim => unittitle_parts.persname,
   :geographic_name_ssim => unittitle_parts.geogname,
   :corporate_name_ssim => unittitle_parts.corpname,
   :family_name_ssim => unittitle_parts.famname,
   :unit_date_ssim => dates.try(:date),
   :begin_year_itsim => dates.try(:start_year),
   :end_year_itsim => dates.try(:end_year)
   }
end
