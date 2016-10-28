# monkey patch
# from https://github.com/projectblacklight/blacklight/commit/efd86b972b7eaa44564183b1197b0c5f1354cd57#diff-69b25eaf076d23e3438a3ad4211020acR45
# Remove after upgrading Blacklight >= 5.7.2

module Blacklight::Solr::Document
  def to_model
    self
  end

  def persisted?
    true
  end
end
