#!/usr/bin/env puma

application_path = File.expand_path '../../', __FILE__
directory application_path
environment ENV['RAILS_ENV'] || 'production'
daemonize true
workers 1
threads 1, 6
pidfile "#{application_path}/tmp/pids/puma.pid"
state_path "#{application_path}/tmp/pids/puma.state"
stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"
bind "unix://#{application_path}/tmp/sockets/puma.socket"

