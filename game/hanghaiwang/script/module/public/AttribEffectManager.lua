-- FileName: AttribEffectManager.lua
-- Author: yucong
-- Date: 2015-11-18
-- Purpose: 属性特效管理器
--[[TODO List]]
require "script/module/public/EffectConst"

AttribEffectManager = class("AttribEffectManager")

function AttribEffectManager:ctor( ... )
end

-- example.
--[[
@param tbdata = {
			fnMovementCall,	回调
			fnFrameCall, 	帧事件回调，可以是函数也可以是函数集合，调用的顺序对应T_EFFECT_DATA数据中FRAMES右边的数值
			loop,			循环类型，默认0，执行一次
			level,			需要显示等级相关的数值
			extra,			额外的值
		}
@param type 对应EffectConst中的宏
]]
-- 锤子动画
function AttribEffectManager:createHammerEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_HAMMER)
end

-- 火花动画
function AttribEffectManager:createSparkEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_SPARK)
end

-- 强化成功
function AttribEffectManager:createStrenOKEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_STREN_OK)
end

-- 附魔成功
function AttribEffectManager:createFixOKEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_FIX_OK)
end

-- 暴击
function AttribEffectManager:createCritEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_CRIT)
end

-- 提升几级
function AttribEffectManager:createAddLevelEffect( tbData )
	return AttribEffectAddLevel:new(tbData):getArmature()
end

-- 装备强化大师的特效(不是飘字)
function AttribEffectManager:createEquipStrMasterEffect( tbData )
	tbData.EType = EffectConst.E_MASTER_EQUIP_STR
	return AttribEffectMaster:new(tbData):getArmature()
end

-- 装备附魔大师的特效(不是飘字)
function AttribEffectManager:createEquipFixMasterEffect( tbData )
	tbData.EType = EffectConst.E_MASTER_EQUIP_FIX
	return AttribEffectMaster:new(tbData):getArmature()
end

-- 饰品强化大师的特效(不是飘字)
function AttribEffectManager:createTreaStrMasterEffect( tbData )
	tbData.EType = EffectConst.E_MASTER_TREA_STR
	return AttribEffectMaster:new(tbData):getArmature()
end

-- 饰品精炼大师的特效(不是飘字)
function AttribEffectManager:createTreaRefineMasterEffect( tbData )
	tbData.EType = EffectConst.E_MASTER_TREA_REFINE
	return AttribEffectMaster:new(tbData):getArmature()
end

function AttribEffectManager:createGuangZhen_Da( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_GUANGZHEN_DA)
end

function AttribEffectManager:createGuangZhen_Xiao( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_GUANGZHEN_XIAO)
end

function AttribEffectManager:createGuangZhen_XiaoWu( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_GUANGZHEN_XIAO_WU)
end

function AttribEffectManager:createGuangZhen_XiaoWu2( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_GUANGZHEN_XIAO_WU2)
end

function AttribEffectManager:createGuangZhen_XiaoRenWu( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_GUANGZHEN_XIAO_RENWU)
end

-- 战斗结束背景光
function AttribEffectManager:createBattleLightEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_BATTLE_LIGHT)
end

-- 触摸继续
function AttribEffectManager:createTouchContinueEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_TOUCH_CONTINUE)
end

-- 触摸关闭
function AttribEffectManager:createTouchCloseEffect( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_TOUCH_CLOSE)
end

-- 一键强化 属性板出现特效
function AttribEffectManager:createBoardLight( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_MASTER_BOARD_LIGHT)
end

-- 属性粒子特效
function AttribEffectManager:createJinJieShuZi( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_JINJIE_SHUZI)
end

-- 属性粒子特效2
function AttribEffectManager:createJinJieShuZi2( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_JINJIE_SHUZI2)
end

-- 觉醒成功
function AttribEffectManager:createAwakaOK( tbData )
	return self:createCommonEffect(tbData, EffectConst.E_AWAKE_OK)
end

-- 不需要特殊处理的特效
function AttribEffectManager:createCommonEffect( tbData, type )
	tbData.EType = type
	return AttribEffectCommon:new(tbData):getArmature()
end

-------------------- 动画创建基类，分发事件 --------------------

-------------AttribEffect---------------
AttribEffect = class("AttribEffect")
AttribEffect._type = nil
AttribEffect._armature = nil

-- 创建动画
-- @param EType 动画的类型
-- @param movementCall
-- @param frameCalls 可以是函数也可以是函数集合，函数集合的顺序必须是调用的顺序
-- @param aniName 动画名，默认nil时从数据中查找名字
-- @param loop 循环类型，默认0，执行一次
function AttribEffect:createArmature( instance, movementCall, frameCalls, loop, aniName )
	assert(EffectConst.T_EFFECT_DATA[instance._type], "type:"..instance._type.." 不存在")
	local filePath = EffectConst.T_EFFECT_DATA[instance._type].PATH
	local animationName = aniName or EffectConst.T_EFFECT_DATA[instance._type].NAME
	local frames = EffectConst.T_EFFECT_DATA[instance._type].FRAMES
	local isAdapt = EffectConst.T_EFFECT_DATA[instance._type].ADAPT or false
	local fnMusic = EffectConst.T_EFFECT_DATA[instance._type].MUSIC
	logger:debug("filePath:"..filePath.." animationName:"..animationName)
	local effect
	effect = UIHelper.createArmatureNode({
		filePath = filePath,
		animationName = animationName,
		loop = loop or 0,
		bRetain = true,
		fnMovementCall = function ( ... )
			if (movementCall) then
				movementCall(...)
			end
			instance:movementCall(...)
		end,
		fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
			logger:debug("AttribEffectManager filePath:"..filePath)
			logger:debug("AttribEffectManager frameEventName:"..frameEventName)
			if (frames[frameEventName] ~= nil) then
				local index = frames[frameEventName]
				self:handleFrameCall(bone, frameEventName, originFrameIndex, currentFrameIndex, frameCalls, index)
				-- 执行通用事件
				instance:frameCall(bone, frameEventName, originFrameIndex, currentFrameIndex)
			end 
		end,
	})
	-- 适配
	if (isAdapt) then
		effect:setScaleX(g_fScaleX)
		effect:setScaleY(g_fScaleX)
	end
	if (fnMusic) then
		fnMusic()
	end
	return effect
end

function AttribEffect:handleFrameCall( bone, frameEventName, originFrameIndex, currentFrameIndex, frameCalls, index )
	if (not frameCalls) then
		return
	end
	local frameCall = nil
	if (type(frameCalls) == "function") then
		frameCall = frameCalls
	elseif (type(frameCalls) == "table") then
		frameCall = frameCalls[index]
	end
	--assert(frameCall, "关键帧:"..frameEventName.." 回调不存在")
	if frameCall then
		frameCall(bone, frameEventName, originFrameIndex, currentFrameIndex)
	end
end

--[[virtual function]]--
function AttribEffect:movementCall( sender, MovementEventType, frameEventName )
	if MovementEventType == 1 then 	-- complete
	elseif MovementEventType == 0 then -- start
	elseif MovementEventType == 2 then -- loop_complete
	end
end

--[[virtual function]]--
function AttribEffect:frameCall( bone, frameEventName, originFrameIndex, currentFrameIndex )
	
end

function AttribEffect:getArmature( ... )
	return self._armature
end

-- 适配
function AttribEffect:adaptation( ... )
	self._armature:setScaleX(g_fScaleX)
end

--********************** 当需要某一类特效需要对帧事件特殊处理，则添加新类，否则统一使用Common类创建 **********************--

-- -------------AttribEffectHammer---------------
-- AttribEffectHammer = class("AttribEffectHammer", AttribEffect)
-- AttribEffectHammer._type = EffectConst.E_HAMMER

-- function AttribEffectHammer:ctor( tbData )
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-- -------------AttribEffectSpark---------------
-- AttribEffectSpark = class("AttribEffectSpark", AttribEffect)
-- AttribEffectSpark._type = EffectConst.E_SPARK

-- function AttribEffectSpark:ctor( tbData )
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-- -------------AttribEffectStrenOK---------------
-- AttribEffectStrenOK = class("AttribEffectStrenOK", AttribEffect)
-- AttribEffectStrenOK._type = EffectConst.E_STREN_OK

-- function AttribEffectStrenOK:ctor( tbData )
-- 	logger:debug({strenOK = tbData})
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-- -------------AttribEffectFixOK---------------
-- AttribEffectFixOK = class("AttribEffectFixOK", AttribEffect)
-- AttribEffectFixOK._type = EffectConst.E_FIX_OK

-- function AttribEffectFixOK:ctor( tbData )
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-- -------------AttribEffectCrit---------------
-- AttribEffectCrit = class("AttribEffectCrit", AttribEffect)
-- AttribEffectCrit._type = EffectConst.E_CRIT

-- function AttribEffectCrit:ctor( tbData )
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-------------AttribEffectAddLevel---------------
AttribEffectAddLevel = class("AttribEffectAddLevel", AttribEffect)
AttribEffectAddLevel._type = EffectConst.E_ADD_LEVEL
AttribEffectAddLevel._level = nil

function AttribEffectAddLevel:ctor( tbData )
	self._level = tonumber(tbData.level) or 0
	local effectName = ""
	if( self._level >= 100 ) then
        effectName = "qh3_3_3"
    elseif( self._level >= 10 ) then
        effectName = "qh3_3_2"
    else
        effectName = "qh3_3_1"
    end
	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop, effectName)
end

function AttribEffectAddLevel:createNumber( num )
	local num100 = 0
    local num10 = 0
    local num1 = 0
    num100 = math.modf(num / 100) or 0
    local pr = num - num100 * 100 or 0
    num10 = math.modf(pr / 10) or 0
    local pr2 = num - num100 * 100 - num10 * 10 or 0
    num1 = pr2
    local function changeNum( _num )
		local numFile = string.format("%snumber/no%d.png", EffectConst.PATH_FORGE , _num)
		logger:debug("numFile:"..numFile)
		local sprite = CCSprite:create(numFile)
		self._armature:addChild(sprite)
		return sprite
	end
	if (num >= 100) then
		local sprite100 = changeNum(num100)
		local sprite10 = changeNum(num10)
		local sprite1 = changeNum(num1)
		sprite100:setPosition(ccp(2, 0))
		sprite10:setPosition(ccp(52, 0))
		sprite1:setPosition(ccp(102, 0))
	elseif (num >= 10) then
		local sprite10 = changeNum(num10)
		local sprite1 = changeNum(num1)
		sprite10:setPosition(ccp(2, 0))
		sprite1:setPosition(ccp(52, 0))
	else
		local sprite1 = changeNum(num1)
		sprite1:setPosition(ccp(2, 0))
	end
end

-- 通用的帧事件回调
function AttribEffectAddLevel:frameCall( bone, frameEventName, originFrameIndex, currentFrameIndex )
	self:createNumber(self._level)
	self._level = nil
end

-------------AttribEffectMaster 强化大师的所有---------------
AttribEffectMaster = class("AttribEffectMaster", AttribEffect)
AttribEffectMaster._type = nil
--AttribEffectMaster._tChangeData = nil

function AttribEffectMaster:ctor( tbData )
	self._type = tbData.EType
	--self._tChangeData = tbData.changeData
	self._level = tonumber(tbData.level) or 0
	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
end

-- 强化大师的特效上的数字
function AttribEffectMaster:createMasterNumber( num )
	local num10 = math.modf(num / 10) or 0
	local num1 = num - num10 * 10
	local function changeNum( _num )
		local numFile = string.format("%snumber/no%d.png", EffectConst.PATH_FORGE , _num)
		local sprite = CCSprite:create(numFile)
		self._armature:addChild(sprite)
		return sprite
	end
	if (num >= 10) then
		local sprite10 = changeNum(num10)
		local sprite1 = changeNum(num1)
		if (self._type == EffectConst.E_MASTER_EQUIP_STR or self._type == EffectConst.E_MASTER_EQUIP_FIX) then
			sprite10:setPosition(ccp(84, 0))
			sprite1:setPosition(ccp(133, 0))
		elseif (self._type == EffectConst.E_MASTER_TREA_STR or self._type == EffectConst.E_MASTER_TREA_REFINE) then
			sprite10:setPosition(ccp(85, 0))
			sprite1:setPosition(ccp(138, 0))
		end
	else
		local sprite1 = changeNum(num1)
		local pos
		if (self._type == EffectConst.E_MASTER_EQUIP_STR or self._type == EffectConst.E_MASTER_EQUIP_FIX) then
			pos = ccp(108, 0)
		elseif (self._type == EffectConst.E_MASTER_TREA_STR or self._type == EffectConst.E_MASTER_TREA_REFINE) then
			pos = ccp(85, 0)
		end
		sprite1:setPosition(pos)
	end
end

-- 通用的帧事件回调
function AttribEffectMaster:frameCall( bone, frameEventName, originFrameIndex, currentFrameIndex )
	-- 封装强化大师帧事件的内容
	self:createMasterNumber(self._level)
	self._level = nil
end

-- 通用的回调
-- function AttribEffectMaster:movementCall( sender, MovementEventType, frameEventName )
-- 	if MovementEventType == 1 then 	-- complete
-- 		sender:removeFromParentAndCleanup(true)
-- 		local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(self._tChangeData, nil, function ( ... )
-- 			 -- 如果在伙伴身上则 需要增加判断 强化大师 增加的飘字效果
-- 		end)
-- 		if node then
-- 			local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 			runningScene:addChild(node, 99999)
-- 		end
-- 		self._tChangeData = nil
-- 	end
-- end

-------------AttribEffectGuangZhen 光阵的所有---------------
-- AttribEffectGuangZhen = class("AttribEffectGuangZhen", AttribEffect)
-- AttribEffectGuangZhen._type = nil

-- function AttribEffectGuangZhen:ctor( tbData )
-- 	self._type = tbData.EType
-- 	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
-- end

-------------AttribEffectCommon-------------
AttribEffectCommon = class("AttribEffectCommon", AttribEffect)

function AttribEffectCommon:ctor( tbData )
	self._type = tbData.EType
	self._armature = self:createArmature(self, tbData.fnMovementCall, tbData.fnFrameCall, tbData.loop)
end