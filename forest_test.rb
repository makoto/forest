require "test/unit"

require "forest"

class TestForest < Test::Unit::TestCase
  def setup
    # 1 - 2 - 13
    #   - 3 - 4
    #       - 5
    #       - 6
    # 7 - 8 - 9 - 10
    # 11
    # 12 - 14
    # 15 - 16
    #    - 17
    #    - 18
    #    - 19
    #    - 20
    
    @data = [
      [1, "foo", "foo2", "foo3", nil] ,
      [2, 1]   ,
      [13, 2]  ,
      [3, "bar", 1]   ,
      [4, 3]   ,
      [5, 3]   ,
      [6, 3]   ,
      [10, 9]  ,
      [9, 8]   ,
      [8, 7]   ,
      [7, nil] ,
      [11, nil],
      [14, 12] ,
      [12, nil],
      [16, 15] ,
      [15, nil],
      [17, 15] ,
      [18, 15] ,
      [19, 15] ,
      [20, 15]
    ]
    @forest = Forest.new(@data)
  end
  
  def test_count
    assert_equal(5, @forest.count)
  end
  
  def test_sum
    assert_equal(20, @forest.sum)
  end

  def test_avg
    assert_equal(4, @forest.avg)
  end
  
  def test_max_sum
    assert_equal(7, @forest.max_sum)
  end

  def test_max_height
    assert_equal(4, @forest.max_height)
  end

  def test_max_width
    assert_equal(5, @forest.max_width)
  end
  
  def test_top
    assert_equal(@forest.max_sum,  @forest.top(1).first.size)
  end
  
  def test_non_matching_leaf
    non_matching_leaf = [
      [1, nil] ,
      [3, 2] ,
    ]
    forest = Forest.new(non_matching_leaf)
    assert_equal(1, forest.count)
    assert_equal(1, forest.orphants.size)
  end
end

