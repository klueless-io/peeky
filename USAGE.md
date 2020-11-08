# Peeky

> Peeky is a Ruby GEM for peaking into ruby classes and extracting meta

As a Ruby Developer, I should be able to Reverse engineer classes and methods, so that I can document and understand them

## Usage

### Sample Classes

The usage examples listed below will work with these sample classes

#### Simple example


```ruby
module Sample
  class SimpleClass
    attr_accessor :read_write

    def position_and_optional(aaa, bbb = 1)
    end
  end
end      
```

#### Complex example


```ruby
module Sample
  class ComplexClass
    attr_accessor :a_read_write1, :a_read_write2
    attr_reader   :b_reader, :b_another_reader
    attr_writer   :c_writer, :c_another_writer

    def do_something_method
    end

    def looks_like_an_attr_reader
      @looks_like_an_attr_reader ||= 5
    end

    def method_01(aaa); end

    def method_02(aaa, bbb = 1); end

    def method_03(aaa, bbb = 1, ccc = 2); end

    def method_04(*aaa); end

    def method_05(aaa, bbb = 1, *ccc); end

    def method_06(**aaa); end

    def method_07(aaa, *bbb, **ccc); end

    def method_08(aaa, *bbb, **ccc, &ddd); end

    def method_09(aaa:); end

    def method_10(aaa:, bbb: 1); end

    def questionable?; end

    def destructive!; end

    def method_with_every_type_of_paramater(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg); end

    # Check that methods are sorted
    def alpha_sort2;                                        end
    def alpha_sort1;                                        end
  end
end      
```


### Build Class Information

Use build_class_info to extract meta data from a ruby class

#### Build ClassInfo
By default information is lazy loaded only when accessed


```ruby
class_info = api.build_class_info(Sample::SimpleClass.new)

puts class_info
```



```shell
Sample::SimpleClass
```

#### Build ClassInfo - pre-loaded
Pre-load will ensure that methods and parameters are loaded straight away.


```ruby
class_info = api.build_class_info(Sample::ComplexClass.new, lazy: false)

puts class_info
```



```shell
Sample::ComplexClass
```


### Render Class

Render a class using a pre-defined class renderer that can be referenced by key

#### Render class interface using class_info
Render a basic class interface in compact format &quot;One line per method&quot;.

Note: Modules are not yet supported in Peeky


```ruby
class_info = api.build_class_info(Sample::SimpleClass.new)

puts api.render_class(:class_interface, class_info: class_info)
```

#### Render class interface using an instance of the intended class


```ruby
puts api.render_class(:class_interface, instance: Sample::SimpleClass.new)
```


### Render Class Examples

Here a list of example renderers for the complex class

#### Class interface
Render simple class using class_interface renderer

```ruby
puts api.render_class(:class_interface, instance: Sample::SimpleClass.new)
```



```ruby
class ComplexClass
  attr_accessor :a_read_write1
  attr_accessor :a_read_write2

  attr_reader :b_another_reader
  attr_reader :b_reader
  attr_reader :looks_like_an_attr_reader

  attr_writer :c_another_writer
  attr_writer :c_writer

  def alpha_sort1;                                                                end
  def alpha_sort2;                                                                end
  def destructive!;                                                               end
  def do_something_method;                                                        end
  def method_01(aaa);                                                             end
  def method_02(aaa, bbb = nil);                                                  end
  def method_03(aaa, bbb = nil, ccc = nil);                                       end
  def method_04(*aaa);                                                            end
  def method_05(aaa, bbb = nil, *ccc);                                            end
  def method_06(**aaa);                                                           end
  def method_07(aaa, *bbb, **ccc);                                                end
  def method_08(aaa, *bbb, **ccc, &ddd);                                          end
  def method_09(aaa:);                                                            end
  def method_10(aaa:, bbb: nil);                                                  end
  def method_with_every_type_of_paramater(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg);end
  def questionable?;                                                              end
end
```

#### Class interface - YARD
Render complex class using class_interface_yard renderer

```ruby
puts api.render_class(:class_interface_yard, instance: Sample::ComplexClass.new)
```



```ruby
class ComplexClass
  # A read write1
  attr_accessor :a_read_write1

  # A read write2
  attr_accessor :a_read_write2

  # B another reader
  attr_reader :b_another_reader

  # B reader
  attr_reader :b_reader

  # Looks like an attr reader
  attr_reader :looks_like_an_attr_reader

  # C another writer
  attr_writer :c_another_writer

  # C writer
  attr_writer :c_writer

  # Alpha sort1
  def alpha_sort1
  end

  # Alpha sort2
  def alpha_sort2
  end

  # Destructive!
  def destructive!
  end

  # Do something method
  def do_something_method
  end

  # Method 01
  #
  # @param aaa [String] aaa (required)
  def method_01(aaa)
  end

  # Method 02
  #
  # @param aaa [String] aaa (required)
  # @param bbb [String] bbb (optional)
  def method_02(aaa, bbb = nil)
  end

  # Method 03
  #
  # @param aaa [String] aaa (required)
  # @param bbb [String] bbb (optional)
  # @param ccc [String] ccc (optional)
  def method_03(aaa, bbb = nil, ccc = nil)
  end

  # Method 04
  #
  # @param aaa [Array<Object>] *aaa - list of aaa
  def method_04(*aaa)
  end

  # Method 05
  #
  # @param aaa [String] aaa (required)
  # @param bbb [String] bbb (optional)
  # @param ccc [Array<Object>] *ccc - list of ccc
  def method_05(aaa, bbb = nil, *ccc)
  end

  # Method 06
  #
  # @param aaa [<key: value>...] **aaa - list of key/values
  def method_06(**aaa)
  end

  # Method 07
  #
  # @param aaa [String] aaa (required)
  # @param bbb [Array<Object>] *bbb - list of bbb
  # @param ccc [<key: value>...] **ccc - list of key/values
  def method_07(aaa, *bbb, **ccc)
  end

  # Method 08
  #
  # @param aaa [String] aaa (required)
  # @param bbb [Array<Object>] *bbb - list of bbb
  # @param ccc [<key: value>...] **ccc - list of key/values
  # @param ddd [Block] &ddd
  def method_08(aaa, *bbb, **ccc, &ddd)
  end

  # Method 09
  #
  # @param aaa [String] aaa: <value for aaa> (required)
  def method_09(aaa:)
  end

  # Method 10
  #
  # @param aaa [String] aaa: <value for aaa> (required)
  # @param bbb [String] bbb: <value for bbb> (optional)
  def method_10(aaa:, bbb: nil)
  end

  # Method with every type of paramater
  #
  # @param aaa [String] aaa (required)
  # @param bbb [String] bbb (optional)
  # @param ccc [Array<Object>] *ccc - list of ccc
  # @param ddd [String] ddd: <value for ddd> (required)
  # @param eee [String] eee: <value for eee> (optional)
  # @param fff [<key: value>...] **fff - list of key/values
  # @param ggg [Block] &ggg
  def method_with_every_type_of_paramater(aaa, bbb = nil, *ccc, ddd:, eee: nil, **fff, &ggg)
  end

  # Questionable?
  #
  # @return [Boolean] true when questionable?
  def questionable?
  end
end
```

#### Debug class info
