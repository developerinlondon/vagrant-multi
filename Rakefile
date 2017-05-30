require 'colorize'

task :default => :init

task :init do
  puts "==> unlocking git crypt:".green
  sh "git crypt unlock"
  puts "==> installing pre-commits:".green
  sh "pre-commit install"
end
