require 'flamegraph'

require './BlockFile'


def time_diff_milli(start, finish)
   (finish - start) * 1000.0
end

Flamegraph.generate('./verifier_long.html') do
if ARGV.length == 1
  begin
    t1 = Time.now
    block = BlockFile.new(ARGV[0])
    
    block.process
    
    t2 = Time.now
    msecs = time_diff_milli t1, t2
    puts "milliseconds: " + msecs.to_s
  rescue RuntimeError => e
    puts "RuntimeError #{e.message}"
  end
else
  puts "Expects an input file as argument"
end
end