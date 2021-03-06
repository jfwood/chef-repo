#
# Cookbook Name:: barbican
# Recipe:: _newrelic_uwsgi
#

include_recipe 'barbican::_newrelic'

#define newrelic-plugin-agent service
service "newrelic_plugin_agent" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true, :status => true
  action :enable
end

template node[:meetme_newrelic_plugin][:config_file] do
  source "uwsgi.newrelic_plugin_agent.cfg.erb"
  owner node[:meetme_newrelic_plugin][:user]
  group node[:meetme_newrelic_plugin][:group]
  mode 0774
  variables(
    :license_key => node[:newrelic][:application_monitoring][:license],
    :poll_interval => node[:meetme_newrelic_plugin][:poll_interval],
    :user => node[:meetme_newrelic_plugin][:user],
    :log_file => "#{node[:meetme_newrelic_plugin][:log_dir]}/#{node[:meetme_newrelic_plugin][:log_file]}",
    :run_dir => node[:meetme_newrelic_plugin][:run_dir],
    :uwsgi_stats_name => node[:hostname],
    :uwsgi_stats_host => node[:meetme_newrelic_plugin][:uwsgi][:host],
    :uwsgi_stats_port => node[:meetme_newrelic_plugin][:uwsgi][:port]
  )
  notifies :start, resources(:service => "newrelic_plugin_agent")
end
