# coding: utf-8

class SimpleGraph
  def initialize
    @spo = {}
    @pos = {}
    @osp = {}
  end

  def add sub, pred, obj
    add_to_index @spo, sub, pred, obj
    add_to_index @pos, pred, obj, sub
    add_to_index @osp, obj, sub, pred
  end

  def add_to_index index, a, b, c
    unless index.include? a
      index[a] = {}
      index[a][b] = [c]
    else
      unless index[a].include? b
        index[a][b] = [c]
      else
        index[a][b] << c
      end
    end
  end

  def remove sub, pred, obj
    return if self.triples(sub, pred, obj) == nil # do nothing

    remove_from @spo, sub, pred, obj
    remove_from @pos, pred, obj, sub
    remove_from @osp, obj, sub, pred
  end

  def remove_from index, a, b, c
    index[a][b].delete c
    if index[a][b].size == 0
      index[a].delete b
      if index.size == 0
        index.delete a
      end
    end
  end

  def triples sub, pred, obj
    triples = []

    if @spo.size == 0
      return nil

    elsif sub != nil and pred != nil and obj != nil
      if @spo.include? sub and @spo[sub].include? pred and @spo[sub][pred].include? obj
        triples << [sub, pred, obj]
      end
      return (triples.size == 0) ? nil : triples

    elsif sub == nil and pred == nil and obj == nil
      @spo.each_key do |s|
        @spo[s].each_key do |p|
          @spo[s][p].each do |o|
            triples << [s, p, o]
          end
        end
      end
      return (triples.size == 0) ? nil : triples

    else
      if sub != nil
        if pred != nil
          # sub, pred, nil
          if triple_exist? @spo, sub, pred
            @spo[sub][pred].each do |o|
              triples << [sub, pred, o]
            end
            return triples
          end
        else
          if obj != nil
            # sub, nil, obj
            if triple_exist? @osp, obj, sub
              @osp[obj][sub].each do |p|
                triples << [sub, p, obj]
              end
              return triples
            end
          else
            # sub, nil, nil
            if @spo.include? sub
              @spo[sub].each_key do |p|
                @spo[sub][p].each do |o|
                  triples << [sub, p, o]
                end
              end
              return triples
            end
          end
        end
      else
        if pred != nil
          if obj != nil
            # nil, pred, obj
            if triple_exist? @pos, pred, obj
              @pos[pred][obj].each do |s|
                triples << [s, pred, obj]
              end
              return triples
            end
          else
            # nil, pred, nil
            if @pos.include? pred
              @pos[pred].each_key do |o|
                @pos[pred][o].each do |s|
                  triples << [s, pred, o]
                end
              end
              return triples
            end
          end
        else
          # nil, nil, obj
          if @osp.include? obj
            @osp[obj].each_key do |s|
              @osp[obj][s].each do |p|
                triples << [s, p, obj]
              end
            end
            return triples
          end
        end
      end
    end
  end

  def triple_exist? index, a, b
    index.include? a and index[a].include? b
  end

  def value sub, pred, obj
    triples = self.triples sub, pred, obj
    return nil if not triples
    triples.each do |triple|
      return triple[0] if not sub
      return triple[1] if not pred
      return triple[2] if not obj
    end
    nil
  end

  def load filename
    require 'csv'
    CSV.open(filename, 'r') do |reader|
      while spo = reader.gets
      self.add spo[0], spo[1], spo[2]
      end
    end
  end

  def save filename
    require 'csv'
    CSV.open(filename, 'w') do |writer|
      self.triples(nil, nil, nil).each do |triple|
        writer << triple
      end
    end
  end
end
