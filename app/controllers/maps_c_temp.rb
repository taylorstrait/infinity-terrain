class MapsController < ApplicationController
BASE = 24


def new 

  # create empty grid
  @base = BASE
  @layout = []
  (BASE * BASE).times {@layout << 0}

  # for visualization
  @grid = []
  (BASE * BASE).times {|i| @grid << i}

  key_nodes = []
  
  key_nodes << rand(3) +        BASE*rand(6) #0
  key_nodes << rand(4..8) +     BASE*rand(6)
  key_nodes << rand(9..13) +    BASE*rand(6)
  key_nodes << rand(14..18) +   BASE*rand(6)
  key_nodes << rand(19..21) +   BASE*rand(6) #4

  key_nodes << rand(3) +        BASE*(rand(6)+6) #5
  key_nodes << rand(4..8) +     BASE*(rand(6)+6)
  key_nodes << rand(9..13) +    BASE*(rand(6)+6)
  key_nodes << rand(14..18) +   BASE*(rand(6)+6)
  key_nodes << rand(19..21) +   BASE*(rand(6)+6) #9
  
  key_nodes << rand(3) +        BASE*(rand(6)+12) #10
  key_nodes << rand(4..8) +     BASE*(rand(6)+12)
  key_nodes << rand(9..13) +    BASE*(rand(6)+12)
  key_nodes << rand(14..18) +   BASE*(rand(6)+12)
  key_nodes << rand(19..21) +   BASE*(rand(6)+12) #14
  
  key_nodes << rand(4) +        BASE*(rand(6)+18) #15
  key_nodes << rand(5..10) +    BASE*(rand(6)+18)
  key_nodes << rand(11..16) +   BASE*(rand(6)+18)
  key_nodes << rand(17..22) +   BASE*(rand(6)+18) #18
  #key_nodes << rand(21..23) +   BASE*(rand(6)+18) #19

  key_nodes[0..4].each do |node|
    size = generate_size_high_cover
    generate_building(node,@layout).each {|x| @layout[x] = size}
  end  

  key_nodes[5..14].each do |node|
    size = generate_size_with_terrain
    generate_building(node,@layout).each {|x| @layout[x] = size}
  end

  key_nodes[15..key_nodes.length].each do |node|
    size = generate_size_low_cover
    generate_building(node,@layout).each {|x| @layout[x] = size}
  end
  
  # place scatter terrain
  max_scatter = 20
  while max_scatter != 0
    x = rand(0..@layout.length)
    while @layout[x] == 0
      @layout[x] = "s"
      max_scatter -= 1
    end
  end
  
  
  # place 2nd level terrain
  max_roof_terrain = 10
  while max_roof_terrain != 0
    x = rand(0..@layout.length)
    while [1,2].include?(@layout[x])
      @layout[x] == 1 ? @layout[x] = "1t" : @layout[x] = "2t"
      max_roof_terrain -= 1
    end
  end

end


def generate_building(node, layout, base=24)

  # generate building at index 
  x = rand(1..100)
  
  case x

  when 1..15 # 2x2
    return generate_bldg_nodes(node,2,2)    
  when 16..30 # 2x3
    return generate_bldg_nodes(node,2,3)
  when 31..40 # 2x4
    return generate_bldg_nodes(node,2,4)
  when 41..60 # 3x2
    return generate_bldg_nodes(node,3,2)
  when 61..75 # 4x2
    return generate_bldg_nodes(node,4,2)
  when 76..88 # 3x3
    return generate_bldg_nodes(node,3,3)
  when 89..92 # 3x4
    return generate_bldg_nodes(node,3,4)
  when 93..96 # 4x3
    return generate_bldg_nodes(node,4,3)
  when 97..100 # 4x4
    return generate_bldg_nodes(node,4,4)
  end
end

def generate_size_low_cover
  size_options = [1,1,1,1,1,1,1,1,2,2]
  size = size_options[rand(size_options.length)]
  return size
end

def generate_size_high_cover
  size_options = [1,1,1,1,1,2,2,2,2,2]
  size = size_options[rand(size_options.length)]
  return size
end

def generate_size_with_terrain
  size_options = [1,1,1,1,2,2,2,2,"T","T"]
  size = size_options[rand(size_options.length)]
  return size
end

def clamp_horiz(node, width, base=BASE)
  while base - (node % base) < width 
    node -= 1
  end
  return node
end

def generate_bldg_nodes(node,x,y,layout=@layout,base=24)
  
  node = validate_node_spacing(node,x,y,layout) 

  shape = [node]
  y.times do |y|
    x.times {|x| shape << node + base*(y-1) + (x-1)}
  end
    
  return shape    
end

def validate_node_spacing(node, width, height, layout=@layout,base=BASE)
  
    if layout[node] != 0 #check same space
      if node + base*2 > layout.length
        node = node + 2
      else
        node = node + base*2
      end
    end
    if layout[node - base] != 0 || layout[(node+width) - base] != 0 # check above
      node = node + base*2
    end
    if layout[node + base*height] != 0 || layout[(node + width + base*height)] != 0 # check below
      node = node - base*2
    end

    if layout[node + width] != 0 && layout[node + base*height] != 0 # check right
      node = node - 2
    end
    if layout[node - 1] != 0 || layout[node + base*height - 1] != 0 # check left
      node = node + 2
    end

  return node
end
end
