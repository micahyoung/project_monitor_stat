module ProjectMonitorStat
  class Reporter
    def initialize(config: raise, result: raise)
      @config = config
      @result = result
    end

    def report
      case result
        when :success
          if config.success_cmd
            Util.system(config.success_cmd)
          else
            Util.puts result
          end
        when :building
          if config.building_cmd
            Util.system(config.building_cmd)
          else
            Util.puts result
          end
        when :fail
          if config.fail_cmd
            Util.system(config.fail_cmd)
          else
            Util.puts result
          end
        when :error
          raise 'Error'
        else
          raise 'Unknown Error'
      end
    end

    private

    attr_reader :config, :result
  end

end