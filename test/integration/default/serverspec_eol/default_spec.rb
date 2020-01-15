require '/tmp/kitchen/spec/spec_helper.rb'
require 'socket'

elasticsearch_user     = 'elasticsearch'
elasticsearch_group    = elasticsearch_user
elasticsearch_log_dir  = '/var/log/elasticsearch'
elasticsearch_pid_dir  = '/var/run/elasticsearch'
elasticsearch_conf_dir = '/etc/elasticsearch'
elasticsearch_data_dir = '/var/lib/elasticsearch'
elasticsearch_home_dir = '/usr/share/elasticsearch'

elasticsearch_network_host = Socket.ip_address_list.detect{ |intf| intf.ipv4_private? }.ip_address

describe group(elasticsearch_group) do
  it { should exist }
end

describe user(elasticsearch_user) do
  it { should exist }
  it { should belong_to_group 'elasticsearch' }
end

describe package('elasticsearch') do
  it { should be_installed }
end

%W(
  #{elasticsearch_log_dir}
  #{elasticsearch_pid_dir}
  #{elasticsearch_data_dir}
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by elasticsearch_user }
  end
end

%W(
  #{elasticsearch_conf_dir}
  #{elasticsearch_home_dir}
  #{elasticsearch_home_dir}/bin
  #{elasticsearch_home_dir}/lib
  #{elasticsearch_home_dir}/modules
  #{elasticsearch_home_dir}/plugins
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
  end
end

# check plugins are installed
%w(
  discovery-ec2
  repository-s3
).each do |plugin|
  describe file("#{elasticsearch_home_dir}/plugins/#{plugin}") do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
  end
end

%W(
  /etc/default/elasticsearch
  #{elasticsearch_conf_dir}/elasticsearch.yml
).each do |f|
  describe file(f) do
    it { should be_file }
  it { should be_mode 644 }
    it { should be_owned_by 'root' }
  end
end

if os[:family] == 'ubuntu' and os[:release] == '14.04'
    describe file('/etc/init.d/elasticsearch') do
      it { should be_executable }
      it { should be_owned_by 'root' }
    end
else
  %W(
    /usr/lib/systemd/system/elasticsearch.service
    /etc/systemd/system/elasticsearch.service.d/elasticsearch.conf
  ).each do |f|
    describe file(f) do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
    end
  end
end

describe service('elasticsearch') do
  it { should be_running }
end
