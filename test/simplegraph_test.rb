# coding: utf-8

require File.expand_path '../../simplegraph', __FILE__
require 'test/unit'

class SimpleGraphTest < Test::Unit::TestCase
  def test_must_be_a_triple_when_add_to_empty_index
    graph = SimpleGraph.new
    index = {}
    graph.add_to_index index, 'a', 'b', 'c'

    assert_equal 1, index.size
    assert index.include? 'a'
    assert index['a'].include? 'b'
    assert_equal ['c'], index['a']['b']
  end

  def test_must_be_two_2nd_items_when_add_to_existing_1st_item
    graph = SimpleGraph.new
    index = {}
    graph.add_to_index index, 'a', 'b', 'c'
    graph.add_to_index index, 'a', 'B', 'C'

    assert_equal 1, index.size
    assert index['a'].include? 'b'
    assert index['a'].include? 'B'
    assert_equal ['c'], index['a']['b']
    assert_equal ['C'], index['a']['B']
  end

  def test_must_be_two_3rd_items_when_add_to_existing_2nd_item
    graph = SimpleGraph.new
    index = {}
    graph.add_to_index index, 'a', 'b', 'c'
    graph.add_to_index index, 'a', 'b', 'C'

    assert_equal 1, index.size
    assert_equal 1, index['a'].size
    assert index['a'].include? 'b'
    assert_equal ['c', 'C'], index['a']['b']
  end

  # test_triples
  # 1, val, val, val
  # 2, val, val, nil
  # 3, val, nil, val
  # 4, val, nil, nil
  # 5, nil, val, val
  # 6, nil, val, nil
  # 7, nil, nil, val
  # 8, nil, nil, nil

  # 1
  def test_must_be_hit_triples_when_sub_pred_obj
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'

    assert_equal [['a', 'b', 'c']], graph.triples('a', 'b', 'c')
  end

  # 2
  def test_must_be_hit_triples_when_sub_pred_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'a', 'b', 'C'

    assert_equal [['a', 'b', 'c'], ['a', 'b', 'C']], graph.triples('a', 'b', nil)
  end

  # 3
  def test_must_be_hit_triples_when_sub_nil_obj
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'a', 'B', 'c'

    assert_equal [['a', 'b', 'c'], ['a', 'B', 'c']], graph.triples('a', nil, 'c')
  end

  # 4
  def test_must_be_hit_triples_when_sub_nil_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'a', 'B', 'c'

    assert_equal [['a', 'b', 'c'], ['a', 'B', 'c']].sort, graph.triples('a', nil, nil).sort
  end

  # 5
  def test_must_be_hit_triples_when_nil_pred_obj
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'A', 'b', 'c'

    assert_equal [['a', 'b', 'c'], ['A', 'b', 'c']].sort, graph.triples(nil, 'b', 'c').sort
  end

  # 6
  def test_must_be_hit_triples_when_nil_pred_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'A', 'b', 'C'

    assert_equal [['a', 'b', 'c'], ['A', 'b', 'C']].sort, graph.triples(nil, 'b', nil).sort
  end

  # 7
  def test_must_be_hit_triples_when_nil_nil_obj
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'A', 'B', 'c'

    assert_equal [['a', 'b', 'c'], ['A', 'B', 'c']].sort, graph.triples(nil, nil, 'c').sort
  end

  # 8
  def test_must_be_hit_triples_when_nil_nil_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'b', 'c', 'a'
    graph.add 'c', 'a', 'b'
    graph.add 'A', 'B', 'C'

    assert_equal [['a', 'b', 'c'], ['b', 'c', 'a'], ['c', 'a', 'b'], ['A', 'B', 'C']].sort, graph.triples(nil, nil, nil).sort
  end

  def test_must_be_nil_if_not_existing_item
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'

    assert_equal nil, graph.triples('a', 'b', 'C')
    assert_equal nil, graph.triples('a', 'B', 'c')
    assert_equal nil, graph.triples('A', 'b', 'c')

    assert_equal nil, graph.triples(nil, 'B', 'c')
    assert_equal nil, graph.triples(nil, 'b', 'C')

    assert_equal nil, graph.triples('a', nil, 'C')
    assert_equal nil, graph.triples('a', 'B', nil)
  end

  def test_must_be_nil_if_triples_empty
    graph = SimpleGraph.new

    assert_equal nil, graph.triples('a', 'b', 'c')
  end


  def test_must_remove_existing_triple
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'

    graph.remove 'a', 'b', 'c'
    assert_equal nil, graph.triples('a', 'b', 'c')
    assert_equal nil, graph.triples(nil, nil, nil)
  end

  def test_must_remain_triple_if_remove_one_obj
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'a', 'b', 'C'

    graph.remove 'a', 'b', 'c'
    assert_equal nil, graph.triples('a', 'b', 'c')
    assert_equal [['a', 'b', 'C']], graph.triples('a', 'b', nil)
  end

  def test_must_remain_triple_if_remove_one_pred
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'a', 'B', 'c'

    graph.remove 'a', 'b', 'c'
    assert_equal nil, graph.triples('a', 'b', 'c')
    assert_equal [['a', 'B', 'c']], graph.triples('a', nil, 'c')
  end

  def test_must_remain_triple_if_remove_one_sub
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'A', 'b', 'c'

    graph.remove 'a', 'b', 'c'
    assert_equal nil, graph.triples('a', 'b', 'c')
    assert_equal [['A', 'b', 'c']], graph.triples(nil, 'b', 'c')
  end

  def test_must_get_value_of_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'

    assert_equal 'a', graph.value(nil, 'b', 'c')
    assert_equal 'b', graph.value('a', nil, 'c')
    assert_equal 'c', graph.value('a', 'b', nil)
  end

  def test_must_get_1st_value_of_hit
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'
    graph.add 'A', 'b', 'c'
    graph.add 'a', 'B', 'c'
    graph.add 'a', 'b', 'C'

    assert_equal 'a', graph.value(nil, 'b', 'c')
    assert_equal 'b', graph.value('a', nil, 'c')
    assert_equal 'c', graph.value('a', 'b', nil)
  end

  def test_must_get_1st_value_of_nil
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'

    assert_equal 'a', graph.value(nil, nil, 'c')
    assert_equal 'b', graph.value('a', nil, nil)
  end

  def test_must_return_nil_when_value_not_exist
    graph = SimpleGraph.new
    graph.add 'a', 'b', 'c'

    assert_equal nil, graph.value(nil, 'B', 'C')
    assert_equal nil, graph.value('A', nil, 'C')
    assert_equal nil, graph.value('A', 'B', nil)
  end
end
