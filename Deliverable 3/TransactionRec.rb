class TransactionRec
  attr_accessor :fromAddr, :toAddr
  
  def initialize(fromAddr, toAddr, numBillcoinsSent, coinsHash = nil, personList = nil)
    @fromAddr = fromAddr.strip
    @toAddr = toAddr.strip
    
    if !validate(@fromAddr)
      raise 'fromAddr contains non alphabetic characters ' + @fromAddr
    elsif @fromAddr.length > 6
      raise 'fromAddr > 6 chars'
    end
    
    if !validate(@toAddr)
      raise 'toAddr contains non alphabetic characters ' + @toAddr
    elsif @toAddr.length > 6
      raise 'toAddr > 6 chars'
    end
    
    if coinsHash != nil && personList != nil
      if !personList.include? toAddr
        personList << toAddr
        coinsHash[toAddr] = numBillcoinsSent.to_i
      else
        coinsHash[toAddr] += numBillcoinsSent.to_i
      end
      
      if coinsHash != nil && coinsHash[fromAddr] != nil && fromAddr != "SYSTEM"
        coinsHash[fromAddr] -= numBillcoinsSent.to_i
      end
    end
  end
  
  def validate(string)
    !string.match(/\A[a-zA-Z]*\z/).nil?
  end
end