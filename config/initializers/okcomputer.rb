OkComputer.mount_at = 'status'

class TablesHaveDataCheck < OkComputer::Check
  def check
    msg = ""
    [
      CollectionHighlightItem,
      CollectionHighlight
    ].each do |klass|
      begin
        # has at least one record and use select(:id) to avoid returning all data
        if klass.select(:id).first!.present?
          msg += "#{klass.name} has data. "
        else
          mark_failure
          msg += "#{klass.name} has no data. "
        end
      rescue ActiveRecord::RecordNotFound
        mark_failure
        msg += "#{klass.name} has no data. "
      rescue => e
        mark_failure
        msg += "#{e.class.name} received: #{e.message}. "
      end
    end
    mark_message msg
  end
end
OkComputer::Registry.register "feature-tables-have-data", TablesHaveDataCheck.new
OkComputer::Registry.register "feature-cache", OkComputer::CacheCheck.new
OkComputer::Registry.register "external-solr", OkComputer::HttpCheck.new('https://sul-solr.stanford.edu/api/node/health')
