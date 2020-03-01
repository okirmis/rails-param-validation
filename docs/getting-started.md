# Getting started

To get started with this gem, first include it into your Rails application by adding it to your `Gemfile` ...

```ruby
gem 'rails-param-validation'
```

... and running:
```sh
$ bundle install
```

Having included the gem, you can start using it right away, e.g. by annotating a controller class:

```ruby
class ExampleController
  desc "Show the functionality of this gem"

  action "Round float values" do
    # Expect a parameter with the name "values" which contains an array of floats
    query_param :values, ArrayType(Float), "Values to round"
    # Document the response of http status 200, which is an array of integers
    response 200, ArrayType(Integer), "Rounded values response"
  end
  def sample_action
    render json: params[:values].map(&:round)
  end
end
```

The parameters for `sample_action` will be automatically checked against our definition on every request.