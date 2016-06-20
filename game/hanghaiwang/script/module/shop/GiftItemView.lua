-- FileName: GiftItemView.lua
-- Author:zhangjunwu
-- Date: 2014-04-00
-- Purpose: 礼包预览
--[[TODO List]]

module("GiftItemView", package.seeall)
require "script/module/shop/ShopGiftData"
require "script/module/public/PublicInfoCtrl"
-- UI控件引用变量 --
-- 模块局部变量 --
local m_fnGetWidget     			= g_fnGetWidgetByName
local m_i18nString 					=  gi18nString

local m_LSV_View 					= nil              --礼包List的panel

local  m_giftsItemInfo 				= nil
local m_jsonforGiftItem 			= "ui/shop_vipgift_review.json"
local m_vipLevel 					= nil
-- 模块局部变量 --
local m_tbEvent = {}
local function init(...)

end

function destroy(...)
	package.loaded["GiftItemView"] = nil
end

function moduleName()
	return "GiftItemView"
end

function loadCell( cell,cell_info,tag)
	logger:debug(cell_info)

	local TFD_LAY_NAME	 	= m_fnGetWidget(cell,"TFD_NAME") 						-- name
	local TFD_DES 			= m_fnGetWidget(cell ,"TFD_ITEM_DESC")		--描述
	local TFD_NUM 			= m_fnGetWidget(cell ,"tfd_item_num_txt")		--数量文本
	local TFD_NUM_VALUE 	= m_fnGetWidget(cell ,"TFD_ITEM_NUM")		--数量值
	local LAY_BTNBG 		= m_fnGetWidget(cell,"IMG_ITEM_ICON_BG")     --item bg
	local IMG_SEAL 			= m_fnGetWidget(cell,"TFD_ITEM_TYPE")

	local Image_Num			= m_fnGetWidget(cell,"tfd_item_num_txt")
	UIHelper.labelAddStroke(Image_Num,m_i18nString(1332))   --数量
	TFD_NUM:setText(m_i18nString(1332))

	TFD_NUM_VALUE:setText(cell_info.num)


	--UIHelper.labelAddStroke(TFD_NUM_VALUE,cell_info.num)   --数量
	-- TFD_NUM_VALUE:setStringValue(tonumber(cell_info.num))

	local iconSprite = nil
	local itemName = ""
	local itemDes = ""
	local color = nil
	if(cell_info.type == "item") then

		local itemTableInfo = ItemUtil.getItemById(tonumber(cell_info.tid))
		color  = g_QulityColor[itemTableInfo.quality]


		itemName = itemTableInfo.name
		itemDes = itemTableInfo.desc

		iconSprite  = ItemUtil.createBtnByTemplateId(cell_info.tid,function (snder,eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(cell_info.tid,cell_info.num)
			end
		end)					--icon

	elseif(cell_info.type == "gold")  then
		iconSprite = ItemUtil.getGoldIconByNum()
		itemName = m_i18nString(2220)
		itemDes = m_i18nString(1463) --"刻有“招财进宝”的金币，可用于招募武将和在商店中购买道具！成就霸业，你，值得拥有！"
		color  = g_QulityColor[4]
	elseif(cell_info.type == "silver") then
		--iconSprite = ItemUtil.getSiliverIconByNum()

		iconSprite = ImageView:create()
		iconSprite:loadTexture("images/base/potential/props_4.png")
		local img = ImageView:create()
		img:loadTexture("images/base/props/beili_da.png")
		iconSprite:addChild(img)

		itemName = m_i18nString(1520)
		itemDes = m_i18nString(1462) --"汉朝通用的银质钱币，可用于强化武将、强化装备。"
		color  = g_QulityColor[4]
	elseif(cell_info.type == "soul") then
		iconSprite = ItemUtil.getSoulIconByNum()
		color  = g_QulityColor[4]
		itemName = m_i18nString(1087) --"将魂"
		itemDes = m_i18nString(1464) --"宿主有武将之魂，将魂用于强化武将，提升武将的能力。"
	end
	--物品名字,描述
	UIHelper.labelEffect(TFD_LAY_NAME,itemName)
	TFD_DES:setText(itemDes)
	TFD_LAY_NAME:setColor(color)
	LAY_BTNBG:addChild(iconSprite)


	if(cell_info.tid) then
		local tbItem = ItemUtil.getItemById(cell_info.tid)
		-- local sealFile = ItemUtil.getSealFileByItem(tbItem)
		local sealStr = ItemUtil.getSealStringByItem(tbItem)
		IMG_SEAL:setText(sealStr)
		IMG_SEAL:setColor(color)
	end
end

function refreshListView( ... )
	m_LSV_View:removeAllItems() -- 初始化清空列表
	local cell, nIdx
	for i,itemInfo in ipairs(m_giftsItemInfo or {}) do
		m_LSV_View:pushBackDefaultItem()
		nIdx = i - 1
		cell = m_LSV_View:getItem(nIdx)  -- cell 索引从 0 开始
		loadCell(cell,itemInfo,i)
	end
end
--[[desc:
    arg1:点击时间table ：arg2: 礼包奖励物品数据 ,arg4:vip等级
    return: 是否有返回值，返回值说明  
—]]
function create(tbBtnEvent,tbGiftItemData,vipLevel)
	logger:debug("hi")
	m_tbEvent = tbBtnEvent
	m_vipLevel = vipLevel
	m_giftsItemInfo = tbGiftItemData
	logger:debug(m_giftsItemInfo)

	m_giftsMainLay= g_fnLoadUI(m_jsonforGiftItem)
	m_giftsMainLay:setSize(g_winSize)

	-- local i18nTitle = m_fnGetWidget(m_giftsMainLay,"tfd_title") --礼包预览
	-- --i18nTitle:setText(m_i18nString(1437))
	-- UIHelper.labelEffect(i18nTitle,m_i18nString(1437))

	local TFD_VIPLEVEL = m_fnGetWidget(m_giftsMainLay,"LABN_VIP")
	TFD_VIPLEVEL:setStringValue(tbGiftItemData.level)

	local i18nDes = m_fnGetWidget(m_giftsMainLay,"tfd_vipgift_illustration") --包含以下物品
	--i18nDes:setText(m_i18nString(1418))
	UIHelper.labelEffect(i18nDes,m_i18nString(1418))

	local LAY_VIPLEVEL = m_fnGetWidget(m_giftsMainLay,"LABN_VIP") 	-- vip等级
	LAY_VIPLEVEL:setStringValue(m_vipLevel)

	local btnClose = m_fnGetWidget(m_giftsMainLay,"BTN_CLOSE") --关闭按钮
	btnClose:addTouchEventListener(tbBtnEvent.onClose)

	m_LSV_View = m_fnGetWidget(m_giftsMainLay,"LSV_VIPGIFT_REVIEW") --listview

	require "script/module/public/UIHelper"

	UIHelper.initListView(m_LSV_View)

	refreshListView()

	return m_giftsMainLay
end
