PlaySkill = class();

function PlaySkill:ctor()
	self.class = PlaySkill;
	self.battleProxy = nil;
	self.attackLoopFcuntion = nil
	self.attackDelayBack = nil;
	--self.battleScene = nil;
	self.battleProxy = nil;
	require "main.view.battleScene.function.ScreenShake"
	require "main.controller.command.battleScene.battle.battlefield.BattleUtils"
end

function PlaySkill:initData(aiEngin,battleUnitID)
	self.unitID = battleUnitID;
  	self.battleProxy = aiEngin.battleProxy;
  	self.aiEngin = aiEngin;
end

function PlaySkill:initScriptData(battleUnitID,battleProxy)
	self.unitID = battleUnitID;
  	self.battleProxy = battleProxy
end

function PlaySkill:setBeAttackPaowuxian(beAttackPaowuxian)
    self.beAttackPaowuxian = beAttackPaowuxian or 0;
end

function PlaySkill:setIsForceDead(isForceDead,isNeedCheckDead)
	self.isForceDead = isForceDead
	self.isNeedCheckDead = isNeedCheckDead
end

function PlaySkill:removeSelf()
	self.class = nil;
end

function PlaySkill:dispose()
	self.attackDelayBack = nil;
	self.battleProxy = nil;
	self.aiEngin = nil
	self:removeColorHandleTimer()
	self:removeSelf();
end

-- function PlaySkill:changeHPAction(roleVO)
	-- 算伤害,有二个地方数字
	-- self.aiEngin:changeHPAction()
	-- local totalHurt = roleVO:getCurrHp() <= 0 and roleVO.playSkillNeedNum or roleVO.changeValue
	-- local tableData = {unitID = self.unitID,hurtNum = totalHurt}
	--self.battleScene:dispatchEvent(Event.new("UnitID_Hurt",tableData));
-- end

-- 播放组合动作--
function PlaySkill:playAttack(tableData,_backFun,faceDirect,flag)
	local roleVO = self.battleProxy.battleGeneralArray[self.unitID];
	local a1Data 
	local a2Data 
	local a3Data 
	local a4Data 
	local a5Data 
	local a6Data
	local a7Data
	local a8Data
	local a9Data
	local a10Data
	self.bodySourceID = roleVO.battleIcon:getBodySourceID()
	if(nil == tableData) then
		return
	else
		if(nil == flag) then
			a1Data = tableData[1]
			a2Data = tableData[2]
			a3Data = tableData[3]
			a4Data = tableData[4]
			a5Data = tableData[5]
			a6Data = tableData[6]
			a7Data = tableData[7]
			a8Data = tableData[8]
			a9Data = tableData[9]
			a10Data = tableData[10]

		else
			a1Data = tableData[1]
			a2Data = tableData[2]
			a3Data = tableData[3]
			a4Data = tableData[4]
			a5Data = tableData[5]
			a6Data = tableData[6]
			a7Data = tableData[7]
			a8Data = tableData[8]
			a9Data = tableData[9]
			a10Data = tableData[10]	 
		end
	end
	-- 回调10
	local function funTen()
	  	self:playAction(_backFun,roleVO,faceDirect,flag,a10Data,nil,nil)
	end	  
	-- 回调9
	local function funNine()
	    self:playAction(_backFun,roleVO,faceDirect,flag,a9Data,a10Data,funTen)
	end
	-- 回调8
	local function funEight()
	    self:playAction(_backFun,roleVO,faceDirect,flag,a8Data,a9Data,funNine)
	end
	-- 回调7
	local function funSeven()
	    self:playAction(_backFun,roleVO,faceDirect,flag,a7Data,a8Data,funEight)
	end
	-- 回调6
	local function funSix()
	    self:playAction(_backFun,roleVO,faceDirect,flag,a6Data,a7Data,funSeven)
	end
	-- 回调5
	local function funFive()
	    self:playAction(_backFun,roleVO,faceDirect,flag,a5Data,a6Data,funSix)
	end 
	-- 回调4
	local function funFour()
		self:playAction(_backFun,roleVO,faceDirect,flag,a4Data,a5Data,funFive)
	end
	-- 回调3
	local function funThree()
	 	self:playAction(_backFun,roleVO,faceDirect,flag,a3Data,a4Data,funFour)
	end
	-- 回调2
	local function funTwo()
	   self:playAction(_backFun,roleVO,faceDirect,flag,a2Data,a3Data,funThree)
	end
	self:playAction(_backFun,roleVO,faceDirect,flag,a1Data,a2Data,funTwo)
end

function PlaySkill:playAction(_backFun,roleVO,faceDirect,flag,playData,nextData,localFun)
	if not playData then localFun() return end
	if not roleVO.battleIcon.bodyIcon.sprite then _backFun() return end
	roleVO.battleIcon:setActionScale(1);
	if flag then
		self:beAttackColor(roleVO)
	end
	local faceParam = 1
	if faceDirect == true then
		faceParam = -1
	end
	if not roleVO.isBattleScript and roleVO:getCurrHp() <= 0 then return _backFun() end
	roleVO.battleIcon:stopAllActions();
	if(nil ~= playData) then 
	    --攻击
	    local actionID = playData["attackActionID"]
	    local actionMoveX = playData["actionMoveX"]
	    local actionMoveY = playData["actionMoveY"]
	    local actionIDTime = playData["attackActionTime"]
	    local actionLoopParam = playData["actionLoop"]
	    local effectID = playData["attackEffectID"]
		local effectMoveX = playData["attackEffectX"]
	    local effectMoveY = playData["attackEffectY"]
	    local effectIDTime = playData["attackEffectTime"]
	    local effectLoopParam = playData["effectLoop"]
	    local effectX = playData["effectX"]
	    local effectY = playData["effectY"]
	    local effectBack = playData["isBack"]
	    local timeDelay = playData["delayTime"]
	    local isAttack = playData["isAttack"]
		local isTexie = playData["isTexie"]
		local effectDelayTime = playData["effectDelayTime"]
	    local zhenping = playData["zhenping"]
		local animateSpeed = playData["actionJiasu"]	
	    
		local effectScale = playData["effectScale"]
		local effectAnimateSpeed = playData["effectAnimateSpeed"]
		local soundEffect= playData["soundEffect"] 
		local slowObjectArray,slowBodyAnimate,slowWeaponAnimate;

	    -- 如果没有设置动作，只设置了时间，说明为帧延迟，此时时间为毫秒
	    if(actionID == 0) then
	      return
	    else
			-- 震屏 特写相关
			self:screenStuff(roleVO,isTexie,zhenping,flag)
			if(actionLoopParam == nil or actionLoopParam == 0 ) then
				actionLoopParam = 1
			end				
			local callBackBoo
            if flag and actionID == BattleConfig.PAO_WU_XIAN then
                local backFun = nextData and localFun or _backFun
                if actionID == BattleConfig.PAO_WU_XIAN then
                    roleVO.battleIcon:hitPaowuxianAnimation(roleVO,faceParam,actionMoveX,actionMoveY,-1.6*2,backFun,self.beAttackPaowuxian,roleVO.coordinateY,self)
                end
                callBackBoo = true 
			elseif(0 ~= actionMoveX or 0 ~= actionMoveY) then
				-- 这时候的时间是动画播放的倍速
				local rate
				if (0 == actionIDTime or nil == actionIDTime) then
					rate = 0.5 
				else
					if actionIDTime >= 10 then
						rate = actionIDTime / 1000
					else
						rate = 0.5 / actionIDTime 
					end
				end

				local x
				if (0 ~= actionMoveX) then
					if flag then
					  	if roleVO.booleanValue == 1 then
					  		x = actionMoveX
					  	else
					  		x = 0;
					  	end
				  	else
				  		x = actionMoveX
				  	end
				else
				  	x = 0
				end

				local y
				if (0 ~= actionMoveY) then
					if flag then 
					  	if roleVO.booleanValue == 1 then
					  		y = actionMoveY
					  	else
					  		y = 0;
					  	end
				  	else
				  		y = actionMoveY
				  	end
				else
				  	y = 0
				end
				local spawnTwoArray = CCArray:create();
				local ccB = ccBezierConfig:new()
                if (x >= 0 and y >= 0) or (x <= 0 and y <= 0) then
                  ccB.controlPoint_1 = ccp(0,y/2)
                  ccB.controlPoint_2 = ccp(faceParam * x/2,y*1.5)
                else
                  ccB.controlPoint_1 = ccp(faceParam * x/2,0)
                  ccB.controlPoint_2 = ccp(faceParam * x,y/2)   
                end
                local downY = 0;
                if flag then
                	downY = -y/2
                end
                ccB.endPosition = ccp(faceParam * x,downY)
                local jumpUp = CCBezierBy:create(rate,ccB);
                spawnTwoArray:addObject(jumpUp); 
                if flag then
                	spawnTwoArray:addObject(CCMoveTo:create(0, ccp(roleVO.battleIcon:getPositionX(),roleVO.coordinateY))); 
                end   		
				spawnTwoArray:addObject(CCDelayTime:create(timeDelay/1000));
				if(nil == nextData) then
					spawnTwoArray:addObject(CCCallFunc:create(_backFun));
				else
					spawnTwoArray:addObject(CCCallFunc:create(localFun));
				end
				callBackBoo = true
				roleVO.battleIcon:runAction(CCSequence:create(spawnTwoArray));
			end

	   		if actionID ~= BattleConfig.PAO_WU_XIAN and actionID ~= BattleConfig.CHONG_CI then
		   		local animCache = CCAnimationCache:sharedAnimationCache();
				local standAnimation = animCache:animationByName(self.bodySourceID.."_"..actionID);
				if standAnimation == nil then -- 如果取不到素材默认播普通被击，也不播放飞行动作，一般给击飞和击倒用 4，7
					standAnimation = animCache:animationByName(self.bodySourceID.."_"..3);
				end
				if not standAnimation and GameData.isCheckRoleSource then 
					log(self.bodySourceID.."_"..actionID.."_There is no"..self.unitID)
					return;
				end
			    if animateSpeed and animateSpeed ~= 0 then
				    roleVO.battleIcon:setActionScale(animateSpeed);
			    end      
	  			local animate=CCAnimate:create(standAnimation);
	  			local array = CCArray:create();
				for i = 1,actionLoopParam do
					array:addObject(animate)
				end		  
				if not callBackBoo then
					array:addObject(CCDelayTime:create(timeDelay/1000));
					if(nil == nextData) then
						array:addObject(CCCallFunc:create(_backFun));
					else
						array:addObject(CCCallFunc:create(localFun));    
					end			  
				end
				slowBodyAnimate = standAnimation;
		        roleVO.battleIcon.bodyIcon:stopAllActions();
		        roleVO.battleIcon.bodyIcon:runAction(CCSequence:create(array));  
	        end
		end
	    -- 特效相关
	    if(effectID ~= nil and effectID ~= "#") then
				self:actionEffectHandler(roleVO,faceDirect,roleVO.battleIcon,effectID,effectLoopParam,effectMoveX,effectMoveY,effectIDTime,effectX,effectY,effectBack,effectDelayTime,effectScale,effectAnimateSpeed,flag)
	    end
	    if soundEffect ~= nil and soundEffect~= "#" then
              self:palySoundEffect(soundEffect)
        end
  	end
end

function PlaySkill:palySoundEffect(soundEffect)
	local soundEffectArr = StringUtils:lua_string_split(soundEffect,"?")
	for k1,v1 in pairs(soundEffectArr) do
		local splitArr = StringUtils:lua_string_split(v1,",");
		if 1 == #splitArr then
			MusicUtils:playEffect(splitArr[1],false)
		else
			local delayEffectFunction
			local function deleySoundEffect()
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)
				MusicUtils:playEffect(splitArr[2],false)
			end
			if splitArr[1] then
				delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleySoundEffect, splitArr[1] / 1000, false)
			end
		end
	end
end

function PlaySkill:beAttackColor(roleVO)
	if not roleVO.battleIcon then return;end;
	if not roleVO.battleIcon.sprite then return;end;
	roleVO.battleIcon:setHighLight(true)
	self:removeColorHandleTimer()
	local function setBeattackColor()
		self:removeColorHandleTimer()
        if roleVO.battleIcon then
        	roleVO.battleIcon:setHighLight(false)
    		if self.aiEngin then
    			self.aiEngin:addEffectAction(roleVO)
    		end
        end
	end
	self.setBeattackColor = Director:sharedDirector():getScheduler():scheduleScriptFunc(setBeattackColor, 0.3, false)
end

function PlaySkill:removeColorHandleTimer()
	if self.setBeattackColor then
    	Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.setBeattackColor);
    	self.setBeattackColor = nil;
    end
end

function PlaySkill:actionEffectHandler(roleVO,faceDirect,battleIcon,effectID,effectLoopParam,effectMoveX,effectMoveY,effectIDTime,effectX,effectY,effectBack,effectDelayTime,effectScale,effectAnimateSpeed,flag)
	local directPram = 1
	if faceDirect then
		directPram = -1
	end
	if(effectX == nil) then
		effectX = 0
	end
	if(effectY == nil) then
		effectY = 0
	end          
    --只有特效ID,说明是叠在身上放的  有位移的特效放在战场里播ccspawn
	  local effectIDArr = StringUtils:lua_string_split(effectID,"?")
	  local effectLoopArr = StringUtils:lua_string_split(effectLoopParam,"?")
	  local effectXArr = StringUtils:lua_string_split(effectX,"?")
	  local effectYArr = StringUtils:lua_string_split(effectY,"?")
	  local effectBackArr = StringUtils:lua_string_split(effectBack,"?")
	  local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?")
	  local effectScaleArr = StringUtils:lua_string_split(effectScale,"?")
	  local effectAnimateSpeedArr = StringUtils:lua_string_split(effectAnimateSpeed,"?")
	  for k,v in pairs(effectIDArr) do
		local effectSigalLoop
		local effectSigalX
		local effectSigalY
		local effectBackSingal
		local effectDelayTimeSingal
		local effectScaleSingal
		local effectAnimateSpeedSingal

		if(effectLoopArr[k] == nil or effectLoopArr[k] == "#" or effectLoopArr[k] == "") then
			effectSigalLoop = 1
		else
			effectSigalLoop = effectLoopArr[k]
		end

		if(effectXArr[k] == nil or effectXArr[k] == "#" or effectXArr[k] == "") then
			effectSigalX = 0
		else
			effectSigalX = effectXArr[k]
		end

		if(effectYArr[k] == nil or effectYArr[k] == "#" or effectYArr[k] == "" or effectYArr[k] == "0") then
			effectSigalY = 0
		else
			effectSigalY = effectYArr[k]
		end			

		if(effectBackArr[k] == nil or effectBackArr[k] == "#" or effectBackArr[k] == "" or effectBackArr[k] == "0") then
			effectBackSingal = nil
		else
			effectBackSingal = effectBackArr[k]
		end
		if(effectDelayTimeArr == nil or effectDelayTimeArr[k] == nil or effectDelayTimeArr[k] == "#" or effectDelayTimeArr[k] == "") then
			effectDelayTimeSingal = 0
		else
			effectDelayTimeSingal = effectDelayTimeArr[k]
		end			
			
		if(effectScaleArr[k] == nil or effectScaleArr[k] == "#" or effectScaleArr[k] == "" or effectScaleArr[k] == "0") then
			effectScaleSingal = 2
		else
			effectScaleSingal = effectScaleArr[k]
		end			
		
		if(effectAnimateSpeedArr[k] == nil or effectAnimateSpeedArr[k] == "#" or effectAnimateSpeedArr[k] == "") then
			effectAnimateSpeedSingal = 0
		else
			effectAnimateSpeedSingal = effectAnimateSpeedArr[k]
		end							
	    local delayEffectFunction
	    local function deleyPlayEffect()
	        if(nil~=delayEffectFunction) then
	          Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
	          delayEffectFunction = nil
	        end

			local effectIcon
			local battleIconTemp = battleIcon;
			local function removeEffect1()
				battleIconTemp:getEffectIcon():removeChild(effectIcon)
				effectIcon = nil
				battleIconTemp = nil
			end       

	        effectIcon = cartoonPlayer(v,effectSigalX * directPram,effectSigalY,effectSigalLoop,removeEffect1,effectScaleSingal,directPram,effectBackSingal)
	        effectIcon:setAnchorPoint(CCPointMake(0.5,0.1))
	        battleIconTemp:getEffectIcon():addChild(effectIcon);
	        BattleUtils:playEffectYinxiao(v)
	    end

	    -- "特效延迟"
	    if(nil==delayEffectFunction) then
	      delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, effectDelayTimeSingal / 1000, false)
	    end			
	  end
end

-- "格子特效"
function PlaySkill:geziAction(flyTable,positionArray,standPoint)
        
    local effectID = flyTable["effectID"]
    local effectX = flyTable["effectX"]
    local effectY = flyTable["effectY"] 
    local effectDelayTime = flyTable["effectDelayTime"]
    local texiaoYanchi = flyTable["texiaoYanchi"]
    local effectScale = flyTable["effectScale"]
    if(effectID == nil or effectID == "#") then 
      return
    end
    local faceParam = 1
    if faceDirect then
      faceParam = -1
    end        
    local pointNum = 1
    local effectIDArr = StringUtils:lua_string_split(effectID,"?")  
    local effectXArr = StringUtils:lua_string_split(effectX,"?")
    local effectYArr = StringUtils:lua_string_split(effectY,"?")
    local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?")
    local texiaoYanchiArr = StringUtils:lua_string_split(texiaoYanchi,"?")

    local effectScaleArr = StringUtils:lua_string_split(effectScale,"?")  
    for k,v in pairs(effectIDArr) do
    
          local delayEffectFunction

        local effectDelayTimeSingal
        local effectSigalX
        local effectSigalY      
        local x
        local y
        
        if(effectXArr[k] == nil or effectXArr[k] == "#" or effectXArr[k] == "") then
          effectSigalX = 0
        else
          effectSigalX = effectXArr[k]
        end
        
        if(effectYArr[k] == nil or effectYArr[k] == "#" or effectYArr[k] == "") then
          effectSigalY = 0
        else
          effectSigalY = effectYArr[k]
        end

        x = effectMoveX
        y = 0
        
        if(effectDelayTimeArr[k] == nil or effectDelayTimeArr[k] == "#" or effectDelayTimeArr[k] == "") then
          if (texiaoYanchiArr[k] == nil or texiaoYanchiArr[k] == "#" or texiaoYanchiArr[k] == "") then
            effectDelayTimeSingal = 0
          else
            effectDelayTimeSingal = tonumber(texiaoYanchiArr[k])
          end
        else
          effectDelayTimeSingal = tonumber(effectDelayTimeArr[k])
        end 
          
        local effectScaleSingal = 2
        effectAnimateSpeedSingal = 0

        if(effectScaleArr[k] == nil or effectScaleArr[k] == "#" or effectScaleArr[k] == "") then
          effectScaleSingal = 2
        else
          effectScaleSingal = tonumber(effectScaleArr[k])
        end     

        local delayEffectFunction
        local function deleyPlayEffect()
            if(nil~=delayEffectFunction) then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
              delayEffectFunction = nil
            end
            local effectIcon  
            local function removeEffect1()
            	if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS) then
                	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(effectIcon)
                end
            end   
            effectIcon = cartoonPlayer(v,effectSigalX,effectSigalY,1,removeEffect1,effectScaleSingal,nil,nil)
            effectIcon:setAnchorPoint(CCPointMake(0.5,0.1));

           if(effectDelayTimeArr[k] == nil or effectDelayTimeArr[k] == "#" or effectDelayTimeArr[k] == "") then
              effectIcon:setPositionXY(positionArray.x+effectSigalX-GameData.uiOffsetX,positionArray.y+effectSigalY)
           else
              local position = positionArray[pointNum]
              if position then
                effectIcon:setPositionXY(position.x+effectSigalX-GameData.uiOffsetX,position.y+effectSigalY)
                pointNum = pointNum + 1
              end
           end
           if standPoint == 1 then
           		effectIcon:setScaleX(-1)
           end
           effectIcon.name = BattleConfig.Is_Fly_Effect
           if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS) then
           		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):addChild(effectIcon)
           end
           BattleUtils:playEffectYinxiao(v)
        end
        -- "特效延迟"
        if(nil==delayEffectFunction) then
          delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, effectDelayTimeSingal / 1000, false)
        end
    end 
end

------无双技能的全屏特效
function PlaySkill:quanpingEffectHandler(skillTable,faceDirect,roleVO,typyP)
	local quanpingEffect = skillTable["quanpingEffect"]
	local quanpingtexiaoPositionX = skillTable["quanpingtexiaoPositionX"]
	local quanpingtexiaoPositionY = skillTable["quanpingtexiaoPositionY"]
	local quanpingLoop = skillTable["quanpingLoop"]
	local quanpingEffectBack = skillTable["quanpingEffectBack"]
	local quanpingEffectSuofang = skillTable["quanpingEffectSuofang"]
	local quanpingEffectJiasu = skillTable["quanpingEffectJiasu"]
	local zhenpingYanchi = skillTable["zhenpingYanchi"]

	if quanpingEffect == nil or quanpingEffect == "#" or quanpingEffect == "" then
		return
	end

	local effectIDArr = StringUtils:lua_string_split(quanpingEffect,"?")
	local effectXArr = StringUtils:lua_string_split(quanpingtexiaoPositionX,"?")
	local effectYArr = StringUtils:lua_string_split(quanpingtexiaoPositionY,"?")
	local quanpingLoopArr = StringUtils:lua_string_split(quanpingLoop,"?")		  
	local quanpingEffectBackArr = StringUtils:lua_string_split(quanpingEffectBack,"?")
	local quanpingEffectSuofangArr = StringUtils:lua_string_split(quanpingEffectSuofang,"?")
	local quanpingEffectJiasuArr = StringUtils:lua_string_split(quanpingEffectJiasu,"?")	
	local zhenpingYanchiArr = StringUtils:lua_string_split(zhenpingYanchi,"?")
	local effectLayerUp = self:getQuanpingSprite(faceDirect,"up")
	local effectLayerDown = self:getQuanpingSprite(faceDirect,"down")

	for k,v in pairs(effectIDArr) do

		local effectSigalLoop
		local effectSigalX
		local effectSigalY
		local effectBackSingal
		local effectSuofangSingal
		local effectJiasuSingal
		local zhenpingYanchiSingal

		if(quanpingLoopArr[k] == nil or quanpingLoopArr[k] == "#" or quanpingLoopArr[k] == "") then
			effectSigalLoop = 1
		else
			effectSigalLoop = quanpingLoopArr[k]
		end

		if(effectXArr[k] == nil or effectXArr[k] == "#" or effectXArr[k] == "") then
			effectSigalX = 0
		else
			effectSigalX = effectXArr[k]
		end

		if(effectYArr[k] == nil or effectYArr[k] == "#" or effectYArr[k] == "") then
			effectSigalY = 0
		else
			effectSigalY = effectYArr[k]
		end			

		if(quanpingEffectBackArr[k] == nil or quanpingEffectBackArr[k] == "#" or quanpingEffectBackArr[k] == "" or quanpingEffectBackArr[k] == "0") then
			effectBackSingal = 0
		else
			effectBackSingal = quanpingEffectBackArr[k]
		end
		if(quanpingEffectSuofangArr[k] == nil or quanpingEffectSuofangArr[k] == "#" or quanpingEffectSuofangArr[k] == "") then
			effectSuofangSingal = 1
		else
			effectSuofangSingal = quanpingEffectSuofangArr[k]
		end
		if(quanpingEffectJiasuArr[k] == nil or quanpingEffectJiasuArr[k] == "#" or quanpingEffectJiasuArr[k] == "") then
			effectJiasuSingal = 0
		else
			effectJiasuSingal = quanpingEffectJiasuArr[k]
		end		

		if(zhenpingYanchiArr[k] == nil or zhenpingYanchiArr[k] == "#" or zhenpingYanchiArr[k] == "") then
			zhenpingYanchiSingal = 0
		else
			zhenpingYanchiSingal = zhenpingYanchiArr[k]
		end	
		local function removeEffect()
			if effectBackSingal == 0 then
			  	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(effectLayerUp);
			else
				sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(effectLayerDown);
			end
		end

        local delayEffectFunction
        local function deleyPlayEffect()
            if(nil~=delayEffectFunction) then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
              delayEffectFunction = nil
            end
            local standPoint;
            for key,buv in pairs(roleVO:getAttackTargets()) do
		        standPoint = buv.standPoint;
		        break
		    end
		    local offsetX = 0
		    if standPoint == BattleConfig.Battle_StandPoint_2 and roleVO.standPoint == BattleConfig.Battle_StandPoint_2 and typyP == 3 then--友方
		    	offsetX = 320
		    end
            local effectIcon = cartoonPlayer(v,effectSigalX - offsetX,effectSigalY-70,effectSigalLoop,removeEffect,effectSuofangSingal,1,nil)
            
            if effectJiasuSingal ~= 0 then
              setEffectActionScale(effectIcon,effectJiasuSingal)
            end
            
            if effectBackSingal == 0 then
	            effectLayerUp:addChild(effectIcon)
	        else
	        	effectLayerDown:addChild(effectIcon)
        	end
        end

        -- "特效延迟"
        if(nil==delayEffectFunction) then
          delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, zhenpingYanchiSingal / 1000, false)
        end
	end	
end

function PlaySkill:getQuanpingSprite(faceDirect,flag)
	local quanpingEffectIcon    
	local winSize = Director:sharedDirector():getWinSize();
	local effectSprite1 = CCSprite:create();
	quanpingEffectIcon = Sprite.new(effectSprite1);
	quanpingEffectIcon:setAnchorPoint(CCPointMake(0.5,0.5));
	quanpingEffectIcon:setPositionXY(winSize.width / 2,winSize.height / 2,true)
	quanpingEffectIcon:setScaleX(faceDirect and -1 or 1)
	if flag == "up" then
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(quanpingEffectIcon);
	else
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(quanpingEffectIcon);
	end
	return quanpingEffectIcon
end

-- 特写 震屏相关
function PlaySkill:screenStuff(roleVO,isTexie,zhenping,flag)
		-- 震屏
		if zhenping ~= nil and zhenping~= "#" and zhenping ~= "" then
			
			local zhenpingArr = StringUtils:lua_string_split(zhenping,"?")
			local zhenpingDelayTime = 0
			local zhenpingType
			
			local delayShakeFunctionID
			local function delayShakeFunction()
				if delayShakeFunctionID then
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayShakeFunctionID)  
				end
				ScreenShake:shakeStart(zhenpingType)
			end
			
			if zhenpingArr and zhenpingArr[1] and zhenpingArr[1] ~= "" then
				zhenpingDelayTime = tonumber(zhenpingArr[1])			
			end
			if zhenpingArr and zhenpingArr[2] and zhenpingArr[2] ~= "" then
				zhenpingType = tonumber(zhenpingArr[2])			
			end	
			delayShakeFunctionID = Director:sharedDirector():getScheduler():scheduleScriptFunc(delayShakeFunction, zhenpingDelayTime / 1000, false)
		end
	end

