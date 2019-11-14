cnc = require"cnc"

math.randomseed(os.time())

local stat = 10000
for players = 2,4 do
  local sadness = 7-players
  do
    local wins = 0
    local turns = 0
    local items = 0
    for i = 1,stat do
      local game = cnc.new{
        players=players,
        sadness=sadness,
        print=function()end,
      }
      local win,turn = game:simulate()
      if win then
        turns = turns + turn
        wins = wins + 1
      end
    end
    print("Config:")
    print("\tplayers: "..players)
    print("\tremain sadness: "..sadness)
    print("\tplayers win "..math.floor((wins/stat)*100).."%")
    print("\taverage turn count to win: "..math.floor(turns/wins*10)/10)
  end
end
