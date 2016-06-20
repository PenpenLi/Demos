-- FileName: VerifyCell.lua
-- Author: zhangqi
-- Date: 2014-09-19
-- Purpose: 审核列表显示的cell封装
--[[TODO List]]

require "script/module/public/Cell/Cell"

-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName

VerifyCell = class("VerifyCell", Cell)

function VerifyCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function VerifyCell:init( tbData )
	if (self.cell) then
		self.mCell = self.cell:clone()
		self.mCell:setScale(g_fScaleX)
		self.mCell:setPosition(ccp(0,0))
		self.mCell:setEnabled(true)
	end
end

-- 创建cell
function VerifyCell:refresh(tbCell)
	--[[ TFD_PLAYER_NAME, TFD_PLAYER_LV, tfd_pvp, LABN_PVP_RANK, LABN_ZHANDOULI, BTN_AGREE, BTN_REFUSE ]]
	local labName = m_fnGetWidget(self.mCell, "TFD_PLAYER_NAME")
	labName:setText(tbCell.name)
	labName:setColor(UserModel.getPotentialColor({htid = tbCell.htid})) -- zhangqi, 2015-08-17

	local labLv = m_fnGetWidget(self.mCell, "TFD_PLAYER_LV")
	labLv:setText(tbCell.level)

	local i18nPos = m_fnGetWidget(self.mCell, "tfd_pvp")
	i18nPos:setText(m_i18n[3516])
	local labRank = m_fnGetWidget(self.mCell, "TFD_PVP_RANK")
	local labDash = m_fnGetWidget(self.mCell, "TFD_DASH")
	labDash:setText("--")
	if (tbCell.arenaRank) then
		labRank:setEnabled(true)
		labDash:setEnabled(false)
		labRank:setText(tbCell.arenaRank)
	else
		labRank:setEnabled(false)
		labDash:setEnabled(true)
	end

	local labFight = m_fnGetWidget(self.mCell, "TFD_ZHANDOULI")
	labFight:setText(tbCell.fight)

	local btnAgree = m_fnGetWidget(self.mCell, "BTN_AGREE")
	btnAgree:setTag(tbCell.uid)
	UIHelper.titleShadow(btnAgree, m_i18n[2105])
	self:addMaskButton(btnAgree, "BTN_AGREE", tbCell.onAgree)

	local btnRefuse = m_fnGetWidget(self.mCell, "BTN_REFUSE")
	btnRefuse:setTag(tbCell.uid)
	UIHelper.titleShadow(btnRefuse, m_i18n[3517])
	self:addMaskButton(btnRefuse, "BTN_REFUSE", tbCell.onRefuse)

	self.layIcon = m_fnGetWidget(self.mCell, "LAY_PHOTO") -- 图标按钮容器
	self.layIcon:removeAllChildren() -- 先删除之前添加的icon button

	local szIcon = self.layIcon:getSize()
	local btnIcon = HeroUtil.createHeroIconBtnByHtid(tbCell.htid)

	self.tbMaskRect["LAY_PHOTO"] = self.layIcon:boundingBox()
	self.tbBtnEvent["LAY_PHOTO"] = {sender = btnIcon, event = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/chat/ChatCommunicationCtrl"
			AudioHelper.playInfoEffect()
			local layCommunication = ChatCommunicationCtrl.create({
				sender_uid = tbCell.uid, sender_uname = tbCell.name, sender_fight = tbCell.fight, sender_level = tbCell.level, figure = tbCell.htid})
			LayerManager.addLayout(layCommunication)
		end
	end}

	btnIcon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
	self.layIcon:addChild(btnIcon)
end
