

module("BattleShipDisplayModule", package.seeall)


local ship1,ship2
local idToShipDisplay = {}

function resetPosition( ... )
   if(ship1) then
      ship1:setPositionX(g_winSize.width/2)
      ship1:setPositionY(0)
      ship1:setVisible(false)

   end

    if(ship2) then
       ship2:setPositionX(g_winSize.width/2)
       ship2:setPositionY(g_winSize.height)
       ship2:setVisible(false)
   end

end
function iniShipDisplay( ... )
	local ship1Data = BattleMainData.fightRecord.team1Info.shipData
    if(ship1Data) then
        if(ship1 == nil) then

            ship1  = require(BATTLE_CLASS_NAME.BattleShipDisplay).new()
            BattleLayerManager.shipLayer:addChild(ship1)
            -- local filp = teamid == BATTLE_CONST.TEAM2
           ship1:reset(BattleURLManager.getShipBody(ship1Data.shipBodyImage),"cannon1",false,BATTLE_CONST.TEAM1)
           
           local shipHeight = ship1:getBodyHeight()
           ship1:setPositionX(g_winSize.width/2)
           ship1:setPositionY(0)

           ship1:setVisible(false)
           ship1.shipid = ship1Data.shipid
            -- 入场会控制位置信息
           idToShipDisplay[ship1.shipid] = ship1
        end

    end

    local ship2Data = BattleMainData.fightRecord.team2Info.shipData
    if(ship2Data) then
        if(ship2 == nil) then
            ship2  = require(BATTLE_CLASS_NAME.BattleShipDisplay).new()
            BattleLayerManager.shipLayer:addChild(ship2)
            -- local filp = teamid == BATTLE_CONST.TEAM2
           ship2:reset(BattleURLManager.getShipBody(ship2Data.shipBodyImage),"cannon1",true,BATTLE_CONST.TEAM2)
           ship2:setVisible(false)
            -- 入场会控制位置信息
           ship2.shipid = ship2Data.shipid

           local shipHeight = ship2:getBodyHeight()
           ship2:setPositionX(g_winSize.width/2)
           ship2:setPositionY(g_winSize.height)

           idToShipDisplay[ship2.shipid] = ship2
        end

    end
end

function release( ... )
    idToShipDisplay = {}
    ObjectTool.removeObject(ship1)
    ObjectTool.removeObject(ship2)
    ship1 = nil
    ship2 = nil
end

function isShip( id )
    return idToShipDisplay[id] ~= nil
end

function getShipByID( id )
    return idToShipDisplay[id]
end

function getTeam1Ship( ... )
    return ship1
end

function getTeam2Ship( ... )
    return ship2
end

function setShip1( ui )
    ship1 = ui
end