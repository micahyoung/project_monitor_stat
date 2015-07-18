require 'rspec'
require 'sinatra/base'
require 'sinatra/cookies'
require 'timeout'
require 'json'

class TestApp < Sinatra::Base
  helpers Sinatra::Cookies

  get '/success_projects' do
    JSON.generate [{build: {status: 'success', building: false, published_at: Time.now}}]
  end

  get '/success_idle_projects' do
    JSON.generate [{build: {status: 'success', building: false, published_at: Time.now - 1000}}]
  end

  get '/success_if_cookies_projects' do
    if cookies['foo'] == 'bar'
      JSON.generate [{build: {status: 'success', building: false, published_at: Time.now}}]
    end
  end

  get '/building_projects' do
    JSON.generate [{build: {status: 'success', building: true}}]
  end

  get '/fail_projects' do
    JSON.generate [{build: {status: 'failure', building: false}}]
  end

  get '/error' do
    JSON.generate({error: 'You need to sign in or sign up before continuing.'})
  end
end

describe 'responding to the result' do
  before do
    @server_thread = Thread.new do
      TestApp.run!
    end

    Timeout.timeout(60) { @server_thread.join(0.1) until TestApp.running? }
  end

  context 'when project build status is success' do
    context 'and project is not building' do
      context 'and cookies are not required' do
        let(:url) { 'http://localhost:4567/success_projects' }

        it 'returns success' do
          result = `bin/project_monitor_stat mytag -u #{url}`
          expect(result).to include 'success'
        end
      end

      context 'and cookies are required' do
        let(:url) { 'http://localhost:4567/success_if_cookies_projects' }

        it 'returns success' do
          result = `bin/project_monitor_stat mytag -c'foo=bar' -u #{url}`
          expect(result).to include 'success'
        end
      end

      context 'and the success is older than the idle minutes' do
        let(:url) { 'http://localhost:4567/success_idle_projects' }

        it 'returns idle' do
          result = `bin/project_monitor_stat mytag -u #{url}`
          expect(result).to include 'idle'
        end
      end
    end

    context 'and project is building' do
      let(:url) { 'http://localhost:4567/building_projects' }

      it 'returns building' do
        result = `bin/project_monitor_stat mytag -u #{url}`
        expect(result).to include 'building'
      end
    end
  end

  context 'when project build status is not success' do
    let(:url) { 'http://localhost:4567/fail_projects' }

    it 'returns fail' do
      result = `bin/project_monitor_stat mytag -u #{url}`
      expect(result).to include 'fail'
    end
  end

  context 'when response is an error' do
    let(:url) { 'http://localhost:4567/error' }

    it 'returns error' do
      result = `bin/project_monitor_stat mytag -u #{url}`
      expect(result).to include 'error'
    end
  end
end
