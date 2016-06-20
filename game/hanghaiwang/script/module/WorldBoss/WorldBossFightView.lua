-- FileName: WorldBossFightView.lua
-- Author: zhangqi
-- Date: 2015-01-29
-- Purpose: 世界Boss的攻击界面
--[[TODO List]]

-- module("WorldBossFightView", package.seeall)

require "db/DB_Worldbossinspire"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local mWorldModel = WorldBossModel
local mDBWorldBase = DB_Worldbossinspire.getDataById(1)
local mNTU = TimeUtil
local mRand = math.random
local mUser = UserModel
local mSN = ShowNotice
local mLayRoot
local _tColor = {
	normal1 = ccc3(0x28, 0x00, 0x00),
	normal2 = ccc3(0xff, 0x00, 0x00),
}

WorldBossFightView = class("WorldBossFightView")

function WorldBossFightView:ctor(layRoot)
	self.layMain = m_fnGetWidget(layRoot, "LAY_FIGHTING")
	mLayRoot = self.layMain
	self.isChanging = false
	UIHelper.registExitAndEnterCall(self.layMain, function () self:stopScheduler() end)

	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = "images/effect/mubiao/mubiao.ExportJson",
		animationName = "mubiao",
		loop = -1,
	})
	--m_arAni1:setAnchorPoint(ccp(0.42,0.2))
	mLayRoot.IMG_EFFECT:addNode(m_arAni1,100)

	self.addPercent = 1
	self.addAttrName = ""
	local pArray = string.split(mDBWorldBase.inspireArr or "", "|")
	if(tonumber(pArray[1])) then
		-- 鼓舞效果的名字
		self.addAttrName = DB_Affix.getDataById(pArray[1]).displayName
	end
	if(tonumber(pArray[2])) then
		-- 鼓舞增加的百分比
		self.addPercent = tonumber(pArray[2])/100
	end

	local ptab = DB_Vip.Vip
	for i=1,table.count(ptab) do
		local pDb = DB_Vip.getDataById(i)
		if(pDb) then
			local pOpenLv = tonumber(pDb.openWorldbossBirth) or 0
			if(not self.openBirth and pOpenLv == 1) then
				self.openBirth = pDb.level
			end
			pOpenLv = tonumber(pDb.worldbossAutoAttack) or 0
			if(not self.openAuto and pOpenLv == 1) then
				self.openAuto = pDb.level
			end
			if(self.openAuto and self.openBirth) then
				break
			end
		end
	end
end

function WorldBossFightView:addScheduler( ... )
	local function updateCallBack( cbFlag, dictData, bRet )
		self:updateBossAtk(cbFlag, dictData, bRet)
	end
	--更新BOSS
	self.pushUpdate = RequestCenter.re_bossUpdate(updateCallBack)
	-- 注册app从后台切回前台的全局 Notify Observer, 重新计算倒计时的总秒数，避免受schedul被暂停的影响	
	self.unregFightNotify = GlobalNotify.addObserverForForeground(
		"WorldBossFightView", 
		function ( ... )
			logger:debug("WorldBossFightView:initFightView-applicationWillEnterForeground recv")
			self:setEndCount()
		end
	)
	
	self.gsUpdateName = "WorldBossFightView-updateEndTimer"
	GlobalScheduler.addCallback(self.gsUpdateName,
		function ( ... )
			self:updateEndTimer() 
		end)
end

function WorldBossFightView:stopScheduler( ... )
	if (self.unregFightNotify) then
		self.unregFightNotify()
		self.unregFightNotify = nil
	end
	logger:debug("WorldBossFightView:stopFightScheduler")
	if(self.gsUpdateName) then
		GlobalScheduler.removeCallback(self.gsUpdateName)
		self.gsUpdateName = nil
	end
	if(self.pushUpdate) then
		Network.remove_re_rpc(self.pushUpdate)
		self.pushUpdate = nil
	end
end

function WorldBossFightView:updateLableNum( label , num , _isNotChange)
	if(not label or not num) then
		return false , 0
	end
	local pNum = num or 1
	local _, now = mNTU.getServerDateTime()
	local strTime, bExpire , strSec = mNTU.expireTimeString(now, num)
	if (bExpire) then
		label:setVisible(false)
	else
		label:setVisible(true)
		label:setText(strTime)
		if(not _isNotChange)then
			pNum = pNum - 1
		end
	end
	return bExpire , strSec , pNum
end

function WorldBossFightView:fnGoToWait()
	if(self.isChanging) then
		logger:debug("wm----isChanging")
		return
	end
	logger:debug("wm----to Changed")
	self.isChanging = true
	self:stopScheduler()
	RequestCenter.boss_over(function ( cbFlag, dictData, bRet )
		logger:debug(dictData)
		if (bRet and tonumber(dictData.ret.is_expired) == 0) then 	-- bug:有时候is_expired = 1,所以boss结束界面不会弹出(原因:前端时间快了)
			mWorldModel.setBossOverInfo(dictData.ret)
			GlobalNotify.postNotify(mWorldModel.MSG.BOSS_PLAY_DEATH)
		end
		logger:debug("wm----change to wait")
		--MainWorldBossCtrl.create(false, 1)	-- false：打开bosswin界面
		
	end, Network.argsHandlerOfTable({1}))
end

function WorldBossFightView:updateEndTimer( ... )

	-- 后端是否推送来的死讯
	local pOver = mWorldModel.fnIsBossOver()
	if(pOver) then
		logger:debug("wm----boss over")
		self:fnGoToWait()
		return
	end
	-- 当前是否血量为0
	if(self.m_enterInfo.hp == 0) then
		logger:debug("wm----hp == 0")
		self:fnGoToWait()
	end
	local pBool, strSec = false , 0
	--end倒计时
	local _, nowSvr = mNTU.getServerDateTime()	-- 当前服务器时间
	local bossInfo = self.m_enterInfo
	local passSec = nowSvr - (bossInfo.start_time or 0) - 2 	-- 开始了多久了
	self.EndCount = mWorldModel.getDuration() - passSec
	-- yucong -- 手动+1，防止前后比后端结束快
	local countdown = WorldBossModel.getCloseCountdown() --+ 1
	if(countdown == 0) then
		logger:debug("wm----time over")
		self.labEndTimer:setVisible(false)
		self:fnGoToWait()
		return
	end
	self.labEndTimer:setText(countdown)
	self.labEndTimer:setVisible(true)
	--攻击cd倒计时
	local atkCountdown = WorldBossModel.getAttackCountdown()
	if (atkCountdown == 0) then
		mLayRoot.TFD_CD:setVisible(false)
		mLayRoot.TFD_CD_INFO:setVisible(false)
		mLayRoot.IMG_EFFECT:setVisible(true)
		if (self.isAuto) then
			self:fnAttackBoss(true)
		end
	else
		mLayRoot.TFD_CD:setText(atkCountdown)
		mLayRoot.TFD_CD:setVisible(true)
		mLayRoot.TFD_CD_INFO:setVisible(true)
		mLayRoot.IMG_EFFECT:setVisible(false)
	end
	-- yucong --
	local attEndTime = bossInfo.last_attack_time + tonumber(mDBWorldBase.cd) - nowSvr

	--贝里鼓舞cd倒计时
	local inspireCountdown = WorldBossModel.getSilverInspireCountdown()
	self.labBelInsTimer:setText(inspireCountdown)
	self.labBelInsTimer:setVisible(true)
	if (inspireCountdown == 0) then
		self.labBelInsTimer:setVisible(false)
	end
end

function WorldBossFightView:setEndCount( ... )
	-- 贝里鼓舞
	local inspireCountdown = WorldBossModel.getSilverInspireCountdown()
	self.labBelInsTimer:setText(inspireCountdown)
	self.labBelInsTimer:setVisible(true)
	if (inspireCountdown == 0) then
		self.labBelInsTimer:setVisible(false)
	end
	-- 结束倒计时
	local countdown = WorldBossModel.getCloseCountdown()
	self.labEndTimer:setText(countdown)
	self.labEndTimer:setVisible(true)
	-- 攻击倒计时
	local atkCountdown = WorldBossModel.getAttackCountdown()
	if (atkCountdown == 0) then
		mLayRoot.TFD_CD:setVisible(false)
		mLayRoot.TFD_CD_INFO:setVisible(false)
		mLayRoot.IMG_EFFECT:setVisible(true)
	else
		mLayRoot.TFD_CD:setText(atkCountdown)
		mLayRoot.TFD_CD:setVisible(true)
		mLayRoot.TFD_CD_INFO:setVisible(true)
		mLayRoot.IMG_EFFECT:setVisible(false)
	end
end

--检查是否可以鼓舞，type -- 1.金币，2.贝利
function WorldBossFightView:checkCanInspire( type )
	local pInspireCount = tonumber(self.m_enterInfo.inspire) or 0
	local pMax = tonumber(mDBWorldBase.maxLv) or 20
	if(pInspireCount >= pMax) then
		mSN.showShellInfo(m_i18n[6002]) -- 鼓舞次数已达上限
		return false
	end
	local pCost = tonumber(mDBWorldBase.inspireGold) or 10
	local pNowHave = mUser.getGoldNumber()
	local pStr = m_i18n[6003] -- "金币不足，无法鼓舞"
	if(type == 2) then
		pCost = tonumber(mDBWorldBase.inspireSilver) or 1000
		pNowHave = mUser.getSilverNumber()
		pStr = m_i18n[6004] -- "贝里不足，无法鼓舞"
	end

	if(pNowHave < pCost) then
		mSN.showShellInfo(pStr)
		return false
	end
	if(type == 2) then
		--local nowSvr = mNTU.getSvrTimeByOffset(0)
		--local pCD = tonumber(mDBWorldBase.inspireCd) or 0
		--local inspireEndTime = (self.m_enterInfo.inspire_time_silver or 0) + pCD
		local inspireCountdown = WorldBossModel.getSilverInspireCountdown()
		if(inspireCountdown ~= 0) then
			mSN.showShellInfo(m_i18n[6005]) -- "鼓舞冷却中，请稍等"
			return false
		end
	end
	return true
end

--更新鼓舞的信息
function WorldBossFightView:updateInspireInfo( isAdd )

	local pNum = self.addPercent * self.m_enterInfo.inspire
	if(isAdd) then
		self.m_enterInfo.inspire = self.m_enterInfo.inspire + 1
		local pTable = {m_i18n[6006].."，" ,"", "+", "", "%"}
		pNum = pNum + self.addPercent
		pTable[2] = tostring(self.addAttrName)
		pTable[4] = tostring(self.addPercent)
		mSN.showShellInfo(table.concat(pTable,""))
	end

	-- 鼓舞加成百分比
	local pTable = {"+" , "" , "%"}
	pTable[2] = tostring(pNum)
	local pText = table.concat(pTable,"")
	mLayRoot.TFD_INSPIRE_NUM:setText(pText)
	UIHelper.labelNewStroke(mLayRoot.TFD_INSPIRE_NUM, _tColor.normal1, 2)
end

-- 金币鼓舞
function WorldBossFightView:fnInspireByGold()
	if(not self:checkCanInspire(1)) then
		return
	end
	RequestCenter.boss_inspireByGold(function ( cbFlag, dictData, bRet )
		logger:debug("WorldBossModel-inspireByGold")
		logger:debug(dictData)
		if (bRet) then
			local pCost = tonumber(mDBWorldBase.inspireGold) or 10
			mUser.addGoldNumber(0-pCost)
			self:updateInspireInfo(true)
		else
			mSN.showShellInfo(m_i18n[6007]) -- 鼓舞失败
		end
	end, Network.argsHandlerOfTable({1}))
end

-- 贝利鼓舞
function WorldBossFightView:fnInspireBySilver()
	if(not self:checkCanInspire(2)) then
		return
	end
	RequestCenter.boss_inspireBySilver(function ( cbFlag, dictData, bRet )
		logger:debug("WorldBossModel-inspireByGold")
		logger:debug(dictData)
		if (bRet) then
			if(dictData.ret.success == "true") then
				self:updateInspireInfo(true)
			else
				mSN.showShellInfo(m_i18n[6007])
			end
			local pCost = tonumber(mDBWorldBase.inspireSilver) or 1000
			mUser.addSilverNumber(0-pCost)
			self.m_enterInfo.inspire_time_silver = tonumber(dictData.ret.time)
			self:setEndCount()
		else
			mSN.showShellInfo(m_i18n[6007])
		end
	end, Network.argsHandlerOfTable({1}))
end

--更新复活花费
function WorldBossFightView:fnUpdateReviveInfo( ... )
	local btnReborn = mLayRoot.BTN_REBORN -- 复活按钮
	local labRebornCost = m_fnGetWidget(btnReborn, "TFD_REBORN_COST") -- 复活花费
	local pNum = tonumber(mDBWorldBase.rebirthBaseGold) or 10
	local pPlus = tonumber(mDBWorldBase.rebirthGrowGold) or 10
	local pCost = pNum + pPlus*(self.m_enterInfo.revive or 0)
	labRebornCost:setText(pCost)
	local pflags = tonumber(self.m_enterInfo.flags) or 0
	if(pflags == 1) then
		self.m_enterInfo.last_attack_time = 0
	end
	return pCost
end

-- 复活
function WorldBossFightView:fnRevive( )
	local countdown = WorldBossModel.getCloseCountdown()
	-- 结束
	if(countdown == 0) then
		return
	end
	local pOpenVL = tonumber(self.openBirth) or 0
	if(pOpenVL > mUser.getVipLevel()) then
		local pTable = {"VIP ", "", m_i18n[4007]}
		pTable[2] = tostring(pOpenVL)
		mSN.showShellInfo(table.concat(pTable,""))
		return
	end

	local pCost = self:fnUpdateReviveInfo()
	if(pCost > mUser.getGoldNumber()) then
		mSN.showShellInfo(m_i18n[6008])--"金币不足，无法复活"
		return
	end
	local atkCountdown = WorldBossModel.getAttackCountdown()
	if(atkCountdown == 0) then
		mSN.showShellInfo(m_i18n[6009])--"玩家未cd"
		return
	end
	local pflags = tonumber(self.m_enterInfo.flags) or 0
	if(pflags == 1) then
		return
	end

	RequestCenter.boss_revive(function ( cbFlag, dictData, bRet )
		logger:debug("WorldBossModel-revive")
		logger:debug(dictData)
		if (bRet) then
			self.m_enterInfo.flags = 1
			mSN.showShellInfo(m_i18n[6010])--"复活成功，清除战斗冷却"
			mUser.addGoldNumber(0-pCost)
			self.m_enterInfo.revive = self.m_enterInfo.revive + 1
			self:fnUpdateReviveInfo()

			-- if(self.isAuto) then
			-- 	self:fnAttackBoss(true)
			-- end
		end
	end, Network.argsHandlerOfTable(self.m_enterInfo.boss_id))
end

-- 攻击
function WorldBossFightView:fnAttackBoss(isNotEnterFight)
	if(self.isAtting) then
		return
	end
	local pOver = mWorldModel.fnIsBossOver()
	if(pOver) then
		return
	end
	local atkCountdown = WorldBossModel.getAttackCountdown()
	if(atkCountdown ~= 0) then
		mSN.showShellInfo(m_i18n[6011])--"攻击冷却中，请稍等。"
		return
	end
	
	self.isAtting = true
	RequestCenter.boss_attackBoss(function ( cbFlag, dictData, bRet )
		logger:debug("WorldBossModel-attackBoss")
		logger:debug(dictData.ret)
		self.isAtting = false
		local pInfo = dictData.ret
		if (bRet) then
			if(pInfo and pInfo.success == "true") then
				self:updateBossHp(pInfo.hp)
				self.m_enterInfo.flags = 0
				self:updateSelfAtk(true,pInfo.attack_hp,pInfo.rank)
				self.m_enterInfo.last_attack_time = tonumber(pInfo.time)
				self:setEndCount()
				local pNowBoss = mWorldModel.getActvieBossDb()
				local rate = OutputMultiplyUtil.getMultiplyRateNum(5)
				local pAddSilver = tonumber(pNowBoss.attackSilver)*mUser.getHeroLevel()
				pAddSilver = math.floor(pAddSilver * rate / 10000)
				local pAddRestige = tonumber(pNowBoss.attackRestige)
				pAddRestige = math.floor(pAddRestige * rate / 10000)
				mUser.addSilverNumber(pAddSilver)
				mUser.addPrestigeNum(pAddRestige)
				-- 自动攻击不进入战斗
				if(not isNotEnterFight) then
					local pData = {pInfo.bossAtkHp,pAddSilver,pAddRestige}
					logger:debug("enterfight")
					-- 战斗完回到boss界面
					local function fnBackToBoss( ... )
						local pOver = mWorldModel.fnIsBossOver()
						if(pOver) then
							logger:debug("wm----fight back over")
							self:fnGoToWait()
						else
							self:setEndCount()
							self:addScheduler()
						end
					end
					self:stopScheduler()
					require "script/battle/BattleModule"
					local dbBoss = mWorldModel.getActvieBossDb()
					BattleModule.PlayBossRecord(dbBoss.stronghold, 1, pInfo.fight_ret, fnBackToBoss, pData)
					GlobalNotify.postNotify(WorldBossModel.MSG.BOSS_ENTER_BATTLE)
				else
					logger:debug("showNotice")
					local pOver = mWorldModel.fnIsBossOver()
					if(pOver or tonumber(pInfo.hp) == 0) then
						logger:debug("wm----atk hp == 0")
						self:fnGoToWait()
						return
					end

					local pDictData = {ret = {hp = pInfo.hp, uname = pInfo.uname , bossAtkHp = pInfo.bossAtkHp}}
					-- 显示推送的伤害
					self:updateBossAtk(nil , pDictData , true)
				end
			end
		end
	end, Network.argsHandlerOfTable(self.m_enterInfo.boss_id))
end

--自动战斗
function WorldBossFightView:fnAutoAtt( ... )
	local pOpenVL = tonumber(self.openAuto) or 0
	if(pOpenVL > mUser.getVipLevel()) then
		local pTable = {"VIP ", "", m_i18n[4007]}
		pTable[2] = tostring(pOpenVL)
		mSN.showShellInfo(table.concat(pTable,""))
		return
	end
	if(self.isAuto) then
		self.isAuto = false
		UIHelper.titleShadow(self.btnAuto , m_i18n[6012])--"自动挑战"
	else
		self.isAuto = true
		UIHelper.titleShadow(self.btnAuto , m_i18n[6013])--"取消自动"
		local atkCountdown = WorldBossModel.getAttackCountdown()
		if(atkCountdown == 0) then
			self:fnAttackBoss(true)
		end
	end
end

--刷新boss血量信息
function WorldBossFightView:updateBossHp( hp )
	if(hp) then
		self.m_enterInfo.hp = tonumber(hp)
	end
	--local labHp = m_fnGetWidget(mLayRoot, "TFD_BLOOD") -- 血量数字显示
	--labHp:setText(self.m_enterInfo.hp .. "/" .. self.m_enterInfo.boss_maxhp)
	local loadHp = m_fnGetWidget(mLayRoot, "LOAD_BOSS") -- 血槽
	loadHp:setPercent(self.m_enterInfo.hp/self.m_enterInfo.boss_maxhp*100) -- (当前血量/最大血量)*100
end

--推送随机伤害显示
function WorldBossFightView:updateBossAtk( cbFlag, dictData, bRet )
	if(bRet) then
		local pInfo = dictData and dictData.ret or nil
		logger:debug("wm----showBossAtkInfo")
		logger:debug(pInfo)
		if(pInfo and pInfo.hp and pInfo.uname and pInfo.bossAtkHp) then
			local pID = tonumber(pInfo.uid) or 0
			if(pID == UserModel.getUserUid()) then
				return
			end
			--local layPlayer = m_fnGetWidget(mLayRoot, "IMG_FIGHT") -- 随机显示其他玩家伤害的layout, 区域
			--WorldBossModel.setDamageInfo(pInfo)
			----[[
			local imgLayer = m_fnGetWidget(mLayRoot, "img_dps_bg") -- 随机显示其他玩家伤害的信息
			imgLayer:setZOrder(10000)
			self:updateBossHp(pInfo.hp)
			local pLayer = imgLayer:clone()
			pLayer:setVisible(true)
			local pname = m_fnGetWidget(pLayer, "TFD_NAME") 
			pname:setText(tostring(pInfo.uname))
			-- UIHelper.labelNewStroke(pname, _tColor.normal1, 2) -- 2016-3-11描边又注掉了
			local patkhp = m_fnGetWidget(pLayer, "LAY_NEW_DPS") 
			local num = WorldBossModel.getRedNumber(pInfo.bossAtkHp)
			num:setAnchorPoint(ccp(0.5, 0.5))
			num:setPosition(ccp(0, patkhp:getContentSize().height/2))
			patkhp:addNode(num)
			logger:debug("hp sizeX:"..tostring(patkhp:getContentSize().width).." sizeY:"..tostring(patkhp:getContentSize().height))
			--patkhp:setText(tostring(pInfo.bossAtkHp))
			local pRandX = mRand(self.dpsInfo[1],self.dpsInfo[3])
			local pRandY = mRand(self.dpsInfo[2],self.dpsInfo[4])
			pLayer:setPosition(ccp(pRandX,pRandY))
			pLayer:setScale(0.1)
			mLayRoot.LAY_PLAYER_DPS:addChild(pLayer)
			local actionArray = CCArray:create()
			-- 1
			actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(1/85, 0.75), CCFadeTo:create(1/85, 0)))

			-- 2
			actionArray:addObject(CCFadeTo:create(1/85, 0.5))

			-- 关键帧 3         位移Y 7       比例 86             透明度 100
			local arr = CCArray:create()
			arr:addObject(CCScaleTo:create(1/85, 0.86))
			arr:addObject(CCFadeTo:create(1/85, 1))
			arr:addObject(CCMoveBy:create(1/85, ccp(0,7 * g_fScaleY)))
			actionArray:addObject(CCSpawn:create(arr))

			-- 关键帧 12        位移Y 68      比例 175            透明度 100
			actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(9/85,1.75),
			                          CCMoveBy:create(9/85,ccp(0,51 * g_fScaleY))))

			-- 关键帧 13        位移Y 70      比例 175            透明度 100
			actionArray:addObject(CCMoveBy:create(1/85,ccp(0,2 * g_fScaleY)))

			-- 关键帧 20        位移Y 87      比例 90             透明度 100
			actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(7/85,1),
			                          CCMoveBy:create(7/85,ccp(0,15 * g_fScaleY))))

			-- 关键帧 55        位移Y 87      比例 90             透明度 100
			actionArray:addObject(CCDelayTime:create(35/85))

			-- 关键帧 65        位移Y 87      比例 30             透明度 0
			actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(10/85,0.4),
			                            CCFadeTo:create(10/85,0)))

			actionArray:addObject(CCCallFuncN:create(function(sender)
		    	sender:removeFromParentAndCleanup(true)
			end))
            local pSeq = CCSequence:create(actionArray)
			pLayer:runAction(pSeq)
			--]]
			GlobalNotify.postNotify(mWorldModel.MSG.BOSS_PLAY_ACTION)
		end
	end
end

--更新自己的攻击信息
function WorldBossFightView:updateSelfAtk( isAdd , attack_hp , atk_rank)
	if(isAdd) then
		self.m_enterInfo.attack_num = self.m_enterInfo.attack_num + 1
	end
	if(attack_hp) then
		self.m_enterInfo.attack_hp = attack_hp 
	end
	if(atk_rank) then
		self.m_enterInfo.atk_rank = atk_rank 
	end

	local layRoot = mLayRoot
	local bossInfo = self.m_enterInfo
	-- 玩家伤害数值显示区域
	--local layFightInfo = m_fnGetWidget(layRoot, "LAY_FIGHT_INFO")

	--local i18n_dps_times = m_fnGetWidget(layDps, "tfd_times")
	--i18n_dps_times:setText("已攻击")

	--local labDpsNum = m_fnGetWidget(layDps, "TFD_TIMES_NUM") -- 已攻击总次数
	--labDpsNum:setText(bossInfo.attack_num)

	--local i18n_dps = m_fnGetWidget(layDps, "tfd_dps")
	--i18n_dps:setText("次，总攻击伤害")

	-- 总攻击伤害
	layRoot.TFD_DPS_NUM:setText(bossInfo.attack_hp)
	UIHelper.labelNewStroke(layRoot.TFD_DPS_NUM, _tColor.normal1, 2)
	layRoot.TFD_DPS_NUM:updateSizeAndPosition()

	local pPercentNum = (bossInfo.attack_hp/bossInfo.boss_maxhp)*100 or 0
	pPercentNum = string.format("%.2f", pPercentNum) 
	if(tonumber(pPercentNum) == 0) then
		pPercentNum = 0
	end
	-- 总攻击伤害百分比
	layRoot.TFD_DPS_PERCENT:setText("("..pPercentNum .. "%)") -- 总攻击伤害/(总血量-当前血量)*100
	layRoot.TFD_DPS_PERCENT:setPositionX(layRoot.TFD_DPS_NUM:getPositionX() + layRoot.TFD_DPS_NUM:getContentSize().width)	--重置位置，防止覆盖
	UIHelper.labelNewStroke(layRoot.TFD_DPS_PERCENT, _tColor.normal1, 2)
	layRoot.TFD_RANK_NOW:setText(m_i18n[2204])	-- 当前排名
	UIHelper.labelNewStroke(layRoot.TFD_RANK_NOW, _tColor.normal1, 2)
	local prank = tonumber(bossInfo.atk_rank) or m_i18n[1093]	-- "无"
	prank = prank == 0 and m_i18n[1093] or prank
	-- 当前排名
	layRoot.TFD_RANK_NUM:setText(prank)
	UIHelper.labelNewStroke(layRoot.TFD_RANK_NUM, _tColor.normal1, 2)

	layRoot.TFD_END:setText(m_i18n[6014])--"结束倒计时："
	layRoot.tfd_dps:setText(m_i18n[6037])--"总伤害："
	layRoot.TFD_INSPIRE:setText(m_i18n[6019])--"鼓舞伤害加成："
	UIHelper.labelNewStroke(layRoot.TFD_END, _tColor.normal1, 2)
	UIHelper.labelNewStroke(layRoot.tfd_dps, _tColor.normal1, 2)
	UIHelper.labelNewStroke(layRoot.TFD_INSPIRE, _tColor.normal1, 2)
end

function WorldBossFightView:fnAddAtkView( ... )
	require "script/module/WorldBoss/WorldBossAtkView"
	local view = (WorldBossAtkView:new()):create()
	LayerManager.addLayoutNoScale(view)
end

function WorldBossFightView:initView( enterInfo )
	logger:debug("WorldBossFightView:initFightView")
	--boss信息
	self.m_enterInfo = enterInfo
	local bossInfo = self.m_enterInfo
	local layRoot = mLayRoot
	local pflags = tonumber(self.m_enterInfo.flags) or 0
	
	self:updateBossHp()

	self.labEndTimer = m_fnGetWidget(layRoot, "TFD_COUNTDOWN") -- 结束倒计时
	self.labEndTimer:setVisible(false)
	UIHelper.labelNewStroke(self.labEndTimer, _tColor.normal1, 2)
	-- local strTime, bExpire = mNTU.expireTimeString( self.endCount )
	-- self.labEndTimer:setText(strTime)

	local layPlayer = m_fnGetWidget(layRoot, "LAY_PLAYER_DPS") -- 随机显示其他玩家伤害的layout, 区域
	local imgLayer = m_fnGetWidget(layPlayer, "img_dps_bg") -- 随机显示其他玩家伤害的信息
	self.dpsInfo = {0,0,0,0}
	local pSizeA = layPlayer:getSize()
	local pSizeB = imgLayer:getSize()
	imgLayer:setPositionType(POSITION_ABSOLUTE)
	self.dpsInfo[1] = pSizeB.width*0.5 --minx
	self.dpsInfo[2] = pSizeB.height*0.5 --miny
	self.dpsInfo[3] = pSizeA.width - pSizeB.width*0.5 --maxx
	self.dpsInfo[4] = pSizeA.height - pSizeB.height --maxy
	imgLayer:setVisible(false)


	local btnBelIns = m_fnGetWidget(layRoot, "BTN_BELLY_INSPIRE") -- 贝里鼓舞按钮
	btnBelIns:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(self.isChanging) then
				return
			end
			self:fnInspireBySilver()
		end
	end)
	self.labBelInsTimer = m_fnGetWidget(btnBelIns, "TFD_INSPIRE_TIME") -- 贝里鼓舞CD
	self.labBelInsTimer:setVisible(false)
	btnBelIns:setTouchEnabled(not self.labBelInsTimer:isVisible())
	UIHelper.labelNewStroke(self.labBelInsTimer, _tColor.normal1, 2)
	local labBellyNum = m_fnGetWidget(layRoot, "TFD_BELLY_NUM") -- 贝里鼓舞花费
	labBellyNum:setText(mDBWorldBase.inspireSilver or "1000")

	local btnGoldIns = m_fnGetWidget(layRoot, "BTN_GOLD_INSPIRE") -- 金币鼓舞按钮
	btnGoldIns:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(self.isChanging) then
				return
			end
			self:fnInspireByGold()
		end
	end)
	local labGoldNum = m_fnGetWidget(layRoot, "TFD_GOLD_NUM") -- 金币鼓舞花费
	labGoldNum:setText(mDBWorldBase.inspireGold or "10")

	self:updateSelfAtk()
	self:updateInspireInfo()


	self.btnAuto = layRoot.BTN_AUTO -- 自动挑战按钮
	UIHelper.titleShadow(self.btnAuto , m_i18n[6012])
	self.isAuto = false
	self.btnAuto:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(self.isChanging) then
				return
			end
			self:fnAutoAtt()
		end
	end)

	-- 复活按钮
	layRoot.BTN_REBORN:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(self.isChanging) then
				return
			end
			self:fnRevive()
		end
	end)
	local i18n_reborn = m_fnGetWidget(layRoot.BTN_REBORN, "tfd_reborn")
	i18n_reborn:setText(m_i18n[6020])
	UIHelper.labelNewStroke(i18n_reborn, g_FontInfo.strokeColor, 2)
	self:fnUpdateReviveInfo()

	-- 攻击按钮
	layRoot.BTN_ATTACK:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if(self.isChanging) then
				return
			end
			self:fnAttackBoss()
		end
	end)

	layRoot.TFD_CD_INFO:setText(m_i18n[6021])--"攻击倒计时："
	self.labAttCD = layRoot.TFD_CD -- 攻击cd
	self.labAttCD:setVisible(false)
	UIHelper.labelNewStroke(self.labAttCD, _tColor.normal2, 3)
	UIHelper.labelNewStroke(layRoot.TFD_CD_INFO, _tColor.normal2, 3)
	layRoot.TFD_CD_INFO:setVisible(false)
	-- 结束倒计时的秒数
	self:setEndCount()
	self:stopScheduler()
	self:addScheduler()
	self.layMain:setEnabled(true)

	GlobalNotify.addObserver(mWorldModel.MSG.BOSS_POP_DAMADGE, function ( ... )
		self:fnMSG_BOSS_POP_DAMADGE()
	end, false, mWorldModel.MSG.BOSS_POP_DAMADGE)
end

function WorldBossFightView:fnMSG_BOSS_POP_DAMADGE( ... )
	local pInfo = WorldBossModel.getDamageInfo()
	if (pInfo) then
		local atkHp = math.floor(tonumber(pInfo.bossAtkHp) / pInfo.maxnum)	-- 不取整的话小数点无法显示
		local imgLayer = m_fnGetWidget(mLayRoot, "img_dps_bg") -- 随机显示其他玩家伤害的信息
		imgLayer:setZOrder(10000)
		self:updateBossHp(pInfo.hp)
		local pLayer = imgLayer:clone()
		pLayer:setVisible(true)
		local pname = m_fnGetWidget(pLayer, "TFD_NAME") 
		pname:setText(tostring(pInfo.uname))
		-- UIHelper.labelNewStroke(pname, _tColor.normal1, 2) -- 2016-3-11描边又注掉了
		local patkhp = m_fnGetWidget(pLayer, "LAY_NEW_DPS") 
		local num = WorldBossModel.getRedNumber(tostring(atkHp))--(pInfo.bossAtkHp)
		num:setAnchorPoint(ccp(0.5, 0.5))
		num:setPosition(ccp(0, patkhp:getContentSize().height/2))
		patkhp:addNode(num)
		local pRandX = mRand(self.dpsInfo[1], self.dpsInfo[3])
		local pRandY = mRand(self.dpsInfo[2],self.dpsInfo[4])
		pLayer:setPosition(ccp(pRandX,pRandY))
		pLayer:setScale(0.1)
		mLayRoot.LAY_PLAYER_DPS:addChild(pLayer)
		--mLayRoot.LAY_PLAYER_DPS:setBackGroundColorType(LAYOUT_COLOR_SOLID)
		--mLayRoot.LAY_PLAYER_DPS:setBackGroundColor(ccc3(255, 0, 0))
		local actionArray = CCArray:create()
		-- 1
		actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(1/85, 0.75), CCFadeTo:create(1/85, 0)))

		-- 2
		actionArray:addObject(CCFadeTo:create(1/85, 0.5))

		-- 关键帧 3         位移Y 7       比例 86             透明度 100
		local arr = CCArray:create()
		arr:addObject(CCScaleTo:create(1/85, 0.86))
		arr:addObject(CCFadeTo:create(1/85, 1))
		arr:addObject(CCMoveBy:create(1/85, ccp(0,7 * g_fScaleY)))
		actionArray:addObject(CCSpawn:create(arr))

		-- 关键帧 12        位移Y 68      比例 175            透明度 100
		actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(9/85,1.75),
		                          CCMoveBy:create(9/85,ccp(0,51 * g_fScaleY))))

		-- 关键帧 13        位移Y 70      比例 175            透明度 100
		actionArray:addObject(CCMoveBy:create(1/85,ccp(0,2 * g_fScaleY)))

		-- 关键帧 20        位移Y 87      比例 90             透明度 100
		actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(7/85,1),
		                          CCMoveBy:create(7/85,ccp(0,15 * g_fScaleY))))

		-- 关键帧 55        位移Y 87      比例 90             透明度 100
		actionArray:addObject(CCDelayTime:create(35/85))

		-- 关键帧 65        位移Y 87      比例 30             透明度 0
		actionArray:addObject(CCSpawn:createWithTwoActions(CCScaleTo:create(10/85,0.4),
		                            CCFadeTo:create(10/85,0)))

		actionArray:addObject(CCCallFuncN:create(function(sender)
	    	sender:removeFromParentAndCleanup(true)
		end))

	    local pSeq = CCSequence:create(actionArray)
		pLayer:runAction(pSeq)

		pInfo.num = pInfo.num - 1
		if (pInfo.num == 0) then
			pInfo = nil
		end
		WorldBossModel.setDamageInfo(pInfo)
	end
end
