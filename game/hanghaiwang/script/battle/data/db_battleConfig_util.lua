

module("db_battleConfig_util",package.seeall)

require "db/DB_BattleConfig"

function getItem( )
		return DB_BattleConfig.getDataById(1)
end


function getArenaBackAndMusic()
	local item = getItem()
	return item.arena_background,item.arena_backmusic
end


function getTowerBackAndMusic()
	local item = getItem()
	return item.tower_background,item.tower_backmusic
end


function getTopShow1BackAndMusic()
	local item = getItem()
	return item.topshow1_background,item.topshow1_backmusic
end

function getTopShow2BackAndMusic()
	local item = getItem()
	return item.topshow2_background,item.topshow2_backmusic
end

function getMineBackAndMusic()
	local item = getItem()
	return item.mine_background,item.mine_backmusic
end
-- 获取海盗激斗
function getWABackAndMusic()
	local item = getItem()
	return item.wa_background,item.wa_backmusic
end

function getDefaultBackAndMusic()
	local item = getItem()
	return item.default_background,item.default_backmusic
end


--- 获取主船入场动作音效
function getShipEnterSceneSound( ... )
	local item = getItem()
	return item.shipEnterSound
end

--- 获取主船属性面板特效音效
function getShipInfoSound( ... )
	local item = getItem()
	return item.shipInfoSound
end

