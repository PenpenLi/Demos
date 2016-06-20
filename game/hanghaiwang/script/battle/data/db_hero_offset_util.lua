module("db_hero_offset_util",package.seeall)

require "db/DB_BattleHeroOffset"
local offsets  = nil--= {fight_elite_leili.png=}
-- local zero = {0,0}
function getItemByName( imgName ,cardType)
	if(offsets == nil) then
		ini()
	end
	if(cardType == nil) then
		cardType = 1
	end
	-- print("--- get offsets:",imgName,offsets[imgName])
	return offsets[imgName .. cardType] or {0,0}
end

function ini( ... )
	offsets = {}
	for k,item in pairs(DB_BattleHeroOffset.BattleHeroOffset) do
		-- print("--- ini offsets:",item[2],item[3],item[4])
		 if(item[2] ~= nil and item[5] ~= nil) then
		 	offsets[item[2] .. item[5]] = {item[3],item[4]}
		 end
	end
end

function release( ... )
	offsets = {}
	_G["db_hero_offset_util"] = nil
	package.loaded["db_hero_offset_util"] = nil
	-- DB_BattleHeroOffset.release()
end


function getHeroImgOffset( imgName ,cardType)
	-- if(cardType == nil) then
	local item = getItemByName(imgName,cardType)
	return item
end