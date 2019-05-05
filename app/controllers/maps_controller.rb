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


def generate_building(node, layout)

  # generate building at index 
  x = rand(1..100)
  
  case x

  when 1..10 # 2x2
    node = validate_node_spacing(node, layout,2,2)
    node = clamp_horiz(node,2)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1]
  when 11..25 # 2x3
    node = validate_node_spacing(node, layout,2,3)
    node = clamp_horiz(node,2)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1,
              node + BASE*2, node + BASE*2 + 1]
  when 25..40 # 2x4
    node = validate_node_spacing(node, layout,2,4)
    node = clamp_horiz(node,2)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1,
              node + BASE*2, node + BASE*2 + 1,
              node + BASE*3, node + BASE*3 + 1]
  when 41..60 # 3x2
    node = validate_node_spacing(node, layout,3,2)
    node = clamp_horiz(node,3)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2]
  when 61..80 # 4x2
    node = validate_node_spacing(node, layout,4,2)
    node = clamp_horiz(node,4)
    
    return [  node, node + 1, node + 2, node + 3, 
              node + BASE, node + BASE + 1, node + BASE + 2, node + BASE + 3]
  when 81..85 # 3x3
    node = validate_node_spacing(node, layout,3,3)
    node = clamp_horiz(node,3)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2]
  when 86..90 # 3x4
    node = validate_node_spacing(node, layout,3,4)
    node = clamp_horiz(node,3)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2,
              node + BASE*3, node + BASE*3 + 1, node + BASE*3 + 2]
  when 91..96 # 4x3
    node = validate_node_spacing(node, layout,4,3)
    node = clamp_horiz(node,4)
    
    return [  node, node + 1, node + 2, node + 3, 
              node + BASE, node + BASE + 1, node + BASE + 2,node + BASE + 3,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2, node + BASE*2 + 3]
  
  when 96..100 # 4x4
    node = validate_node_spacing(node, layout,4,4)
    node = clamp_horiz(node,4)
    
    return [  node, node + 1, node + 2, node + 3, 
              node + BASE, node + BASE + 1, node + BASE + 2,node + BASE + 3,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2, node + BASE*2 + 3,
              node + BASE*3, node + BASE*3 + 1, node + BASE*3 + 2, node + BASE*3 + 3]
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

def validate_node_spacing(node, layout, width=2, height=2, base=BASE)
  
    if layout[node] != 0
      if node + base*2 > layout.length
        node = node + 2
      else
        node = node + base*2
      end
    end
    if layout[node - base] != 0 || layout[(node+width) - base] != 0# check above
      node = node + base
    end
    if layout[node + base*height] != 0 || layout[(node + width + base*height)] != 0 # check below
      node = node - base
    end

    if layout[node + width] != 0 && layout[node - 2] == 0 # check right
      node = node - 1
    end
    if layout[node - 1] != 0 && layout[node + width + 1] == 0 # check right
      node = node + 1
    end
    if layout[node + base*height] != 0 && layout[node - base*2] == 0 # check vert
      node = node - base
    end

  return node
end
end
