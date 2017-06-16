#
# Cookbook:: myhaproxy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.default['haproxy']['members'] = [
{
'hostname' => 'ec2-54-171-90-124.eu-west-1.compute.amazonaws.com',
'ipaddress' => '54.171.90.124',
'port' => 80,
'ssl_port' => 80
}, {
'hostname' => 'ec2-54-171-64-75.eu-west-1.compute.amazonaws.com',
'ipaddress' => '54.171.64.75',
'port' => 80,
'ssl_port' => 80
}]

include_recipe 'haproxy::default'
