-- FileName: GuildCopyRankView.lua
-- Author: yangna
-- Date: 2015-06-02
-- Purpose: 工会副本伤害排行榜 视图
--[[TODO List]]

module("GuildCopyRankView", package.seeall)

-- UI控件引用变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

-- 模块局部变量 --
local _layMain = nil
local _listView = nil

local _tbArgs = nil
local nTag = 123

local function init(...)

end

function destroy(...) 
	package.loaded["GuildCopyRankView"] = nil
end

function moduleName()
    return "GuildCopyRankView"
end


local m_color = { ccc3(0xc8,0x50,0x00),
				  ccc3(0x6c,0x6a,0x68),
				  ccc3(0x9f,0x4f,0x36),
				  ccc3(0x82,0x56,0x00)
				}

function updateCellByIndex( lsv,id )


	local cell = _listView:getItem(id)
	local tbData = _tbArgs.tbHitData[id+1]

	local i = id + 1

	local lay_rank_info = cell.item.LAY_RANK_INFO
	lay_rank_info.TFD_PLAYER_LV:setText(tbData.level )
	lay_rank_info.TFD_NAME:setText(tbData.uname)
    local color = UserModel.getPotentialColor({htid=tbData.figure})
    lay_rank_info.TFD_NAME:setColor(color)

	lay_rank_info.IMG_RANKNUM1:setVisible(false)
	lay_rank_info.IMG_RANKNUM2:setVisible(false)
	lay_rank_info.IMG_RANKNUM3:setVisible(false)
	lay_rank_info.LABN_RANK_AFTER4:setVisible(false)
	lay_rank_info.IMG_RANK:setVisible(false)

	cell.item.IMG_CELLBG:setVisible(false)
	cell.item.IMG_CELLBG1:setVisible(false)
	cell.item.IMG_CELLBG2:setVisible(false)
	cell.item.IMG_CELLBG3:setVisible(false)

	if (i < 4 ) then 
		cell.item["IMG_CELLBG" .. i]:setVisible(true)
		lay_rank_info["IMG_RANKNUM" .. i]:setVisible(true)
	else 
		cell.item.IMG_CELLBG:setVisible(true)
		lay_rank_info.LABN_RANK_AFTER4:setVisible(true)
		lay_rank_info.IMG_RANK:setVisible(true)
		lay_rank_info.LABN_RANK_AFTER4:setStringValue(tostring(i))
	end 
	
	lay_rank_info.BTN_FORMATION:addTouchEventListener(_tbArgs.onFormation)  --查看阵容
	lay_rank_info.BTN_FORMATION:setTag(tonumber(tbData.uid))

	lay_rank_info.tfd_atk_single:setText(m_i18n[5919])  --"单次攻击最高伤害"
	lay_rank_info.LABN_ATK_NUM:setStringValue(tbData.hp)
	lay_rank_info.TFD_CONTRIBUTION:setText(_tbArgs.ContriData[i] )  --个人贡献

	lay_rank_info.TFD_BELLY:setText(_tbArgs.BellyData[i]) -- 获得贝里

	-- 头像
	lay_rank_info.LAY_PHOTO:removeChildByTag(nTag,true)
    local headSp = HeroUtil.getHeroIconByHTID(tonumber(tbData.figure))
    headSp:setTag(nTag)
    local size = lay_rank_info.LAY_PHOTO:getSize()
    headSp:setPosition(ccp(size.width/2,size.height/2))
	lay_rank_info.LAY_PHOTO:addNode(headSp)


	local color = m_color[ i>4 and 4 or i]
	lay_rank_info.TFD_LEVEL:setColor(color)
	lay_rank_info.tfd_belly_txt:setColor(color)
	lay_rank_info.tfd_atk_single:setColor(color)
	lay_rank_info.tfd_con:setColor(color)

end


local function findUser( tbData )
	local index = 0
	for k,v in pairs(tbData) do 
		if (tonumber(v.uid) == tonumber(UserModel.getUserUid())) then 
			index = k
			break
		end 
	end 
	return index
end


function create(tbArgs)
	_tbArgs = tbArgs

	logger:debug(tbArgs.tbHitData)

	_layMain = g_fnLoadUI("ui/union_rank.json")

	_layMain.BTN_CLOSE:addTouchEventListener(tbArgs.onClose)
	
	_layMain.BTN_SURE:addTouchEventListener(tbArgs.onClose)
	UIHelper.titleShadow(_layMain.BTN_SURE,m_i18n[1992])

	_listView = _layMain.LSV_MAIN

	UIHelper.initListViewCell(_listView)

	UIHelper.reloadListView(_listView,#tbArgs.tbHitData,updateCellByIndex)

	local nRank = findUser(tbArgs.tbHitData)
	if ( tonumber(nRank) == 0) then 
		_layMain.TFD_NOW_RANK_NUM:setText("0")
		_layMain.TFD_NOW_ATK_NUM:setText("0")
		_layMain.TFD_NOW_CON_NUM:setText("0")
		_layMain.TFD_BELLY1:setText("0")
	else
		_layMain.TFD_NOW_RANK_NUM:setText("" .. nRank)
		_layMain.TFD_NOW_ATK_NUM:setText( tbArgs.tbHitData[tonumber(nRank)].hp)
		_layMain.TFD_NOW_CON_NUM:setText(tbArgs.ContriData[tonumber(nRank)])   --个人拥有贡献度)
		_layMain.TFD_BELLY1:setText(tbArgs.BellyData[tonumber(nRank)])
	end 

	return _layMain
end
