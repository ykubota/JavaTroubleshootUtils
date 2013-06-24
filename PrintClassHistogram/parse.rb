#!/usr/bin/env ruby

while line = gets
  if /^num\s+#instances\s+#bytes\s+class\sname/ =~ line
    h = {}
    until /^Total\s+(\d+)\s+(\d+)/ =~ line do
      if /^\s*(\d+):\s+(\d+)\s+(\d+)\s+([a-zA-Z\[\];\.\$\d\<\>].*$)/ =~ line
        rank, instances, bytes = $1.to_i, $2.to_i, $3.to_i
        if h.key?($4)
          h[$4] = [h[$4][0],  h[$4][1] + instances,  h[$4][2] + bytes]
        else
          h[$4] = [rank, instances, bytes]
        end
      end 
      line = gets
    end 
 
    instances, bytes = h.sort.inject([0, 0]) do|array, kv| 
      puts kv.flatten.join(',')
      value = kv[1]
      [array[0] + value[1], array[1] + value[2]]
    end 
 
    if $1.to_i != instances || $2.to_i != bytes
      puts "[ERROR] Illegal Result!: #{$1}/#{instances}, #{$2}/#{bytes}"
    end 
 
  end 
end
