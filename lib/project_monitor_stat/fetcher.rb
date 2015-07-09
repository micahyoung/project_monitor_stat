require 'net/http'
require 'json'

module ProjectMonitorStat
  class Fetcher
    def initialize(url: raise, session_id: nil)
      @uri = URI(url)
    end

    def fetch
      request = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      begin
        projects = JSON.parse(response.body)
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

    attr_reader :uri
  end
end
