require 'spec_helper'

elasticsearch_user     = 'elasticsearch'
elasticsearch_group    = elasticsearch_user
elasticsearch_log_dir  = '/var/log/elasticsearch'
elasticsearch_pid_dir  = '/var/run/elasticsearch'
elasticsearch_conf_dir = '/etc/elasticsearch'
elasticsearch_data_dir = '/var/lib/elasticsearch'
elasticsearch_home_dir = '/usr/share/elasticsearch'

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
  #{elasticsearch_conf_dir}
  #{elasticsearch_data_dir}
  #{elasticsearch_home_dir}/plugins
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by elasticsearch_user }
  end
end

%W(
  #{elasticsearch_home_dir}
  #{elasticsearch_home_dir}/bin
  #{elasticsearch_home_dir}/lib
  #{elasticsearch_home_dir}/modules
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
  end
end

# check cloud-aws plugin is installed
describe file("#{elasticsearch_home_dir}/plugins/cloud-aws") do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

%W(
  /etc/default/elasticsearch
  /etc/sysctl.d/60-elasticsearch.conf
  #{elasticsearch_conf_dir}/elasticsearch.yml
  #{elasticsearch_conf_dir}/logging.yml
).each do |f|
  describe file(f) do
    it { should be_file }
  it { should be_mode 644 }
    it { should be_owned_by 'root' }
  end
end

describe file('/etc/init.d/elasticsearch') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe service('elasticsearch') do
  it { should be_running }
end
