-- FileName: GCDistriPeopleView.lua
-- Author: zhangjunwu
-- Date: 2015-06-05
-- Purpose: 工会副本战利品分配成员 View

module("GCDistriPeopleView", package.seeall)

-- UI控件引用变量 --
local m_i18n 		= gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

-- 模块局部变量 --
local _layMain 		= nil
local _listView 	= nil
local _tbEventArgs  = nil 
local function init(...)

end

function destroy(...)
	package.loaded["GCDistriPeopleView"] = nil
end

function moduleName()
    return "GCDistriPeopleView"
end


function refreashListView( tbArgs )
	_listView:removeAllItems()

	local queue = tbArgs.queue  --物品的队列
	local queueCount = table.count(queue)
	logger:debug(queue)

	for i,v in ipairs(queue) do
		_listView:pushBackDefaultItem()
		local cell = _listView:getItem(i - 1)
		--玩家信息
		logger:debug(queue[i])
		cell.TFD_ITEM_NAME:setText(queue[i].uname)
		local name_color =  UserModel.getPotentialColor({htid = queue[i].figure,bright = true}) 
		cell.TFD_ITEM_NAME:setColor(name_color)

		--头像
		local iconBg = cell.LAY_PHOTO
		local heroIcon = HeroUtil.createHeroIconBtnByHtid(queue[i].figure, nil)
		heroIcon:setPosition(ccp(iconBg:getSize().width / 2, iconBg:getSize().height / 2))
		iconBg:addChild(heroIcon)

		cell.BTN_FENPEI:setTag(i)
		cell.BTN_FENPEI:addTouchEventListener(_tbEventArgs.onDistribution) 
		UIHelper.titleShadow(cell.BTN_FENPEI,m_i18n[5922])

		cell.TFD_ATTACK:setText(queue[i].HiDamage) 

		cell.tfd_gongxian:setText(m_i18n[5919])  

		local nPercent = queue[i].HiDamage / queue[i].copyHp * 100
		cell.LOAD_PROGRESS:setPercent((nPercent > 100) and 100 or nPercent)
	end
	
end


function create(tbEvent , tbArgs)
	logger:debug(tbArgs)
	_tbEventArgs = tbEvent
	_layMain = g_fnLoadUI("ui/union_fenpei_people.json")

	_layMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_listView = _layMain.LSV_MAIN

	UIHelper.initListView(_listView)

	refreashListView(tbArgs)

	return _layMain
end
