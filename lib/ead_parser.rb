require 'eadsax'
class EadParser
  attr_reader :file, :reader, :xml
  def initialize(file)
    if file.is_a?(String)
      @file = File.open(file, "r")
    elsif file.is_a?(File)
      @file = file
    end
    @xml = Nokogiri::XML(@file.read)
    @xml.remove_namespaces!
    @reader = Eadsax::Ead.parse(@xml.to_s)
  end

  def unittitle_parts(id)
    parts = OpenStruct.new
    unittitle = @xml.xpath("//*[@id='#{id}']/did/unittitle")
    [:corpname, :persname, :geogname, :famname].each do |name|
      parts.send("#{name}=", unittitle.xpath("./#{name}").map(&:text))
    end
    parts
  end
end
