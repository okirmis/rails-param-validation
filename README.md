# RailsParamValidation

[![pipeline status](https://git.iftrue.de/okirmis/rails-param-validation/badges/master/pipeline.svg)](https://git.iftrue.de/okirmis/rails-param-validation/commits/master)

This gem provides parameter validation for Rails using a declarative parameter definition and makes the automatic validation of complex parameters very easy. It also supports an export of the definition as an OpenAPI document.

* [Why this gem?](./docs/main-idea.md)
* [Getting started](./docs/getting-started.md)
* [Annotations](./docs/annotations.md)
* [OpenAPI Export](./docs/openapi.md)

## Quick Example

Let's take a look at a very simple example: a controller with a sample action, which gets a list of floats, rounds them to the nearest integer and returns it in a json encoded form.

```ruby
class ExampleController
  desc "Show the functionality of this gem"

  action "Round float values" do
    # Expect a parameter with the name "values" which contains an array of floats
    query_param :values, ArrayType(Float), "Values to round"
    # Document the response of http status 200, which is an array of integers
    response 200, :success, ArrayType(Integer), "Rounded values response"
  end
  def sample_action
    render json: params[:values].map(&:round)
  end

  # We assume GET /round to be mapped to this action
end
```

Sending a valid request, the parameters are validated and casted correctly and we get the response one would expect:

```
$ curl -H "Accept: application/json" "http://localhost:3000/round?values[]=1.5&values[]=2.0&values[]=-0.777"
[2,2,-1]
```

When a request with invalid parameters is sent, we get an error response which also describes the error.

```
$ curl -H "Accept: application/json" "http://localhost:3000/round?values[]=1.5&values[]=2.0&values[]=XYZ"
{"status":"fail","errors":[{"path":"values/2","message":"Expected a float"}]}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-param-validation'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails-param-validator
