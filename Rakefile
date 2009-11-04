# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    #config.metrics  = [:rcov, :flog] #define which metrics you want to use
    config.daily_data_resolution = false
    config.churn    = {
      :start_date => '3 months ago',
      :minimum_churn_count => 4
    }
    config.graphs   =  [:flog, :flay, :reek, :roodi, :rcov]
    #config.coverage[:test_files] = ['test/**/*_test.rb', 'spec/**/*_spec.rb']
    #config.coverage[:rcov_opts] = ["--sort coverage", "--html", "--rails", "--exclude /gems/,/Library/,spec"]
    #config.flog     = { :dirs_to_flog => ['cms/app', 'cms/lib']  }
    #config.flay     = { :dirs_to_flay => ['cms/app', 'cms/lib']  }
    #config.saikuro  = { "--warn_cyclo" => "3", "--error_cyclo" => "4" }
  end
rescue LoadError
  # metric_fu gem not installed; we may safely ignore this (used by cruisecontrol.rb)
end
