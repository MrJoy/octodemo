module Octodemo
  class Generator
    def initialize(plugin, name)
      @plugin = plugin
      @name = name
      @description = "Generate a new #{name}."
    end

    def description=(val)
      @description = val
    end
    def description
      if(@arguments.any?)
        "#{@description}\n#{@arguments.summary}"
      else
        @description
      end
    end

    def run(source_dir, option_data)
      arguments.process!(option_data)
      errors = arguments.errors
      if(errors.count > 0)
        raise "Missing required parameters: #{errors.join(', ')}"
      end
      @scaffold.exec(source_dir, File.join(@plugin.root, 'templates', @name.to_s), @arguments)
    end

    attr_reader :name
    attr_accessor :arguments
    attr_accessor :scaffold

    class Arguments
      def add(name, options)
        @arguments ||= {}
        @arguments[name] = {
          :required => false,
          :default => nil,
          :is_flag => false,
        }.merge(options)
        unless(@arguments[name][:parse])
          if(@arguments[name][:is_flag])
            @arguments[name][:parse] = proc { |val| val.to_i != 0 }
          else
            @arguments[name][:parse] = proc { |val| val }
          end
        end
      end

      def process!(option_data)
        @values = {}

        @arguments.keys.each do |name|
          @values[name] = @arguments[name][:default]
          external_name = name.to_s.upcase
          unless(option_data[external_name].blank?)
            @values[name] = @arguments[name][:parse].call(option_data[external_name])
          end
          if(@values[name].is_a?(Proc))
            @values[name] = @values[name].call
          end
        end
      end

      def method_missing(name, *args, &block)
        return @values[name]
      end

      def errors
        required_args = @arguments.keys.select { |arg| @arguments[arg][:required] }
        errors = []
        required_args.each do |name|
          errors << name.upcase if(@values[name].blank?)
        end
        return errors
      end

      def any?
        return @arguments.keys.count > 0
      end

      def summary
        args = @arguments.keys

        required_args = args.select { |arg| @arguments[arg][:required] }
        optional_args = args.reject { |arg| @arguments[arg][:required] }

        output = []
        if(required_args.length > 0)
          output << "Required Parameters:"
          output += required_args.
            map { |name| format_arg(name) }.
            map { |line| "\t#{line}" }
        end
        if(optional_args.length > 0)
          output << "Optional Parameters:"
          output += optional_args.
            map { |name| format_arg(name) }.
            map { |line| "\t#{line}" }
        end
        return output.map { |line| "\t#{line}"}.join("\n")
      end

      def format_arg(name)
        opts = @arguments[name]
        formatted = "#{name.upcase}"
        formatted += ": #{opts[:description]}" unless(opts[:description].blank?)

        if(opts[:default] && !opts[:default].is_a?(Proc))
          formatted += " (default=='#{opts[:default]}')"
        end

        return formatted
      end
    end

    class Scaffold
      def initialize(body)
        @body = body
      end

      attr_accessor :body
    end
  end
end
