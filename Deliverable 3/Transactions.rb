require './TransactionRec'

class Transactions
  
  def initialize(transLine, coinsHash = nil, personList = nil)
    @transList = []
    @coinsHash = coinsHash
    
    fields = transLine.split(":") # Split list of transactions separated by :
    
    fields.each do |field|
      i1 = field.index('>')
      i2 = field.index('(')
      i3 = field.index(')')
      fromAddr = field[0..(i1-1)]
      toAddr = field[(i1+1)..(i2-1)]
      numBillcoins = field[(i2+1)..(i3-1)]
        
      eachTransaction = TransactionRec.new(fromAddr, toAddr, numBillcoins, coinsHash, personList)
      @transList << eachTransaction
    end
  end
  
  def count
    @transList.length()
  end
  
  # Every address should have non-negative balance (>= 0) by the end of the block
  def checkNegative
    status = nil
    
    @transList.each do |tran|
      if tran.fromAddr != "SYSTEM" && @coinsHash[tran.fromAddr] < 0
        status = "Invalid block, address " + tran.fromAddr + " has " + @coinsHash[tran.fromAddr].to_s + " billcoins!"
      end
    end
    
    status
  end
  
  # Check if first transaction in first block is SYSTEM
  def startFromSystem(transIdx)
    flag = false
    
    if @transList.length > 0
      if @transList[transIdx].fromAddr.eql? "SYSTEM"
        flag = true
      end
    end  
    
    flag
  end

  # Check if last transaction in each block is from SYSTEM
  def lastTransFromSystem
    flag = true
    rec = @transList[@transList.length() - 1]
       
    if rec.fromAddr != "SYSTEM"
      flag = false
    end
    
    flag
  end
end