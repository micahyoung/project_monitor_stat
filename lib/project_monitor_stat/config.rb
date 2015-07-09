require 'uri'
require 'optionparser'

module ProjectMonitorStat
  class Config
    def self.parse_options(argv: raise)
      tag = argv[0] || raise(ArgumentError.new('You must provide a tag'))
      url = 'http://pulse.pivotallabs.com/projects.json'
      session_id = nil
      success_cmd = nil
      building_cmd = nil
      fail_cmd = nil

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename(__FILE__)} tag [options]"

        opts.on('-sCOMMAND', '--success COMMAND',
                'Success command') do |s|
          success_cmd = s
        end

        opts.on('-bCOMMAND', '--building COMMAND',
                'Building command') do |b|
          building_cmd = b
        end

        opts.on('-fCOMMAND', '--fail COMMAND',
                'Fail command') do |s|
          fail_cmd = s
        end

        opts.on('-u', '--url',
                'Your projectMonitor url ',
                "  Default: #{url}") do |u|
          url = u
        end

        opts.on('-i', '--session_id []',
                'Your _projectmonitor_session cookie if outside a whitelisted IP ',
                '  Get this from your browser cookie inspector') do |i|
          session_id = i
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

      new(url: url, tag: tag, success_cmd: success_cmd, building_cmd: building_cmd, fail_cmd: fail_cmd, session_id: session_id)
    end

    attr_reader :success_cmd, :building_cmd, :fail_cmd, :session_id

    def initialize(url: raise, tag: raise, success_cmd: raise, building_cmd: raise, fail_cmd: raise, session_id: nil)
      @base_url = url
      @tag = tag
      @success_cmd = success_cmd
      @building_cmd = building_cmd
      @fail_cmd = fail_cmd
      @session_id = session_id
    end

    def url
      uri = URI(base_url)
      uri.query = "tags=#{tag}"
      uri
    end

    private

    attr_reader :base_url, :tag
  end
end
