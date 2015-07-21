require 'uri'
require 'optparse'

module ProjectMonitorStat
  class Config
    def self.parse_options(argv: raise)
      instance = new
      instance.tags = []
      instance.base_url = 'http://pulse.pivotallabs.com/projects.json'
      instance.idle_seconds = 600

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: project_monitor_stat [options]'

        opts.on('-t tag1,tag2', '--tags tag1,tag2,tag3', Array,
                'Project Monitor tags') do |t|
          instance.tags |= t
        end

        opts.on('-g', '--git-author-tags',
                'Use current git author username@ or pair+usernames@ for tags') do
          git_email_parser = GitEmailParser.new

          if git_email_parser.username_tags.empty?
            Util.puts "Error: Invalid git email: '#{git_email_parser.git_email}'"
            Util.puts opts
            exit(1)
          end

          instance.tags |= git_email_parser.username_tags
        end

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
          Util.puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          Util.puts VERSION
          exit
        end
      end

      opt_parser.parse!(argv)

      if instance.tags.empty?
        Util.puts "Error: At least one tag required"
        Util.puts opt_parser.help
        exit(1)
      end

      instance
    end

    attr_accessor :tags, :base_url, :success_cmd, :building_cmd, :fail_cmd, :idle_cmd, :idle_seconds, :cookie

    def url
      uri = URI(base_url)
      uri.query = "tags=#{tags.join(',')}"
      uri
    end
  end
end
