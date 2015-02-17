require 'thread'

module Volt
  # Modes provide a way to effect the state inside of a block that
  # can be checked from elsewhere.  This is very useful if you have
  # some flag you may want to change without needing to pass all
  # of the way through some other code.
  module Modes
    module ClassMethods
      # Takes a block that when run, changes to mode inside of it
      def run_in_mode(mode_name)
        if RUBY_PLATFORM == 'opal'
          yield
        else
          previous = Thread.current[mode_name]
          Thread.current[mode_name] = true
          begin
            yield
          ensure
            Thread.current[mode_name] = previous
          end
        end
      end
    end

    def self.included(base)
      base.send :extend, ClassMethods
    end

    # Check to see if we are in the specified mode
    def in_mode?(mode_name)
      return defined?(Thread) && Thread.current[mode_name]
    end
  end
end