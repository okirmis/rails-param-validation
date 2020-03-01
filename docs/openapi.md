# OpenAPI Export

When annotating the controller actions with parameter and response types, you get an [OpenAPI](https://www.openapis.org/) 3.0 export for free.

## Export task

When included in a Rails application, this gem automatically adds a rake task with the name `openapi:export`. It exports the OpenAPI definition in YAML format to the applications root directory (filename: `openapi.yaml`).

```sh
$ rake openapi:export
Writing <your_apps_dir>/openapi.yaml... done.
```

## Configuration

An OpenAPI document contains some meta data about the API. By default, the following default values are assumed:

|  Property | Default | Description |
|---|---|---|
| `info.version` | `1.0` | API version |
| `info.title`   | Application module name | Name or title of the API |
| `info.description`   | Application module name + `" application"` | The API's brief description |
| `info.url`   | `http://localhost:3000` | The base URL of the API, all specified paths are relative to that |

These properties can be configured, e.g. in the `application.rb`, using:

```ruby
# ...
module MyApp
  class Application < Rails::Application
    RailsParamValidation.openapi.title = "My App's API"
    RailsParamValidation.openapi.description = 'This is an awesome API to interact with my App'
    RailsParamValidation.openapi.version = '2.0'
    RailsParamValidation.openapi.url = 'https://api.myapp.com'

    # ...
  end
end 
```