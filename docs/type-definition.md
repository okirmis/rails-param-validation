# Type definition

This gem provides declarative type checking. This part of the documentation will explain, how types are declared. Some types support inner types (e.g. arrays), so the definition can be nested.

* [Constants](#type-constant)
* [Alternatives](#type-alternatives)
* [String](#type-string)
* [Integer](#type-integer)
* [Float](#type-float)
* [Boolean](#type-boolean)
* [UUID (v4)](#type-uuid)
* [RegEx Pattern](#type-regex)
* [Date & DateTime](#type-date-time)
* [Optional Values](#type-optional)
* [Array](#type-array)
* [Object](#type-object)
* [Hash](#type-hash)

### Constants
<a name="type-constant"></a>

Accepts exactly the defined value, if its string representation is identical. This is especially useful in combination with alternatives.

Example:
```ruby
query_param :accept_terms, true, "The user's consent to the terms of service"
```

This would accept the values `"true"` or `true` and reject all others.

### Alternatives
<a name="type-alternatives"></a>

Accepts values that match at least one of the definitions.

Example:
```ruby
query_param :gender, [:male, :female, :other], "User's gender"
query_param :date_or_timestamp, [DateTime, Integer], "Modification date"
```

The first example will match any of the values `"male"`, `"female"`, `"other"`.

The second example will match any iso formatted date time string or a timestamp (e.g. seconds since 1970-01-01).

### String
<a name="type-string"></a>

Accept any string or type which can be converted to a string, namely: `String`, `Symbol`, `Numeric`, `Boolean`. The value will be automatically converted to a string.

Example:
```ruby
query_param :name, String, "The user's name"
```

### Integer
<a name="type-integer"></a>

Accepts an integer or a string which represents an integer. If a string is passed, which cannot be parsed to an integer, the value is rejected. If the string can be converted to an integer, this is done in any case, if the value is accepted, an integer is returned.

Example:
```ruby
query_param :year_of_birth, Integer, "The year, the user was born"
```

In this case, `params[:year_of_birth].is_a? Integer` returns `true`.


### Float
<a name="type-float"></a>

Accepts an integer, float or a string which represents a float. If a string is passed, which cannot be parsed to a float, the value is rejected. If the string can be converted to a float, this is done in any case, if the value is accepted, a float is returned. Also integers are converted to floats.

Example:
```ruby
query_param :radius, Float, "Search radius"
```

In this case, `params[:radius].is_a? Float` returns `true`.


### Boolean
<a name="type-boolean"></a>

Accepts a float or a string, which represents a boolean (either `"true"` or `"false"`).

Example:
```ruby
query_param :radius, Float, "Search radius"
```

In this case, `params[:radius].is_a? Float` returns `true`.


### Uuid
<a name="type-uuid"></a>

Accepts a string or symbol in uuid v4 format. If the string does not match the correct format, it is rejected.

Example:
```ruby
query_param :user_id, Uuid, "The user's ID"
```


### Regex
<a name="type-regex"></a>

Accepts a string or symbol, that matches a given `RegExp` pattern.

Example:
```ruby
query_param :slug, /[a-z][a-z_0-9]+/, "Slug for the article as used in the URL"
```

### Date & DateTime
<a name="type-date-time"></a>

Accept strings that represent valid dates or datetimes, e.g. `"2020-02-28"` (for dates) or `"2020-02-28T12:13:14+01:00"`.

Example:
```ruby
query_param :expiration_date, Date, "Date until the article will be available"
```

### Optional Value
<a name="type-optional"></a>

If a value is not passed, define a default value which is returned in this case. It can be used with any inner type. If the value is passed, it is validated. If it does not match, the value is rejected. If it is not specified at all, the default value is used.

Example:
```ruby
query_param :public, Optional(Boolean, false), "Will the article be publicly available"
query_param :expiration_date, Optional(Date, -> { Date.today + 14.days }), "Date until the article will be available"
```

In the first example, the constant is `false` is returned if no value is specified.

In the second example, the `Proc` is evaluated whenever no data is passed for the parameter.

### Array
<a name="type-array"></a>

Accepts a list of values. Every value of the entry has to match the inner type.

Example:
```ruby
body_param :tags, ArrayType(String), "Tags to assign to the article"
```

This can be combined with any inner type.

### Object
<a name="type-object"></a>

Accept an object with a defined list of keys. All properties have to match there definition.

Example:
```ruby
body_param :article, { 
              title: String,
              body: String,
              expiration_date: Optional(Date, Date.today + 14.days),
              tags: ArrayType(String)
            }, "Article to store"
```

### Hash
<a name="type-hash"></a>

Accept an object with arbitrary keys. The values and the keys can be validated against a type definition.

Example:
```ruby
body_param :settings, HashType(DateTime, /key_[a-z]/), "User settings"
```

In this case, all keys have to start with `key_` and the rest may only consist of lower case letters. The values have to be date times.