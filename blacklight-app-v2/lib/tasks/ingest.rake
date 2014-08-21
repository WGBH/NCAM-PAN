namespace :ingest do
  desc "Load NCAM_AFA data"
  task :ncamafa => :environment do
    file = ENV['file']
    Ingest::Ncamafa.new(file).process!
  end
  
end
