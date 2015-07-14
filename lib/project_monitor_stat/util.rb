module ProjectMonitorStat
  class Util
    def self.puts(*args)
      IO.puts(*args)
    end

    def self.system(*args)
      Kernel.system(*args)
    end

    def self.get(url)
      uri = URI(url)
      request = Net::HTTP::Get.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      response.body
    end
  end
end
