#!/usr/bin/env ruby

sheet, time = Hash.new { |hash,key| hash[key]={} }, 0
while line = gets
  if /^num\s+#instances\s+#bytes\s+class\sname/ =~ line
    h, time, instances, bytes= {}, time + 1, 0, 0
    until /^Total\s+(\d+)\s+(\d+)/ =~ line do
      if /^\s*(\d+):\s+(\d+)\s+(\d+)\s+([a-zA-Z\[\];\.\$\d\<\>].*$)/ =~ line
        rank, instance, byte= $1.to_i, $2.to_i, $3.to_i
        instances, bytes = instances+instance, bytes+byte

        if h.key?($4)
          h[$4] = [h[$4][0],  h[$4][1] + instance,  h[$4][2] + byte]
        else
          h[$4] = [rank, instance, byte]
        end
      end
      line = gets
    end 

    if $1.to_i != instances || $2.to_i != bytes
      puts "[ERROR] Illegal Result!: ##{time} #{$1}/#{instances}, #{$2}/#{bytes}"
    end 

    h.each do |klass, value|
        sheet[klass][time]=value
    end 

  end 
end

f_rnk,f_ins,f_byt=open("rank.log","w"),open("instance.log","w"),open("byte.log","w")
sheet.each do |klass, delta|
  rank,instance,byte="#{klass},","#{klass},","#{klass},"
  # have bluge
  1.upto(time) do |t|
    if delta.key?(t)
      rank<<"#{delta[t][0]},"
      instance<<"#{delta[t][1]},"
      byte<<"#{delta[t][2]},"
    else
      rank<<"0,"
      instance<<"0,"
      byte<<"0,"
    end
  end
  f_rnk.puts rank
  f_ins.puts instance
  f_byt.puts byte
end

