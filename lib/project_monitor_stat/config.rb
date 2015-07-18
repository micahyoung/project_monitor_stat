require 'uri'
require 'optparse'

module ProjectMonitorStat
  class Config
    def self.parse_options(argv: raise)
      tag = argv[0] || raise(ArgumentError.new('You must provide a tag'))
      instance = new
      instance.tag = tag
      instance.base_url = 'http://pulse.pivotallabs.com/projects.json'
      instance.idle_seconds = 600

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} tag [options]"

        opts.on('-sCOMMAND', '--success COMMAND',
                'Command after success') do |s|
          instance.success_cmd = s
        end

        opts.on('-iCOMMAND', '--idle COMMAND',
                'Command when idle after success') do |i|
          instance.idle_cmd = i
        end

        opts.on('--idle-seconds SECONDS',
                'Seconds after which a success build is idle') do |is|
          instance.idle_seconds = is.to_i
        end

        opts.on('-bCOMMAND', '--building COMMAND',
                'Command when building') do |b|
          instance.building_cmd = b
        end

        opts.on('-fCOMMAND', '--fail COMMAND',
                'Command after fail') do |s|
          instance.fail_cmd = s
        end

        opts.on('-uURL', '--url URL',
                'Custom project monitor url ',
                "  Default: #{instance.base_url}") do |u|

          instance.base_url = u
        end

        opts.on('-cCOOKIE', '--cookies COOKIE',
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

    attr_accessor :tag, :base_url, :success_cmd, :building_cmd, :fail_cmd, :idle_cmd, :idle_seconds, :cookie

    def url
      uri = URI(base_url)
      uri.query = "tags=#{tag}"
      uri
    end
  end
end
