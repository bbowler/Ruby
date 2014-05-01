#!/usr/bin/ruby
# ssh.rb
# Brad Bowler 04/2014
# Command line options to run UNIX commands via SSH
#  
require 'rubygems'
require 'net/ssh'
require 'optparse'

opts = OptionParser.new
opts.on("-h HOSTNAME",      "--hostname NAME",         String, "Hostname of Server")       { |v| @hostname = v }
opts.on("-u SSH USERNAME",  "--username SSH USERNAME", String, "SSH Username of Server")   { |v| @username = v }
opts.on("-p SSH PASSWORD",  "--password SSH PASSWORD", String, "SSH Password of Server")   { |v| @password = v }
opts.on("-c SHELL_COMMAND", "--command SHELL_COMMAND", String, "Shell Command to Execute") { |v| @cmd = v }

begin
  opts.parse!(ARGV)
rescue OptionParser::ParseError => e
  puts e
end

raise OptionParser::MissingArgument, "Hostname [-h]" if @hostname.nil?
raise OptionParser::MissingArgument, "SSH Username [-u]" if @username.nil?
raise OptionParser::MissingArgument, "SSH Password [-p]" if @password.nil?
raise OptionParser::MissingArgument, "Command to Execute [-c]" if @cmd.nil?

if File.file?("/Ruby200-x64/pw/bbowler") then
	pwFile = File.open("/Ruby200-x64/pw/bbowler", "r") 
	while mypw = pwFile.gets do
		#puts "***From File-->#{mypw}<--"
		@password = mypw.chomp
		#puts "***From Parm-->#{@password}<--***"
		#puts @hostname
		#puts @username
		#puts @cmd
	end
		pwFile.close
else
	puts "No file, using password parameter instead ..."
end

 begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)
	res = ssh.exec!(@cmd)
    puts res
    ssh.close
  rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password} for #{@cmd}"
  end
