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
        return :error_invalid_json
      end

      if projects.empty?
        return :error_no_projects
      end

      begin
        status_successes = projects.map do |project|
          project.fetch('build').fetch('status') == 'success'
        end
        building_results = projects.map do |project|
          project.fetch('build').fetch('building')
        end
      rescue JSON::ParserError, KeyError, TypeError
        return :error_invalid_project_attributes
      end

      if status_successes.all?
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
