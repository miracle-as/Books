desc 'Continuous build target'
task :cruise => ['cruise:metrics']

namespace :cruise do

  task :set_testing_env do
    RAILS_ENV = 'test'
  end

  task :init_testing_env => ['db:migrate', :set_testing_env, 'db:test:prepare']

  desc 'Continuous build target with all metrics'
  task :metrics => [:init_testing_env, 'metrics:all']

end
