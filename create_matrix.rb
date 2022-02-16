#!/usr/bin/ruby
require_relative "domtblout"
require_relative "matrix_def"
require_relative "overlap_def"

listpath = './domtblout'

listname = ARGV.shift.chomp
evalue = ARGV.shift.chomp
listhash = Hash.new
domcom = Hash.new
overlap = Hash.new
domain = Hash.new

File.open(listname, "r").each_line do |list|
    if list.include?('#') then
    else
      # Extract all domain combinations
      organism = list.split('.')[0]
      listhash.store( organism, Domtblout.new("#{listpath}/#{list.chomp}", evalue))
      listhash[organism].create_domain_combi

      domain.merge!(listhash[organism].domain_hash)
      domcom.merge!(listhash[organism].domcom)

      # Extract overlaped combinations
      listhash[organism].gene_hash.each_key do |gene|
        align = listhash[organism].gene_hash[gene]['alignment']
        seq   = listhash[organism].gene_hash[gene]['seq']
        for i in 0..(seq.length - 2) do
          for j in i..(seq.length - 1) do
            combi = [seq[i], seq[j]].sort

            # Store new domain combination to hash
            if overlap.fetch(combi, false)
            else
              overlap.store(combi, Array.new)
            end

            # Test the domain combination is inner or not.
            if !overlap[combi].include?(organism)
                result = inner_partial(seq[i], seq[j],
                                       align[i].split('/')[0].split('-'),
                                       align[j].split('/')[0].split('-'), gene)
                if result == 0
                    overlap[combi].push(organism)
                end
            end
          end
        end
      end
    end
end

domain_table(domain, listhash, evalue)
combi_table( domcom, listhash, evalue)
overlap_table( overlap, listhash, evalue)

