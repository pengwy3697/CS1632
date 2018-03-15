require './Transactions'


class Block
  
  attr_accessor :blockNum, :prevHash, :transactions, :timestampStr, :currentHash, :expectedHash, :seconds, :nanoSeconds
  
  def initialize(line, coinsHash = nil, personList = nil)
    values = line.split("|")
    
    if values.length < 5 || values.length > 5
      puts 'Each block should contain 5 elements'
      raise 'BLOCKCHAIN INVALID'
    end
    
    @coinsHash = coinsHash    # A dictionary that keeps track of coins earned by each person
    @personList = personList
    @blockNum = values[0].to_i
    @prevHash = values[1]
    @transactionsStr = values[2]
    @transactions = Transactions.new(values[2], @coinsHash, @personList) # Transactions class will parse list of transactions separated by :
    @timestampStr = values[3]
    @currentHash = values[4].tr("\n", "") # Remove newline at the end

#    if !validate(@timestampStr)
#      puts 'TImestamp invalid'
#      raise 'BLOCKCHAIN INVALID'
#    end

    i = @timestampStr.index('.')
    @seconds = @timestampStr[0..(i-1)].to_i
    @nanoSeconds = @timestampStr[(i+1)..(-1)].to_i
     
    if @blockNum == 0
      if !transactions.startFromSystem(0)
        raise 'Block 0 should start with SYSTEM'
      end
    end
   
    if @blockNum > 0
      if !transactions.lastTransFromSystem
        raise 'Last transaction in block ' + @blockNum.to_s + ' should start with SYSTEM'
      end
    end
 
    # Calculate hash  
    @expectedHash = hashFunc
    
    # puts "current '" + @currentHash + "'"
    # puts "expected '" + @expectedHash + "'"
    # puts @currentHash.encoding
    # puts @expectedHash.encoding
  end
  
  def validate(string)
    !string.match(/[0-9]*\.[0-9]*/).nil?
  end
  
  def calcx(x)
    (x ** 2000) * ((x + 2) ** 21) - ((x + 5) ** 3)
  end
  
  def hashFunc
    strIn = @blockNum.to_s + "|" + @prevHash + "|" + @transactionsStr + "|" + @timestampStr
    sum = 0
    uni = strIn.unpack('U*')
    
    uni.each { |x|
      v = calcx(x)
      sum += v
    }
    sum = sum % 65536
    hex = sum.to_s(16)
    hex.force_encoding(Encoding::UTF_8) # Convert to UTF_8 encoding from US-ASCII
  end
end