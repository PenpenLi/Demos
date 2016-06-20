-- FileName: GCSharedRecordView.lua
-- Author: yangna
-- Date: 2015-06-02
-- Purpose: 奖励分配记录 
--[[TODO List]]

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

_listView = nil
_tbRecordData = nil
local _nTag = 103

GCSharedRecordView = class("GCSharedRecordView")

function GCSharedRecordView:ctor( ... )
	self.layMain = g_fnLoadUI("ui/union_copy_record.json")
end

function GCSharedRecordView:updateCellByIndex(id)
	local tbData = _tbRecordData[id+1]
	local cell = _listView:getItem(id)
	local TFD_GOODS_NAME = m_fnGetWidget(cell,"TFD_GOODS_NAME")

	local tbReward = tbData.va_recorder.reward
	local data = {{type=tbReward[1],id=tbReward[2],num=tbReward[3]}}
	local tbReward = RewardUtil.parseRewardsByTb(RewardUtil.getItemsDataByTb(data))
	tbReward = tbReward[1]

	cell.item.LAY_ITEM:removeChildByTag(_nTag,true)
	cell.item.LAY_ITEM:addChild(tbReward.icon)
	tbReward.icon:setTag(_nTag)
	local size = cell.item.LAY_ITEM:getSize()
	tbReward.icon:setPosition(ccp(size.width/2,size.height/2))
	TFD_GOODS_NAME:setText(tbReward.name)
	TFD_GOODS_NAME:setColor(g_QulityColor[tbReward.quality])

	local playername = tbData.va_recorder.uname
	local time = os.date("%m|%d|%H|%M",tbData.reward_time)
	local tbTime = lua_string_split(time,"|")

	cell.item.TFD_TIME:setText(string.format(m_i18n[5916],tonumber(tbTime[1]),tonumber(tbTime[2]),tbTime[3],tbTime[4]))   --"于%d月%d日 %s:%s获得"
	cell.item.TFD_PLAYER_NAME:setText(playername)
	cell.item.TFD_PLAYER_NAME:setColor(UserModel.getPotentialColor({htid=tbData.va_recorder.figure}))

	local str={
		m_i18n[5917],   --"由会长手动分配"
		m_i18n[5918],   --"由系统自动分配"
	}
	cell.item.TFD_INFO2:setText(str[tonumber(tbData.record_type)])   --由系统分配

end

function GCSharedRecordView:init(tbRecordData )
	if (not tbRecordData) then 
		return 
	end 
	logger:debug(tbRecordData)
	_tbRecordData = tbRecordData
	UIHelper.reloadListView(_listView,table.count(_tbRecordData),self.updateCellByIndex)
end

function GCSharedRecordView:create( )
	local layMain = self.layMain
	local BTN_CLOSE = m_fnGetWidget(layMain,"BTN_CLOSE")
	BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_listView = m_fnGetWidget(layMain,"LSV_TOTAL")
	UIHelper.initListViewCell(_listView)

	return layMain
end