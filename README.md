
Fuzzy Ruby
==========

[![Build Status](https://travis-ci.org/benweissmann/fuzzy-ruby.svg)](https://travis-ci.org/benweissmann/fuzzy-ruby)

One of the most difficult parts of programming is spelling everything correctly.
Particularly in a dynamic-typed language like Ruby, a single typo can cause
a critical runtime failure.

Traditional solutions to this problem include complex static analysis,
burdonsome code reviews, and onerous unit testing.

Fuzzy Ruby is a much easier solution to this problem: it modifies the Ruby
runtime environment so misspellings will automatically be corrected.


Example
=======

Without `fuzzy-ruby`:

```ruby
irb(main):001:0> "Hello".revers
NoMethodError: undefined method `revers' for "Hello":String
irb(main):002:0> my_variable = 123
=> 123
irb(main):003:0> my_vraiable
NameError: undefined local variable or method `my_vraiable' for main:Object
```

With `fuzzy-ruby`:


```ruby
rirb(main):001:0> require 'fuzzy-ruby'
=> true
irb(main):002:0> "Hello".revers
=> "olleH"
irb(main):003:0> my_variable = 123
=> 123
irb(main):004:0> my_vraiable
=> 123
```


Installation
============

Add this line to your application's Gemfile:

```ruby
gem 'fuzzy-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fuzzy-ruby


Advanced Usage
==============

A simple `require 'fuzzy-ruby'` will load Fuzzy Ruby and set it up to
automatically correct misspellings. However, if you'd like more fine-grained
control, you can use `require 'fuzzy-ruby/api'`, which just gives you access
to the `FuzzyRuby` api without modifying your runtime environment.

#### `FuzzyRuby.install`

Without a block, sets up Fuzzy Ruby to autocorrect misspellings until
`FuzzyRuby.uninstall` is called. With a block, runs the block with Fuzzy Ruby
installed, and then automatically uninstalls it when the block completes or
raises an error. The return value or error from the block is propagated up.

#### `FuzzyRuby.uninstall`

Undoes a `FuzzyRuby.install`.

#### `FuzzyRuby.mode = :autocorrect | :autocorrect_with_warning | :warn_only`

Sets the mode of Fuzzy Ruby. By default, Fuzzy Ruby uses `:autocorrect`, which
automatically corrects typos without warning. Other modes are
`:autocorrect_with_warning`, which autocorrect but prints a warning to stderr,
and `:warn_only`, which just prints the warning, but does not correct.


License
=======

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


How Does It Work?
=================

Fuzzy Ruby overrides `method_missing` on `Object`. This allows us to intercept
methods calls to any object, as well as local variable access. We then grab the
list of methods on the object, as well as the list of local variables
(using the `binding_of_caller` gem) and select the best match using the
Jaro-Winkler text distance algorithm (from the `amatch` gem). We then use
`eval` or `send` to run the method or access the local variable.


Notes
=====

Don't actually use this. Please.
