require 'project_monitor_stat'

describe ProjectMonitorStat::Fetcher do
  describe '#fetch' do
    context 'when not building' do
      context 'and all success projects' do
        context 'and no config idle time' do
          it 'returns success' do
            config = double(:config, url: 'http://example.com', cookie: nil, idle_seconds: nil)
            projects_json = [
                {build: {status: 'success', building: false}}
            ].to_json

            allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

            reporter = ProjectMonitorStat::Fetcher.new(config: config)
            expect(reporter.fetch).to eq :success
          end
        end

        context 'and the most recent build time exceeds the idle time' do
          it 'returns success' do
            config = double(:config, url: 'http://example.com', cookie: nil, idle_seconds: 1000)
            projects_json = [
                {build: {status: 'success', building: false, published_at: Time.now - 1100}}
            ].to_json

            allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

            reporter = ProjectMonitorStat::Fetcher.new(config: config)
            expect(reporter.fetch).to eq :idle
          end
        end

        context 'and the most recent build time is less than the idle time' do
          it 'returns success' do
            config = double(:config, url: 'http://example.com', cookie: nil, idle_seconds: 1000)
            projects_json = [
                {build: {status: 'success', building: false, published_at: Time.now - 900}}
            ].to_json

            allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

            reporter = ProjectMonitorStat::Fetcher.new(config: config)
            expect(reporter.fetch).to eq :success
          end
        end
      end

      context 'and any fail projects' do
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
    end

    context 'when building' do
      context 'and all success projects' do
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

      context 'and any fail projects' do
        it 'returns building' do
          config = double(:config, url: 'http://example.com', cookie: nil)
          projects_json = [
              {build: {status: 'fail', building: true}}
          ].to_json

          allow(ProjectMonitorStat::Util).to receive(:get).with(url: 'http://example.com', cookie: nil).and_return(projects_json)

          reporter = ProjectMonitorStat::Fetcher.new(config: config)
          expect(reporter.fetch).to eq :fail
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