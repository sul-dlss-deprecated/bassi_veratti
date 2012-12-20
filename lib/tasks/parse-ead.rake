require 'rsolr'
require 'ead_parser'
require 'rest-client'

namespace :bassi do
  desc "Parse EAD File"
  task :"parse-ead" do
  
    ead = EadParser.new("#{Rails.root}/data/bassi-ead.xml")
    
    solr = Blacklight.solr
    documents = solrize_ead ead
    unless documents.blank?
      documents.each{|doc| solr.add doc }
      solr.commit
    end
  end
end

def solrize_ead(ead)
  documents = []
  folders = []
  ead.reader.archdesc.dsc.c01s.each do |c01|
    c01.c02s.each do |c02|
      containers = containers_for_collection(c02)
      unless folders.include? container_key(containers)
        documents << folder_from_contents(c02, containers, c01)
        folders << container_key(containers) unless folders.include? container_key(containers)
      end
      c02.c03s.each do |c03|
        containers = containers_for_collection(c03)
        unless folders.include? container_key(containers)
          documents << folder_from_contents(c02, containers, c01)
          folders << container_key(containers) unless folders.include? container_key(containers)
        end
        c03.c04s.each do |c04|
          containers = containers_for_collection(c04)
          unless folders.include? container_key(containers)
            documents << folder_from_contents(c02, containers, c01)
            folders << container_key(containers) unless folders.include? container_key(containers)
          end
          documents << document_from_contents(ead, c04, c03, c01, containers)
        end
        documents << document_from_contents(ead, c03, c02, c01, containers)
      end
      documents << document_from_contents(ead, c02, c01, c01, containers)
    end
    dates = dates_from_unitdate(c01.did)
    documents << {:id => c01.identifier,
                  :title_tsi => [clean_string(c01.did.unittitle), dates.try(:date)].join(" "),
                  :level_ssim => c01.level,
                  :description_tsim => description(c01),
                  :purl_ssi => c01.dao.try(:href)}
  end
  documents
end

# used for debugging ead hierarchy.
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

def print_types(c)
  containers_for_collection(c).inspect
end

def clean_string(s)
  s.gsub(/\s+/, " ").strip unless s.nil?
end

def container_key(containers)
  return nil if containers.blank?
  "box#{containers["Box"]}-folder#{containers["Folder"]}"
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
  if did.unitdate
    dates.date = did.unitdate.try(:value)
    if normalized_dates
      dates.start_year = did.unitdate.normal.split("/").first
      dates.end_year = did.unitdate.normal.split("/").last
    end
  end
  dates
end

def image_ids_from_purl(purl)
  image_ids=[]
  if purl
    begin 
      result = RestClient.get "#{purl}.xml"  # now get the content metadata from the PURL page and index the filenames
      doc = Nokogiri::XML(result)
      cm=doc.xpath('//contentMetadata')
      files=cm.xpath('//file')
      image_ids=files.collect {|file| file.attributes['id']}
    rescue # we might get a 404 from the rest client call if the object is not yet accessioned...
    
    end
  end
  return image_ids
end

def druid_from_purl(purl)
  purl ? "#{/[A-Za-z]{2}[0-9]{3}[A-Za-z]{2}[0-9]{4}/.match(purl)}" : nil
end

def folder_from_contents(content, containers, series)
  dates = dates_from_unitdate(content.did)
  {:id => container_key(containers),
   :title_tsi => [clean_string(content.did.unittitle), dates.try(:date)].join(" "),
   :level_ssim => "Folder",
   :box_ssim => containers["Box"],
   :folder_ssim => containers["Folder"],
   :extent_ssim => content.did.physdesc.try(:extent),
   :unit_date_ssim => dates.try(:date),
   :begin_year_itsim => dates.try(:start_year),
   :end_year_itsim => dates.try(:end_year),
   :description_tsim => description(content),
   :series_ssim => series.identifier
  }
end

def document_from_contents(ead, content, direct_parent, series, containers)
  unittitle_parts = ead.unittitle_parts(content.identifier)
  dates = dates_from_unitdate(content.did)

  purl=content.dao.try(:href)
  druid=druid_from_purl(purl)
  imageids=image_ids_from_purl(purl)

  {:id => content.identifier,
   :title_tsi => [clean_string(content.did.unittitle), dates.try(:date)].join(" "),
   :level_ssim => content.level,
   :direct_parent_ssim => direct_parent.identifier,
   :direct_parent_level_ssim => direct_parent.level,
   :box_ssim => containers["Box"],
   :folder_ssim => containers["Folder"],
   :parent_folder_ssim => container_key(containers),
   :series_ssim => series.identifier,
   :purl_ssi => purl,
   :druid_ssi => druid,
   :image_id_ssim => imageids,
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
