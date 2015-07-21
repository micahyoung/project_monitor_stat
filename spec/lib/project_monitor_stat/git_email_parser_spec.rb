require 'project_monitor_stat'

describe ProjectMonitorStat::GitEmailParser do
  describe '#username_tags' do
    before do
      expect(ProjectMonitorStat::Util).to receive(:x).with('git config --get user.email').and_return(git_email)
    end

    context 'when solo' do
      let(:git_email) { 'foo@qux.com' }

      it 'returns the username' do
        git_email_parser = ProjectMonitorStat::GitEmailParser.new
        expect(git_email_parser.username_tags).to eq ['foo']
      end
    end

    context 'when pair' do
      let(:git_email) { 'pair+foo+bar@qux.com' }

      it 'returns the username' do
        git_email_parser = ProjectMonitorStat::GitEmailParser.new
        expect(git_email_parser.username_tags).to eq ['foo', 'bar']
      end
    end

    context 'when tri-pair' do
      let(:git_email) { 'pair+foo+bar+baz@qux.com' }

      it 'returns the username' do
        git_email_parser = ProjectMonitorStat::GitEmailParser.new
        expect(git_email_parser.username_tags).to eq ['foo', 'bar', 'baz']
      end
    end

    context 'when half-pair' do
      let(:git_email) { 'pair+foo@qux.com' }

      it 'returns the username' do
        git_email_parser = ProjectMonitorStat::GitEmailParser.new
        expect(git_email_parser.username_tags).to eq ['foo']
      end
    end

    context 'when blank' do
      let(:git_email) { '' }

      it 'returns the username' do
        git_email_parser = ProjectMonitorStat::GitEmailParser.new
        expect(git_email_parser.username_tags).to eq []
      end
    end
  end
end