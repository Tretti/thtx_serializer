def run_specs paths
  exec "rspec -Ispec #{paths.join ' '}"
end

task :console do
  require 'pry'
  require 'thtx_serializer'
  ARGV.clear
  Pry.start
end

desc "Run tests"
task :test do
  paths =
    if explicit_list = ENV['run']
      explicit_list.split(',')
    else
      Dir['spec/**/*_spec.rb'].shuffle!
    end
  run_specs paths
end

task spec: :test
task default: :test
