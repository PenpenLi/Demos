
GameScript = class();

function GameScript:ctor()
	self.class = GameScript;
	self.userProxy = Facade.getInstance():retrieveProxy(UserProxy.name);
	self.heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
	self.scriptStepDataTable = nil
	self.EVENT_1 = 1-- 1.npc显示
	self.EVENT_2 = 2-- 2.npc移动
	self.EVENT_3 = 3-- 3.npc播放技能/动作  参数1攻击 2被攻击默认1
	self.EVENT_4 = 4-- 4.npc出场方式  参数为几种类型 跳等
	self.EVENT_5 = 5
	self.EVENT_6 = 6
	self.EVENT_7 = 7
	self.EVENT_11 = 11-- 11 图片出现 参数为几种类型，下同
	self.EVENT_12 = 12-- 12 图片消失
	self.EVENT_21 = 21-- 21 粒子特效出现 持续性的
	self.EVENT_22 = 22-- 22 粒子特效消失
	self.EVENT_23 = 23-- 23 全屏大特效过场
	self.EVENT_31 = 31-- 31 UI出现
	self.EVENT_32 = 32-- 32 UI消失
	self.EVENT_41 = 41-- 41 押黑对话 目前的押黑 参数放对话内容
	self.EVENT_42 = 42-- 42 泡泡对话 重新做 参数放对话内容，注意长度
	self.EVENT_51 = 51-- 51 震屏 参数为几种类型
	self.EVENT_52 = 52-- 52 全屏从亮渐黑 固定类型
	self.EVENT_53 = 53-- 53 全屏从黑渐亮 固定类型
	self.EVENT_54 = 54-- 54 移屏 参数为几种类型 快速缓动等
	self.EVENT_55 = 55-- 55 黑屏 参数配时间 毫秒
	self.EVENT_61 = 61-- 61 音乐 是否需要格外的音乐
	self.EVENT_71 = 71-- 71 图字出现
	self.EVENT_72 = 72-- 72 图字消失
	self.EVENT_81 = 81-- 81 背景出现
	self.EVENT_82 = 82-- 82 背景消失
	self.EVENT_88 = 88-- 88 结束
	self.EVENT_101 = 101
	self.EVENT_102 = 102
	self.imageFadeTable = {}--图片
	self.roleDataTable = {}--角色
	self.effectDataTable = {}--特效
	self.cacheTable = {}--素材缓存
	self.particleEffectTable = {}
	self.bitmapTextTable = {}
	self.mapBackgroundTable = {}
	self.flagI = 1
	self.battleUnitId = 2000000
end

function GameScript:cleanSelf()
	self.class = nil
end

function GameScript:dispose()
    self:cleanSelf();
end

function GameScript:reSertData()
    self:removeIndexTimer()
	self.imageFadeTable = {}--图片
	self.roleDataTable = {}--角色
	self.effectDataTable = {}--特效
	self.cacheTable = {}--素材缓存
	self.particleEffectTable = {}
	self.mapBackgroundTable = {}
end

function GameScript:beginScript(scriptId)
	self.scriptId = tonumber(scriptId)
	print("scriptId==============="..scriptId)
	self.scriptStepDataTable = analysisByName("Zhanchangjiaoben_Zhanchangjiaoben","id",self.scriptId)
	self:playScriptStep(10)
end

-- 写死的打点，变动就得调整
-- id = 1、14、30、122、151、158、167、176、192
function GameScript:gameScriptDC(stepId)
	if self.scriptId == 101 then
		if stepId == 10 then
			hecDC(2,45)
		elseif stepId == "110" then
			hecDC(2,46)
		elseif stepId == "200" then			
			hecDC(2,47)
		elseif stepId == "295" then			
			hecDC(2,48)		
		elseif stepId == "380" then			
			hecDC(2,49)					
		end
	-- elseif self.scriptId == 102 then
	-- 	if stepId == 1090 then
	-- 		hecDC(2,47)
	-- 	end
	-- elseif self.scriptId == 103 then		
	-- 	if stepId == 260 then
	-- 		hecDC(2,48)
	-- 	end
	-- elseif self.scriptId == 104 then		
	-- 	if stepId == 60 then
	-- 		hecDC(2,49)
	-- 	elseif stepId == 160 then
	-- 		hecDC(2,50)
	-- 	elseif stepId == 260 then			
	-- 		hecDC(2,51)
	-- 	elseif stepId == 999 then	
	-- 		hecDC(2,52)
	-- 	end
	end
end

function GameScript:playScriptStep(stepId)

	print("stepid=============="..stepId)
	self:gameScriptDC(stepId)

	if stepId == "999" or self.isOnTiaoGuo then
		self:endScriptData()
		return
	elseif stepId == "99" then
		self:readyEndScript()
		return
	end
	local singleStepData = self:getStepData(tonumber(stepId))
	self:timerStepLoop(singleStepData)
	local eventId = singleStepData.event
	print("eventId============"..eventId)
	if eventId == self.EVENT_1 then
		self:bornRole(singleStepData,stepId)
	elseif eventId == self.EVENT_2 then
		self:roleRun(singleStepData,stepId)
	elseif eventId == self.EVENT_3 then	
		self:rolePlaySkill(singleStepData,stepId)
	elseif eventId == self.EVENT_5 then
		self:roleLeave(singleStepData)
	elseif eventId == self.EVENT_6 then	
		self:rolePlayBeattack(singleStepData)
	elseif eventId == self.EVENT_7 then	
		self:rolePlayBeattack(singleStepData,"dead")
	elseif eventId == self.EVENT_11 then	
		self:imageFadeIn(singleStepData,stepId)
	elseif eventId == self.EVENT_12 then	
		self:imageFadeOut(singleStepData,stepId)
	elseif eventId == self.EVENT_21 then	
		self:particleEffectIn(singleStepData,stepId)
	elseif eventId == self.EVENT_22 then	
		self:particleEffectOut(singleStepData,stepId)
	elseif eventId == self.EVENT_23 then	
		self:effectPlayOnce(singleStepData,stepId)
	elseif eventId == self.EVENT_41 then
		self:blackDialogue(singleStepData,stepId)
	elseif eventId == self.EVENT_42 then
		self:popDialogue(singleStepData)
	elseif eventId == self.EVENT_52 then	
		self:backGroundLightToDark(singleStepData,stepId)
	elseif eventId == self.EVENT_53 then	
		self:backGroundDarkToLight(singleStepData)
	elseif eventId == self.EVENT_54 then
		self:screenMoveTo(singleStepData)
	elseif eventId == self.EVENT_71 then
		self:bitmapTextFieldFadeIn(singleStepData,stepId)
	elseif eventId == self.EVENT_72 then
		self:bitmapTextFieldFadeOut(singleStepData)
	elseif eventId == self.EVENT_81 then
		self:mapBackgroundIn(singleStepData,stepId)
	elseif eventId == self.EVENT_82 then
		self:mapBackgroundOut(singleStepData)
	elseif eventId == self.EVENT_101 then
		self.guideSkillTimes = 0--引导技能次数
	elseif eventId == self.EVENT_102 then
		self:guideEliteSkill()
	end
end

function GameScript:endScriptData()
	for key,image in pairs(self.imageFadeTable) do
		self.effectLayer:removeChild(image);
	end
	
	for key,effect in pairs(self.effectDataTable) do
		self.effectLayer:removeChild(effect);
	end
	for key,effect in pairs(self.particleEffectTable) do
		if self.effectLayer.sprite then
			self.effectLayer.sprite:removeChild(effect);
		end
	end
	for key,bitmap in pairs(self.bitmapTextTable) do
		self.effectLayer:removeChild(bitmap);
	end
	for key,map in pairs(self.mapBackgroundTable) do
		self.mapLayer:removeChild(map);
	end
	self.effectLayer:removeChild(self.blackScreen);
	self:readyEndScript()
	self:reSertData()
end

function GameScript:readyEndScript()
	for key,roleVO in pairs(self.roleDataTable) do
	    self.playerLayer:removeChild(roleVO);
	    self.mapLayer:removeChild(roleVO.roleScriptShadow); 
	end
end

function GameScript:casheScriptSource(scriptId)
	local dataTable = analysisByName("Zhanchangjiaoben_Zhanchangjiaoben","id",scriptId)
	
    for k,v in pairs(dataTable) do
      if v.event == 3 then -- 释放技能
        analysisSkillthreeArr(tonumber(v.eventparameter),GameConfig.PLAYER_CARRER_5);
      elseif v.event == 102 or v.event == 101 then
      	if not self.guideSkillArray then self.guideSkillArray = {} end
      	table.insert(self.guideSkillArray,v);
      	self.hasGuildSkill = true
      end

      local objectType = v.objecttype
      if objectType == 2 and v.event == 1 then -- 怪物
        local monsterPO = analysis("Guaiwu_Guaiwubiao",v.objectparameter);
        self:findOutFromArts(monsterPO.modelId,true);
      elseif objectType == 6 and v.event == 1 then -- 其他卡牌
        local petPO = analysis("Kapai_Kapaiku",v.objectparameter);
        local isDelete = self:isDeleteSource(v.objectparameter)
        self:findOutFromArts(petPO.material_id,false);
      end        
    end
end

function GameScript:isDeleteSource(configId)
	if self.heroHouseProxy:getPeibingPeizhi(1) then
		for key, value in pairs(self.heroHouseProxy:getPeibingPeizhi(1).GeneralIdArray)do
			local generalData = self.heroHouseProxy:getGeneralData(value.GeneralId);
	  		if generalData.ConfigId  == tonumber(configId) then
	  			return false
	  		end
		end	
	else
		for key, value in pairs(self.userProxy.generalArray)do
	  		if value.ConfigId  == tonumber(configId) then
	  			return false
	  		end
		end	
	end


	return true
end

-----------------
--读取查找arts.lua中的数据
-----------------
function GameScript:findOutFromArts(artID,isDelete)
	if not artID then return end
    local cartoonType = artData[tonumber(artID)].type
    if cartoonType == 4 then -- spritestudio 
      local boneImage = "resource/image/arts/"..artID..".png"
      self.cacheTable[boneImage] = boneImage
    elseif cartoonType == 5 then -- spine
      local boneImage = "resource/image/arts/"..artID..".png"
      self.cacheTable[boneImage] = boneImage
    elseif cartoonType == 1 then
      local table = self.battleProxy.totalBattleArtsTable[tostring(artID)];
      if not table then return;end;
      for k1,v1 in pairs(table) do
        self.cacheTable[v1] = v1;
        if isDelete then
        	GameData.deleteBattleTextureMap[v1] = v1;
        end
      end
    end
end

function GameScript:screenMoveTo(singleStepData)
	local nextStepBeginArr1 = StringUtils:lua_string_split(singleStepData.tdt,"|")
	Tweenlite:to(self.playerLayer,tonumber(nextStepBeginArr1[1])/1000,tonumber(-(singleStepData.endingcoordinatesX-GameConfig.STAGE_WIDTH/2)),0,nil,nil,nil,"CCEaseSineInOut")
	Tweenlite:to(self.mapLayer,tonumber(nextStepBeginArr1[1])/1000,tonumber(-(singleStepData.endingcoordinatesX-GameConfig.STAGE_WIDTH/2)),0,nil,nil,nil,"CCEaseSineInOut")
end

function GameScript:timerStepLoop(singleStepData)
	local nextStepBeginArr = StringUtils:lua_string_split(singleStepData.tdt,";") -- 开始x毫秒后调用步骤y eg: x|y$a|b
	if nextStepBeginArr[1] ~= "" then
		for k,v in ipairs(nextStepBeginArr) do
			local nextStepBeginArr1 = StringUtils:lua_string_split(v,"|")

			if nextStepBeginArr1[1] ~= "" then
				local timer1 
				local function timerFunc1()
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
					self:playScriptStep(nextStepBeginArr1[2])
				end
				timer1 = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerFunc1, tonumber(nextStepBeginArr1[1]) / 1000, false)
			end
		end
	end
end

function GameScript:getStepData(stepId)
	for k,v in pairs(self.scriptStepDataTable) do
		if v.stepid == stepId then
			return v;
		end
	end
end

--背景图出现
function GameScript:mapBackgroundIn(scriptData,stepId)
	local mapPO = analysis("Zhandoupeizhi_Zhandouditu",tonumber(scriptData.objectparameter));
    local mapBackground = getImageByArtId(mapPO.front1)
    mapBackground.touchEnabled = true
    mapBackground.touchChildren = true
    mapBackground:setPositionY((GameConfig.STAGE_HEIGHT-mapBackground:getContentSize().height)/2)
    self.mapLayer:addChild(mapBackground);
    self.mapBackgroundTable[self.scriptId.."_"..stepId.."_"..scriptData.objectparameter] = mapBackground
end

--背景图消失
function GameScript:mapBackgroundOut(singleStepData)
	local mapBackground = self.mapBackgroundTable[singleStepData.objectparameter]
	if mapBackground then
		self.mapLayer:removeChild(mapBackground);
		self.mapBackgroundTable[singleStepData.objectparameter] = nil
	end
end

--图字出现
function GameScript:bitmapTextFieldFadeIn(scriptData,stepId)
	local px = scriptData.startingcoordinatesX ~="" and scriptData.startingcoordinatesX or GameConfig.STAGE_WIDTH/2
	local py = scriptData.startingcoordinatesY ~="" and scriptData.startingcoordinatesY or GameConfig.STAGE_HEIGHT/2
	local name = scriptData.objectparameter == "" and "jiaoben" or scriptData.objectparameter
    local bitmapTextField=BitmapTextField.new(scriptData.eventparameter, name,80);
    bitmapTextField:setPositionXY(px-GameData.uiOffsetX,py-GameData.uiOffsetY)
    bitmapTextField:setAlpha(0)
    bitmapTextField.sprite:setAnchorPoint(transLayerAnchor(0, 1));
    bitmapTextField.sprite:setLineBreakWithoutSpace(scriptData.orientations == 1);
    self.effectLayer:addChild(bitmapTextField);
	bitmapTextField:runAction(CCFadeTo:create(1,255));
	self.bitmapTextTable[self.scriptId.."_"..stepId] = bitmapTextField
end

--图字消失
function GameScript:bitmapTextFieldFadeOut(scriptData)
	for key,bitmapTextField in pairs(self.bitmapTextTable) do
		if key == scriptData.objectparameter then
			local function complete()
				self.effectLayer:removeChild(bitmapTextField);
				self.bitmapTextTable[key] = nil
			end
			local array = CCArray:create();
			array:addObject(CCFadeTo:create(0.8,0))
			array:addObject(CCCallFunc:create(complete))
			bitmapTextField:runAction(CCSequence:create(array));
			break
		end
	end
end

-- background from light to dark
function GameScript:backGroundLightToDark(singleStepData,stepId)
	local isFirstPlay = self:isFirstPlay(stepId)
	self.blackScreen = LayerColorBackGround:getBackGround()
	self.blackScreen:setScale(2)
	self.blackScreen:setAlpha(isFirstPlay and 1 or 0)
	self.blackScreen:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
	self.effectLayer:addChild(self.blackScreen);

	local function complete()
		self:cacheSource(stepId)
	end

	local array = CCArray:create();
	local time = singleStepData.objectparameter ~= "" and (tonumber(singleStepData.objectparameter)/1000) or 1
	array:addObject(CCFadeTo:create((isFirstPlay and 1 or time),255))
	array:addObject(CCCallFunc:create(complete))
	self.blackScreen:runAction(CCSequence:create(array));
end

function GameScript:cacheSource(stepId)
	if stepId == 10 then
		local function startFun()
			self.battleProxy:artsClassify()
			self:casheScriptSource(self.scriptId)
			--死亡特效
			luaUrl = "resource/image/arts/P871.lua";
			self.cacheTable[luaUrl] = luaUrl
			GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
			for key,url in pairs(self.cacheTable) do
				BitmapCacher:animationCacheAsync(url);
			end
			self:initChildIndex()
		end
		Tweenlite:delayCallS(0,startFun);
	end
end

function GameScript:isFirstPlay(stepId)
	if self.currentScriptStep == 1 and stepId == 10 then

		return true
	end
	return false
end

-- background from dark to light
function GameScript:backGroundDarkToLight(singleStepData)
	if not self.blackScreen or not self.blackScreen.sprite then return end
	local function complete()
		self:removeBlackScreen()
	end
	local array = CCArray:create();
	local time = singleStepData.objectparameter ~= "" and (tonumber(singleStepData.objectparameter)/1000) or 1
	array:addObject(CCFadeTo:create(time,0))
	array:addObject(CCCallFunc:create(complete))
	self.blackScreen:runAction(CCSequence:create(array));

end

function GameScript:removeBlackScreen()
	self.effectLayer:removeChild(self.blackScreen);
	self.blackScreen = nil
	self.effectLayer:removeChild(self.blackScreen);
	self.blackScreen = nil
end

-- image fade in
function GameScript:imageFadeIn(scriptData,stepId)
	-- 填充数据
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- 起始X坐标
	local startingcoordinatesXArr = StringUtils:lua_string_split(scriptData.startingcoordinatesX,"?")
	-- 起始Y坐标
	local startingcoordinatesYArr = StringUtils:lua_string_split(scriptData.startingcoordinatesY,"?")
	for k,v in pairs(objectparameterArr) do
	    local image = getImageByArtId(tonumber(v))
	    image:setAlpha(0)
	    image:setAnchorPoint(CCPointMake(0.5, 0.5))
	    local imagePx = startingcoordinatesXArr[k] ~= "" and startingcoordinatesXArr[k] or GameConfig.STAGE_WIDTH/2
	    local imagePy = startingcoordinatesYArr[k] ~= "" and startingcoordinatesYArr[k] or GameConfig.STAGE_HEIGHT/2
	    image:setPositionXY(imagePx-GameData.uiOffsetX,imagePy-GameData.uiOffsetY)
	    self.effectLayer:addChild(image);
	    local function complete()
	    end
		local array = CCArray:create();
		array:addObject(CCFadeTo:create(1,255))
		array:addObject(CCCallFunc:create(complete))
		image:runAction(CCSequence:create(array));
		self.imageFadeTable[self.scriptId.."_"..stepId.."_"..tonumber(v)] = image
	end

end

-- image fade out
function GameScript:imageFadeOut(scriptData,stepId)
	-- 填充数据
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- 起始X坐标
	local startingcoordinatesXArr = StringUtils:lua_string_split(scriptData.startingcoordinatesX,"?")
	-- 起始Y坐标
	local startingcoordinatesYArr = StringUtils:lua_string_split(scriptData.startingcoordinatesY,"?")

	for k,v in pairs(objectparameterArr) do
	    local image = self.imageFadeTable[v]
	    if image then
		    local function complete()
		    	self.effectLayer:removeChild(image);    
		    	self.imageFadeTable[v] = nil	
		    end
			local array = CCArray:create();
			array:addObject(CCFadeTo:create(1,0))
			array:addObject(CCCallFunc:create(complete))
			image:runAction(CCSequence:create(array));
		end
	end
end

-- effect fade in
function GameScript:particleEffectIn(scriptData,stepId)
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- 起始X坐标
	local startingcoordinatesXArr = StringUtils:lua_string_split(scriptData.startingcoordinatesX,"?")
	-- 起始Y坐标
	local startingcoordinatesYArr = StringUtils:lua_string_split(scriptData.startingcoordinatesY,"?")

	for k,v in pairs(objectparameterArr) do
		local liziEffect = "resource/image/arts/"..v..".plist"
  		if isFileExist(liziEffect) then -- 粒子特效
  			local particle = ParticleSystem:adddScreenPlist(self.effectLayer,v)
  			particle:setPosition(ccp(startingcoordinatesXArr[k],startingcoordinatesYArr[k]))
  			self.particleEffectTable[self.scriptId.."_"..stepId.."_"..scriptData.objectparameter] = particle
  		end
	end
end

-- effect fade out
function GameScript:particleEffectOut(scriptData)
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	for k,v in pairs(objectparameterArr) do
	    local particle = self.particleEffectTable[v]
	    if particle then
		    self.effectLayer.sprite:removeChild(particle);   
		end
	end
end

-- effectPlayOnce
function GameScript:effectPlayOnce(scriptData,stepId)
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- 起始X坐标
	local startingcoordinatesXArr = StringUtils:lua_string_split(scriptData.startingcoordinatesX,"?")
	-- 起始Y坐标
	local startingcoordinatesYArr = StringUtils:lua_string_split(scriptData.startingcoordinatesY,"?")

	for k,v in pairs(objectparameterArr) do
		local effect;
		local back1666;
		local function complete()
	    	self.effectLayer:removeChild(effect);
	    	self:removeGround1666(back1666)
	    end
	    local scale;
	    if v == "1666" then
	    	scale = 2
	    	back1666 = self:addBlackGround1666()
	    else
	    	scale = 1.12
	    end
	    effect = cartoonPlayer(v,startingcoordinatesXArr[k],startingcoordinatesYArr[k],1,complete,scale)
	    effect:setPositionXY(GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2)
	    self.effectLayer:addChild(effect);
	    self.effectDataTable[self.scriptId.."_"..stepId.."_"..tonumber(v)] = effect
	end
	self:cacheSource(stepId)
end

function GameScript:addBlackGround1666()
	local blackScreen1666 = LayerColorBackGround:getBackGround()
	blackScreen1666:setScale(2)
	blackScreen1666:setAlpha(1)
	blackScreen1666:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
	self.effectLayer:addChild(blackScreen1666);
	return blackScreen1666
end

function GameScript:removeGround1666(blackScreen1666)
	if blackScreen1666 then
		self.effectLayer:removeChild(blackScreen1666);
	end
end

-- 模拟生成人物
-- roleTable: 
-- type 1 玩家 2 英雄 3怪物
-- faceto 朝向
-- value
-- x,y
-- scale
function GameScript:bornRole(scriptData,stepId)
	local material_id;
	local monsterType = nil
	local role;
	if scriptData.objecttype == 1 then -- 出战方 0 主角自己 1 所有人
		material_id = analysis("Zhujiao_Huanhua",self.userProxy.transforId,"body")
		role = getCompositeRole(material_id,nil,true)
	elseif scriptData.objecttype == 2 then --怪物
		local guaiwubiao = analysis("Guaiwu_Guaiwubiao",scriptData.objectparameter) 
		material_id = guaiwubiao.modelId
		monsterType = guaiwubiao.type
		print("stepId,scriptData.objectparameter,material_id",stepId,scriptData.objectparameter, material_id)
		role = getCompositeRole(material_id,nil,true)
	elseif scriptData.objecttype == 7 or  scriptData.objecttype == 6 then --英雄
		local kapaiVO = analysis("Kapai_Kapaiku",scriptData.objectparameter) 
		role = getCompositeRole(kapaiVO.material_id,nil,true)
	end
	if monsterType == 3 then
		role.isBoss = true;
	elseif monsterType == 2 then
		role.isElite = true;
	end
	role:setPositionXY(scriptData.startingcoordinatesX,scriptData.startingcoordinatesY,true)
	role:changeFaceDirect(scriptData.orientations==1)
	role.name = BattleConfig.Is_Player_Role
	self.playerLayer:addChild(role)
	self.roleDataTable[self.scriptId.."_"..stepId.."_"..scriptData.objectparameter] = role
	self:initRoleShadow(role)
end

function GameScript:initRoleShadow(role)
    local roleScriptShadow
    if role.isBoss or role.isElite then
      local cartoonId = role.isBoss and 1091 or 1092
      roleScriptShadow = cartoonPlayer(cartoonId,0,0,0);
      self.mapLayer:addChildAt(roleScriptShadow,200);
    else
      roleScriptShadow = Image.new()
      roleScriptShadow:loadByArtID(19)
      roleScriptShadow:setAnchorPoint(CCPointMake(0.5,0.5));
      self.mapLayer:addChildAt(roleScriptShadow,200);
    end
    roleScriptShadow:setPositionXY(role:getPositionX(),role:getPositionY())
    role.roleScriptShadow = roleScriptShadow
    
end

--生成后端数据
function GameScript:bornServerRole(type,scriptData,battleUnitId,roleData,k1)
	if type == 6 then
		local monster,level = self.battleProxy:getScriptBornMonster(tonumber(scriptData.eventparameter))
		monster:setLevel(level)
		monster:initData()
		local propertyManager = monster:getScriptPropertyManager()
		local follower = self.battleProxy:createScriptHero(tonumber(scriptData.objectparameter),self.battleUnitId,level)
		follower:setPropertyManager(propertyManager)
		follower:setCoordinateX(roleData.CoordinateX)
		follower:setCoordinateY(roleData.CoordinateY)
		follower:setOriginalXY(roleData.CoordinateX,roleData.CoordinateY)
		self.roleDataTable[k1].follower = follower;
	end
end

function GameScript:isNoNeedLeave(roleType,battleUnitId)
	if not self.battleProxy.AIBattleField then return end
	if roleType ~= 6 then return end
	local isLeaveUnitId
	for k,v in pairs(_dataTable) do
		if v.objectparameter == self.battleUnitId and v.event == EVENT_5 then
			isLeaveUnitId = self.battleUnitId
			break;
		end
	end
	if isLeaveUnitId then
		return nil
	else
		return true
	end
end

-- 模拟角色走路
function GameScript:roleRun(scriptData,stepId)
	local role = self.roleDataTable[scriptData.objectparameter]
	if not role then return end
	require "main.controller.command.battleScene.battle.battlefield.BattleUtils"
	local cX = scriptData.endingcoordinatesX ~= "" and scriptData.endingcoordinatesX or 0;
	local cY = scriptData.endingcoordinatesY ~= "" and scriptData.endingcoordinatesY or 0;
	local moveTime = BattleUtils:getDistance(role:getPositionX(),role:getPositionY(),cX,cY)/300;
	role:tweenLiteAnimation(math.abs(moveTime), ccp(scriptData.endingcoordinatesX, scriptData.endingcoordinatesY));
	local bool = false 
	if scriptData.orientations == 0 or scriptData.orientations == 1 then
		bool = true
	end
	role:changeFaceDirect(bool)
	role:playAndLoop(BattleConfig.RUN);
end

-- 模拟角色释放技能
function GameScript:rolePlaySkill(scriptData,stepid)
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- -- 对应的朝向
	local eventparameterArr = StringUtils:lua_string_split(scriptData.eventparameter,"?")


	for k,v in pairs(objectparameterArr) do
		local roleVO = self.roleDataTable[v]
		local VO = {}
		VO.battleIcon = roleVO
		VO.currentHP = 10000
		VO.isBattleScript = true
		VO.coordinateY = roleVO:getPositionY()
		self.battleProxy.battleGeneralArray[v] = VO
		roleVO.VO = VO
		local eventparameterArr1 = StringUtils:lua_string_split(eventparameterArr[k],",")
		local editorid = analysis("Jineng_Jineng",eventparameterArr1[1],"editorid")--1226
		local realKey = "key"..editorid;
		local skillTable = BattleData.attackSkillArray[realKey]
		-- local attackTable = {}
		-- for k,v in pairs(skillTable) do
	 --      if(k == "a1"
	 --      or k == "a2"
	 --      or k == "a3"
	 --      or k == "a4"
	 --      or k == "a5"
		--   or k == "a6"
		--   or k == "a7"
		--   or k == "a8"
		--   or k == "a9"
		--   or k == "a10") then
	 --        attackTable[k] = v	  
	 --      end
		-- end
		if not roleVO.playSkill then
			require "main.view.battleScene.core.PlaySkill"
			roleVO.playSkill = PlaySkill.new()
			roleVO.playSkill:initScriptData(v,self.battleProxy)
		end
		local function attackBack()
			roleVO:playAndLoop(BattleConfig.HOLD)
		end
		local bool = false 
		if scriptData.orientations == 0 or scriptData.orientations == 1 then
			bool = true
		end
		roleVO.playSkill:playAttack(skillTable,attackBack,bool)
	end
end

-- 模拟角色被击
function GameScript:rolePlayBeattack(scriptData,isDead)
	-- 怪物/英雄ID
	local objectparameterArr = StringUtils:lua_string_split(scriptData.objectparameter,"?")
	-- -- 对应的朝向
	local eventparameterArr = StringUtils:lua_string_split(scriptData.eventparameter,"?")

	for k,v in pairs(objectparameterArr) do
		local roleVO = self.roleDataTable[v]
		local VO = {}
		VO.battleIcon = roleVO
		VO.currentHP = isDead and 0 or 9999999
		VO.isBattleScript = true
		VO.coordinateY = roleVO:getPositionY()
		VO.standPoint = BattleConfig.Battle_StandPoint_2
		self.battleProxy.battleGeneralArray[v] = VO
		roleVO.VO = VO
		local eventparameterArr1 = StringUtils:lua_string_split(eventparameterArr[k],",")
		local editorid = analysis("Jineng_Jineng",eventparameterArr1[1],"editorid")--1226eventparameterArr1[1]
		local realKey = "key"..editorid;
		local skillTable = BattleData.beAttackSkillArray[realKey]
		local screenTable = BattleData.screenSkillArray[realKey]
		-- local beAttackTable = {}
		-- local isForceDead = true
		-- for k,v in pairs(skillTable) do
		-- 	if(k == "b1"
		-- 	or k == "b2"
		-- 	or k == "b3"
		-- 	or k == "b4"
		-- 	or k == "b5"
		-- 	or k == "b6"
		-- 	or k == "b7"
		-- 	or k == "b8"
		-- 	or k == "b9"
		-- 	or k == "b10") then
	 --        beAttackTable[k] = v	
	 --        if v.attackActionID == BattleConfig.PAO_WU_XIAN then
		-- 		isForceDead = false
		-- 	end  
	 --      end
		-- end
		-- local delayBeattackTimeArr = StringUtils:lua_string_split(screenTable.beijiyanchi,"?")
		-- local beAttackTableTemp,isNeedCheckDead = BattleUtils:getBeattackDataTable(#delayBeattackTimeArr,copyTable(beAttackTable),1)    
		if not roleVO.playSkill then
			require "main.view.battleScene.core.PlaySkill"
			roleVO.playSkill = PlaySkill.new()
			roleVO.playSkill:initScriptData(v,self.battleProxy)
		end
		local function attackBack()
			if isDead then
				roleVO:playDeadAnimation(nil,true)
				self:removeShadow(roleVO,scriptData)
			else
				roleVO:playAndLoop(BattleConfig.HOLD)
			end
		end
		-- roleVO.playSkill:setIsForceDead(true,isNeedCheckDead)
		-- roleVO.playSkill:setBeAttackPaowuxian(screenTable.paowuxian)
		local bool = false 
		if scriptData.orientations == 0 or scriptData.orientations == 1 then
			bool = true
		end
		roleVO:changeFaceDirect(bool);
		roleVO.playSkill:playAttack(copyTable(skillTable),attackBack,false,true)
	end
end

function GameScript:roleLeave(scriptData)
	local roleVO = self.roleDataTable[scriptData.objectparameter]
	if not roleVO then return end
    self.playerLayer:removeChild(roleVO);
    self:removeShadow(roleVO,scriptData)
end

function GameScript:removeShadow(roleVO,scriptData)
	self.roleDataTable[scriptData.objectparameter] = nil
	self.mapLayer:removeChild(roleVO.roleScriptShadow); 
	roleVO.roleScriptShadow = nil
end

-- 音效
function GameScript:playSoundEffect(scriptData)
	MusicUtils:playEffect(scriptData.objectparameter,false)
end

-- 震屏
function GameScript:sceenShake(scriptData)
	ScreenShake:shakeStart(tonumber(scriptData.eventparameter))
end

-- 移屏
function GameScript:sceenMove(scriptData)
end

function GameScript:blackDialogue(scriptData,stepId)
	if not scriptData then
		error("'generalVO is nil==",self.scriptId,"==",stepId)
	end
	local nextStepEndArr = StringUtils:lua_string_split(scriptData.cot,";") -- 结束后x毫秒后调用步骤y eg: x|y$a|b
		-- 完成本条脚本后的回调函数
	local function endSingalStepFunc()
		if nextStepEndArr[1] ~= "" then
			for k,v in ipairs(nextStepEndArr) do
				local nextStepEndArr1 = StringUtils:lua_string_split(v,"|")
				local timer1 
				local function timerFunc2()
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
					self:playScriptStep(nextStepEndArr1[2])
				end
				timer1 = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerFunc2, nextStepEndArr1[1] / 1000, false)
			end
		end
	end
	require "main.controller.command.task.ModalDialogCommand"
	Facade.getInstance():registerCommand(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND, ModalDialogCommand);
	local data = {isBattleDialog = true, dialog = scriptData.eventparameter,callBackFun = endSingalStepFunc,isBattleScript = self.isBattleScript}
	Facade.getInstance():sendNotification(TaskNotification.new(TaskNotifications.OPEN_MODAL_DIALOG_COMMOND,data)); 
end

function GameScript:popDialogue(scriptData)
	local roleVO = self.roleDataTable[scriptData.objectparameter];
	if not roleVO then return end
	require "main.view.battleScene.function.TextAnimationDialog"
	local textAnimationDialog = TextAnimationDialog.new();
	textAnimationDialog:initLayer();
	roleVO:addChild(textAnimationDialog);
	textAnimationDialog:setVisibleDialog(true)
	local height = roleVO:getNameTextHeight()>180 and 180 or roleVO.nameTextHeight
	textAnimationDialog:setPositionXY(0,height-50);
	local bool = false 
	if scriptData.orientations == 0 or scriptData.orientations == 1 then
		bool = true
	end
	textAnimationDialog:textAnimation(scriptData.eventparameter,bool,roleVO)
end

function GameScript:initChildIndex()
    self:removeIndexTimer()
    local function indexTimerFun()
        self:refreshRoleChildIndex()
    end
    self.indexTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(indexTimerFun, 0, false)
end

function GameScript:removeIndexTimer()
    if self.indexTimer then
      Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.indexTimer);
      self.indexTimer = nil;
    end
end

local function sortOnCenterY(a, b) return a.py > b.py end
function GameScript:refreshRoleChildIndex()
	local generalSortArray = {}
	for key,child in pairs(self.roleDataTable) do
		child.py = child:getPositionY()
		if child.py then
			table.insert(generalSortArray, child)
		end
	end
	
	table.sort(generalSortArray,sortOnCenterY)
	for key,child in pairs(generalSortArray) do
        self.playerLayer:setChildIndex(child, key+1);

        if child.roleScriptShadow then
        	self.playerLayer:setChildIndex(child.roleScriptShadow, 1);
            child.roleScriptShadow:setPositionXY(child:getPositionX(),child:getPositionY(),true)   
        end
    end
end
