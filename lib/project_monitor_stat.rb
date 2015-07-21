module ProjectMonitorStat
  VERSION = '0.0.7'

  autoload :Config, 'project_monitor_stat/config'
  autoload :GitEmailParser, 'project_monitor_stat/git_email_parser'
  autoload :Fetcher, 'project_monitor_stat/fetcher'
  autoload :Reporter, 'project_monitor_stat/reporter'
  autoload :Util, 'project_monitor_stat/util'
end