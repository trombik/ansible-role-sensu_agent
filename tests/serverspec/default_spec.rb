require "spec_helper"
require "serverspec"

package = "sensu-go-agent"
service = "sensu-agent"
config  = "/etc/sensu/agent.yml"
user    = "sensu"
group   = "sensu"
ports   = []
log_dir = "/var/log/sensu_agent"
db_dir  = "/var/lib/sensu_agent"
gems    = %w[sensu-plugin sensu-plugins-disk-checks]

case os[:family]
when "freebsd"
  config = "/usr/local/etc/sensu/agent.yml"
  db_dir = "/var/db/sensu_agent"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("Managed by ansible") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/sensu_agent") do
    it { should be_file }
    its(:content) { should match(/Managed by ansible/) }
  end
  describe command "ps -wp `pgrep sensu-agent`" do
    its(:stderr) { should eq "" }
    its(:stdout) { should match Regexp.escape("sensu-agent start -c /usr/local/etc/sensu/agent.yml") }
  end
when "ubuntu"
  describe file("/etc/default/sensu-agent") do
    it { should be_file }
    its(:content) { should match(/Managed by ansible/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

gems.each do |g|
  describe package g do
    let(:sudo_options) { "-u #{user} --set-home" }
    it { should be_installed.by('gem') }
  end
end
