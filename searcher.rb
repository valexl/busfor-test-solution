require 'yaml'

# Class for search trips by priority and clearing results of that
class Searcher
  # fields which we considere as a primary keys for this set
  PRIMARY_KEYS = ['from', 'to', 'start_time', 'start_date', 'end_time', 'end_date']

  # @params [String] sources_file path to file with sources
  # @params [String] trips_file path to file with trips
  # @return [Searcher]
  def initialize(sources_file:, trips_file:)
    @sources_file = sources_file
    @trips_file   = trips_file
  end

  # @params [String] path - file to result file
  # @return [Boolean] true if everything is ok and false if sometghing happens
  def save_results_to_file(path)
    File.open(path,"w") do |f|
      f.write(results.to_yaml)
    end
  end

  # @return [Array] uniq trips based on priority 
  def results
    @results ||= grouped_by_primary_keys_trips.values.map do |trip_set|
      trip_set.sort do |t1, t2| 
        get_priority_for_trip(t2) <=> get_priority_for_trip(t1)
      end.first
    end
  end

  private
    # loaded from sources_file sources
    # @return [Hash]
    def sources
      @sources ||= YAML.load(File.read(@sources_file))
    end

    # loaded from trips_file trips
    # @return [Hash]
    def trips
      @trips ||= YAML.load(File.read(@trips_file))
    end

    # grouped by primary keys trips
    # @return [Hash] of grouped by PRIMARY_KEYS trips
    def grouped_by_primary_keys_trips
      trips.group_by {|trip| trip.values_at(*PRIMARY_KEYS).join(":")}
    end

    # return priority for given trip
    # @params [Hash] trip 
    # @return [Integer] priority
    def get_priority_for_trip(trip)
      sources[trip['source']]
    end
end
