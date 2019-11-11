local cnc = {
  encounter_types = {
    "magic","physical","social","treasure"
  },
  player_slot = {
    "head","hand_left","hand_right","shoulder",
  }
}

function cnc.new(init)
  local self = {}

  self._map_pieces = init._map_pieces or 2
  self._players = {}
  for i = 1,init.players or 1 do
    local player = {}
    player.sadness = init.sadness or 6
    table.insert(self._players,player)
  end

  self.simulate = cnc.simulate
  self.addItem = cnc.addItem
  self.getRollMod = cnc.getRollMod
  self.print = init.print or print

  return self
end

function cnc:getRollMod(player,t)
  local mod = 0
  for _,slot in pairs(cnc.player_slot) do
    if player[slot] == t then
      self.print("\t\tfound "..player[slot].." in slot "..slot)
      mod = mod + 1
    end
  end
  return mod
end

function cnc:addItem(player,reward_type)
  local slot = cnc.player_slot[math.random(1,4)]
  if slot == "hand_left" or slot == "hand_right" then
    if player["hand_right"] == nil then
      player["hand_right"] = reward_type
      self.print("\t\tgot "..reward_type.." in right hand")
    else
      player["hand_left"] = reward_type
      self.print("\t\tgot "..reward_type.." in left hand")
    end
  else
    player[slot] = reward_type
    self.print("\t\tgot "..reward_type.." in "..slot)
  end
end

-- this simulation is dumb - players always roll for themselves, and take whatever they can
function cnc:simulate()
  local turn_count = 0
  local player_index = 1
  while #self._players > 0 and self._map_pieces > 0 do
    turn_count = turn_count + 1
    self.print("Turn "..turn_count.." ("..player_index.."/"..#self._players.."}")
    local player = self._players[player_index]
    local encounter = math.random(1,4)
    local difficulty = math.random(1,4)
    local roll = math.random(1,4)-2
    self.print("\tencounter: "..cnc.encounter_types[encounter])
    self.print("\tdifficulty: "..difficulty)
    self.print("\tbase roll: "..roll)
    -- determine encounter
    if encounter ~= 4 then
      -- roll against encounter
      roll = roll + self:getRollMod(player,cnc.encounter_types[encounter])
      self.print("\tmod roll: "..roll)
      -- see if the roll wins
      if roll > difficulty then
        self.print("\t\tSuccess Roll")
        -- get a related item
        --local reward_type = cnc.encounter_types[encounter]
        --self:addItem(player,reward_type)
      else
        self.print("\t\tSadness")
        -- you are sad
        player.sadness = player.sadness - 1
      end
    else
      -- treasure!
      if difficulty ~= 4 then
        -- get item
        local reward_type = cnc.encounter_types[difficulty]
        self:addItem(player,reward_type)
        self:addItem(player,reward_type)
      else
        -- get map piece
        self.print("found a map piece - remaining: "..self._map_pieces)
        self._map_pieces = self._map_pieces - 1
      end
    end

    -- remove players who are too sad
    for i,player in pairs(self._players) do
      if player.sadness <= 0 then
        self.print("Player "..i.." is too sad.")
        table.remove(self._players,i)
      end
    end

    -- next player
    player_index = (player_index + 1)
    if player_index > #self._players then
      player_index = 1
    end
  end
  local avg_items = 0
  for _,player in pairs(self._players) do
    local avg_player_items = 0
    for _,slot in pairs(cnc.player_slot) do
      if player[slot] then
        avg_player_items = avg_player_items + 1
      end
    end
    avg_items = avg_items + avg_player_items/#self._players
  end
  return self._map_pieces == 0,turn_count,avg_items
end

return cnc
