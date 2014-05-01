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
 begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)
	puts "******************************************************************"
	puts "*********************** Executing uname -a ***********************"
	puts "******************************************************************"
	res = ssh.exec!("uname -a")
    puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing nslookup $HOSTNAME *************"
	puts "******************************************************************"
	res = ssh.exec!("nslookup $HOSTNAME")
    puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing free -m ************************"
	puts "******************************************************************"
	res = ssh.exec!("free -m")
    puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing ps -aux |sort -nrk 4| head -10 *"
	puts "******************************************************************"
	res = ssh.exec!("ps -aux |sort -nrk 4| head -10")
    puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing df -h    ***********************"
	puts "******************************************************************"
	res = ssh.exec!("df -h")
    puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing df -a -h ***********************"
	puts "******************************************************************"
	res = ssh.exec!(@cmd)
	puts res
	puts " "
	puts " "
	puts "******************************************************************"
	puts "*********************** Executing last ***************************"
	puts "******************************************************************"
	res = ssh.exec!("last")
    puts res
    ssh.close
  rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  end
