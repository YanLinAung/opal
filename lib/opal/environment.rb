module Opal
  # Default Environment that assumes no Gemfile or gemspec for the given
  # app/library.
  class Environment
    def self.load(dir)
      return GemfileEnvironment.new dir if File.exists? File.join(dir, 'Gemfile')
      return GemspecEnvironment.new dir unless Dir["#{dir}/*.gemspec"].empty?
      return Environment.new dir
    end

    attr_accessor :files
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def name
      File.basename @root
    end

    # Default require paths is just 'lib'
    def require_paths
      ['lib']
    end

    def specs
      []
    end
  end

  # Used for libs/gems that have a gemspec (but no Gemfile!).
  class GemspecEnvironment < Environment; end

  # Used for environments which use a Gemfile
  class GemfileEnvironment < Environment
    def bundler
      return @bundler if @bundler
      require 'bundler'
      @bundler = Bundler.load
    end

    def specs
      bundler.specs
    end
  end
end
