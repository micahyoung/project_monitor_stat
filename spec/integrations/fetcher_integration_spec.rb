require 'project_monitor_stat'

require 'rspec'
require 'sinatra'
require 'timeout'

class TestApp < Sinatra::Base
  get '/success_projects' do
    [{build: {status: 'success', building: false}}].to_json
  end

  get '/building_projects' do
    [{build: {status: 'success', building: true}}].to_json
  end

  get '/fail_projects' do
    [{build: {status: 'failure', building: false}}].to_json
  end

  get '/error' do
    {error: 'You need to sign in or sign up before continuing.'}.to_json
  end
end

describe 'responding to the result' do
  before do
    @server_thread = Thread.new do
      TestApp.run!
    end

    Timeout.timeout(60) { @server_thread.join(0.1) until TestApp.running? }
  end

  let(:config) { double(:config, url: url, cookie: nil) }

  context 'when project build status is success' do
    context 'and project is building' do
      let(:url) { 'http://localhost:4567/building_projects' }

      it 'success' do
        result = ProjectMonitorStat::Fetcher.new(config: config).fetch
        expect(result).to eq :building
      end
    end

    context 'and project is not building' do
      let(:url) { 'http://localhost:4567/success_projects' }

      it 'success' do
        result = ProjectMonitorStat::Fetcher.new(config: config).fetch
        expect(result).to eq :success
      end
    end
  end

  context 'when project build status is not success' do
    let(:url) { 'http://localhost:4567/fail_projects' }

    it 'fails' do
      result = ProjectMonitorStat::Fetcher.new(config: config).fetch
      expect(result).to eq :fail
    end
  end

  context 'when response is an error' do
    let(:url) { 'http://localhost:4567//error' }

    it 'fails' do
      result = ProjectMonitorStat::Fetcher.new(config: config).fetch
      expect(result).to eq :error
    end
  end
end
