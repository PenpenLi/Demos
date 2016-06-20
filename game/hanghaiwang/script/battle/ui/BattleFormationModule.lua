-- 战斗队伍显示
    
module("BattleFormationModule", package.seeall)

local displayList = {}
local team1List = {}
local team2List = {}



-- 按table创建显示,添加到图层 并更新idToDisplay
function createTeamDisplay( data , list , overridePostion,des)
	--local postionMarks = {}
	--removeUnIntersectionFromDisplayList(data,list)
	des 			= des or ""
	overridePostion = overridePostion or true

	local count = 0
	-- 遍历team数据
	for i,v in pairs(data) do
		local display
		local index = tonumber(v.positionIndex)
		-- 没有就生成
		if (list[index] == nil) then
	        display 							= require("script/battle/ui/BattlPlayerDisplay").new()
	    else
	    	if(overridePostion) then 
       			display 							= list[index]
       			-- display:setVisible(true)
       			display:toRawZOder()
       		else
       			error("BattleTeamDisplayModule.createTeamDisplay the position:",v.positionIndex,"has hero!!",des)
       		end
		end
		--if idToDisplay == nil then --print("idToDisplay is nil ") end
		-- if v == nil then --print("data is nil") 
		-- 	else 
		-- 		--print("v.id is:",v.id) 
		-- 	end
		-- idToDisplay[v.id] 						= v
		-- --print("createTeamDisplay: display.isGhostState->",display.isGhostState)
		if(display.isGhostState ~= true) then
			display:reset(v)
		end
		-- --print("createTeamDisplay: display.getParent->",display:getParent())
		
		if(display:getParent() == nil) then
			display:setParent(BattleLayerManager.battlePlayerLayer)
		end
		list[v.positionIndex] 		= display
		count = count + 1
    end -- for end

    --print("   count:",count)
end

-- 根据全局位置索引获取
function indexByPostion( gposition )	
	
end

function indexByTeam1Position( position )
	
end


function indexByTeam2Position( position )
	
end

-- 替换指定位置显示对象
function replaceNewBydata( data , teamid )

end




function indexByID( id )
	
end