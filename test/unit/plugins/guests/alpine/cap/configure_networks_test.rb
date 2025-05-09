# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

require_relative "../../../../base"

describe 'VagrantPlugins::GuestAlpine::Cap::ConfigureNetworks' do
  let(:described_class) do
    VagrantPlugins::GuestAlpine::Plugin.components.guest_capabilities[:alpine].get(:configure_networks)
  end
  let(:machine) { double('machine') }
  let(:communicator) { VagrantTests::DummyCommunicator::Communicator.new(machine) }

  before do
    allow(machine).to receive(:communicate).and_return(communicator)
  end

  after do
    communicator.verify_expectations!
  end

  it 'should configure networks' do
    networks = [
      { type: :static, ip: '192.168.10.10', netmask: '255.255.255.0', interface: 0, name: 'eth0' },
      { type: :dhcp, interface: 1, name: 'eth1' }
    ]

    expect(communicator).to receive(:sudo).with("sed -e '/^#VAGRANT-BEGIN/,$ d' /etc/network/interfaces > /tmp/vagrant-network-interfaces.pre")
    expect(communicator).to receive(:sudo).with("sed -ne '/^#VAGRANT-END/,$ p' /etc/network/interfaces | tail -n +2 > /tmp/vagrant-network-interfaces.post")
    expect(communicator).to receive(:sudo).with(/\/sbin\/ifdown eth0/)
    expect(communicator).to receive(:sudo).with('/sbin/ip addr flush dev eth0 2> /dev/null')
    expect(communicator).to receive(:sudo).with(/\/sbin\/ifdown eth1/)
    expect(communicator).to receive(:sudo).with('/sbin/ip addr flush dev eth1 2> /dev/null')
    expect(communicator).to receive(:sudo).with('cat /tmp/vagrant-network-interfaces.pre /tmp/vagrant-network-entry /tmp/vagrant-network-interfaces.post > /etc/network/interfaces')
    expect(communicator).to receive(:sudo).with('rm -f /tmp/vagrant-network-interfaces.pre /tmp/vagrant-network-entry /tmp/vagrant-network-interfaces.post')
    expect(communicator).to receive(:sudo).with('/sbin/ifup eth0')
    expect(communicator).to receive(:sudo).with('/sbin/ifup eth1')

    allow_message_expectations_on_nil

    described_class.configure_networks(machine, networks)
  end

  context "dhcp assigned default route" do
    let(:networks) {
      [{type: :dhcp, use_dhcp_assigned_default_route: is_enabled}]
    }
    let(:is_enabled) { false }
    let(:tempfile) { double(:tempfile, binmode: true, close: true, path: "/dev/null") }

    before do
      allow(Tempfile).to receive(:new).and_return(tempfile)
    end

    context "when not enabled" do
      it "should not configure default route" do
        expect(tempfile).not_to receive(:write).with(/post-up route del default dev eth0/)

        described_class.configure_networks(machine, networks)
      end
    end

    context "when enabled" do
      let(:is_enabled) { true }

      it "should configure default route" do
        expect(tempfile).to receive(:write).with(/post-up route del default dev eth0/)

        described_class.configure_networks(machine, networks)
      end
    end
  end
end
