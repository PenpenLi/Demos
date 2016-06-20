

module("db_buff_util",package.seeall)

require "db/DB_Buffer"

function getItemByid( id )
	----print("db_buff_util.getItemByid:",tonumber(id))
	-- --print("db_buff_util.getItemByid raw:",id)
	return DB_Buffer.getDataById(tonumber(id))
end
-- 获取伤害特效 
function getDamageEffectName( id )
 	local item  = getItemByid(id)
 	if(item ~= nil and item.damageEff ~= nil ) then
 		if(item.damageEff == "") then return nil end
 		return item.damageEff
 	end
end -- function 

-- 移除时间
function getRemoveTime( id )
 	local item  = getItemByid(id)
 	if(item ~= nil and item.removeTimeType ~= nil ) then
 		if(item.removeTimeType == "") then return nil end
 		return tonumber(item.removeTimeType)
 	end
end -- function 




-- 添加时间
function getAddTime( id )
	if(id == nil) then error("db_buff_util:getAddTime id is nil") end
	-- --print("db_buff_util.getAddTime:",tonumber(id))
 	local item  = getItemByid(id)
 	if(item ~= nil and item.addTimeType ~= nil ) then
 		if(item.addTimeType == "") then return nil end
 		return tonumber(item.addTimeType)
 	end
end -- function 



-- 伤害时间
function getDamageTime( id )

 	if(id == nil) then error("db_buff_util:getDamageTime id is nil") end
	-- --print("db_buff_util.getDamageTime:",tonumber(id))
	 	local item  = getItemByid(id)
 	if(item ~= nil and item.damageTimeType ~= nil ) then
 		if(item.damageTimeType == "") then return nil end
 		return tonumber(item.damageTimeType)
 	end
end -- function 


function getRemoveEffectName(id)
	local item  = getItemByid(id)
	if(item ~= nil ) then
		local disappearEff = item.disappearEff
		if(disappearEff ==  nil) then disappearEff = nil end
		return disappearEff
	end
end

function getAddEffectName( id )
	local item  = getItemByid(id)
	if(item ~= nil ) then
		local addEffName = item.addEff
		if(addEffName == "" or addEffName == "nil") then addEffName = nil end
		return addEffName
	end
end
-- 获取buff图标
function getIcon( id )
	local item  = getItemByid(id)
 	if(item ~= nil ) then
 		local iconName = item.icon
 		if(iconName == "") then iconName = nil end
 		return iconName
 	end
end
-- 获取伤害挂点
function getDamagePostion( id )
	local item  = getItemByid(id)
 	if(item ~= nil ) then
 		return tonumber(item.damagePostion)
 	end
end
-- 获取添加挂点 默认值:脚底
function getAddPostion( id )
	local item  = getItemByid(id)
 	if(item ~= nil and item.positon ~= nil) then
 		return tonumber(item.positon)
 	end
 	return BATTLE_CONST.POS_FEET
end

-- 获取添加声音
function getAddSound( id )
	local item  = getItemByid(id)
 	if(item ~= nil) then
 		return item.addSound
 	end
 	return nil
end

-- buff添加时提示文字图片名称
function getAddTip( id )
	local item  = getItemByid(id)
 	if(item ~= nil) then
 		return item.addTip
 	end
 	return nil
end

-- 获取buff伤害时的额外文字
function getDamageTip( ... )
	local item  = getItemByid(id)
 	if(item ~= nil ) then
 		local iconName = item.damageTip
 		if(iconName == "") then iconName = nil end
 		return iconName
 	end
end

-- -- 获取添加时间
-- function getAddTime( )
-- 	local item  = getItemByid(id)
--  	if(item ~= nil ) then
--  		return tonumber(item.addTimeType)
--  	end
-- end
--获取移除时间 -- 直接删除
-- function getRemoveTime()

-- end
 
-- 获取伤害文字图片
function getDamageTitle(id)
	local item  = getItemByid(id)
 	if(item ~= nil ) then
 		local iconName = item.damagetitle
 		if(iconName == "") then iconName = nil end
 		return iconName
 	end
end

