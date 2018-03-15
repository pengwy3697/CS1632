require './Block'

class BlockFile
  
  def initialize(filename)
    if !File.exist? filename
      raise 'Input file does not exist: ' + filename
    end
    
    @filename = filename
    @blocks = []
    @coinsHash = Hash.new # A dictionary keeps track of person and coins earned
    @personList = []
  end
  
  def summarize
    @personList.each do |person|
      # puts person + "#{person}: #{@coinsHash[person].to_s} billcoins"
      puts person + ": " + @coinsHash[person].to_s + " billcoins"
    end
  end
  
  def verifyFirstBlock(block)
    
    # Check block number - first block should start from 0
    if block.blockNum != 0
      # puts block.blockNum
      raise 'Block number should start with 0'
    end
   
    # Check block - first block should start with SYSTEM
    if !block.transactions.startFromSystem(0)
      puts 'Block 0 should start with SYSTEM'
      raise 'Block 0 should start with SYSTEM'
    end
     
    # First block should have exactly one transaction
    if block.transactions.count != 1
      raise 'First block should have exactly one transaction'
    end
    
    status = block.transactions.checkNegative
    if (status != nil)
      puts "Line 1: " + status
      raise 'BLOCKCHAIN INVALID'
    end
  end
  
  def verifyPrevNextBlock(lineNum, lineWithoutCR, prevBlock, nextBlock)
    numStr = (lineNum + 1).to_s
    # Each block should have at least one transaction
    if nextBlock.transactions.count < 1
      raise 'Each block should have at least one transaction'
    end
    
    # Check block number - each block should increment by one from previous block
    if prevBlock.blockNum + 1 != nextBlock.blockNum
      puts "Line " + numStr + ": Invalid block number " + nextBlock.blockNum.to_s +
           ", should be " + (prevBlock.blockNum + 1).to_s
      raise 'BLOCKCHAIN INVALID'
    end
    
    status = nextBlock.transactions.checkNegative
    if status != nil
      puts "Line " + numStr + ": " + status
      raise  'BLOCKCHAIN INVALID'
    end
    
    # Check time should never be the same or move "backwards in time"
    if prevBlock.seconds > nextBlock.seconds
      puts "Line " + numStr + ": Previous timestamp " + prevBlock.timestampStr +
           " >= new timestamp " + nextBlock.timestampStr 
      raise 'BLOCKCHAIN INVALID'
    elsif prevBlock.seconds == nextBlock.seconds && prevBlock.nanoSeconds >= nextBlock.nanoSeconds
      puts "Line " + numStr + ": Previous timestamp " + prevBlock.timestampStr +
           " >= new timestamp " + nextBlock.timestampStr 
      raise 'BLOCKCHAIN INVALID'
    end

    # Check if hash in previous block and next block are the same
    if !nextBlock.prevHash.eql? prevBlock.currentHash
      puts "Line " + numStr + ": Previous has was " + nextBlock.prevHash +
           ", should be " + prevBlock.currentHash
      raise 'BLOCKCHAIN INVALID'
    end

    # Check if hash passed in and calculated hash are the same
    if !nextBlock.currentHash.eql? nextBlock.expectedHash
      puts "Line " + numStr + ": String '" + lineWithoutCR + "' hash set to " +
           nextBlock.currentHash + ", should be " + nextBlock.expectedHash
      raise 'BLOCKCHAIN INVALID'
    end
  end
  
  def process
    begin
      f = File.open(@filename, 'r')

      f.each_line { |line|
        block = Block.new(line, @coinsHash, @personList)
        
        # First block
        if @blocks.length() == 0
          verifyFirstBlock(block)
          
        # Subsequent block
        else
          lineNum = @blocks.length() - 1
          prev = @blocks[lineNum]
          verifyPrevNextBlock(lineNum, line.tr("\n", ""), prev, block) # Remvoe newline at end of input line for outputting purpose
        end
        
        @blocks << block
      }
      summarize
      true
    rescue RuntimeError => e
      puts "#{e.message}"
      false
    end
  end
  
end