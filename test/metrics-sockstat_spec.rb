#!/usr/bin/env ruby
#
# metrics-sockstat_spec
#
# DESCRIPTION:
#   Tests for metrics-sockstat.rb
#
# OUTPUT:
#
# PLATFORMS:
#
# DEPENDENCIES:
#
# USAGE:
#   bundle install
#   rake spec
#
# NOTES:
#
# LICENSE:
#   Copyright 2015 Contegix, LLC.
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
require_relative './plugin_stub.rb'
require_relative './spec_helper.rb'
require_relative '../bin/metrics-sockstat.rb'

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
  c.before { allow($stderr).to receive(:puts) }
end

describe Sockstat, 'run' do

  it 'should successfully output socket metrics for the total number of sockets and any other types that are present' do
    sockstat = Sockstat.new
    allow(sockstat).to receive(:read_sockstat).and_return("sockets: used 10\nFOO: bar 5 baz 4")
    allow(sockstat).to receive(:output)
    expect(sockstat).to receive(:output).with(match('total_used 10'))
    expect(sockstat).to receive(:output).with(match('FOO.bar 5'))
    expect(sockstat).to receive(:output).with(match('FOO.baz 4'))
    expect(-> { sockstat.run }).to raise_error SystemExit
  end

end
