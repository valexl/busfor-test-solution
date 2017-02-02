load('searcher.rb')

searcher = Searcher.new(sources_file: "#{Dir.pwd}/sources.yml", trips_file: "#{Dir.pwd}/trips.yml")
searcher.save_results_to_file "#{Dir.pwd}/results.yml"
  
