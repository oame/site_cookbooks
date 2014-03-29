#
# Cookbook Name:: site_simple_iptables
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "simple_iptables"

# Reject packets other than those explicitly allowed
simple_iptables_policy "INPUT" do
  policy "DROP"
end

# Allow all traffic on the loopback device
simple_iptables_rule "system" do
  rule "--in-interface lo"
  jump "ACCEPT"
end

# Allow ICMP
#simple_iptables_rule "system" do
#  rule "-p icmp --icmp-type any"
#  jump "ACCEPT"
#end

# Allows ESP and AH
#simple_iptables_rule "system" do
#  rule ["-p 50",
#        "-p 51"]
#  jump "ACCEPT"
#end

# Allow DNS Multicast
simple_iptables_rule "system" do
  rule "-p udp --dport 5353 -d 224.0.0.251"
  jump "ACCEPT"
end

# Allows ESTABLISHED and RELATED connections
simple_iptables_rule "system" do
  rule "-m state --state ESTABLISHED,RELATED"
  jump "ACCEPT"
end

# Allow ping
simple_iptables_rule "system" do
  rule "-m state --state NEW -m icmp -p icmp --icmp-type 8"
  jump "ACCEPT"
end

# Allow SSH
simple_iptables_rule "system" do
  rule "-p tcp --dport 10122"
  jump "ACCEPT"
end

# Allow HTTP, HTTPS
simple_iptables_rule "http" do
  rule ["-p tcp --dport 80",
        "-p tcp --dport 443"]
  jump "ACCEPT"
end

# Allow SMTP
simple_iptables_rule "smtp" do
  rule "-m state --state NEW -m tcp -p tcp --dport 25"
  jump "ACCEPT"
end

# Allow FTP
simple_iptables_rule "ftp" do
  rule ["-m state --state NEW -m tcp -p tcp --dport 20",
        "-m state --state NEW -m tcp -p tcp --dport 21",
        "-m state --state NEW -m tcp -p tcp --dport 30000:35000"]
  jump "ACCEPT"
end

# Allow MySQL
#simple_iptables_rule "mysql" do
#  rule "-m state --state NEW -m tcp -p tcp --dport 3306"
#  jump "ACCEPT"
#end

# Log iptables denied calls (access via 'dmesg' command)
simple_iptables_rule "system" do
  rule "--match limit --limit 5/min --jump LOG --log-prefix \"iptables denied: \" --log-level 7"
  jump false
end