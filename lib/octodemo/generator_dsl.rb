module Octodemo
  class GeneratorsDSL
    def initialize(plugin, &block)
      @plugin = plugin
      @generators = {}
    end
    def to_generators; return @generators; end

    def generator(name, &block)
      ctx = GeneratorDSL.new(@plugin, name.to_sym)
      ctx.instance_eval(&block)
      @generators[name] = ctx.to_generator
    end


    class GeneratorDSL
      def initialize(plugin, name); @generator = Generator.new(plugin, name); end
      def to_generator; return @generator; end

      def desc(description)
        @generator.description = description
      end

      def arguments(&block)
        ctx = ArgumentsDSL.new
        ctx.instance_eval(&block)
        @generator.arguments = ctx.to_arguments
      end

      def scaffold(&block)
        @generator.scaffold = ScaffoldDSL.new(&block)
      end


      class ArgumentsDSL
        def initialize(&block)
          @arguments = Octodemo::Generator::Arguments.new
        end

        def to_arguments; @arguments; end

        def method_missing(name, *args, &block)
          options = {}
          (args || []).each do |arg|
            options.merge!(arg) if(arg.is_a?(Hash))
          end
          @arguments.add(name, options)
        end
      end

      class ScaffoldDSL
        def initialize(&block)
          @body = block
        end

        def exec(source_dir, template_dir, args)
          @source_dir = source_dir
          @template_dir = template_dir
          @args = args
          @dir_stack = []
          instance_eval(&@body)
        end

        def args; return @args; end

        def template(*path)
          puts "READ #{File.join(@template_dir, *path)}"
        end

        def dir(name, &block)
          @dir_stack.push(name)
          puts "mkdir -p '#{name}'"
          puts "pushd '#{name}'"
          block.call
          @dir_stack.pop
          puts "popd"
        end

        def page(name, *opts)
          puts "WRITE #{File.join(@source_dir, *@dir_stack, name)}.markdown"
        end

        def file(name, *opts)
          puts "WRITE #{File.join(@source_dir, *@dir_stack, name)}"
        end
      end
    end
  end
end
