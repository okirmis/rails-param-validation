namespace :openapi do

  desc "Export OpenAPI definition to to openapi.yaml"
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

    filename = Rails.root.join("openapi.yaml").to_s
    print "Writing #{filename}..."

    begin
      File.open(filename, "w") { |f| f.write YAML.dump(openapi.to_object) }
      puts " done."
    rescue Exception => e
      puts " failed."
      raise e
    end
  end
end