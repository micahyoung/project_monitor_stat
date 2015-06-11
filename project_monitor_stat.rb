require 'uri'
require 'net/http'
require 'json'

module ProjectMonitorStat
  class Fetcher
    def initialize(tag:)
      @tag = tag
    end

    def fetch
      uri = URI('http://pulse.pivotallabs.com/projects.json')
      uri.query = "tags=#{tag}"
      request = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      projects = JSON.parse(response.body)
      all_successful = projects.all? do |project|
        build = project.fetch('build')
        build.fetch('status') == 'success'
      end

      all_successful == true ? exit(0) : exit(1)
    end

    private

    attr_reader :tag
  end
end

if __FILE__ == $0
  tag = ARGV.fetch(0)
  puts ProjectMonitorStat::Fetcher.new(tag: tag).fetch
end
