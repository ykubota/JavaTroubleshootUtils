#!/usr/bin/env ruby

while line = STDIN.gets
  if /^num\s+#instances\s+#bytes\s+class\sname/ =~ line
    h = {}
    until /^Total\s+(\d+)\s+(\d+)/ =~ line do
      if /^\s*(\d+):\s+(\d+)\s+(\d+)\s+([a-zA-Z\[\];\.\$\d\<\>].*$)/ =~ line
        rank, instances, bytes = $1.to_i, $2.to_i, $3.to_i
        if h.key?($4)
          h[$4] = [h[$4][0], h[$4][1] + instances, h[$4][2] + bytes ]
        else
          h.store($4,[rank, instances, bytes])
        end
      end
      line = STDIN.gets
    end

    instances=0;bytes=0;
    h.sort.each do|key,value|
      instances+=value[1];bytes+=value[2]
      puts "#{key},#{value[0]},#{value[1]},#{value[2]}"
    end
    puts "[ERROR] Illegal Result!: #{$1}/#{instances}, #{$2}/#{bytes}" if $1.to_i != instances || $2.to_i != bytes
  end 
end
