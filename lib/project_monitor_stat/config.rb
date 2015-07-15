require 'uri'
require 'optparse'

module ProjectMonitorStat
  class Config
    def self.parse_options(argv: raise)
      tag = argv[0] || raise(ArgumentError.new('You must provide a tag'))
      instance = new
      instance.base_url = 'http://pulse.pivotallabs.com/projects.json'

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} tag [options]"

        opts.on('-sCOMMAND', '--success COMMAND',
                'Success command') do |s|
          instance.success_cmd = s
        end

        opts.on('-bCOMMAND', '--building COMMAND',
                'Building command') do |b|
          instance.building_cmd = b
        end

        opts.on('-fCOMMAND', '--fail COMMAND',
                'Fail command') do |s|
          instance.fail_cmd = s
        end

        opts.on('-u', '--url',
                'Your projectMonitor url ',
                "  Default: #{instance.base_url}") do |u|
          instance.base_url = u
        end

        opts.on('-c', '--cookies []',
                'Your cookie string',
                '  Get this from your browser cookie inspector') do |c|
          instance.cookie = c
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          puts VERSION
          exit
        end
      end

      opt_parser.parse!(argv)

      instance
    end

    attr_accessor :base_url, :success_cmd, :building_cmd, :fail_cmd, :cookie

    def url
      uri = URI(base_url)
      uri.query = "tags=#{tag}"
      uri
    end

    private

    attr_reader :tag
  end
end
