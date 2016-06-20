-- FileName: AwakeWinView.lua
-- Author: LvNanchun
-- Date: 2015-11-17
-- Purpose: function description of module
--[[TODO List]]

AwakeWinView = class("AwakeWinView")

-- UI variable --

-- module local variable --
local ANIMATION_TIME = 0.3
-- 每一行的图标数
local ROW_NUM = 4
local _fnGetWidget = g_fnGetWidgetByName
local _i18nString = gi18nString

function AwakeWinView:moduleName()
    return "AwakeWinView"
end

function AwakeWinView:ctor( tbInfo )
	self._layMain = g_fnLoadUI("ui/dcopy_win.json")
	-- 初始化战斗力，贝里和经验的数值
	self._layMain.TFD_ZHANDOULI_NUM:setText("0")
	self._layMain.TFD_MONEY_NUM:setText("0")
	self._layMain.TFD_EXP_NUM:setText("0")
	-- 战斗力贝里经验的条隐藏
	self._layMain.LAY_EFFECT1:setVisible(false)
	-- 经验条初始化
	self._layMain.TFD_LV:setText(tostring(tbInfo.level) .. "级")
	self._layMain.TFD_EXP:setText(tostring(tbInfo.nowExp) .. "/" .. tostring(tbInfo.needExp))
	local expPercent = intPercent(tbInfo.nowExp, tbInfo.needExp)
	self._layMain.LOAD_EXP_BAR:setPercent((expPercent > 100) and 100 or expPercent)
	-- max图标
	self._layMain.IMG_MAX:setVisible(false)

	-- 初始化全局的变量供其他函数使用
	self._tbViewInfo = {}
	self._tbViewInfo.level = tbInfo.level
	self._tbViewInfo.nowExp = tbInfo.nowExp
	self._tbViewInfo.needExp = tbInfo.needExp
	self._tbViewInfo.fightNum = tbInfo.fightNum
	self._tbViewInfo.strongHoldName = tbInfo.strongHoldName
	self._tbViewInfo.score = tbInfo.score
	self._tbViewInfo.beginAddReward = tbInfo.beginAddReward
	self._tbViewInfo.silver = tbInfo.silver
	self._tbViewInfo.exp = tbInfo.exp
	self._tbViewInfo.reward = tbInfo.reward
	self._tbViewInfo.bUpLevel = tbInfo.bUpLevel

	-- 用于计时器的临时变量
	self._tmpExp = 0
	-- 计算翻到第几张卡
	self._tmpCard = 0

	-- 设置格式
	-- 奖励物品四个字
	UIHelper.labelNewStroke( self._layMain.tfd_reward, ccc3(0x49,0x00,0x00), 3 )
	-- 据点名字
	UIHelper.labelNewStroke( self._layMain.TFD_NAME, ccc3(0x80,0x00,0x00), 3 )
	-- 经验条上的经验值
	UIHelper.labelNewStroke( self._layMain.TFD_EXP, ccc3(0x28,0x00,0x00), 2 )

end

--更新贝里
function AwakeWinView:updateSilverNumber()
	--labSilverNum:setText(tostring(m_tbReward.silver or 0))
	local labSilverNum = self._layMain.TFD_MONEY_NUM
	local number = tonumber(labSilverNum:getStringValue())
	local silveNumber = tonumber(self._tbViewInfo.silver)
	if(number ~= nil and number < silveNumber)then
		number = number + math.ceil(silveNumber/ANIMATION_TIME/30)
		labSilverNum:setText(tostring(number))
	else
		labSilverNum:setText(tostring(silveNumber))
		self._silverSche()
		self._silverSche = nil

		if ((not self._silverSche) and (not self._expBarSche) and (not self._expNumSche)) then
			self._layMain:setTouchEnabled(true)
		end
	end
end
--更新经验数字
function AwakeWinView:updateExpNumber()
	local labExpNum = self._layMain.TFD_EXP_NUM
	local number = tonumber(labExpNum:getStringValue())
	local expNumber = tonumber(self._tbViewInfo.exp)
	if(number ~= nil and number < expNumber)then
		number = number + math.ceil(expNumber/ANIMATION_TIME/30)
		labExpNum:setText(tostring(number))
	else
		labExpNum:setText(tostring(expNumber))
		self._expNumSche()
		self._expNumSche = nil

		if ((not self._silverSche) and (not self._expBarSche) and (not self._expNumSche)) then
			self._layMain:setTouchEnabled(true)
		end
	end
end
-- 更新经验条
function AwakeWinView:updateExpLine()
	--print("updateExpLine!")
	local expNumber = tonumber(self._tbViewInfo.exp)

	if(self._tmpExp < expNumber and expNumber > 0) then

		local tbUserInfo = UserModel.getUserInfo()
		local tUpExp = DB_Level_up_exp.getDataById(2)
		local nCurLevel = tonumber(tbUserInfo.level) -- 当前等级
		local nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 下一等级需要的经验值
		local nExpNum = tonumber(self._tbViewInfo.nowExp) -- 当前的经验值

		self._tmpExp  =  self._tmpExp + expNumber/ANIMATION_TIME/30
		self._tmpExp = (self._tmpExp > expNumber) and expNumber or self._tmpExp

		local nNewExpNum = (nExpNum + self._tmpExp)
		-- logger:debug("lastExp = " .. nExpNum .. " addExp = " .. m_expChangeNumber .. " nextExp = " .. nLevelUpExp .. " newExp = " .. nNewExpNum)

		local bLvUp = (nExpNum + self._tmpExp) >= nLevelUpExp; -- 获得经验后是否升级


		nCurLevel = bLvUp and (nCurLevel + 1) or nCurLevel
		if(bLvUp == true) then
			nNewExpNum = nNewExpNum - tUpExp["lv_" .. nCurLevel]
			self._layMain.TFD_LV:setText(_i18nString(4366, nCurLevel))
		end



		nLevelUpExp = tUpExp["lv_" .. (nCurLevel+1)] -- 重新计算下一等级需要的经验值，作为分母

		--最高级别
		local maxLevel  = UserModel.getUserMaxLevel()
		if(nCurLevel >= maxLevel) then
			nNewExpNum = 0
			self._tmpExp = expNumber
			--stopScheduler(SchedulerType.ExpBar_Scheduler)
		end

		--去掉小数点
		nNewExpNum =  math.floor(nNewExpNum)

		local expString = nNewExpNum .. "/" .. nLevelUpExp
		self._layMain.TFD_EXP:setText(expString)
		-- labnExpDom:setStringValue(nLevelUpExp)

		local nPercent = intPercent(nNewExpNum, nLevelUpExp)
		self._layMain.LOAD_EXP_BAR:setPercent((nPercent > 100) and 100 or nPercent)

	else
		self._expBarSche()
		self._expBarSche = nil
		self:addExpAfterCardAndExp(1)
		self:setMaxLevelUI()

		if ((not self._silverSche) and (not self._expBarSche) and (not self._expNumSche)) then
			self._layMain:setTouchEnabled(true)
		end
	end
end

--暂停所有计时器，
function AwakeWinView:stopAllScheduler( ... )
	self._expBarSche()
	self._expNumSche()
	self._silverSche()
	self._expBarSche = nil
	self._expNumSche = nil
	self._silverSche = nil
	self:addExpAfterCardAndExp(1)
	self:setMaxLevelUI()
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
--设置用户达到顶级之后的经验条显示
function AwakeWinView:setMaxLevelUI( ... )
	if (layMain) then
		-- 等级
		local userLevel = UserModel.getUserInfo().level
		local maxUserLevel = UserModel.getUserMaxLevel()

		self._layMain.TFD_LV:setText(m_i18nString(4366, userLevel))

		if(tonumber(userLevel) >= maxUserLevel) then
			self._layMain.TFD_EXP:setEnabled(false)

			self._layMain.IMG_MAX:setEnabled(true)
			self._layMain.LOAD_EXP_BAR:setPercent(100)
		end
	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
--只有在翻牌结束并且经验计时器都走完了之后才会执行升级逻辑
function AwakeWinView:addExpAfterCardAndExp(addtype)
	self._tmpCard = self._tmpCard + 1
	if (addtype==1) then
		UserModel.addExpValue(tonumber(self._tbViewInfo.exp or 0),"dobattle")
		self:setMaxLevelUI()
	end
	if(self._tmpCard >= 2) then
		LayerManager.removeLayoutByName("copy_result_layout")
		if(self._tbViewInfo.bUpLevel) then
			performWithDelay(self._layMain,
				function()
					require "script/module/public/GlobalNotify"
					GlobalNotify.postNotify(GlobalNotify.LEVEL_UP,createTreasureNotice(BattleMainData.extra_rewardRet))
				end,
				0.1)
			
		end	

		self._layMain:setTouchEnabled(true)
		-- layMain:setEnabled(true)
		-- btnShare:setTouchEnabled(true)
	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
--翻牌关键帧的逻辑调用（关键帧之后破防下一个item的动画
function AwakeWinView:playNextFrameEffect( bone, frameEventName, originFrameIndex, currentFrameIndex)
	if (frameEventName == "1") then 
		AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
		local tbDropItem = self._tbViewInfo.reward
		--掉落物品名字
	    local labName  =  tbDropItem[self.tmpCardIndex].labName
	    labName:setVisible(true)
	    --掉落物品的标识（伙伴碎片，装备碎片）
	    local imgFlag = tbDropItem[self.tmpCardIndex].imgFlag	
	    if(imgFlag) then
	    	imgFlag:setVisible(true)
	    end
	    local btnItem = tbDropItem[self.tmpCardIndex].btnItem
	    btnItem:setTouchEnabled(true)
	    self.tmpCardIndex = self.tmpCardIndex + 1

		if(self.tmpCardIndex == 1) then
   			effectNode:getBone("win_drop_3"):addDisplay(itemImage, 0) -- 替换 关键帧
 			self:addExpAfterCardAndExp()
		else
			logger:debug("掉落物品的动画波到最后一个了")
		end

	end
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function AwakeWinView:setListView( tbItemDrop )
	local listView = self._layMain.LSV_TOTAL

	-- 四个以上的时候listView可以滑动
	listView:setTouchEnabled((#tbItemDrop > 4))
	UIHelper.initListView(listView)

	logger:debug({tbItemDrop = tbItemDrop})

	for i,v in ipairs(tbItemDrop) do
		if (i % 4 == 1) then
			listView:pushBackDefaultItem()
		end
		local cell = listView:getItem( math.floor( (i - 1) / 4 ) )
		local layDrop = _fnGetWidget(cell, "LAY_DROP" .. tostring((i-1)%4+1))

		if (v.disable) then
			layDrop:setVisible(false)
			tbItemDrop[i] = nil
		else
			local imgDrop = _fnGetWidget(cell, "IMG_" .. tostring((i-1)%4+1))
			local tfdName = _fnGetWidget(cell, "TFD_NAME_" .. tostring((i-1)%4+1))

			tfdName:setText(v.dbInfo.name)
			tfdName:setColor(g_QulityColor2[v.dbInfo.quality])
			UIHelper.labelNewStroke( tfdName, ccc3(0x28,0x00,0x00), 2 )

			local btnIcon = ItemUtil.createBtnByTemplateIdAndNumber(v.item_template_id, v.num,function ( sender,eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					PublicInfoCtrl.createItemInfoViewByTid(tonumber(v.item_template_id),v.num)
				end
			end)

			imgDrop:addChild(btnIcon)
			tbItemDrop[i].effectNode = v.fnAddEffect(imgDrop, function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				self:playNextFrameEffect(bone, frameEventName, originFrameIndex, currentFrameIndex)
			end)
			tbItemDrop[i].btnItem = btnIcon
			tbItemDrop[i].labName = tfdName

			btnIcon:setTouchEnabled(false)
			tfdName:setVisible(false)

		end

	end

	logger:debug({tbItemDrop = tbItemDrop})
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function AwakeWinView:playDropItemAction()
	-- 用于存储卡牌的index播放特效
	self.tmpCardIndex = 1
	
	logger:debug({xxxxxxxxxxxxxxxxx = self._tbViewInfo.reward})

	for i,v in ipairs(self._tbViewInfo.reward) do
		local firstEffectNode = v.effectNode
		firstEffectNode:getAnimation():play("win_drop", -1, -1, 0)
		local itemImage =  v.btnItem
	    firstEffectNode:getBone("win_drop_3"):addDisplay(itemImage, 0) -- 替换 

	end

	self:addExpAfterCardAndExp()
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function AwakeWinView:playRewardAction( tbInfo )
	-- 播放滚字效果
	self._expBarSche = GlobalScheduler.scheduleFunc(function ( ... )
		self:updateExpLine()
	end, 0.0)
	self._silverSche = GlobalScheduler.scheduleFunc(function ( ... )
		self:updateSilverNumber()
	end, 0.0)
	self._expNumSche = GlobalScheduler.scheduleFunc(function ( ... )
		self:updateExpNumber()
	end, 0.0)

	-- menghao 战斗评价动画
	local actionArr = CCArray:create()
		
	actionArr:addObject(CCDelayTime:create(0.2))
	--zhangjunwu 战斗评价结束之后开始播放掉落物品的翻牌特效 2014-11-19
	actionArr:addObject(CCCallFunc:create(function ( ... )
		self:playDropItemAction()
	end))

	self._layMain:runAction(CCSequence:create(actionArr))
end

function AwakeWinView:create( tbBtn )
	-- 战斗力设置
	self._layMain.TFD_ZHANDOULI_NUM:setText(tostring(self._tbViewInfo.fightNum))
	-- 据点名字设置
	self._layMain.TFD_NAME:setText(self._tbViewInfo.strongHoldName)

	local tbItemDrop = self._tbViewInfo.reward
	-- 设置物品掉落listview
	self:setListView( tbItemDrop )

	-- 构造战斗胜利动画需要的数据
	local tbStars = {self._layMain.IMG_STAR3_1, self._layMain.IMG_STAR3_2, self._layMain.IMG_STAR3_3}
	local tbWidgets = {self._layMain.LAY_EFFECT1}
	-- 添加战斗胜利动画
	EffBattleWin:new({imgTitle = self._layMain.IMG_TITLE_EFFECT, imgRainBow = self._layMain.IMG_RAINBOW , 
		tbStars=tbStars,
		starLv=self._tbViewInfo.score,							-- TODO
		callback=function ( ... )
			palyPropertyEffect(tbWidgets,self._tbViewInfo.beginAddReward)
		end}
		)

	-- 触摸星星
	self._layMain.LAY_HARD3:setTouchEnabled(true)
	self._layMain.LAY_HARD3:addTouchEventListener(tbBtn.star)

	-- 发送战报
	self._layMain.BTN_REPORT:addTouchEventListener(tbBtn.sendReport)

	self._layMain.LAY_MAIN:setTouchEnabled(true)
	-- 关闭
	self._layMain.LAY_MAIN:addTouchEventListener(tbBtn.close)
	-- 闪光的关闭界面提示
	local armature = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_close.ExportJson",
			animationName = "fadein_close",
			loop = 1,
		})
	self._layMain.IMG_FADEIN_EFFECT:addNode(armature)

	performWithDelay(self._layMain,function()
					local layout = Layout:create()
					layout:setName("copy_result_layout")
					LayerManager.addLayoutNoScale(layout)
				end,
				0.01)

	UIHelper.registExitAndEnterCall( self._layMain,tbBtn.onExitCall,tbBtn.onEnterCall)

	return self._layMain
end

