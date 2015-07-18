require 'project_monitor_stat'

describe ProjectMonitorStat::Fetcher do
  describe '#fetch' do
    context 'with all success projects' do
      context 'and not building' do
        it 'returns success' do
          config = double(:config, url: 'http://example.com', cookie: nil)
          projects_json = [
              {build: {status: 'success', building: false}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(config: config)
          expect(reporter.fetch).to eq :success
        end
      end

      context 'and building' do
        it 'returns building' do
          config = double(:config, url: 'http://example.com', cookie: nil)
          projects_json = [
              {build: {status: 'success', building: true}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(config: config)
          expect(reporter.fetch).to eq :building
        end
      end
    end

    context 'with any fail projects' do
      context 'and not building' do
        it 'returns fail' do
          config = double(:config, url: 'http://example.com', cookie: nil)
          projects_json = [
              {build: {status: 'fail', building: false}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(config: config)
          expect(reporter.fetch).to eq :fail
        end
      end

      context 'and building' do
        it 'returns building' do
          config = double(:config, url: 'http://example.com', cookie: nil)
          projects_json = [
              {build: {status: 'success', building: true}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(config: config)
          expect(reporter.fetch).to eq :building
        end
      end
    end

    context 'with no projects' do
      it 'returns error' do
        config = double(:config, url: 'http://example.com', cookie: nil)
        projects_json = [].to_json

        allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

        reporter = ProjectMonitorStat::Fetcher.new(config: config)
        expect(reporter.fetch).to eq :error_no_projects
      end
    end

    context 'with invalid json' do
      it 'returns error' do
        config = double(:config, url: 'http://example.com', cookie: nil)
        projects_json = 'INVALID JSON'

        allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

        reporter = ProjectMonitorStat::Fetcher.new(config: config)
        expect(reporter.fetch).to eq :error_invalid_json
      end
    end

    context 'with invalid project' do
      it 'returns error' do
        config = double(:config, url: 'http://example.com', cookie: nil)
        projects_json = {error: 'You need to sign in or sign up before continuing.'}.to_json

        allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

        reporter = ProjectMonitorStat::Fetcher.new(config: config)
        expect(reporter.fetch).to eq :error_invalid_project_attributes
      end
    end
  end
end