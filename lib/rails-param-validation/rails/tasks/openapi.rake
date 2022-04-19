namespace :openapi do

  desc "Export OpenAPI definition to openapi.json"
  task export: :environment do
    # Ensure all controllers are loaded
    if defined? Zeitwerk
      # Due to a regression using rails 6 (https://github.com/rails/rails/issues/37006),
      # we need to call zeitwerk explicitly
      Zeitwerk::Loader.eager_load_all
    else
      Rails.application.eager_load!
    end

    openapi = RailsParamValidation::OpenApi.new(
        RailsParamValidation.openapi.title,
        RailsParamValidation.openapi.version,
        RailsParamValidation.openapi.url,
        RailsParamValidation.openapi.description
    )

    filename = RailsParamValidation.openapi.file_path
    print "Writing #{filename}..."

    begin
      File.open(filename, "w") { |f| f.write JSON.pretty_generate(openapi.to_object) }
      puts " done."
    rescue Exception => e
      puts " failed."
      raise e
    end
  end
end