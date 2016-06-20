-- FileName: MailCell.lua
-- Author:zhangjunwu
-- Date: 2014-06-02
-- Purpose: 邮件cell
--[[TODO List]]
-- 模块局部变量 --
require "script/module/public/class"
require "script/module/public/Cell/Cell"
require "script/module/public/ItemUtil"
require "script/module/public/PublicInfoCtrl"
require "script/module/mail/MailData"
require "script/module/public/BTRichText"
require "script/module/switch/SwitchModel"
-- UI控件引用变量 -
-- 模块局部变量 --
-- #825600
local normalColor  = {r=0x82;g=0x56;b=0x00}
local numlColor  = speColor
-- local speColor  = {r=0x4d;g=0xec;b=0x15}  --将原来黄色的字体改为深色品质的绿色色值0x4d,0xec,0x15
local speColor  = g_QulityColor[3]  --将原来黄色的字体改为深色品质的绿色色值0x4d,0xec,0x15
local m_fnGetWidget = g_fnGetWidgetByName
local m_requestNewMailNum = 6
local m_TagRichText = 10001

local m_i18nString = gi18nString


MailCell = class("MailCell")


function MailCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function MailCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mlaycell = widget:clone()
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end

function MailCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("MailCell:addMaskButton:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
		logger:debug("LevelRewardCell:addMaskButton  xx = %f, yy = %f", xx, yy)
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}

	end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function MailCell:touchMask(point)
	logger:debug("MailCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
        return nil
    end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug("MailCell:touchMask rect:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("MailCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			return self.tbBtnEvent[name]
			-- return true
		end
	end
end


function MailCell:getGroup()
	if (self.mlaycell) then
		-- local tg = HZTouchGroup:create() -- 可接受触摸事件，传递给UIButton等UI控件
		-- tg:addWidget(self.mlaycell)
		-- return tg
		return self.mlaycell
	end
	return nil
end
--邮件主题和时间
function setCellTitle( template_id,cell ,tCellValue)
	-- 模板内容数据
	local templateData = nil
	if(template_id == 0)then
		-- 模板id为0的 没有配置模板内容
		templateData = nil
	else
		templateData = MailData.getMailTemplateData(template_id)
	end
	-- 邮件标题
	-- 邮件类型: 玩家邮件:黄色, 战斗邮件:红色, 系统邮件:绿色

	-- 将原来绿色改为#00620c
	-- 红色改为#c80b0b
	-- 黄改为蓝色，#114293
	if( template_id == 0 )then
		-- 模板id为0的特殊邮件
	else
		local layMailTitle = m_fnGetWidget(cell,"TFD_CLASS")
		--layMailTitle:setText(templateData.name)
		logger:debug(template_id)
		if( template_id == 15 or template_id == 23 or template_id == 24 
			or template_id == 25 or template_id == 26  or template_id == 27
			or template_id == 29 or  template_id == 31 or template_id == 32  
			or template_id == 23 or template_id == 24 or template_id == 45 )then
			-- 被欺负邮件
			layMailTitle:setColor(ccc3(0xc8, 0x0b, 0x0b))
		elseif(template_id == 14)then
			-- 好友留言 #fff600
			layMailTitle:setColor(ccc3(0x11, 0x42, 0x93))
		else
			--#40e100	
			layMailTitle:setColor(ccc3(0x00, 0x62, 0x0c))
		end

		UIHelper.labelEffect(layMailTitle,templateData.name)
	end
	-- 邮件时间
	local strDay  = ""
	if(tCellValue.template_id == "18") then
		logger:debug( tCellValue.va_extra.data[5].send_time)
		strDay = MailData.getValidTime(tCellValue.va_extra.data[5].send_time)
	else
		strDay = MailData.getValidTime( tCellValue.recv_time )
	end

	local layMailTime = m_fnGetWidget(cell,"TFD_STATUS")
	layMailTime:setText(strDay)
	--#ff8a3700
	layMailTime:setColor(ccc3(0x8a, 0x37, 0x00))
end

-- 创建cell
function MailCell:refresh(tCellValue, idx)
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
	
	if (self.mlaycell) then

		local noBtnCell = m_fnGetWidget(self.mlaycell,"LAY_CELL_NOBTNS")
		local btnCell = m_fnGetWidget(self.mlaycell,"LAY_CELL_BTNS")
		local moreBtnCell = m_fnGetWidget(self.mlaycell,"LAY_MORE")
		noBtnCell:setEnabled(false)
		noBtnCell:setTouchEnabled(false)
		local layRichText2 = m_fnGetWidget(noBtnCell,"LAY_RICH_TEXT2")
		layRichText2:removeAllChildrenWithCleanup(true)

		btnCell:setEnabled(false)
		btnCell:setTouchEnabled(false)
		local layRichText = m_fnGetWidget(btnCell,"LAY_RICH_TEXT")
		layRichText:removeAllChildrenWithCleanup(true)


		moreBtnCell:setEnabled(false)
		moreBtnCell:setTouchEnabled(false)
		--更多
		logger:debug(tCellValue)
		if(tCellValue.more == true)then
			local mid = tonumber(MailData.showMailData[#MailData.showMailData-1].mid)
			logger:debug("mid .... " .. mid)
			moreBtnCell:setEnabled(true)

			local btnMore = m_fnGetWidget(moreBtnCell,"BTN_MORE")
			btnMore:setTag(mid)
			-- btnMore:addTouchEventListener(moreBtnCallFun)
			self:addMaskButton(btnMore, "BTN_MORE", moreBtnCallFun)
			btnMore:setTitleText(m_i18nString(2160))
			return
		end

		local template_id = tonumber(tCellValue.template_id)

		local itemTag = tonumber(tCellValue.sender_uid)
		-- 文本内容数据
		local textInfo = {}
		-- 数组行
		local rowIndex = 0
		--文字描述添加到此item上
		local layContent = nil
		-- 数组列
		local columnIndex = 0
		-- 确定行列
		for i=1, #MailData.tArrId do
			for j=1, #MailData.tArrId[i] do
				if (MailData.tArrId[i][j] == template_id) then
					rowIndex = i
					columnIndex = j
					break
				end
			end
		end
		--需要按钮出现
		if(rowIndex >0 or columnIndex > 0) then
			logger:debug(rowIndex .. columnIndex)
			logger:debug("按钮出现吧~~")

			noBtnCell:setEnabled(false)
			btnCell:setEnabled(true)

			layContent = m_fnGetWidget(btnCell,"LAY_RICH_TEXT")
			layContent:removeAllChildrenWithCleanup(true)
			
			local btnAgree = m_fnGetWidget(btnCell,"BTN_2") 					--同意按钮
			local btnRefuse = m_fnGetWidget(btnCell,"BTN_3") 					--拒绝按钮
			local btnAgreed = m_fnGetWidget(btnCell,"IMG_AGREED") 				--已同意按钮
			local btnRefused = m_fnGetWidget(btnCell,"IMG_REFUSED") 			--已拒绝按钮
			local btnReply = m_fnGetWidget(btnCell,"BTN_1")						--回复按钮
			btnAgreed:setEnabled(false)
			btnRefuse:setEnabled(false)
			btnAgree:setEnabled(false)
			btnRefused:setEnabled(false)
			btnReply:setEnabled(false)

			-- 判断 确定是否有按钮
			if(rowIndex == 1) then
				-- 申请好友邮件的状态值  0没处理, 1是已同意, 2已拒绝
				local status = tonumber(tCellValue.va_extra.status)
				logger:debug("status0.0",status)
				setCellTitle(template_id,btnCell,tCellValue)

				if(status == 1)then
					btnAgreed:setEnabled(true) 										-- 已同意
				end
				if(status == 2)then
					btnRefused:setEnabled(true)										--已拒绝
				end
				if(status == 0)then
					-- 好友申请
					local itemTag = tonumber(tCellValue.sender_uid)
					btnAgree:setEnabled(true)

					btnAgree:setTag(itemTag)
					--btnAgree:setTitleText(m_i18nString(2105))						--国际化赋值
					UIHelper.titleShadow(btnAgree,m_i18nString(2105))
					-- btnAgree:addTouchEventListener(agreeItemCallFun) 				-- 注册回调
					self:addMaskButton(btnAgree, "BTN_2", agreeItemCallFun)

					btnRefuse:setEnabled(true)
					btnRefuse:setTag(itemTag)										-- 拒绝按钮
					-- btnRefuse:addTouchEventListener(refuseItemCallFun) 				-- 注册回调
					self:addMaskButton(btnRefuse, "BTN_3", refuseItemCallFun)
					--btnRefuse:setTitleText(m_i18nString(2106))						--国际化赋值
					UIHelper.titleShadow(btnRefuse,m_i18nString(2106))
				end
			elseif(rowIndex == 2) then
				-- 好友留言
				logger:debug("haoyou liuyanle")
				local itemTag = tonumber(tCellValue.sender_uid)
				setCellTitle(template_id,btnCell,tCellValue)

				btnReply:setEnabled(true)											-- 回复按钮
				UIHelper.titleShadow(btnReply,m_i18nString(2158))
				btnReply:setTag(itemTag)
				self:addMaskButton(btnReply, "BTN_1", replyItemCallFun)
			elseif (rowIndex == 3) then
				-- 去反击
				setCellTitle(template_id,btnCell,tCellValue)

				btnReply:setEnabled(true)											-- 去反击
				--btnReply:setTitleText(m_i18nString(2108))							--国际化赋值
				UIHelper.titleShadow(btnReply,m_i18nString(5659))
				local itemTag = tonumber(tCellValue.sender_uid)

				btnReply:setTag(itemTag)
				local captureDomainType =  tonumber(tCellValue.va_extra.data[3]) or 0
				local captureUid =  tonumber(tCellValue.va_extra.data[1].uid) or 0
				 --反击按钮回调
				self:addMaskButton(btnReply, "BTN_1", function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						require "script/module/mine/MineMailCtrl"
						MineMailCtrl.fnCounterAttack(captureUid,captureDomainType)
					end
				end)

			elseif (rowIndex == 4) then
				-- 去竞技场
				setCellTitle(template_id,btnCell,tCellValue)

				btnReply:setEnabled(true)											-- 去竞技场按钮
				--btnReply:setTitleText(m_i18nString(2108))							--国际化赋值
				UIHelper.titleShadow(btnReply,m_i18nString(2108))
				-- btnReply:addTouchEventListener(toAreanItemCallFun)					-- 注册回调
				self:addMaskButton(btnReply, "BTN_1", toAreanItemCallFun)
			elseif (rowIndex == 7) then
				-- 去切磋
				logger:debug(tCellValue.va_extra.data[1].uid)
				logger:debug(tCellValue.va_extra.data[1])
				logger:debug(tCellValue.va_extra)
				setCellTitle(template_id,btnCell,tCellValue)
				local itemTag = tonumber(tCellValue.va_extra.data[1].uid)
				btnReply:setEnabled(true)
				logger:debug(itemTag)
				btnReply:setTag(itemTag)											-- 去切磋按钮
				UIHelper.titleShadow(btnReply,m_i18nString(6702))
				self:addMaskButton(btnReply, "BTN_1", toPKCallFun)

			elseif (rowIndex == 6) then
				-- 去抢夺
				setCellTitle(template_id,btnCell,tCellValue)
				btnReply:setEnabled(true)											-- 去q抢夺按钮
				--btnReply:setTitleText(m_i18nString(2109))
				UIHelper.titleShadow(btnReply,m_i18nString(2109))
				self:addMaskButton(btnReply, "BTN_1", toRobItemCallFun)
			end

		else
			-- 没有按钮
			noBtnCell:setEnabled(true)
			layContent = m_fnGetWidget(noBtnCell,"LAY_RICH_TEXT2")
			layContent:removeAllChildrenWithCleanup(true)
			setCellTitle(template_id,noBtnCell,tCellValue)							--设置邮件的时间和主题
		end

		-- 模板内容数据
		local templateData = nil
		logger:debug(template_id)
		if(template_id == 0)then
			-- 模板id为0的 没有配置模板内容
			templateData = nil
		else
			logger:debug(template_id)
			templateData = MailData.getMailTemplateData(template_id)
		end
		--富文本
		local richStr
		--富文本的按钮回调
		local tbEvent = {}
		tbEvent.tag = 0   --初始化为0
		-- 内容行
		local tStrId_rowIndex = 0
		-- 数组列
		local tStrId_columnIndex = 0
		-- 确定行列
		for i=1, #MailData.tStrId do
			for j=1, #MailData.tStrId[i] do
				if (MailData.tStrId[i][j] == template_id) then
					tStrId_rowIndex = i
					tStrId_columnIndex = j
					break
				end
			end
		end
		logger:debug(tStrId_rowIndex .. "content" .. tStrId_columnIndex)
		if(tStrId_rowIndex == 1)then
			-- 22->充值 缺少单位
			local gold_num = tCellValue.va_extra.data[1]
			richStr =  UIHelper.concatString({templateData.content[1],gold_num or " "})
			textInfo = {richStr,{{color=normalColor};{color=speColor}}}
		elseif(tStrId_rowIndex == 2)then
			if(tStrId_columnIndex == 1 or tStrId_columnIndex == 2 or tStrId_columnIndex == 3 or tStrId_columnIndex == 11)then
				-- 8,9->资源矿强夺,16->竞技场防守成功  33->联盟会长退出时成为某某联盟会长
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end

				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				--转让联盟长
				if(tStrId_columnIndex == 11) then
					logger:debug(tCellValue.va_extra.data[1])
					hero_name = tCellValue.va_extra.data[1]
					name_color =speColor
				end

				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " ",templateData.content[2]})
				textInfo = {richStr,{{color=normalColor};{color=name_color, style = nil};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 3)then
				-- 16->竞技场防守成功
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)

				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " ",templateData.content[2],m_i18nString(2167)})
				textInfo = {richStr,{{color=normalColor};{color=name_color, style = nil};{color=normalColor};
									{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};}}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 4 or tStrId_columnIndex == 5 or tStrId_columnIndex == 6)then
				-- 11->同意好友请求,12->拒绝好友请求,13->断绝好友关系
				-- 玩家姓名
				local hero_name = tCellValue.sender_uname
				local hero_uid = tCellValue.sender_uid
				local hero_utid = tCellValue.sender_utid or 1
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " ",templateData.content[2]})
				logger:debug(richStr)
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=normalColor};
					}
					}
			end
			if(tStrId_columnIndex == 7 or tStrId_columnIndex == 8)then
				-- 19,20->接受入团申请，拒绝入团申请
				local guildName = " "
				if( tCellValue.va_extra.data[1] )then
					guildName = tCellValue.va_extra.data[1].guild_name
				end
				richStr =  UIHelper.concatString({templateData.content[1],guildName,templateData.content[2]})
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 9)then
				-- 30->vip
				local vipData = 0
				if( tCellValue.va_extra.data[1] )then
					vipData = tonumber(tCellValue.va_extra.data[1])
				end
				richStr =  UIHelper.concatString({templateData.content[1],vipData or " ",templateData.content[2]})
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 10)then
				-- 31->竞技场被击败 排名没变的
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name ,templateData.content[2],m_i18nString(2167)})
				textInfo = {richStr,{{color=normalColor};{color=name_color, style = nil};{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};}}
				tbEvent.tag = replay
			end

			if(tStrId_columnIndex == 12 or tStrId_columnIndex == 13)then
				-- 45->切磋被击败   46->切磋胜利
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name ,templateData.content[2],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
		elseif(tStrId_rowIndex == 3)then
			if(tStrId_columnIndex == 1)then
				-- 1->资源矿到期
				-- 占领时间
				local gather_time = 0
				if(tCellValue.va_extra.data[1])then
					gather_time = tonumber(tCellValue.va_extra.data[1])
				end
				local timeStr = nil
				if(gather_time)then
					timeStr = TimeUtil.getTimeStringFont(gather_time)
				end
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[2] )then
					coin = tonumber(tCellValue.va_extra.data[2]) ..  m_i18nString(1520)      --贝里
				end
				richStr =  UIHelper.concatString({templateData.content[1],timeStr or " " ,templateData.content[2],coin})
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};{color=speColor};}}
			end
			if(tStrId_columnIndex == 4)then
				-- 10->申请好友
				local name_color,stroke_color = getHeroNameColor( tCellValue.sender_utid )
				richStr =  UIHelper.concatString({tCellValue.sender_uname or " " ,templateData.content[1] ,tCellValue.content or " "})
				textInfo = {richStr,{{color=speColor,style = nil};{color=normalColor};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 7)then
				-- 18->竞技场排名奖励
				-- 位置
				local arena_position = " "
				if( tCellValue.va_extra.data[2] )then
					arena_position = tCellValue.va_extra.data[2].arena_position
				end

				local str4 = " "
				-- 声望 addby 2013.12.2
				local reward_prestige = tCellValue.va_extra.data[3]
				if(reward_prestige ~= nil and tonumber(reward_prestige) > 0)then
					str4 = str4 .. reward_prestige .. m_i18nString(1921)    --[1921] = "声望",
				end
				-- 贝里
				local reward_coin = tCellValue.va_extra.data[4]
				if(reward_coin ~= nil and tonumber(reward_coin) > 0)then
					str4 = str4 .. reward_coin ..  m_i18nString(1520)      --贝里
				end
				-- 物品
				local item_template_id = nil
				if( tCellValue.va_extra.data[5] )then
					item_template_id = tCellValue.va_extra.data[5].item_template_id
				end
				logger:debug(item_template_id)
				if(item_template_id)then
					local rewardItem_name = ItemUtil.getItemById( tonumber(item_template_id) ).name
					local rewardItem_num = " "
					if( tCellValue.va_extra.data[5] )then
						rewardItem_num = tCellValue.va_extra.data[5].item_number
					end
					str4 = str4 .. rewardItem_name .. "*" .. rewardItem_num
				end
				richStr =  UIHelper.concatString({templateData.content[1],arena_position or " " ,templateData.content[2],str4})
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};{color=speColor};}}
			end
			if(tStrId_columnIndex == 2 or tStrId_columnIndex == 3)then
				-- 4,5->资源矿抢夺
				-- 资源矿原主人名字
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				--战斗重播数值
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " " ,templateData.content[2],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
				tbEvent.isMineBattle = true
			end
			if(tStrId_columnIndex == 5)then
				-- 15->竞技场被击败
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 竞技场排名
				local arena_position = " "
				if(tCellValue.va_extra.data[2])then
					arena_position = tCellValue.va_extra.data[2].arena_position
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " " ,templateData.content[2],arena_position,m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=name_color, style = nil};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 6)then
				-- 17->竞技场幸运排名奖励
				-- 位置
				local arena_position = " "
				if(tCellValue.va_extra.data[2])then
					arena_position = tCellValue.va_extra.data[2].arena_position
				end
				-- 金币数
				local gold = " "
				if(tCellValue.va_extra.data[3])then
					gold = tCellValue.va_extra.data[3].gold .. m_i18nString(2220) 
				end
				richStr =  UIHelper.concatString({templateData.content[1],arena_position or " " ,templateData.content[2],gold})
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};{color=speColor};}}
			end
			if(tStrId_columnIndex == 8 or tStrId_columnIndex == 9 or tStrId_columnIndex == 10)then
				-- 34->资源矿放弃 35 占领时间结束 36主动放弃协助
				local strTime = TimeUtil.getTimeStringFont(tCellValue.va_extra.data[1] or 0)
				
				local nInterBelly = tonumber(tCellValue.va_extra.data[2])
				logger:debug(nInterBelly)
				local strBelly = math.floor(nInterBelly) .. m_i18nString(1520)
				richStr =  UIHelper.concatString({templateData.content[1],
												strTime ,
												templateData.content[2],
												strBelly})
				textInfo = {richStr,{{color=normalColor};
									{color=speColor};
									{color=normalColor};
									{color=speColor};}}
			end

			if(tStrId_columnIndex == 11)then
				-- 41 协助被抢夺矿主提示
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				local strTime = TimeUtil.getTimeStringFont(tCellValue.va_extra.data[2] or 0)
				-- 物品名称
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name,templateData.content[2],strTime,m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay

			end
		elseif(tStrId_rowIndex == 4)then
			-- 21->踢出军团, 23->被抢夺碎片, 27->比武积分抢夺, 28->比武排行奖励, 29->夺宝被掠夺贝里
			if(tStrId_columnIndex == 1 )then
				-- 21->踢出军团
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[2] )then
					hero_name = tCellValue.va_extra.data[2].uname
					hero_uid = tCellValue.va_extra.data[2].uid
					hero_utid = tCellValue.va_extra.data[2].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 军团名字
				local guildName = " "
				if( tCellValue.va_extra.data[1] )then
					guildName = tCellValue.va_extra.data[1].guild_name
				end
				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " " ,templateData.content[2],guildName,templateData.content[3]})
				textInfo = {richStr,{{color=normalColor};{color=speColor,style = nil};
					{color=normalColor};{color=speColor,style = nil};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 2)then
				-- 23->被抢夺碎片
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 物品名称
				local item_template_id = nil
				if(tCellValue.va_extra.data[2])then
					item_template_id = tCellValue.va_extra.data[2].fragId
				end
				 logger:debug(item_template_id)
				local item_name = nil
				if(item_template_id)then
					--local itemInfo = ItemUtil.getItemById( tonumber(item_template_id) )

					item_name = ItemUtil.getItemById( tonumber(item_template_id) ).name .. m_i18nString(2448)
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name,templateData.content[2],item_name or "",templateData.content[3],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 3)then
				-- 27->比武积分抢夺
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local score = " "
				if( tCellValue.va_extra.data[2] )then
					score = tCellValue.va_extra.data[2].integral
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name,templateData.content[2],score,templateData.content[3],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 4)then
				-- 28->比武排行奖励
				-- 位置
				local match_position = " "
				if(tCellValue.va_extra.data[1]) then
					match_position = tCellValue.va_extra.data[1].rank
				end
				local str4 = " "
				-- 贝里
				local reward_coin = nil
				if( tCellValue.va_extra.data[3] )then
					reward_coin = tCellValue.va_extra.data[3].silver
				end
				if(reward_coin ~= nil and tonumber(reward_coin) > 0)then
					str4 = str4 .. reward_coin .. m_i18nString(1520)      --贝里
				end
				-- 金币
				local reward_gold = nil
				if(tCellValue.va_extra.data[4])then
					reward_gold = tCellValue.va_extra.data[4].gold
				end
				if(reward_gold ~= nil and tonumber(reward_gold) > 0)then
					str4 = str4 .. reward_gold .. m_i18nString(2220)   --金币
				end 
				-- 物品
				local item_template_id = nil
				if( tCellValue.va_extra.data[5] )then
					item_template_id = tCellValue.va_extra.data[5].item_template_id
				end
				logger:debug("item_template_id ",item_template_id)
				if(item_template_id ~= nil)then
					local rewardItem_name = ItemUtil.getItemById(item_template_id).name
					local rewardItem_num = " "
					if( tCellValue.va_extra.data[5] )then
						rewardItem_num = tCellValue.va_extra.data[5].item_number
					end
					str4 = str4 .. rewardItem_name .. "*" .. rewardItem_num
				end
				richStr =  UIHelper.concatString({templateData.content[1],match_position,templateData.content[2],str4},true)
				textInfo = {richStr,{{color=normalColor};{color=speColor};{color=normalColor};{color=normalColor};}}
			end
			if(tStrId_columnIndex == 5)then
				-- 29->夺宝被掠夺贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[2] )then
					coin = tCellValue.va_extra.data[2].silver
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name,templateData.content[2],coin,templateData.content[3],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 6)then
				-- 32->竞技场被击败 并且被掠夺了贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[2] )then
					coin = tCellValue.va_extra.data[2].silver
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)

				richStr =  UIHelper.concatString({templateData.content[1],hero_name,templateData.content[2],coin,templateData.content[3],m_i18nString(2167)})
				logger:debug(richStr .. hero_name .. templateData.content[2] .. coin .. templateData.content[3])
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 7)then
				-- 43->仇人被掠夺贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0

				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( tCellValue.va_extra.data[1].utid )
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[2] )then
					coin = tCellValue.va_extra.data[2]
				end	
				--宝物碎片名字			
				local nameFrag = " "
				if( tCellValue.va_extra.data[2] )then
					-- nameFrag = ItemUtil.getItemById(tCellValue.va_extra.data[2].fragId).name
				end

				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1],hero_name or " ",templateData.content[2],coin,templateData.content[3]})
				logger:debug(richStr .. hero_name .. templateData.content[2] .. coin .. templateData.content[3])
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					-- {btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				-- tbEvent.tag = replay
			end
			-- 资源矿被占领  资源矿被放弃  协助被抢夺  协助时间结束
			if(tStrId_columnIndex == 8 or tStrId_columnIndex == 9 or tStrId_columnIndex == 10 or tStrId_columnIndex == 11) then
				local strTime = TimeUtil.getTimeStringFont(tCellValue.va_extra.data[2] or 0)
				local nInterBelly = tonumber(tCellValue.va_extra.data[3])
				local strBelly = math.floor(nInterBelly) .. m_i18nString(1520)

				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0

				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( tCellValue.va_extra.data[1].utid )
	
				-- 您所协助的资源矿被|占领，共协助|，总计获得|",
				richStr =  UIHelper.concatString({templateData.content[1],
												hero_name ,
												templateData.content[2],
												strTime,
												templateData.content[3],
												strBelly})
				textInfo = {richStr,{{color=normalColor};
									{color=speColor};
									{color=normalColor};
									{color=speColor};
									{color=normalColor};
									{color=speColor};
									}}

			end
		elseif(tStrId_rowIndex == 5)then
			if(tStrId_columnIndex == 1 or tStrId_columnIndex == 2)then
				-- 2,7->资源矿守护成功
				-- 抢夺者姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({hero_name,templateData.content[1],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=name_color, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
				tbEvent.isMineBattle = true
			end
			if(tStrId_columnIndex == 3)then
				-- 14->好友留言
				-- 玩家姓名
				local hero_name = tCellValue.sender_uname
				local hero_uid = tCellValue.sender_uid
				local hero_utid = tCellValue.sender_utid or 1
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 内容
				local str = tCellValue.content
				richStr =  UIHelper.concatString({hero_name,templateData.content[1],str or " " },true)
				textInfo = {richStr,{{color = name_color};{color=normalColor};{color=normalColor};}}
			end
		elseif(tStrId_rowIndex == 6)then
			-- 3,6->守护资源矿失败
			-- 抢夺者姓名
			local hero_name = " "
			local hero_uid = 0
			local hero_utid = 0
			if( tCellValue.va_extra.data[1] )then
				hero_name = tCellValue.va_extra.data[1].uname
				hero_uid = tCellValue.va_extra.data[1].uid
				hero_utid = tCellValue.va_extra.data[1].utid
			end
			-- 玩家名字颜色
			local name_color,stroke_color = getHeroNameColor( hero_utid )
			-- 占领时间
			local gather_time = 0
			if(tCellValue.va_extra.data[2])then
				gather_time = math.floor(tonumber(tCellValue.va_extra.data[2]))
			end
			local timeStr = TimeUtil.getTimeStringFont(gather_time)
			-- 获得的贝里数
			local coin = " "
			if( tCellValue.va_extra.data[3] )then
				coin = tonumber(tCellValue.va_extra.data[3]) ..  m_i18nString(1520)      --贝里
			end
			-- 战报
			local replay = tonumber(tCellValue.va_extra.replay)
			richStr =  UIHelper.concatString({hero_name,templateData.content[1] ,timeStr or " ",templateData.content[2],coin or " ",templateData.content[3],m_i18nString(2167)})
			textInfo = {richStr,{	{color=name_color, style = nil};
				{color=normalColor};
				{color=speColor};
				{color=normalColor};
				{color=speColor, style = nil};
				{color=normalColor};
				{btn = true, font = g_sFontPangWa,size = 30,color=lookBatterTextColor()};
				}
				}
			tbEvent.tag = replay
			tbEvent.isMineBattle = true
		elseif(tStrId_rowIndex == 7)then
			-- 24->竞技场被掠夺贝里, 25->夺宝被掠夺贝里, 26->比武被掠夺贝里
			if(tStrId_columnIndex == 1)then
				-- 24->竞技场被掠夺贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[2] )then
					coin = tCellValue.va_extra.data[2].silver
				end
				-- 位置
				local arena_position = " "
				if( tCellValue.va_extra.data[3] )then
					arena_position = tCellValue.va_extra.data[3].rank
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1] ,hero_name,templateData.content[2],coin ,templateData.content[3],arena_position,templateData.content[4],m_i18nString(2167)})

				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color = lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay

			end
			if(tStrId_columnIndex == 2)then
				-- 25->夺宝被掠夺贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[1] )then
					hero_name = tCellValue.va_extra.data[1].uname
					hero_uid = tCellValue.va_extra.data[1].uid
					hero_utid = tCellValue.va_extra.data[1].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local coin = " "
				if (tCellValue.va_extra.data[3]) then
					coin = tCellValue.va_extra.data[3].silver
				end
				-- 物品名称
				local item_template_id = nil
				if(tCellValue.va_extra.data[2])then
					item_template_id = tCellValue.va_extra.data[2].fragId
				end
				-- logger:debug(item_template_id)
				local item_name = nil
				if(item_template_id)then
					item_name = ItemUtil.getItemById( tonumber(item_template_id) ).name
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1] ,
												hero_name,
												templateData.content[2],
												coin ,
												templateData.content[3],
												item_name,
												templateData.content[4],
												m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color = lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
			end
			if(tStrId_columnIndex == 3)then
				-- 26->比武被掠夺贝里
				-- 玩家姓名
				local hero_name = " "
				local hero_uid = 0
				local hero_utid = 0
				if( tCellValue.va_extra.data[2] )then
					hero_name = tCellValue.va_extra.data[2].uname
					hero_uid = tCellValue.va_extra.data[2].uid
					hero_utid = tCellValue.va_extra.data[2].utid
				end
				-- 玩家名字颜色
				local name_color,stroke_color = getHeroNameColor( hero_utid )
				-- 获得的贝里数
				local coin = " "
				if( tCellValue.va_extra.data[1] )then
					coin = tCellValue.va_extra.data[1].silver
				end
				-- 积分
				local score = " "
				if( tCellValue.va_extra.data[3] )then
					score = tCellValue.va_extra.data[3].integral
				end
				--战斗重播数值
				local replay = tonumber(tCellValue.va_extra.replay)
				richStr =  UIHelper.concatString({templateData.content[1] ,hero_name,templateData.content[2],coin ,templateData.content[3],score,templateData.content[4],m_i18nString(2167)})
				textInfo = {richStr,{
					{color=normalColor};
					{color=name_color, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{color=speColor, style = nil};
					{color=normalColor};
					{btn = true, font = g_sFontPangWa,size = 30,color = lookBatterTextColor()};
					}
					}
				tbEvent.tag = replay
				tbEvent.tid = tCellValue.template_id
			end
		elseif(tStrId_rowIndex == 8)then
			if(tStrId_columnIndex == 1)then
				-- 0->模板id为0的特殊邮件
				local contentStr = tCellValue.content or " "
				richStr = contentStr
				textInfo = {richStr,{{color=normalColor};}}
			end
		else
			logger:debug("没有模板id" .. template_id)
		end

		local richText = BTRichText.create(textInfo, nil, nil)
		richText:setSize(layContent:getSize())
		richText:setAnchorPoint(ccp(0,0))
		richText:setPosition(ccp(0,0))
		layContent:addChild(richText, 10, m_TagRichText)
		-- --给富文本注册按钮回调事件

		if(tbEvent.tag ~= 0 ) then
			logger:debug(tbEvent.isMineBattle)
			if(tbEvent.isMineBattle) then
				tbEvent.handler = fnLookMinebatter

			else
				tbEvent.handler = fnLookbatter
			end
			BTRichText.addTouchEventHandler(tbEvent)
			logger:debug("tbEvent.tag ~= 0")
		end
	end -- if (self.mlaycell) then
end

-- 玩家名字的颜色

function getHeroNameColor( utid )
	return UIHelper.getHeroNameColor2By(utid)
end



--查看资源矿战报
function fnLookMinebatter( _tag, sender)
	-- 音效
	local tag = sender:getTag()

	AudioHelper.playCommonEffect()
	local function createNext( fightRet )
		if(LayerManager.curModuleName() ~= MainMailCtrl.moduleName()) then
			return 
		end
		-- 调用战斗接口 参数:atk
		-- 解析战斗串获得战斗评价
		local amf3_obj = Base64.decodeWithZip(fightRet)
		local lua_obj = amf3.decode(amf3_obj)
		local tbData = {}

   		if(tonumber(UserModel.getUserUid()) == tonumber(lua_obj.team1.uid)) then
   			tbData.uid = lua_obj.team2.uid
   			tbData.uname = lua_obj.team2.name
   			tbData.fightForce = lua_obj.team2.fightForce
   		else
   			tbData.uid = lua_obj.team1.uid
   			tbData.uname = lua_obj.team1.name
   			tbData.fightForce = lua_obj.team1.fightForce
   		end
   			tbData.brid = lua_obj.brid
   			
		require "script/battle/BattleModule"
		local fnCallBack = function ( ... )
		end
		require "script/module/mail/ReplayWinCtrl"
		tbData.type = MailData.ReplayType.KTypeMailBattle
		
		MainMailView.removeListView()
		BattleModule.playMineBattle(fightRet,fnCallBack,tbData,true) 
	end

	MailService.getRecord(tag,createNext)
end
--查看战报
function fnLookbatter( _tag, sender)
	-- 音效
	local tag = sender:getTag()

	AudioHelper.playCommonEffect()
	local function createNext( fightRet )
		if(LayerManager.curModuleName() ~= MainMailCtrl.moduleName()) then
			return 
		end
		-- 调用战斗接口 参数:atk
		local amf3_obj = Base64.decodeWithZip(fightRet)
		local lua_obj = amf3.decode(amf3_obj)
		local tbData = {}

   		if(tonumber(UserModel.getUserUid()) == tonumber(lua_obj.team1.uid)) then
   			tbData.uid = lua_obj.team2.uid
   			tbData.playerName = lua_obj.team2.name
   			tbData.fightForce = lua_obj.team2.fightForce
   			tbData.uid2 = lua_obj.team1.uid
   		else
   			tbData.uid = lua_obj.team1.uid
   			tbData.uid2 = lua_obj.team2.uid
   			tbData.playerName = lua_obj.team1.name
   			tbData.fightForce = lua_obj.team1.fightForce
   		end
   			tbData.brid = lua_obj.brid

		require "script/battle/BattleModule"
		local fnCallBack = function ( ... )
		end
		require "script/module/mail/ReplayWinCtrl"
		tbData.type = MailData.ReplayType.KTypeMailBattle
		
		MainMailView.removeListView()
		BattleModule.PlayNormalRecord(fightRet,fnCallBack,tbData,true)
	end

	MailService.getRecord(tag,createNext)
end
-- 同意好友申请回调
function agreeItemCallFun( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then

		local tag = sender:getTag() -- uid
		logger:debug(tag)
		
		AudioHelper.playCommonEffect() 
		-- 音效
		local function createNext( ... )
			local function createNext1( ... )
				-- 更新列表
				if(MainMailCtrl.m_curPage == 1)then
					logger:debug(MailData.showMailData)
					MainMailView.setMailData(MailData.showMailData)
				end
				if(MainMailCtrl.m_curPage == 3)then
					MainMailView.setMailData(MailData.showMailData)
				end
			end
			-- local mid = applyMenu:getTag()
			MailService.setApplyMailAdded(tag,createNext1)
			--添加好友后重新获取好友数据
			require "script/network/PreRequest"
			PreRequest.getFriendsList()
		end
		MailService.addFriend(tag,createNext)
	end
end

-- 拒绝好友申请回调
function refuseItemCallFun(sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效
		AudioHelper.playCommonEffect() 
		local tag = sender:getTag()   --uid

		local function createNext( ... )
			local function createNext1( ... )
				-- 更新列表
				if(MainMailCtrl.m_curPage == 1)then
					MainMailView.setMailData(MailData.showMailData)
				end
				if(MainMailCtrl.m_curPage == 3)then
					MainMailView.setMailData(MailData.showMailData)
				end
			end
			-- local mid = applyMenu:getTag()
			MailService.setApplyMailRejected(tag,createNext1)
		end
		MailService.rejectFriend(tag,createNext)
	end
end

-- 好友留言回复回调
function replyItemCallFun( sender, eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效

		AudioHelper.playCommonEffect() 
		
		require "script/module/mail/LeaveMessageCtrl"
		tag = sender:getTag()
		logger:debug(tag)
		LayerManager.addLayout(LeaveMessageCtrl.create(tag),nil,g_tbTouchPriority.richTextBtn - 1)
		LeaveMessageView.createEditBox()
	end
end
-- 去竞技回调
function toAreanItemCallFun( sender, eventType )
	-- 音效
	if (eventType == TOUCH_EVENT_ENDED) then
		-- logger:debug("去竞技 " .. tag)
		AudioHelper.playCommonEffect()
		local canEnter = SwitchModel.getSwitchOpenState( ksSwitchArena )
		if( canEnter ) then
			require "script/module/arena/MainArenaCtrl"
			MainArenaCtrl.create()
		end
	end
end
-- 去抢夺回调
function toRobItemCallFun( sender, eventType )
	-- 音效
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- logger:debug("去夺宝 " .. tag)
		local canEnter = SwitchModel.getSwitchOpenState( ksSwitchArena )
		if( canEnter ) then
			require "script/module/grabTreasure/MainGrabTreasureCtrl"

			MainGrabTreasureCtrl.create()
		end
	end
end

-- 去切磋回调
function toPKCallFun( sender, eventType )
	-- 音效
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		logger:debug("tbEventListener.onPVP")
		require "script/module/public/PVP"
		PVP.doPVP(sender:getTag())
	end
end

-- 更多邮件按钮回调
function moreBtnCallFun( sender, eventType )
	logger:debug("more btn clicked")
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效
		AudioHelper.playCommonEffect()
		local tag = sender:getTag()
		logger:debug("tag is " .. tag)
		if(MainMailCtrl.m_curPage == 1)then
			--全部邮件
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data) == 0)then
					-- local str = "没有更多邮件可显示！"
					ShowNotice.showShellInfo(m_i18nString(5660))
					--return
				end
				local newDataCount = table.count(t_data) 
				logger:debug(table.count(t_data) )
				MailData.showMailData = MailData.addToShowMailData(MailData.showMailData,t_data,ntotleMail)
				MainMailView.setMailData(MailData.showMailData,newDataCount)
			end
			MailService.getMailBoxList( tag ,m_requestNewMailNum,"true",createNext)
		end
		if(MainMailCtrl.m_curPage == 2)then
			--战斗邮件
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data) == 0)then
					-- local str = "没有更多邮件可显示！"
					ShowNotice.showShellInfo(m_i18nString(5660))
					--return
				end
				local newDataCount = table.count(t_data) 
				MailData.showMailData = MailData.addToShowMailData(MailData.showMailData,t_data,ntotleMail)
				MainMailView.setMailData(MailData.showMailData,newDataCount)
			end
			MailService.getBattleMailList( tag ,m_requestNewMailNum,"true",createNext)
		end
		if(MainMailCtrl.m_curPage == 3)then
			--好友邮件
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data) == 0)then
					-- local str = "没有更多邮件可显示！"
					ShowNotice.showShellInfo(m_i18nString(5660))
					--return
				end
				local newDataCount = table.count(t_data) 
				MailData.showMailData = MailData.addToShowMailData(MailData.showMailData,t_data,ntotleMail)
				MainMailView.setMailData(MailData.showMailData,newDataCount)
			end
			MailService.getPlayMailList( tag ,m_requestNewMailNum,"true",createNext)
		end
		if(MainMailCtrl.m_curPage == 4)then
			--系统邮件
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data) == 0)then
					-- local str = "没有更多邮件可显示！"
					ShowNotice.showShellInfo(m_i18nString(5660))
					--return
				end
				local newDataCount = table.count(t_data) 
				MailData.showMailData = MailData.addToShowMailData(MailData.showMailData,t_data,ntotleMail)
				MainMailView.setMailData(MailData.showMailData,newDataCount)
			end
			MailService.getSysMailList( tag ,m_requestNewMailNum,"true",createNext)
		end
	end

end
--查看战报的颜色
function lookBatterTextColor( ... )
	local color = speColor
	return color
end
--玩家颜色
function playerNameColor( ... )
	local color = speColor
	return color
end

