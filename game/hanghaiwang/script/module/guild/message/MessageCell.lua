-- FileName: MessageCell.lua
-- Author:zhangjunwu
-- Date: 2014-09-22
-- Purpose: 留言板Cell
--[[TODO List]]
-- 模块局部变量 --
require "script/module/public/class"
require "script/module/public/Cell/Cell"
require "script/module/guild/message/CommunicationCtrl"
-- UI控件引用变量 -
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbCellValue = nil
MessageCell = class("MessageCell",Cell)


function MessageCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function MessageCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mlaycell = widget:clone()
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end



function MessageCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("MessageCell:addMaskButton:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*posPercent.x, szParent.height*posPercent.y
		logger:debug("LevelRewardCell:addMaskButton  xx = %f, yy = %f", xx, yy)
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
	end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function MessageCell:touchMask(point)
	logger:debug("MessageCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug(name)
		logger:debug("MessageCell:touchMask rect:x = %f,x = %f,x = %f,x = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("MessageCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			return self.tbBtnEvent[name]
				-- return true
		end
	end
end


function MessageCell:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end
-- 创建cell
function MessageCell:refresh(tCellValue)
	logger:debug("dddfasdfasdfasdf")
	if(self.mlaycell)then


		-- 玩家名字
		local strPlayerName = tCellValue.uname or " "
		strPlayerName = strPlayerName .. ":"

		--玩家的身份
		 --'type':            职务类型：0团员，1团长，2副团
		local IMG_LEADER = m_fnGetWidget(self.mlaycell,"IMG_LEADER")    --会长
		local IMG_VICE = m_fnGetWidget(self.mlaycell,"IMG_VICE")    	--副会长
		local IMG_MEMBER = m_fnGetWidget(self.mlaycell,"IMG_MEMBER")    --成员

		IMG_LEADER:setEnabled(true)
		IMG_MEMBER:setEnabled(true)
		IMG_VICE:setEnabled(true)

		if(tonumber(tCellValue.type) == 0) then
			IMG_LEADER:setEnabled(false)
			IMG_VICE:setEnabled(false)
		elseif(tonumber(tCellValue.type) == 1)then
			IMG_VICE:setEnabled(false)
			IMG_MEMBER:setEnabled(false)
		elseif(tonumber(tCellValue.type) == 2)then
			IMG_LEADER:setEnabled(false)
			IMG_MEMBER:setEnabled(false)
		end

		-- 玩家等级
		local strPlayerLv = tCellValue.level or " "

		--玩家头像, zhangqi, 2015-01-09, 去主角后后端删除了dress和htid，头像id改为figure
		local headIconBtn,heroInfo = HeroUtil.createHeroIconBtnByHtid(tCellValue.figure)
		-- local dressId = nil
		-- if(not table.isEmpty(tCellValue.dress) and (tCellValue.dress["1"]) and tonumber(tCellValue.dress["1"]) >0 )then
		-- 	dressId = tonumber(tCellValue.dress["1"])
		-- end
		-- local headIconBtn,heroInfo = HeroUtil.createHeroIconBtnByHtid(tCellValue.htid, dressId)
		local headIconBg = m_fnGetWidget(self.mlaycell,"LAY_PHOTO")
		headIconBg:addChild(headIconBtn)
		headIconBtn:setPosition(ccp(headIconBg:getSize().width / 2,headIconBg:getSize().height / 2))
		headIconBtn:setTag(tonumber(tCellValue.uid))
		self.tbMaskRect["LAY_PHOTO"] = headIconBg:boundingBox()
		self.tbBtnEvent["LAY_PHOTO"] = {sender = headIconBtn, event = onHeroIcon}

		--时间
		local strTime = TimeUtil.getTimeFormatYMDHMS(tCellValue.time) or " "
		local TFD_TIME = m_fnGetWidget(self.mlaycell,"TFD_TIME")
		TFD_TIME:setText(strTime)

		--留言内容
		-- local strTime = "北34胜6负的战绩追平了他们的队史前40场比赛最佳战绩，2010-11赛季，马刺队也曾在赛季前40场比赛中拿到了34胜6负的战绩。"--tCellValue.message or " "
		local strTime = tCellValue.message or " "
		local LAY_NEWS = m_fnGetWidget(self.mlaycell,"LAY_NEWS")

		-- LAY_NEWS:removeAllChildrenWithCleanup(true)
		local richStr = ""
		-- local LAY_NEWS = m_fnGetWidget(self.mlaycell,"LAY_NEWS")
		richStr = strPlayerName .. "  " ..  "|" ..  strTime 
		local tbRichTextColor = {}
		local HeroColor =  UserModel.getPotentialColor({htid = tCellValue.figure})
		local tbColorName = {color = HeroColor }
		table.insert(tbRichTextColor,tbColorName)
		local tbColor1 = {color = ccc3(0x82,0x57,0x00)}
		table.insert(tbRichTextColor,tbColor1)

		LAY_NEWS:setLayoutType(LAYOUT_RELATIVE)

		local textInfo = {richStr,tbRichTextColor}
		local richText = BTRichText.create(textInfo, nil, nil)
		richText:setSize(LAY_NEWS:getSize())
		LAY_NEWS:removeChildByTag(123,true)
		richText:setAnchorPoint(ccp(0,1))
		-- richText:setVerticalSpace(2)
		richText:visit()

		local textHeight = richText:getTextHeight()

		local img_content_bg = m_fnGetWidget(self.mlaycell, "img_content_bg")
		logger:debug(textHeight)
		logger:debug(img_content_bg:getSize().height)
		if(textHeight > LAY_NEWS:getSize().height) then
			img_content_bg:setSize(CCSizeMake(img_content_bg:getSize().width ,textHeight + 20))
		end

		richText:setSize(LAY_NEWS:getSize())
		
		-- LAY_NEWS:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
		-- LAY_NEWS:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
		-- LAY_NEWS:setBackGroundColorOpacity(100)
		LAY_NEWS:addChild(richText,0,123)

		logger:debug(LAY_NEWS:getSize().width)
		logger:debug(richText:getSize().width)
	end
end

function onHeroIcon( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local uid = sender:getTag()

		AudioHelper.playCommonEffect()

		local bFirend = false
		function requestFunc(cbFlag, dictData, bRet)
			if(bRet == true)then
				local dataRet = dictData.ret
				if(dataRet == "true" or dataRet == true )then
					bFirend = true
				end
				if(dataRet == "false" or dataRet == false  )then
					bFirend = false
				end
			end
			logger:debug(bFirend)
			local tbUserInfo  = MainMessageView.getCurMessageDatabyUid(uid)
			logger:debug(tbUserInfo)
			if(tbUserInfo) then
				tbUserInfo.isFriend = bFirend

				CommunicationCtrl.create(tbUserInfo)
			end

		end

		local args = CCArray:create()
		args:addObject(CCInteger:create(tonumber(uid)))
		Network.rpc(requestFunc, "friend.isFriend", "friend.isFriend", args, true)



	end
end
