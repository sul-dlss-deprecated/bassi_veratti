require 'eadsax'
class EadParser
  attr_reader :file, :reader
  def initialize(file)
    if file.is_a?(String)
      @file = File.open(file, "r")
    elsif file.is_a?(File)
      @file = file
    end
    @reader = Eadsax::Ead.parse(@file.read)
  end
  
  def series
    @reader.archdesc.dsc.c01s
  end
  
  def subseries
    
  end
  
end