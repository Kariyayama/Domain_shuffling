require 'date'
def domain_table(domain, listhash, e_val)
  # Create domain table
  outfile1 = File.open('domain_out.csv', "w")
  outfile1.puts "##{Date.today}"
  outfile1.puts "# Evalue: #{e_val}"
  # Header
  outfile1.print "#"
  listhash.each_key do |key|
    outfile1.print "#{key},"
  end
  outfile1.puts "domain"

  # Main_table
  domain.each_key do |key_dom|
    listhash.each_key do |animal|
      if listhash[animal].domain_hash.fetch(key_dom, nil) != nil then
        outfile1.print "1,"
      else
        outfile1.print "0,"
      end
    end
    outfile1.puts "#{key_dom}"
  end
  outfile1.close
end

def combi_table(domcom, listhash, e_val)
  # Create domcom table
  outfile2 = File.open('combi_out.csv', "w")
  # Header
  outfile2.puts "##{Date.today}"
  outfile2.puts "# Evalue: #{e_val}"
  outfile2.print "#"
  listhash.each_key do |key|
    outfile2.print "#{key},"
  end
  outfile2.puts "domain1,domain2"

  # Main Table
  domcom.each_key do |key_combi|
    listhash.each_key do |animal|
      if listhash[animal].domcom.fetch(key_combi, nil) then
        outfile2.print "1,"
      else
        outfile2.print "0,"
      end
    end
    outfile2.puts "#{key_combi.join(',')}"
  end
  outfile2.close
end

def overlap_table(domcom, listhash, e_val)
  # Create domcom table
  outfile3 = File.open('overlap_out.csv', "w")
  # Header
  outfile3.puts "##{Date.today}"
  outfile3.puts "# Evalue: #{e_val}"
  outfile3.print "#"
  listhash.each_key do |key|
    outfile3.print "#{key},"
  end
  outfile3.puts "domain1,domain2"

  # Main Table
  domcom.each_key do |key_combi|
    listhash.each_key do |animal|
      if domcom[key_combi].include?(animal) then
        outfile3.print "1,"
      else
        outfile3.print "0,"
      end
    end
    outfile3.puts "#{key_combi.join(',')}"
  end
  outfile3.close
end
