require 'project_monitor_stat'

describe ProjectMonitorStat::Fetcher do
  describe '#fetch' do
    context 'when success' do
      context 'and not building' do
        it 'returns success' do
          url = 'http://example.com'
          projects_json = [
              {build: {status: 'success', building: false}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(url: url)
          expect(reporter.fetch).to eq :success
        end
      end

      context 'and building' do
        it 'returns building' do
          url = 'http://example.com'
          projects_json = [
              {build: {status: 'success', building: true}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(url: url)
          expect(reporter.fetch).to eq :building
        end
      end
    end

    context 'when fail' do
      context 'and not building' do
        it 'returns fail' do
          url = 'http://example.com'
          projects_json = [
              {build: {status: 'fail', building: false}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(url: url)
          expect(reporter.fetch).to eq :fail
        end
      end

      context 'and building' do
        it 'returns building' do
          url = 'http://example.com'
          projects_json = [
              {build: {status: 'success', building: true}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(url: url)
          expect(reporter.fetch).to eq :building
        end
      end
    end
  end
end