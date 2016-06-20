-- Filename: TreasureUtil.lua
-- Author: lichenyang
-- Date: 2013-11-5
-- Purpose: 宝物数据处理层

module("TreasureUtil", package.seeall)

require "script/model/utils/HeroUtil"


--[[
	@des:		得到碎片卡牌图片
	@param:		fragment_tid  碎片模板id
	@return:	图标sprite
]]
function getFragmentCardSprite( fragment_tid )
	require "db/DB_Item_treasure_fragment"
	local tableInfo = DB_Item_treasure_fragment.getDataById(fragment_tid)
	local bgSprite = CCSprite:create("images/item/equipinfo/card/equip_" .. tableInfo.quality .. ".png")
	return bgSprite
end

--[[
	@des:		得到碎片图片
	@param:		fragment_tid  碎片模板id
	@return:	图标sprite
]]
function getFragmentIcon( fragment_tid )
	local tableInfo = DB_Item_treasure_fragment.getDataById(fragment_tid)

	bgFile = "images/base/potential/props_" .. tableInfo.quality .. ".png"
	iconFile = "images/base/props/" .. tableInfo.icon_small
	local item_sprite = CCSprite:create(bgFile)
	local icon_sprite = CCSprite:create(iconFile)
	icon_sprite:setAnchorPoint(ccp(0.5, 0.5))
	icon_sprite:setPosition(ccp(item_sprite:getContentSize().width/2, item_sprite:getContentSize().height/2))
	item_sprite:addChild(icon_sprite)

	return item_sprite
end

--[[
	@des:	创建一个碎片按钮
]]
function createFragmentItem( ... )

end

--[[
	@des:		通过概率获得夺宝的成功的描述
	@param:		percent   
	@return:    "较低概率" ...
	@author:	zhz
]]
function getFragmentPercentDesc(tPerct )
	require "db/DB_Loot"
	tPerct = tonumber(tPerct)
	local lootInfo = DB_Loot.getDataById(1)
	local percents = lua_string_split(lootInfo.ratioArr,",")
	local descArr = lua_string_split(lootInfo.ratioDec, ",")
	for i=1, #percents do
		if(tPerct <= tonumber(percents[i])) then
			return descArr[i]
		end
	end
	return ""
end

--[[
	@des:		通过 isnpc 和 squad 获得 要抢夺的头像
	@param:		isnpc ,    item_temple_id
	@return:    对应的头像
]]
function getRobberHeadIcon( npc, squad )
	require "db/DB_Monsters_tmpl"
	require "db/DB_Monsters"
	logger:debug(squad)
	npc = tonumber(npc)
	local headSprite
	if(npc == 0 ) then
		local dressId = nil
		if(squad.dress and not table.isEmpty(squad.dress)) then
			dressId = tonumber(squad.dress["1"] )
		end
		print(" squad.htid is ", squad.htid , " dressId  is : ", dressId)
		headSprite = HeroUtil.createHeroIconBtnByHtid(tonumber(squad.htid), dressId or 0)
	elseif(npc == 1) then
		headSprite =  getRobNpcIconByhid(squad)
	end

	return headSprite
end


-- 根据npc的hid得到对应的头像icon
function getRobNpcIconByhid( htid )
	-- 根据hid查找DB_Monsters表得到对应的htid
	require "db/DB_Monsters"
	-- local htid = DB_Monsters.getDataById(hid).htid
	-- 根据htid查找DB_Monsters_tmpl表得到icon
	require "db/DB_Monsters_tmpl"
	local heroData = DB_Monsters_tmpl.getDataById(htid)
	local icon ="images/base/hero/head_icon/" .. heroData.head_icon_id

	--local quality_bg ="images/hero/quality/"..heroData.star_lv .. ".png" --三国的
	local quality_bg =  "images/base/potential/officer_" .. heroData.star_lv .. ".png" --我们的


	local btnIcon  = Button:create()
	btnIcon:loadTextures(quality_bg, quality_bg, nil) -- 用品质边框初始化按钮

	local imgIcon = ImageView:create()
	imgIcon:loadTexture(icon)

	btnIcon:addChild(imgIcon)
	return btnIcon
end


--[[
	@des:		根据star_lv 来排序阵容
	@param:		squad
	@return :
--]]
function sortQuad( squad, npc)
	require "db/DB_Monsters_tmpl"
	require "db/DB_Heroes"
	npc= tonumber(npc)
	local sortQuad= {}
	if(1==npc) then
		local function keySort ( w1 , w2 )
			local  dataW1 = DB_Monsters_tmpl.getDataById(w1)
			local dataW2 = DB_Monsters_tmpl.getDataById(w2)
			-- return tonumber(dataW1.star_lv) > tonumber(dataW2.star_lv)
			if(tonumber(dataW1.star_lv) > tonumber(dataW2.star_lv)) then
				return true
			elseif(tonumber(dataW1.star_lv) == tonumber(dataW2.star_lv) and tonumber(dataW1.id) > tonumber( dataW2.id)) then
				return true
			else
				return false
			end
		end
		table.sort( squad, keySort )
	else
		local function keySort ( w1 , w2 )
			local  dataW1 = DB_Heroes.getDataById(w1.htid)
			local dataW2 = DB_Heroes.getDataById(w2.htid)
			-- return tonumber(dataW1.star_lv) > tonumber(dataW2.star_lv)
			if(tonumber(dataW1.star_lv) > tonumber(dataW2.star_lv)) then
				return true
			elseif(tonumber(dataW1.star_lv) == tonumber(dataW2.star_lv) and tonumber(dataW1.id) > tonumber( dataW2.id)) then
				return true
			else
				return false
			end
		end
		table.sort( squad, keySort)

	end
	return squad
end

--[[
	@des:		得到宝物大图标
]]
function getTreasureBigIcon( treasure_id )
	local treasureInfo 	= DB_Item_treasure.getDataById(treasure_id)
	local sprite 		= CCSprite:create("images/base/treas/big/" .. treasureInfo.icon_big)
	return sprite
end


--[[
	@des:		得到品质颜色
]]
function getTreasureColor( treasure_id )
	--yangna  2015.1.24  HeroPublicLua和HeroPublicUtil 相同的方法 getCCColorByStarLevel
	require "script/module/partner/HeroPublicUtil"
	local treasureInfo 	= DB_Item_treasure.getDataById(treasure_id)
	local nameColor = HeroPublicUtil.getCCColorByStarLevel(treasureInfo.quality)
	return nameColor
end

--
--返回不同概率的抢夺所用的图片
function getPercentImageByName(desc  )
	require "db/DB_Loot"
	local lootInfo = DB_Loot.getDataById(1)
	local percents = lua_string_split(lootInfo.ratioArr,",")
	local descArr = lua_string_split(lootInfo.ratioDec, ",")
	logger:debug(descArr)
	logger:debug(desc)
	for i=1,table.count(descArr) do
		if(desc == descArr[i]) then
			return "images/others/probability_" .. i .. ".png"
		end
	end
	-- if(desc== descArr[1] or desc ==descArr[2] or  desc ==descArr[3] ) then
	-- 	return ccc3(0x01,0xf4,0x5a)
	-- 	return "ui/probability_" .. i .. ".png"
	-- elseif(desc == descArr[4]or desc== descArr[5] ) then
	-- 	return 	ccc3(0x1f, 0xe8 ,0xf9)
	-- 		--{0x51, 0xfb, 0xff},
	-- elseif(  desc== descArr[6] or desc== descArr[7]) then
	-- 	return ccc3(255, 0, 0xe1)
	-- else
	-- 	return ccc3(0xfb,0x48,0xff)
	-- end
end
--
--返回不同概率的抢夺所用的图片
function getPercentColorByName(desc  )
	require "db/DB_Loot"
	local lootInfo = DB_Loot.getDataById(1)
	local percents = lua_string_split(lootInfo.ratioArr,",")
	local descArr = lua_string_split(lootInfo.ratioDec, ",")
	if(desc== descArr[1] or desc ==descArr[2] or  desc ==descArr[3] ) then
		return ccc3(0x01,0xf4,0x5a)
	elseif(desc == descArr[4]or desc== descArr[5] ) then
		return 	ccc3(0x1f, 0xe8 ,0xf9)
	elseif(  desc== descArr[6] or desc== descArr[7]) then
		return ccc3(255, 0, 0xe1)
	else
		return ccc3(0xfb,0x48,0xff)
	end
end
--返回船只的图片，正常图片和按下图片
function getShipImageByName(robInfo)
	-- logger:debug(des)


	-- 处理npc 的状态
	-- if(tonumber(robInfo.npc) == 1) then
	-- 	return "images/others/grab_ship_1_h.png","images/others/grab_ship_1_n.png"
	-- else
	-- 	return "images/others/grab_ship_4_h.png","images/others/grab_ship_4_n.png"
	-- end

	-- 根据 服务器返回的 ship_figure字段决定船形象  by yangna 2015.1.21
	if robInfo.ship_figure then
		local ship_figure = tonumber(robInfo.ship_figure)
		if ship_figure == 0 then
			ship_figure = 1
		end

		return "images/others/ship" .. ship_figure .. "_h.png","images/others/ship" .. ship_figure .. "_n.png"
	else
		require "db/DB_Loot"
		local lootInfo = DB_Loot.getDataById(1)
		local desc = robInfo.ratioDesc
		local descArr = lua_string_split(lootInfo.ratioDec, ",")
		if(desc== descArr[1]) then
			return "images/others/grab_ship_1_h.png","images/others/grab_ship_1_n.png"
		elseif(desc == descArr[2]or desc== descArr[3] ) then
			return "images/others/grab_ship_2_h.png","images/others/grab_ship_2_n.png"
		elseif(  desc== descArr[4] or desc== descArr[5]) then
			return "images/others/grab_ship_3_h.png","images/others/grab_ship_3_n.png"
		else
			return "images/others/grab_ship_4_h.png","images/others/grab_ship_4_n.png"
		end
	end
end

-- 绿色：#01f45a
-- 蓝色：#1fe8f9
-- 紫色：#fb48ff


