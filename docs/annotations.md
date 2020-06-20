# Annotations

## Controller annotations

**desc**

Define a description for the controller that is later used in the OpenAPI export.

## Action annotations

All of the following annotations have to be placed **above** the action definition and must be used within an `action` block like this:

```ruby
action "Return a random number" do
  query_param :min, Optional(Float, 0.0), 'Minimum value'
  query_param :max, Optional(Float, 1.0), 'Maximum value'

  response 200, { value: Float }, 'Random value response'
end
def random_value
    render json: { value: Random.rand(params[:min]..params[:max]) }
end
```

**query_param**

Parameter passed via query string, e.g. `http://localhost/my_action?parameter=value`. The first value is the parameter name (which must be a symbol), the second is the [type definition](./type-definition.md). The last (optional) parameter to this call is the description.

**path_param**

Parameter passed as part of the actions route, e.g. `http://localhost/my_action/value` where the route definition is something like `get '/my_action/:parameter, to: 'my_controller#my_action'`. The first value is the parameter name (which must be a symbol), the second is the [type definition](./type-definition.md). The last (optional) parameter to this call is the description.

**body_param**

Parameter as part of a JSON body in a POST/PUT/PATCH operation. The first value is the parameter name (which must be a symbol) as the JSON body must be a JSON object which has a key named like the parameter. The second parameter is the [type definition](./type-definition.md). The last (optional) parameter to this call is the description.

Example body:

```json
{
  "min": 1.3,
  "max": 3.7
}
```

This body contains two parameters which have to be documented separately, e.g. like this:

```ruby
action do
  body_param :min, Optional(Float, 0.0), 'Minimum value'
  body_param :max, Optional(Float, 1.0), 'Maximum value'
end
# ...
```

**response**

The response annotation defines the possible responses the action can generate, where the first parameter is the HTTP status code, the second is the [type definition](./type-definition.md). The last (optional) parameter to this call is the description.

**accept_all_params**

To disable parameter validation, an action can be annotated with the `accept_all_params` annotation.