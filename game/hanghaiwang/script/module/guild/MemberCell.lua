-- FileName: MemberCell.lua
-- Author: menghao
-- Date: 2014-09-19
-- Purpose: 成员列表cell


require "script/module/public/class"


-- 模块局部变量 --
local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName


MemberCell = class("MemberCell")


function MemberCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end


function MemberCell:init( tbData )
	if (self.cell) then
		self.mlaycell = self.cell:clone()
		self.mlaycell:setScale(g_fScaleX)
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end


function MemberCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
	end
end


-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function MemberCell:touchMask(point)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		if (rect:containsPoint(point)) then
			return self.tbBtnEvent[name]
		end
	end
end


function MemberCell:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end


-- 创建cell
function MemberCell:refresh(tbCell)
	logger:debug({MemberCell_refresh = tbCell})
	-- 自己还是别人
	local imgBGMe = m_fnGetWidget(self.mlaycell, "IMG_BG_ME")
	local imgBGOthers = m_fnGetWidget(self.mlaycell, "IMG_BG_OTHERS")
	if (UserModel.getUserUid() == tonumber(tbCell.uid)) then
		imgBGMe:setEnabled(true)
		imgBGOthers:setEnabled(false)
	else
		imgBGMe:setEnabled(false)
		imgBGOthers:setEnabled(true)
	end

	-- 头像
	local layPhoto = m_fnGetWidget(self.mlaycell, "LAY_PHOTO")
	local heroIcon = HeroUtil.createHeroIconBtnByHtid(tbCell.figure, nil)
	heroIcon:setPosition(ccp(layPhoto:getSize().width / 2, layPhoto:getSize().height / 2))
	layPhoto:addChild(heroIcon)

	self.tbMaskRect["LAY_PHOTO"] = layPhoto:boundingBox()
	self.tbBtnEvent["LAY_PHOTO"] = {sender = heroIcon, event = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/formation/FormationCtrl"
			FormationCtrl.loadFormationWithUid(tbCell.uid)
		end
	end}

	-- 名字等级职务
	local tfdName = m_fnGetWidget(self.mlaycell, "TFD_PLAYER_NAME")
	local tfdLv = m_fnGetWidget(self.mlaycell, "TFD_PLAYER_LV")
	tfdName:setText(tbCell.uname)
	local nameColor = UserModel.getPotentialColor({htid = tbCell.figure}) -- 2015-07-29
	tfdName:setColor(nameColor)
	tfdLv:setText(tbCell.level)

	local imgLeader = m_fnGetWidget(self.mlaycell, "IMG_LEADER")
	local imgLeaderVice = m_fnGetWidget(self.mlaycell, "IMG_LEADER_VICE")
	local imgMember = m_fnGetWidget(self.mlaycell, "IMG_MEMBER")
	if (tbCell.member_type == "0") then
		imgMember:setEnabled(true)
		imgLeader:setEnabled(false)
		imgLeaderVice:setEnabled(false)
	elseif (tbCell.member_type == "1") then
		imgMember:setEnabled(false)
		imgLeader:setEnabled(true)
		imgLeaderVice:setEnabled(false)
	else
		imgMember:setEnabled(false)
		imgLeader:setEnabled(false)
		imgLeaderVice:setEnabled(true)
	end

	-- 竞技 贡献
	local layContributeBg = m_fnGetWidget(self.mlaycell, "LAY_CONTRIBUTE_REMAIN")
	local tfdPVP = m_fnGetWidget(self.mlaycell, "tfd_pvp")
	local tfdTotalContri = m_fnGetWidget(self.mlaycell, "tfd_total_contribution")
	local tfdLeftContri = m_fnGetWidget(self.mlaycell, "TFD_REMAIN_CONTRIBUTION")
	local labPVP = m_fnGetWidget(self.mlaycell, "TFD_PVP_RANK")

	local labDash = m_fnGetWidget(self.mlaycell, "TFD_DASH")
	labDash:setText("--")
	
	local labTotalContri = m_fnGetWidget(self.mlaycell, "TFD_TOTAL_NUM")
	local labLeftContri = m_fnGetWidget(self.mlaycell, "TFD_REMAIN_NUM")
	tfdPVP:setText(m_i18n[3516])
	tfdTotalContri:setText(m_i18n[3601])
	tfdLeftContri:setText(m_i18n[3604])
	if (tbCell.position) then
		labPVP:setEnabled(true)
		labDash:setEnabled(false)
		labPVP:setText(tbCell.position)
	else
		labPVP:setEnabled(false)
		labDash:setEnabled(true)
	end
	labTotalContri:setText(tbCell.contri_total)
	labLeftContri:setText(tbCell.contri_point)

	local i18n_zhanli = m_fnGetWidget(self.mlaycell, "TFD_ZHAN")
	i18n_zhanli:setText(m_i18n[3589])

	if (UserModel.getUserUid() == tonumber(tbCell.uid)) then
		layContributeBg:setEnabled(true)
		tfdLeftContri:setEnabled(true)
		labLeftContri:setEnabled(true)

		local color = ccc3(0x2c, 0x71, 0x7f)
		i18n_zhanli:setColor(color)
		tfdPVP:setColor(color)
		tfdTotalContri:setColor(color)
		tfdLeftContri:setColor(color)
	else
		local color = ccc3(0x82,0x57,0x00)
		i18n_zhanli:setColor(color)
		tfdPVP:setColor(color)
		tfdTotalContri:setColor(color)
		tfdLeftContri:setColor(color)
		
		layContributeBg:setEnabled(false)
		tfdLeftContri:setEnabled(false)
		labLeftContri:setEnabled(false)
	end

	-- 战力 在不在线
	local labFight = m_fnGetWidget(self.mlaycell, "TFD_ZHAN_NUM")
	local tfdOnline = m_fnGetWidget(self.mlaycell, "TFD_ONLINE")
	local imgOnline = m_fnGetWidget(self.mlaycell, "IMG_ONLINE")
	labFight:setText(tbCell.fight_force)
	if (tbCell.status == "1") then
		imgOnline:setEnabled(true)
		tfdOnline:setText("")
	else
		imgOnline:setEnabled(false)
		tfdOnline:setText(m_i18n[2909] .. TimeUtil.getTimeStringWithUnit(TimeUtil.getSvrTimeByOffset() - tonumber(tbCell.last_logoff_time)))
	end

	-- 贡献
	local layNo = m_fnGetWidget(self.mlaycell, "LAY_NO")
	local layNo7 = m_fnGetWidget(self.mlaycell, "LAY_NO7")
	local layBelly = m_fnGetWidget(self.mlaycell, "LAY_BELLY")
	local layGold = m_fnGetWidget(self.mlaycell, "LAY_GOLD")

	local l_time = tbCell.contri_time or 0
	l_time = tonumber(l_time)

	-- 今天00:00:00 的时间戳
	local t_time = TimeUtil.getSvrIntervalByTime(000000)
	if(l_time>=t_time )then
		if(tonumber(tbCell.contri_type) == 1)then
			layNo:setEnabled(false)
			layNo7:setEnabled(false)
			layBelly:setEnabled(true)
			layGold:setEnabled(false)

			local tfdBellyContri = m_fnGetWidget(layBelly, "TFD_BELLY_CONTRIBUTION")
		else
			layNo:setEnabled(false)
			layNo7:setEnabled(false)
			layBelly:setEnabled(false)
			layGold:setEnabled(true)

			local tfdToday = m_fnGetWidget(layGold, "tfd_jinri")
			local labGold = m_fnGetWidget(layGold, "TFD_CONTRIBUTE_MONEY")
			local tfdGoldContri = m_fnGetWidget(layGold, "tfd_gold_contribute")

			tfdToday:setText(m_i18n[3678])
			tfdGoldContri:setText(m_i18n[3679])

			if(tonumber(tbCell.contri_type) == 2)then
				labGold:setText(20)
			elseif(tonumber(tbCell.contri_type) == 3)then
				labGold:setText(200)
			elseif(tonumber(tbCell.contri_type) == 4)then
				labGold:setText(300)
			else
				logger:debug("this contri_type is no add !!!")
				--今天没在本工会建设过，但是在其他工会建设了 2016.1.14  yn
				layBelly:setEnabled(false)
				layGold:setEnabled(false)
				local tfdContriNoNum = m_fnGetWidget(layNo, "TFD_CONTRIBUTE_NO")
				local tfdContriNo = m_fnGetWidget(layNo, "tfd_no_contribution")
				layNo:setEnabled(true)
				layNo7:setEnabled(false)
				tfdContriNoNum:setText(1)
				tfdContriNo:setText(gi18nString(3606, ""))
			end
		end
	else
		layBelly:setEnabled(false)
		layGold:setEnabled(false)

		local c_days = 0
		c_days = math.ceil( ( t_time- l_time)/(60*60*24) )
		if (c_days > 7) then
			local tfdContriNoNum = m_fnGetWidget(layNo7, "TFD_CONTRIBUTE_NO")
			local tfdContriNo = m_fnGetWidget(layNo7, "tfd_no_contribution")
			layNo7:setEnabled(true)
			layNo:setEnabled(false)
			tfdContriNoNum:setText(7)
			tfdContriNo:setText(gi18nString(3681, ""))
		else
			local tfdContriNoNum = m_fnGetWidget(layNo, "TFD_CONTRIBUTE_NO")
			local tfdContriNo = m_fnGetWidget(layNo, "tfd_no_contribution")
			layNo:setEnabled(true)
			layNo7:setEnabled(false)
			tfdContriNoNum:setText(c_days)
			tfdContriNo:setText(gi18nString(3606, ""))
		end
	end


	local btnJunwu = m_fnGetWidget(self.mlaycell, "BTN_JUNWU")
	UIHelper.titleShadow(btnJunwu, m_i18n[3610])
	btnJunwu:setTag(tbCell.uid)
	self:addMaskButton(btnJunwu, "BTN_JUNWU", function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/guild/GuildAffairsCtrl"
			GuildAffairsCtrl.create(sender:getTag())
		end
	end)
end

