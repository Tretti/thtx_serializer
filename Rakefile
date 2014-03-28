# Added by devtools
require 'devtools'
Devtools.init_rake_tasks

namespace :ci do
  desc 'Run metrics (except mutant, rubocop) and spec'
  task travis: %w[
    metrics:coverage
    spec:integration
    metrics:flog
  ]
end

task default: :spec
