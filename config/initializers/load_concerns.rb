application = Rails.application
engines = application.railties.engines

# application is an engine
engines = [application, *engines]

engines.each do |engine|
  concerns_path = engine.paths['app/concerns']

  if concerns_path
    concerns_directories = concerns_path.existent_directories
  else
    # app/concerns is not set, so just derive it from root.  Cannot derive from app because it will glob app/models too
    concerns_directories = [engine.root.join('app', 'concerns').to_path]
  end

  concerns_directories.each do |concerns_directory|
    concerns_pathname = Pathname.new(concerns_directory)
    loader = Metasploit::Concern::Loader.new(root: concerns_pathname)
    loader.register
  end
end

