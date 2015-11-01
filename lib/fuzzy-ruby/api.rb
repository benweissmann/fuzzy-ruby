require 'amatch'
require 'binding_of_caller'
require 'fuzzy-ruby/version'

module FuzzyRuby
  class << self
    VALID_MODES = [:autocorrect, :autocorrect_with_warning, :warn_only]
    @mode = :autocorrect
    @enabled = false

    def mode= new_mode
      unless VALID_MODES.include? new_mode
        raise ArgumentError.new "Invalid mode: #{new_mode}"
      end

      @mode = new_mode
    end

    def install
      # Enable automatic autocorrection
      @enabled = true

      if block_given?
        begin
          return yield
        ensure
          uninstall
        end
      end
    end

    def uninstall
      @enabled = false
    end

    def enabled?
      @enabled
    end

    attr_reader :mode

    private

    # Automatically corrects a method call or local variable access.
    #
    # May actually call the corrected version / return the value of the
    # corrected variable name, or may just print a parming, or both, based
    # on the value of @mode
    #
    # binding: The binding in which the method call or variable access occurred
    # receiver: The object whose methods are being called
    # name: Name of the method or variable, as a symbol
    # args: Array of arguments passed to the method
    # block: Block passed to the method
    def autocorrect binding, receiver, name, args, block
      # assemble possible methods or variables we could correct to
      methods = receiver.methods.map(&:to_s)
      vars = binding.eval("local_variables").map(&:to_s)

      # match the mostly likely one
      matcher = Amatch::JaroWinkler.new(name.to_s)
      best = (vars + methods).sort_by{|m| matcher.match(m)}.last

      # print a warning depending on mode
      case @mode
      when :autocorrect_with_warning
        STDERR.puts "WARNING: Autocorrecting #{name} to #{best}"
      when :warn_only
        STDERR.puts "WARNING: by #{name}, you probably meant #{best}"
      end

      # execute the corrected version
      if @mode != :warn_only
        if methods.include? best
          return receiver.send(best.to_sym, *args, &block)
        else
          return binding.eval(best)
        end
      end
    end
  end
end


# hook into method_missing on Object
class Object
  alias_method :__fuzzyruby_method_missing_old__, :method_missing
  def method_missing name, *args, &block
    if FuzzyRuby.enabled?
      FuzzyRuby.send :autocorrect, binding.of_caller(1), self, name, args, block
    else
      __fuzzyruby_method_missing_old__ name, *args, &block
    end
  end
end

