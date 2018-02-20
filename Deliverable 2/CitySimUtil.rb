class CitySimUtil
  #############################################################################
  # set the seed of random generator
  #############################################################################
  def setRandomSeed(randomSeed)
    if (randomSeed.to_i < 0)
      raise RuntimeError, "Invalid random generator seed < 0"
    end
    srand randomSeed
  end

  #############################################################################
  # generate random number based on the range
  #############################################################################
  def genRandom(randomRange)
    if (randomRange.to_i <= 0)
      raise RuntimeError, "Invalid random number range <= 1"
    end
    numRange=randomRange-1
    rand(0..numRange)
  end
  
  ###############################################################################
  def isNumeric(obj) 
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  ###############################################################################
  def validateArg(arg)
  
    if arg.length != 1
      raise RuntimeError, "Enter a seed and only a seed"
    end
  
    if (!isNumeric(arg[0]))
      return 0
    end
  
    return arg[0].to_i;
  end
end