require 'minitest/autorun'
require 'BlockFile'
require 'Block'

class BcoinTest < Minitest::Test
  def setup
    @coinsHash = Hash.new # A dictionary keeps track of person and coins earned
    @personList = []
  end
  
  # Input file does not exist
  def test_no_input_file
    begin
      BlockFile.new("not_exist.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # From Addr or To Addr greater than 6 chars
  def test_to_addr_greater_than_6_chars
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Jonathan(100)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  def test_from_addr_greater_than_6_chars
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|1518892051.737141000|1c12\n" + 
                                           "1|1c12|Jonathan>George(100)|1518892051.740967000|abb2") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
   
  # From Addr or To addr contain non alphabetic chars
  def test_to_addr_contain_numeric
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Mary88(100)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # First transaction in first block should be from SYSTEM
  def test_first_block_not_from_system
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|John>Henry(100)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
    
  # First block should have only one transaction
  def test_first_block_contain_multiple_trans
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100):John>Henry(200)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
    
  # First block does not start with 0
  def test_first_block_num_not_0
    begin
      File.open("t.txt", 'w') {|f| f.write("2|0|SYSTEM>Henry(100):John>Henry(200)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # Last transaction of each block should be from SYSTEM
  def test_last_transaction_not_system
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|1518892051.737141000\n" + 
                                           "1|1c12|Henry>George(80):Henry>Mary(20)|1518892051.740967000|abb2") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
   
  # Every block should have at least one transaction
  def test_block_contain_no_trans
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0||1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # Timestamp is the same within 2 blocks
  def test_same_timestamp
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|1518892051.737141000|1c12\n" + 
                                           "1|1c12|SYSTEM>George(100)|1518892051.737141000|abb2") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # Block number is not incremented by 1
  def test_block_numbers_not_sequential
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|1518892051.737141000|1c12\n" + 
                                           "2|1c12|SYSTEM>George(100)|1518892051.740967000|abb2") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
   
  # Hash codes do not match between previous and next blocks
  def test_different_hash_codes
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|1518892051.737141000|1c12\n" + 
                                           "1|1c22|SYSTEM>George(100)|1518892051.740967000|abb2") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # Billcoins is negative
  def test_block_contain_negative_billcoins
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(-100)|1518892051.737141000|1c12") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # Block contains < 5 or > 5 elements
  def test_block_contains_3_elements
    begin
      File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Henry(100)|") }
      BlockFile.new("t.txt").process
    rescue RuntimeError => e
      "RuntimeError #{e.message}"
      assert true
    end
  end
  
  # From Addr or To Addr greater than 6 chars
  # BlockFile lass
  def test_blockfile_class
    File.open("t.txt", 'w') {|f| f.write("0|0|SYSTEM>Seb(100)|1518892051.737141000|1c12") }
    assert_equal true, BlockFile.new("t.txt").process
  end
  
  # Test transaction checks fromAddr and toAddr using reg exp
  # Block lass
  def test_block_class
    block = Block.new("1|1c12|SYSTEM>George(100)|1518892051.740967000|abb2")
    assert_equal 1, block.transactions.count
  end
 
  # Test transactions - last one should be from SYSTEM
  # Transactions lass
  def test_transactions_class
    trans = Transactions.new("George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):Joe>Wu(100)")
    assert_equal false, trans.lastTransFromSystem
  end
   
  # Test transaction checks fromAddr and toAddr using reg exp
  # TransactionRec lass
  def test_transaction_record_class
    fromAddr = "Jennie"
    toAddr = "Audrey"
    rec = TransactionRec.new(fromAddr, toAddr, "100")
    assert_equal true, rec.validate(fromAddr)
    assert_equal true, rec.validate(toAddr)
  end
  
end