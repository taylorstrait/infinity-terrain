class MapsController < ApplicationController
BASE = 24


def new 
  
  # add url for seed on initial load
  unless request.parameters[:seed]
    redirect_to "/?seed=#{rand(100000)}"
  end
  
  ##### generate seed(s) #####
  # clear srand and set next seed
  srand
  @next_seed = rand(100000)
  
  # set srand to seed or random
  if !request.parameters[:seed].blank?
    @seed = request.parameters[:seed].to_i
  else
    @seed = rand(100000)
  end
  srand @seed

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
  key_nodes << rand(17..21) +   BASE*(rand(6)+18) #18
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

  when 1..15 # 2x2
    node = validate_node_spacing(node, layout,2,2)
    node = clamp_to_edge(node,2,2)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1]
  when 16..25 # 2x3
    node = validate_node_spacing(node, layout,2,3)
    node = clamp_to_edge(node,2,3)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1,
              node + BASE*2, node + BASE*2 + 1]
  when 26..35 # 2x4
    node = validate_node_spacing(node, layout,2,4)
    node = clamp_to_edge(node,2,4)
    
    return [  node, node + 1, 
              node + BASE, node + BASE + 1,
              node + BASE*2, node + BASE*2 + 1,
              node + BASE*3, node + BASE*3 + 1]
  when 36..60 # 3x2
    node = validate_node_spacing(node, layout,3,2)
    node = clamp_to_edge(node,3,2)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2]
  when 61..80 # 4x2
    node = validate_node_spacing(node, layout,4,2)
    node = clamp_to_edge(node,4,2)
    
    return [  node, node + 1, node + 2, node + 3, 
              node + BASE, node + BASE + 1, node + BASE + 2, node + BASE + 3]
  when 81..85 # 3x3
    node = validate_node_spacing(node, layout,3,3)
    node = clamp_to_edge(node,3,3)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2]
  when 86..90 # 3x4
    node = validate_node_spacing(node, layout,3,4)
    node = clamp_to_edge(node,3,4)
    
    return [  node, node + 1, node + 2, 
              node + BASE, node + BASE + 1, node + BASE + 2,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2,
              node + BASE*3, node + BASE*3 + 1, node + BASE*3 + 2]
  when 91..96 # 4x3
    node = validate_node_spacing(node, layout,4,3)
    node = clamp_to_edge(node,4,3)
    
    return [  node, node + 1, node + 2, node + 3, 
              node + BASE, node + BASE + 1, node + BASE + 2,node + BASE + 3,
              node + BASE*2, node + BASE*2 + 1, node + BASE*2 + 2, node + BASE*2 + 3]
  
  when 97..100 # 4x4
    node = validate_node_spacing(node, layout,4,4)
    node = clamp_to_edge(node,4,4)
    
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

# matt's sweet code
# def clamp_to_edgeeee(node, x, y base=BASE)
#   originX = node % base
#   originY = node / base
#   
#   if originX + x > base
#     node -= originX + x - base
#   end
# 
#   if originY + y > base
#     node -= base * (originY + y - base)
#   end
# 
#   return node
# end

def clamp_to_edge(node, x, y, base=BASE)
  while base - (node % base) < x 
    node -= 1
  end
  while (node + (base*(y-1))) >= (base*base)
    node -= base
  end
  return node
end

def validate_node_spacing(node, layout, x=2, y=2, base=BASE)
  
    if layout[node] != 0 #check same space
      if node + base*2 > layout.length
        node = node + 2
      else
        node = node + base*2
      end
    end
    if layout[node - base] != 0 || layout[(node+x) - base] != 0 # check above
      node = node + base*2
    end
    if layout[node + base*y] != 0 || layout[(node + x + base*y)] != 0 # check below
      node = node - base*2
    end

    if layout[node + x] != 0 && layout[node + base*y] != 0 # check right
      node = node - 2
    end
    if layout[node - 1] != 0 || layout[node + base*y - 1] != 0 # check left
      node = node + 2
    end

  return node
end




end
