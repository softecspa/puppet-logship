require 'spec_helper'

describe 'logship' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "logship class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('logship::params') }
        it { should contain_class('logship::install').that_comes_before('logship::config') }
        it { should contain_class('logship::config') }
        it { should contain_class('logship::service').that_subscribes_to('logship::config') }

        it { should contain_service('logship') }
        it { should contain_package('logship').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'logship class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('logship') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
