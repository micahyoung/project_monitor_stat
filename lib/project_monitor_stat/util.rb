require 'net/http'
require 'uri'

module ProjectMonitorStat
  class Util
    def self.puts(*args)
      Kernel.puts(*args)
    end

    def self.system(*args)
      Kernel.system(*args)
    end

    def self.get(url: raise, cookie: nil)
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)
      request.add_field('Cookie', cookie) if cookie

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      response.body
    end
  end
end
