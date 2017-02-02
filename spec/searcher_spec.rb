require 'rspec'
load 'searcher.rb'

RSpec.describe Searcher do
  let(:subject)      { described_class.new sources_file: sources_file, trips_file: trips_file }
  let(:sources_file) { "#{Dir.pwd}/sources.yml" }
  let(:trips_file)   { "#{Dir.pwd}/trips.yml" }
  let(:results_file) { "#{Dir.pwd}/spec/tmp/results.yml" }
  
  let(:expected_results) do
    YAML.load(File.read("#{Dir.pwd}/spec/fixtures/expected_results.yml"))
  end

  after(:each) do
    File.delete(results_file) if File.exist?(results_file)
  end

  it 'initial test' do
    expect(subject).to be_a(Searcher) 
  end

  describe "#results" do
    it 'returns array' do
      expect(subject.results).to be_a(Array)
    end

    it 'returns expected records' do
      expect(subject.results).to eq(expected_results)
    end
  end

  describe "#save_results_to_file" do
    it 'saves results to file' do
      subject.save_results_to_file(results_file)
      expect(YAML.load(File.read(results_file))).to eq(expected_results)
    end
  end
end
