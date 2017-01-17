#
# Cookbook Name:: cookbook-enable-MSDTC
# Recipe:: default
#
# Copyright 2017, Aqovia Ltd.
#
# All rights reserved - Do Not Redistribute
#


registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security' do
  values [{:name => 'NetworkDtcAccessTransactions', :type => :dword, :data => 1},
          {:name => 'NetworkDtcAccess', :type => :dword, :data => 1},
          {:name => 'NetworkDtcAccessClients', :type => :dword, :data => 1},
          {:name => 'NetworkDtcAccessInbound', :type => :dword, :data => 1},
          {:name => 'NetworkDtcAccessOutbound', :type => :dword, :data => 1},
          {:name => 'NetworkDtcAccessTip', :type => :dword, :data => 1}
         ]
  action :create
end

windows_firewall_rule 'Sql Server DTC' do
	localport node['fromport']'..'node['toport']
	protocol 'TCP'
	firewall_action :allow
end

registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc\Internet' do
  values [{:name => 'Ports', :type => :REG_MULTI_SZ, :data => node['fromport']-node['toport']},
          {:name => 'PortsInternetAvailable', :type => :REG_SZ, :data => Y},
          {:name => 'UseInternetPorts', :type => :REG_SZ, :data => Y}          
         ]
  action :create
end
