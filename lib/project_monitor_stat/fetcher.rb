require 'net/http'
require 'json'

module ProjectMonitorStat
  class Fetcher
    def initialize(config: raise)
      @config = config
    end

    def fetch
      json = Util.get(url: config.url, cookie: config.cookie)

      begin
        projects = JSON.parse(json)
      rescue JSON::ParserError
        return :error
      end

      begin
        success_results = projects.map do |project|
          project.fetch('build').fetch('status') == 'success'
        end
        building_results = projects.map do |project|
          project.fetch('build').fetch('building')
        end
      rescue JSON::ParserError, TypeError
        return :error
      end

      if success_results.all?
        if building_results.any?
          :building
        else
          :success
        end
      else
        :fail
      end
    end

    private

    attr_reader :config
  end
end
