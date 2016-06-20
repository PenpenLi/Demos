-- FileName: DynamicCell.lua
-- Author:zhangjunwu
-- Date: 2014-09-15
-- Purpose: 联盟列表Cell
--[[TODO List]]
-- 模块局部变量 --
require "script/module/public/class"
require "script/module/public/Cell/Cell"
-- UI控件引用变量 -
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

DynamicCell = class("DynamicCell")


function DynamicCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function DynamicCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mlaycell = widget:clone()
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end

function DynamicCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("DynamicCell:addMaskButton:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

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
function DynamicCell:touchMask(point)
	logger:debug("DynamicCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug(name)
		logger:debug("DynamicCell:touchMask rect:x = %f,x = %f,x = %f,x = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("DynamicCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			return self.tbBtnEvent[name]
				-- return true
		end
	end
end


function DynamicCell:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end
-- 创建cell
function DynamicCell:refresh(tCellValue)
	if(self.mlaycell)then

		-- 玩家名字
		local strPlayerName = tCellValue.user.uname or " "
		-- local TFD_PLAYER_NAME = m_fnGetWidget(self.mlaycell,"TFD_PLAYER_NAME")
		-- TFD_PLAYER_NAME:setText(strPlayerName)

		-- 玩家等级
		local strPlayerLv = tCellValue.user.level or " "
		-- local TFD_PLAYER_LV = m_fnGetWidget(self.mlaycell,"TFD_PLAYER_LV")
		-- TFD_PLAYER_LV:setText(strPlayerLv)

		--玩家头像, zhangqi, 2015-01-09, 去主角后后端删除了dress和htid，头像id改为figure
		local headIconSprite,heroInfo = HeroUtil.createHeroIconBtnByHtid(tCellValue.user.figure)
		-- local dressId = nil
		-- if(not table.isEmpty(tCellValue.user.dress) and (tCellValue.user.dress["1"]) and tonumber(tCellValue.user.dress["1"]) >0 )then
		-- 	dressId = tonumber(tCellValue.user.dress["1"])
		-- end

		-- local headIconSprite,heroInfo = HeroUtil.createHeroIconBtnByHtid(tCellValue.user.htid, dressId)
		-- 注册函数
		--headIconItem:registerScriptTapHandler(headIconItemCallFun)
		local headIconBg = m_fnGetWidget(self.mlaycell,"LAY_PHOTO")
		headIconBg:addChild(headIconSprite)
		headIconSprite:setPosition(ccp(headIconBg:getSize().width / 2,headIconBg:getSize().height / 2))

		headIconSprite:setTag(tonumber(tCellValue.user.uid))
		self.tbMaskRect["LAY_PHOTO"] = headIconBg:boundingBox()
		self.tbBtnEvent["LAY_PHOTO"] = {sender = headIconSprite, event = onHeroIconCall}


		--时间
		local strTime = TimeUtil.getTimeFormatYMDHMS(tCellValue.info.time) or " "
		local TFD_TIME = m_fnGetWidget(self.mlaycell,"TFD_TIME")
		TFD_TIME:setText(strTime)

		--动态内容
		local tbDynamicInfo = getContentStr(tCellValue)

		local tbText = {}
		local tbColor = {}

		for i,v in ipairs(tbDynamicInfo) do
			table.insert(tbText,v.text)

			local tbColor1 = {color = v.color ,font = g_sFontCuYuan}
			table.insert(tbColor,tbColor1)
		end

		-- 拜关公殿
		if(tonumber(tCellValue.info.type) == 108)then
			-- 喝咖啡动态中还有黄色字体，需要改为#571e01
			local rewardStr = getRewardStr(tCellValue)
			table.insert(tbText,rewardStr)
			local tbColor1 = {color = ccc3(0x57,0x1e,0x01) ,font = g_sFontCuYuan}
			table.insert(tbColor,tbColor1)
		end

		local LAY_NEWS = m_fnGetWidget(self.mlaycell,"LAY_NEWS")
		-- LAY_NEWS:setLayoutType(LAYOUT_RELATIVE)
		local richStr =  UIHelper.concatString(tbText)
		local textInfo = {richStr,tbColor}
		logger:debug(textInfo)
		LAY_NEWS:setLayoutType(LAYOUT_RELATIVE)
		local richText = BTRichText.create(textInfo, nil, nil)
		local laySize = LAY_NEWS:getSize()
		richText:setSize(CCSizeMake(laySize.width - 13,laySize.height))
		richText:setAnchorPoint(ccp(0,0))
		richText:setPosition(ccp(0,0))
		LAY_NEWS:removeChildByTag(123,true)
		richText:setVerticalSpace(2)

		richText:visit()

		local textHeight = richText:getTextHeight()

		local img_content_bg = m_fnGetWidget(self.mlaycell, "img_content_bg")
		logger:debug(textHeight)
		logger:debug(img_content_bg:getSize().height)
		if(textHeight > LAY_NEWS:getSize().height) then
			img_content_bg:setSize(CCSizeMake(img_content_bg:getSize().width,textHeight + 20))
		end
		-- LAY_NEWS:setBackGroundColorType(LAYOUT_COLOR_SOLID) -- 设置单色模式
		-- LAY_NEWS:setBackGroundColor(ccc3(0x00, 0x00, 0x00))
		-- LAY_NEWS:setBackGroundColorOpacity(100)
	
		LAY_NEWS:addChild(richText,0,123)
	end

end
--点击头像的回调
function onHeroIconCall( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		local uid = sender:getTag()

		AudioHelper.playCommonEffect()

		require "script/module/formation/FormationCtrl"
		FormationCtrl.loadFormationWithUid(uid)
	end
end
--联盟大厅            人鱼咖啡厅                                     "军团商店"  “公会副本”
local buildingArr = {m_i18nString(3701), m_i18nString(3721), m_i18nString(3816), m_i18nString(5955)}

-- 解析人鱼咖啡厅获得的奖励
function getRewardStr( dynamicInfo )
	local rewardStr = ""
	local m_reward = dynamicInfo.info.reward
	if(m_reward.gold and tonumber(m_reward.gold) >0)then
		--j金币
		rewardStr = rewardStr .. m_i18nString(2220) .. "+" .. tonumber(m_reward.gold)
	end
	if(m_reward.silver and tonumber(m_reward.silver)>0)then
		--银币
		rewardStr = rewardStr .. m_i18nString(1520) .. "+" .. tonumber(m_reward.silver)
	end
	if(m_reward.execution and tonumber(m_reward.execution)>0)then
		--体力
		rewardStr = rewardStr .. m_i18nString(1922) .. "+" .. tonumber(m_reward.execution)
	end
	if(m_reward.stamina and tonumber(m_reward.stamina)>0)then
		--耐力
		rewardStr = rewardStr .. m_i18nString(1923) .. "+" tonumber(m_reward.stamina)
	end
	if(m_reward.prestige and tonumber(m_reward.prestige)>0)then
		--声望
		rewardStr = rewardStr .. m_i18nString(1921) .. "+" .. tonumber(m_reward.prestige)
	end

	return rewardStr
end

--20150-6-23 3.将原来白色的文字修改为#825700  4.将原来黄色的文字修改为#571e01
--不确定的内容的显示颜色
local contentNameColor  = {r=0x57;g=0x1e;b=0x01}
--i18n里的内容指定的颜色
local i18nColor  =   {r=0x82;g=0x57;b=0x00}
--  获得文案的显示
function getContentStr(dynamicInfo)
	local m_type = tonumber(dynamicInfo.info.type)
	local userNameColor =  UserModel.getPotentialColor({htid = dynamicInfo.user.figure,bright = nil}) 

	local text_arr = {}
	--local color_arr = {}
	if( m_type == 101)then
		-- 玩家加入军团
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		-- 进入军团
		local dict_2 = {}
		dict_2.text = m_i18nString(3631)
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
	elseif(m_type == 102)then
		-- 玩家退出军团
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		-- 退出军团
		local dict_2 = {}
		dict_2.text = m_i18nString(3632) --"退出了军团"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
	elseif(m_type == 103)then
		-- 被踢出军团
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.info.uname
		dict_1.color = UserModel.getPotentialColor(dynamicInfo.info.figure)
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3633) --"被"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
		-- 名字
		local dict_3 = {}
		dict_3.text = dynamicInfo.user.uname
		dict_3.color = userNameColor
		table.insert(text_arr, dict_3)
		--
		local dict_4 = {}
		dict_4.text = m_i18nString(3634) --"请出了军团"
		dict_4.color = i18nColor
		table.insert(text_arr, dict_4)
	elseif(m_type == 104)then
		-- 弹劾军团长
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3635) --"弹劾"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
		-- 名字
		local dict_3 = {}
		dict_3.text = dynamicInfo.info.uname
		dict_3.color = UserModel.getPotentialColor(dynamicInfo.info.figure)
		table.insert(text_arr, dict_3)
		--
		local dict_4 = {}
		dict_4.text = m_i18nString(3636) --"成功，成为了"
		dict_4.color = i18nColor
		table.insert(text_arr, dict_4)


		--
		local dict_5 = {}
		dict_5.text = GuildDataModel.getGildName()
		dict_5.color = contentNameColor
		table.insert(text_arr, dict_5)

				--
		local dict_6 = {}
		dict_6.text = m_i18nString(3637) --[3637] = "的新任联盟会长！",
		dict_6.color = i18nColor
		table.insert(text_arr, dict_6)

	elseif(m_type == 105)then
		-- 职位任命
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.info.uname
		dict_1.color = UserModel.getPotentialColor(dynamicInfo.info.figure)
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3638)  --"被军l联盟长"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
		-- 名字
		local dict_3 = {}
		dict_3.text = dynamicInfo.user.uname
		dict_3.color = userNameColor
		table.insert(text_arr, dict_3)
		--
		local dict_4 = {}
		dict_4.text = m_i18nString(3639) --"任命为副联盟长"
		dict_4.color = i18nColor
		table.insert(text_arr, dict_4)
	elseif(m_type == 106)then
		-- 建筑升级
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3640) --"将"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)

		-- 建筑
		local dict_3 = {}
		dict_3.text = buildingArr[tonumber(dynamicInfo.info.upgrade.type)]
		dict_3.color = contentNameColor
		table.insert(text_arr, dict_3)
		--
		local dict_4 = {}
		dict_4.text = m_i18nString(3641) --"从"
		dict_4.color = i18nColor
		table.insert(text_arr, dict_4)
		-- 旧等级
		local dict_5 = {}
		dict_5.text = dynamicInfo.info.upgrade.oldLevel
		dict_5.color = contentNameColor
		table.insert(text_arr, dict_5)
		--
		local dict_6 = {}
		dict_6.text = m_i18nString(3642) --"级升到了"
		dict_6.color = i18nColor
		table.insert(text_arr, dict_6)
		-- 新等级
		local dict_7 = {}
		dict_7.text = dynamicInfo.info.upgrade.newLevel
		dict_7.color = contentNameColor
		table.insert(text_arr, dict_7)
		--
		local dict_8 = {}
		dict_8.text = m_i18nString(3643) --"级"
		dict_8.color = i18nColor
		table.insert(text_arr, dict_8)
	elseif(m_type == 107)then
		-- 转让军团长
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3644) --"将联盟长转让给了"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
		-- 名字
		local dict_3 = {}
		dict_3.text = dynamicInfo.info.uname
		dict_3.color = UserModel.getPotentialColor(dynamicInfo.info.figure)
		table.insert(text_arr, dict_3)
	elseif(m_type == 108)then
		-- 喝咖啡
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		logger:debug(dict_1)
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(3645) --"参拜关公殿获得了"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)
	elseif(m_type == 109)then
		-- 贡献
		-- 名字
		local dict_1 = {}
		dict_1.text = dynamicInfo.user.uname
		dict_1.color = userNameColor
		table.insert(text_arr, dict_1)
		--
		local dict_2 = {}
		dict_2.text = m_i18nString(1405 )  --"消耗"
		dict_2.color = i18nColor
		table.insert(text_arr, dict_2)

		-- 数量
		local num_text = 0
		local contribute_info = dynamicInfo.info.contribute
		if(contribute_info.silver and tonumber(contribute_info.silver)>0 )then
			num_text = contribute_info.silver ..  m_i18nString(1520) --贝里
		elseif(contribute_info.gold and tonumber(contribute_info.gold)>0 )then
			num_text = contribute_info.gold .. m_i18nString(2220)    --金币
		end
		local dict_3 = {}
		dict_3.text = num_text
		dict_3.color = contentNameColor
		table.insert(text_arr, dict_3)
		--
		local dict_4 = {}
		dict_4.text = m_i18nString(3646) --"增加了"
		dict_4.color = i18nColor
		table.insert(text_arr, dict_4)
		--
		local dict_5 = {}
		dict_5.text = contribute_info.exp
		dict_5.color = contentNameColor
		table.insert(text_arr, dict_5)
		--
		local dict_6 = {}
		dict_6.text = m_i18nString(3647) --"建设度，"
		dict_6.color = i18nColor
		table.insert(text_arr, dict_6)
		--
		local dict_7 = {}
		dict_7.text = m_i18nString(3648) --"获得了"
		dict_7.color = i18nColor
		table.insert(text_arr, dict_7)
		--
		local dict_8 = {}
		dict_8.text = contribute_info.point
		dict_8.color = contentNameColor
		table.insert(text_arr, dict_8)
		--
		local dict_9 = {}
		dict_9.text = m_i18nString(3649) --"个人贡献"
		dict_9.color = i18nColor
		table.insert(text_arr, dict_9)

	end

	return text_arr
end
