require 'eadsax'
class EadParser
  attr_reader :file, :reader
  def initialize(file)
    if file.is_a?(String)
      @file = File.open(file, "r")
    elsif file.is_a?(File)
      @file = file
    end
    xml = Nokogiri::XML(@file.read)
    xml.remove_namespaces!
    @reader = Eadsax::Ead.parse(xml.to_s)
  end
  
end