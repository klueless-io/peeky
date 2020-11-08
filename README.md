# Peeky

> Peeky is a Ruby GEM for peaking into ruby classes and extracting meta

When using the source code for this gem, start by running `bin/setup` to install locally or `bundle install`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peeky'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install peeky
```

## Stories

### Main Story

As a Ruby Developer, I should be able to Reverse engineer classes and methods, so that I can document and understand them

See all [stories](./STORIES.md)

### Featured Stories

- As a Developer, I should be able to interrogate class instance information, so that I can reverse engineer a ruby class
- As a Developer, I can render a method with minimal parameter calls, So that I know the minimum parameters when calling a method
- As a Developer, I can render a class with instance attributes and methods, So that I can quickly mock out an entire class

## Usage

See all [usage examples](./USAGE.md)

### Basic Example

This example assumes you have this simple class



```ruby
module Sample
  class SimpleClass
    attr_accessor :read_write

    def position_and_optional(aaa, bbb = 1)
    end
  end
end      
```


### Rendering Examples

Here a list of example renderers for the simple class

#### Class interface
Render simple class using class_interface renderer with compact formatting

```ruby
puts api.render_class(:class_interface, instance: Sample::SimpleClass.new)
```



```ruby
class SimpleClass
  attr_accessor :read_write

  def position_and_optional(aaa, bbb = nil);                                      end
end
```

#### Documented class interface
Render simple class using class_interface_yard renderer to product YARD compatible documentation

```ruby
puts api.render_class(:class_interface_yard, instance: Sample::SimpleClass.new)
```



```ruby
class SimpleClass
  # Read write
  attr_accessor :read_write

  # Position and optional
  #
  # @param aaa [String] aaa (required)
  # @param bbb [String] bbb (optional)
  def position_and_optional(aaa, bbb = nil)
  end
end
```

#### Class debug
Render debug information

```ruby
puts api.render_class(:class_debug, instance: Sample::SimpleClass.new)
```



```text
----------------------------------------------------------------------
class name                    : SimpleClass
module name                   : Sample
class full name               : Sample::SimpleClass

-- Attributes --------------------------------------------------------
attr_accessor                 : read_write

-- Public Methods ----------------------------------------------------
position_and_optional::
name                 param format         type
----------------------------------------------------------------------
aaa                  aaa                  param_required
bbb                  bbb = nil            param_optional
```




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klueless-io/peeky. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Peeky project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/klueless-io/peeky/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) David. See [MIT License](LICENSE.txt) for further details.
