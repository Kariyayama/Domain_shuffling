#!/usr/bin/ruby
require_relative "domtblout"
require 'date'

domtblout = ARGV.shift.chomp
tablefile = ARGV.shift.chomp
evalue    = ARGV.shift

listpath = './domtblout/'
organism = domtblout.split('.')[0]
list = Domtblout.new(listpath + domtblout.chomp, evalue)
list.create_domain_combi

domcom  = list.domcom
outfile = File.open("#{organism}_#{tablefile}", "w")
infile  = File.open(tablefile, "r")
outfile.puts "##{Date.today}"
outfile.puts "#Evalue: #{evalue}"
infile.each_line do |line|
  unless line.include?('#')
    l = line.chomp.split(",")
    key = [l[-2].chomp, l[-1].chomp]
    if domcom.fetch(key, nil) != nil then
      outfile.puts "#{l[0..-1].join(',')},#{domcom[key].join(',')}"
    else
      outfile.puts line
    end
  end
end
infile.close
outfile.close

