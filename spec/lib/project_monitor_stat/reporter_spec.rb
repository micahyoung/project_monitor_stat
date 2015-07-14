require 'project_monitor_stat'

describe ProjectMonitorStat::Reporter do
  describe '#report' do
    context 'when successful' do
      context 'and success command' do
        it 'only calls the command' do
          config = double(:config, success_cmd: 'foo')
          result = :success
          expect(ProjectMonitorStat::Util).to receive(:system).with('foo')
          expect(ProjectMonitorStat::Util).to_not receive(:puts)

          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
      context 'and no success command' do
        it 'only prints the result' do
          config = double(:config, success_cmd: nil)
          result = :success
          expect(ProjectMonitorStat::Util).to receive(:puts).with(result)
          expect(ProjectMonitorStat::Util).to_not receive(:system)

          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
    end

    context 'when building' do
      context 'and building command' do
        it 'only calls the command' do
          config = double(:config, building_cmd: 'bar')
          result = :building
          expect(ProjectMonitorStat::Util).to receive(:system).with('bar')
          expect(ProjectMonitorStat::Util).to_not receive(:puts)

          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
      context 'and no success command' do
        it 'only prints the result' do
          config = double(:config, building_cmd: nil)
          result = :building
          expect(ProjectMonitorStat::Util).to receive(:puts).with(result)
          expect(ProjectMonitorStat::Util).to_not receive(:system)


          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
    end

    context 'when failing' do
      context 'and failing command' do
        it 'only calls the command' do
          config = double(:config, fail_cmd: 'baz')
          result = :fail
          expect(ProjectMonitorStat::Util).to receive(:system).with('baz')
          expect(ProjectMonitorStat::Util).to_not receive(:puts)

          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
      context 'and no success command' do
        it 'only prints the result' do
          config = double(:config, fail_cmd: nil)
          result = :fail
          expect(ProjectMonitorStat::Util).to receive(:puts).with(result)
          expect(ProjectMonitorStat::Util).to_not receive(:system)


          reporter = ProjectMonitorStat::Reporter.new(config: config, result: result)
          reporter.report
        end
      end
    end
  end
end