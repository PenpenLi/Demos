-- FileName: MasterEquipAndTreasure.lua
-- Author: yucong
-- Date: 2015-05-12
-- Purpose: 强化大师-装备和宝物 子视图层
--[[TODO List]]

module("MasterEquipAndTreasure", package.seeall)

----------------- 局部 -------------------
local _mainLayer
local _heroInfo
local _curPage				-- 1:装备强化 2:装备附魔 3:宝物强化 4:宝物精炼
local _heroPageNum = 0		-- 阵容界面的页号 1~6
local _autoEquip = {}		-- 自动强化的装备们~
local _equipIndex = 1
local _tBefore = nil
local _nCrit = 0    -- 暴击次数
local _nCost = 0    -- 消耗贝里
local _animationPath = "images/effect/forge"
local _isAutoEnhance = false 	-- 是否正在自动强化过程中
local _orignColor_Switch = ccc3(0x90, 0x65, 0x0E) 	-- 切换按钮的原始颜色
local kTREASURE_NUM = 3
----------------- 局部 -------------------

----------------- 控件 -------------------
local _left_widgets = {
	LAY_1 = nil,	--四个格子
	LAY_2 = nil,
	LAY_3 = nil,
	LAY_4 = nil,
}
----------------- 控件 -------------------

------------------ 数据 -------------------
local _masterdata = {
	nOneKey_vip = 0,	-- 一键强化开启的vip等级
	nOneKey_lv = 0,		-- 一键强化开启的等级
	strOnekey_Str = nil,-- 一键强化开启说明
	nScoreTotal = 0,	-- 品级总和
	nScorelv = 0,		-- 品级大师等级
	tbAttr_info = {},	-- 当前属性
	tbAttr_afinfo = {},	-- 下一级属性
}
local _animationData = {
	aniData_1 = nil,
	aniData_2 = nil,
	aniData_3 = nil,
	aniData_4 = nil,
	flyNode = nil,
}
------------------ 数据 -------------------

local m_fnGetWidget =  g_fnGetWidgetByName 
local m_i18n = gi18n

-- 数据处理
local function handleDatas( ... )
	_autoEquip = {}
	--_tBefore = nil
	_isAutoEnhance = false
	_masterdata.nOneKey_vip, _masterdata.nOneKey_lv, _masterdata.strOnekey_Str = MainEquipMasterView.fnGetAllStrOpenLv()
	_masterdata.nScoreTotal = MainEquipMasterCtrl.fnGetNumByType(_curPage, _heroInfo)
    _masterdata.nScorelv = MainEquipMasterCtrl.fnGetAttrLv(_curPage, _masterdata.nScoreTotal)
    _masterdata.tbAttr_info = MainEquipMasterCtrl.fnGetAttrInfo(_curPage, _masterdata.nScorelv)
    _masterdata.tbAttr_afinfo = MainEquipMasterCtrl.fnGetAttrInfo(_curPage, _masterdata.nScorelv + 1)
end

-- 是否在装备界面
local function isEquipPage( ... )
	if (_curPage == 1 or _curPage == 2) then
		return true
	end
	return false
end

-- 是否在宝物界面
local function isTreasurePage( ... )
	if (_curPage == 3 or _curPage == 4) then
		return true
	end
	return false
end

-- 是否在强化界面
local function isStrengthPage( ... )
	if (_curPage == 1 or _curPage == 3) then
		return true
	end
	return false
end

-- 设置当前页index
function setCurPage( page )
	_curPage = page

	-- 切换按钮状态切换
	-- _mainLayer.BTN_TREASURE_STR:setFocused(isStrengthPage())
	-- _mainLayer.BTN_TREASURE_STR:setTouchEnabled(not isStrengthPage())
	-- _mainLayer.BTN_ENHANCE:setFocused(not isStrengthPage())
	-- _mainLayer.BTN_ENHANCE:setTouchEnabled(isStrengthPage())
	-- local selcolor = ccc3( 0x82, 0x57, 0x00)
	-- local color = ccc3(_orignColor_Switch.r, _orignColor_Switch.g, _orignColor_Switch.b)
 -- 	MainEquipMasterView.setBtnColor(_mainLayer.BTN_TREASURE_STR, isStrengthPage() and selcolor or color)
 -- 	MainEquipMasterView.setBtnColor(_mainLayer.BTN_ENHANCE, not isStrengthPage() and selcolor or color)
end

-- 关闭子窗口的回调
local function closeChildCallback( ... )
    -- yucong 强化界面删除了自己的信息条，需重新添加有偏移的信息条
    PlayerPanel.addForStrenMaster()
	reload()
	LayerManager.removeLayout()
    -- LayerManager.setPaomadeng(_mainLayer, -1)
end

--动画完成的处理
local function fnDoAnimationOver( ... )
	-- 移除屏蔽层
	LayerManager.removeLayout()
    _isAutoEnhance = false
    _equipIndex = 1
    _autoEquip = {}
    reload()

    local visibleSize = CCDirector:sharedDirector():getVisibleSize()
    local tAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(_heroInfo)
    local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(_tBefore,tAfter,1)

    function addMasterEffect( showString )
        if (not showString) then
            return
        end
        local masterEffect = g_attribManager:createEquipStrMasterEffect({
            level = tAfter[tonumber(1)],
            fnMovementCall = function ( armature,movementType,movementID )
                if(movementType == 1) then
                    armature:removeFromParentAndCleanup(true)
                    _animationData.flyNode = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString, nil, function (  )
                        if(_animationData.flyNode) then
                            --_animationData.flyNode:removeFromParentAndCleanup(true)
                            _animationData.flyNode = nil

                            showNotice()
                        end
                        _tBefore = nil
                    end)
                    if(_animationData.flyNode)then
                        local runningScene = CCDirector:sharedDirector():getRunningScene()
                        runningScene:addChild(_animationData.flyNode, 99999)
                    else
                        showNotice()
                    end
                end
            end
        })
        masterEffect:setPosition(ccp(visibleSize.width*0.5, visibleSize.height *0.5 + 50))
        _mainLayer:addNode(masterEffect, 4)
    end

    addMasterEffect(showString)
end

function showNotice( ... )
    -- 应策划要求，取消暴击显示的悬浮框
    --ShowNotice.showMasterInfo(_nCrit, UIHelper.getBellyStringAndUnit(_nCost))
    _nCrit = 0
    _nCost = 0
end

-- 刷新某一装备
local function reloadSingleEquip( info )
	-- 获得当前的装备数据
    local armInfos = _heroInfo.equip.arming
    for i = 1 , 4 do 
        local pID = armInfos[tostring(i)] or nil
        if ((not pID) == false and (tonumber(pID) ~= 0)) then
            local itemId = tonumber(pID.item_id) or 0
            if( (tonumber(info.key) == itemId)) then
                local itemTemid = tonumber(pID.item_template_id)
                local armInfo = ItemUtil.getItemById(tonumber(itemTemid))
           
                -- 刷新进度条显示
                local pNow = pID.va_item_text.armReinforceLevel or 0
                local pMaxLevel = (armInfo.level_limit_ratio * UserModel.getHeroLevel()) or 0
                logger:debug(pMaxLevel)
                pMaxLevel = _maxNow
                logger:debug(_maxNow)

                local lay = _left_widgets[i]
                --进度条上显示 0 / 10
	            lay.TFD_LVNUM:setText(tostring(pNow).."/"..tostring(pMaxLevel))
	            --设置进度
	            local pPercent = pMaxLevel == 0 and 0 or (tonumber(pNow)/tonumber(pMaxLevel) or 0)
	            pPercent = pPercent > 1 and 1 or pPercent
	            lay.LOAD_PROGRESS:setPercent(tonumber(pPercent)*100)

                break
            end
        end
    end
end

--[[desc:一键强化的特效处理
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function addAutoAnimation()

    if(_equipIndex > #_autoEquip) then
        --没有后续了，处理动画结束
        fnDoAnimationOver()
        return
    end
    
    local pInfo = _autoEquip[_equipIndex]
    if(not pInfo) then
        fnDoAnimationOver()
        return
    end
    local pTag = pInfo.site or 1

    local pLay = _left_widgets[pTag]
    local parentLay = tolua.cast(pLay:getParent(), "Widget")

    local count = 0

    -- 锤子动画
    local visibleSize = CCDirector:sharedDirector():getVisibleSize()
    AudioHelper.playEffect("audio/effect/texiao02_chuizi.mp3")
    _animationData.aniData_1 = g_attribManager:createHammerEffect({
        fnMovementCall = function ( armature,movementType,movementID )
                if(movementType == 1) then
                armature:removeFromParentAndCleanup(true)
                armature = nil
                _animationData.aniData_1 = nil
                end
            end,
        fnFrameCall = function ( bone,frameEventName,originFrameIndex,currentFrameIndex )
                if(_isAutoEnhance) then
                    addAnimation2()
                end
            end,
    })
    -- UIHelper.createArmatureNode({
    --     filePath =_animationPath .. "/UI_20_hammer/qh4.ExportJson",
    --     animationName = "qh4",
    --     loop = 0,
    --     fnMovementCall = function ( armature,movementType,movementID )
    --          if(movementType == 1) then
    --             armature:removeFromParentAndCleanup(true)
    --             armature = nil
    --             _animationData.aniData_1 = nil
    --          end
    --     end,
    --     fnFrameCall = function ( bone,frameEventName,originFrameIndex,currentFrameIndex )
    --         if(_isAutoEnhance) then
    --             if (frameEventName == "qh4_21") then
    --                 addAnimation2()
    --             end
    --         end
    --     end,
    -- })
    --_animationData.aniData_1:setPosition(pLay:getSize().width/2, pLay:getSize().height / 2)
    --_animationData.aniData_1:setTag(999991)
    _animationData.aniData_1:setPosition(pLay:getPositionX() + pLay:getSize().width/2, pLay:getPositionY() + pLay:getSize().height / 2)
    -- 动画不能放在自己的格子上，会被其他格子遮挡，统一放到父节点上
    parentLay:addNode(_animationData.aniData_1, 3)
    --pLay:addNode(_animationData.aniData_1, 3)

    -- 锤子敲下去 火花
    function addAnimation2(  )
        AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
        _animationData.aniData_2 = g_attribManager:createSparkEffect({
            fnMovementCall = function ( armature,movementType,movementID )
                if(movementType == 1) then
                    if(_isAutoEnhance) then
                        addAnimation3()
                    end
                    armature:removeFromParentAndCleanup(true)
                    armature = nil
                    _animationData.aniData_2 = nil
                end
            end,
        })
        -- UIHelper.createArmatureNode({
        --     filePath = _animationPath .. "/UI_15/qh.ExportJson",
        --     animationName = "qh",
        --     loop = 0,
        --     fnMovementCall = function ( armature,movementType,movementID )
        --         if(movementType == 1) then
        --             if(_isAutoEnhance) then
        --                 addAnimation3()
        --             end
        --             armature:removeFromParentAndCleanup(true)
        --             armature = nil
        --             _animationData.aniData_2 = nil
        --         end
        --     end,
        -- })
        --_animationData.aniData_2:setPosition(pLay:getSize().width/2, pLay:getSize().height / 2)
        --_animationData.aniData_2:setTag(999992)
        _animationData.aniData_2:setPosition(pLay:getPositionX() + pLay:getSize().width/2, pLay:getPositionY() + pLay:getSize().height / 2)
    	parentLay:addNode(_animationData.aniData_2, 3)
        --pLay:addNode(_animationData.aniData_2, 3)
    end

    -- 强化成功
    function addAnimation3( )
        -- 2016-02-18 yucong 特效音效整合到AttribEffectManager统一管理
        -- AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
        _animationData.aniData_3 = g_attribManager:createStrenOKEffect({
            fnMovementCall = function ( armature,movementType,movementID )
                if(movementType == 1) then
                    -- if(_isAutoEnhance) then
                    --     -- 动画队列后移
                    --     _equipIndex = _equipIndex + 1
                    --     -- 刷新单一装备显示
                    --     reloadSingleEquip(pInfo)
                    --     addAutoAnimation()
                    -- end
                    armature:removeFromParentAndCleanup(true)
                    armature = nil
                    _animationData.aniData_3 = nil
                end
            end,
            fnFrameCall = function ( bone,frameEventName,originFrameIndex,currentFrameIndex )
                if(_isAutoEnhance) then
                    MainEquipMasterView.showAttrChangeAnimation(pInfo)
                    addAnimation4(pInfo)
                end
            end,
        })
        _animationData.aniData_3:setPosition(ccp(visibleSize.width*0.5, visibleSize.height *0.5 + 50))
        --_animationData.aniData_3:setTag(999993)
        _mainLayer:addNode(_animationData.aniData_3, 3)
    end


   --  提升几级
    function addAnimation4( _info )
        logger:debug(_info)
        -- local pName = ""
        -- local pNum100 = 0
        -- local pNum10 = 0
        -- local pNum1 = 0
        local level_num = tonumber(_info.varNew) - tonumber(_info.varOld)
        logger:debug({xxxInfo = _info})
        
        -- pNum100 = math.modf(level_num/100) or 0
        -- local pr = level_num - pNum100*100 or 0
        -- pNum10 =  math.modf(pr/10) or 0
        -- local pr2 = level_num - pNum100*100 - pNum10*10 or 0
        -- pNum1 = pr2

        -- if( level_num >= 100 ) then
        --     pName = "qh3_3_3"
        -- elseif( level_num >= 10 ) then
        --     pName = "qh3_3_2"
        -- else
        --     pName = "qh3_3_1"
        -- end
        
        AudioHelper.playEffect("audio/effect/texiao_tishengXji.mp3")
        _animationData.aniData_4 = g_attribManager:createAddLevelEffect({
            level = level_num,
            fnMovementCall = function ( armature,movementType,movementID )
                if(movementType == 1) then
                    if(_isAutoEnhance) then
                        -- 动画队列后移
                        _equipIndex = _equipIndex + 1
                        -- 刷新单一装备显示
                        reloadSingleEquip(pInfo)
                        addAutoAnimation()
                    end
                    armature:removeFromParentAndCleanup(true)
                    armature = nil
                    _animationData.aniData_4 = nil
                end
            end,
        })
        -- UIHelper.createArmatureNode({
        --     filePath = _animationPath .. "/qh3_3/qh3_3.ExportJson",
        --     animationName = pName,
        --     loop = 0,
        --     fnMovementCall = function ( armature,movementType,movementID )
        --         if(movementType == 1) then
        --             armature:removeFromParentAndCleanup(true)
        --             armature = nil
        --             _animationData.aniData_4 = nil
        --         end
        --     end,
        -- })


        -- --[[desc:替换数字
        --     _boneName: 
        --     _num:
        --     return: 是否有返回值，返回值说明  
        -- —]]
        -- local function changeNum( _boneName , _num )
        --     local mBone = _animationData.aniData_4:getBone(_boneName)
        --     local numFile = string.format("%s/number/no%d.png", _animationPath , _num)
        --     local ccSkin = CCSkin:create(numFile)
        --     ccSkin:setAnchorPoint(ccp(0.5, 0.5)) -- 设置锚点和强化动画的锚点一致
        --     mBone:addDisplay(ccSkin,0) -- 替换
        -- end

        -- if(level_num >= 100) then
        --     changeNum("no9_2_Copy7",pNum100)
        --     changeNum("no9_Copy6",pNum10)
        --     changeNum("no9_Copy4",pNum1)
        -- elseif( level_num >= 10 ) then
        --     changeNum("no9_2",pNum10)
        --     changeNum("no9",pNum1)
        -- else
        --     changeNum("no9_2",pNum1)
        -- end

        _animationData.aniData_4:setPosition(visibleSize.width*0.5, visibleSize.height*0.5 - 50)
        --_animationData.aniData_4:setTag(999994)
        _mainLayer:addNode(_animationData.aniData_4,3)
    end
end

--[[desc:修改装备等级
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function changeAutoArmInfo( _armHid , _realArmLevel )
    local armInfos = _heroInfo.equip.arming
    for i = 1 , 4 do 
        local pID = armInfos[tostring(i)] or nil
         if ((not pID) == false and (tonumber(pID) ~= 0)) then
            local itemTemid = tonumber(pID.item_id)
            if( (tonumber(_armHid) == itemTemid) and (tonumber(_realArmLevel) > tonumber(pID.va_item_text.armReinforceLevel)) ) then
                local pV = {site = i , key = _armHid , varNew = _realArmLevel , varOld = pID.va_item_text.armReinforceLevel}
                table.insert(_autoEquip , pV)
                if(_heroInfo.hid~=nil)then
                    -- 修改伙伴身上的
                    HeroModel.setHeroEquipReinforceLevelBy(_heroInfo.hid, pID.item_id, _realArmLevel)
                    pID.va_item_text.armReinforceLevel = _realArmLevel
                else
                    -- 修改背包中的
                    DataCache.setArmReinforceLevelBy( itemTemid, _realArmLevel )
                end
            end
        end
    end
end

-- 全身强化网络回调
function onOnekey_serverCallback( cbFlag, dictData, bRet )
	if (not bRet) then
		-- 移除屏蔽层
		LayerManager.removeLayout()
		return
	end
	local pResult = table.isEmpty(dictData.ret)
    if(pResult)then
        assert(pResult , "doCallbackAutoReinforce dictData == nil")
        return
    end
    _autoEquip = {}
    logger:debug(dictData.ret)
    _nCrit = tonumber(dictData.ret[tostring(1)]) or 0
    _nCost = tonumber(dictData.ret[tostring(0)]) or 0
    UserModel.addSilverNumber( -_nCost )

    local pHero = HeroModel.getHeroByHid(_heroInfo.hid) or nil
    if(pHero) then
        _heroInfo = pHero
    end

    local armInfos = _heroInfo.equip.arming
    
    for i = 1 , 4 do 
        local pID = armInfos[tostring(i)] or nil
        if ((not pID) == false and (tonumber(pID) ~= 0)) then
            local itemTemid = tostring(pID.item_id)
            local pLevel = tonumber(dictData.ret[itemTemid]) or 0
            changeAutoArmInfo(itemTemid , pLevel)
            ItemUtil.setEquipEnchantLevel(tonumber(itemTemid))
            
        end
    end
    
    UserModel.setInfoChanged(true) 
    UserModel.updateFightValue({[_heroInfo.hid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER}})

    _isAutoEnhance = true
    addAutoAnimation()
end

-- 全身强化按钮回调
local function onOnekey( sender,eventType )

	if (eventType == TOUCH_EVENT_ENDED) then
        if (MainEquipMasterView.isOneKeyCannotUse(true)) then
            return
        end
        if (_curPage ~= 1) then 
			return
		end
		if(_isAutoEnhance) then
            return
        end
		
        AudioHelper.playCommonEffect()
        

        local armInfos = _heroInfo.equip.arming
        local pHaveArm = 4
        local pCanEnhance = false
        local pUnMoeny = false
        local pUnLevel = false
        local nCost = 0
        --对穿戴的装备判断
        for i = 1 , 4 do
            local pID = armInfos[tostring(i)] or nil
            if (not pID or tonumber(pID) == 0) then
                pHaveArm = pHaveArm - 1
            else
                local itemTemid = tonumber(pID.item_template_id)
                local armInfo = ItemUtil.getItemById(tonumber(itemTemid))

                local pNowLevel = tonumber(pID.va_item_text.armReinforceLevel) or 0
                local nNextLevel = pNowLevel + 1
                local pMaxLevel = tonumber(armInfo.level_limit_ratio * UserModel.getHeroLevel()) or 0
                local fee_id = armInfo.strengthenFeeID --"" .. armInfo.quality .. armInfo.type
                require "db/DB_Reinforce_fee"
                local m_fee_data = DB_Reinforce_fee.getDataById(tonumber(fee_id))
                local pCost = tonumber(m_fee_data["coin_lv" .. nNextLevel]) or 0
                local pHave = tonumber(UserModel.getSilverNumber()) or 0
                if( (pNowLevel < pMaxLevel)--[[ and (pCost <= pHave) ]])then
                    pCanEnhance = true
                    pCost = 0
                    -- 计算最大强化等级需要的贝里
                    for level = nNextLevel, pMaxLevel do
                        local need = pCost + tonumber(m_fee_data["coin_lv" .. level]) or 0
                        if (need > pHave) then
                            break
                        end
                        pCost = need
                    end
                    nCost = pCost + nCost
                    --logger:debug("nCost:"..nCost)
                else
                    if(pNowLevel >= pMaxLevel) then
                        pUnLevel = true
                    elseif(pCost > pHave) then
                        pUnMoeny = true
                    end
                end
            end
        end

        if(pCanEnhance) then
            -- 获取预计强化贝里
            RequestCenter.forge_autoReinforceAll(function ( cbFlag, dictData, bRet )
                if (bRet) then
                    logger:debug(dictData.ret)
                    local costMoney = tonumber(dictData.ret[tostring(0)]) or 0
                    local haveMoney = tonumber(UserModel.getSilverNumber()) or 0
                    if (costMoney > 0 and costMoney <= haveMoney) then
                        -- 处理大于100万的格式
                        local strCost = UIHelper.getBellyStringAndUnit(costMoney)
                        local layer = g_fnLoadUI("ui/formation_guru_tip1.json")
                        layer.TFD_BELLY_NUM:setText(tostring(strCost))
                        layer.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)
                        layer.BTN_CANCEL:addTouchEventListener(UIHelper.onClose)
                        layer.BTN_CONFIRM:addTouchEventListener(function ( sender, eventType )
                            if (eventType == TOUCH_EVENT_ENDED) then
                                AudioHelper.playCommonEffect()
                                LayerManager.removeLayout()
                                -- 播放动画时加屏蔽层
                                local layout = Layout:create()
                                layout:setName("layForShield")
                                LayerManager.addLayout(layout)
                                -- 获得强化前的状态
                                _tBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(_heroInfo)
                                local args = Network.argsHandler(_heroInfo.hid)
                                RequestCenter.forge_autoReinforceAll( onOnekey_serverCallback , args)
                            end
                        end)
                        
                        LayerManager.addLayout(layer)
                    else
                        PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里掉落界面
                        ShowNotice.showShellInfo(m_i18n[5018])  --贝里不足，无法全身强化
                        return 
                    end
                end
            end, Network.argsHandlerOfTable({_heroInfo.hid, 1}))  
        else
            require "script/module/public/ShowNotice"
            if(pHaveArm == 0) then
                ShowNotice.showShellInfo(m_i18n[5019])  --该伙伴没有任何装备，无法全身强化
                return
            end
            -- if(pUnMoeny) then
            --     PublicInfoCtrl.createItemDropInfoViewByTid(60406)  -- 贝里掉落界面
            --     ShowNotice.showShellInfo(m_i18n[5018])  --贝里不足，无法全身强化
            --     return 
            -- end
            if(pUnLevel) then
                ShowNotice.showShellInfo(m_i18n[5020])  --该伙伴的所有装备已经强化至满级
                return 
            end
        end
        
    end
end

-- 切换按钮回调
local function onSwitch( sender,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 动画播放中
		if(_isAutoEnhance) then
	        return
	    end
		local btn = tolua.cast(sender,"Button")
	    if (btn) then
	        setCurPage(btn:getTag())
	        -- 刷新
	        reload()
	    end
	end
end

-- 刷新装备显示
local function reload_Equip( ... )
	-- 不在装备界面则不加载
	if (not isEquipPage()) then
		return
	end
	
	local armInfos = _heroInfo.equip.arming
    --该伙伴没有帽子、武器、项链、衣服
    local pEquipStrings = {m_i18n[5012],m_i18n[5011],m_i18n[5009],m_i18n[5013]}

    local pMaxNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.nScorelv + 1)
	if(pMaxNum == 0) then
		pMaxNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.nScorelv)
	end
	_maxNow = pMaxNum
    
    for i = 1 , 4 do 
    	local lay = _left_widgets[i]
        lay:setVisible(true)
        lay:setEnabled(true)
        --根据装备类型获取角色身上的装备
        local pID = armInfos[tostring(i)] or nil
        --没有装备对应装备
        if(not pID or tonumber(pID) == 0) then
        	lay.TFD_NO_EQUIP:setVisible(true)
        	lay.TFD_NAME:setVisible(false)
        	lay.IMG_LOAD_BG:setVisible(false)
        	lay.TFD_CANT_REFINE:setVisible(false)
        	lay.IMG_ICON:setVisible(false)
        	lay.IMG_LOCK:setVisible(false)
        	lay.TFD_UNLOCK_LV:setVisible(false)

        	lay.TFD_NO_EQUIP:setText(pEquipStrings[i])
            --提示 该伙伴没有xxx
            lay.BTN_FRAME:addTouchEventListener(function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    require "script/module/public/ShowNotice"
                    ShowNotice.showShellInfo(pEquipStrings[i])
                end
            end)
        else
        	lay.TFD_NO_EQUIP:setVisible(false)
        	lay.TFD_NAME:setVisible(true)
        	lay.IMG_LOAD_BG:setVisible(true)
        	lay.TFD_CANT_REFINE:setVisible(false)
        	lay.IMG_ICON:setVisible(true)
        	lay.IMG_LOCK:setVisible(false)
        	lay.TFD_UNLOCK_LV:setVisible(false)

        	local itemTemid = tonumber(pID.item_template_id)
        	-- 装备详细按钮回调
        	lay.BTN_FRAME:addTouchEventListener(function ( sender, eventType )
        		if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    -- 动画播放中
                    if(_isAutoEnhance) then
                        return
                    end

                    -- zhangqi, 2015-06-19, 从阵容进入装备强化
                    local createType = g_equipStrengthFrom.CreateType.createTypeFormation

                    if(isStrengthPage()) then
                        --强化某个装备
                        if (not SwitchModel.getSwitchOpenState(ksSwitchWeaponForge,true)) then
                            return
                        end
                        
                        require "script/module/equipment/EquipStrengModel"
                        local widgetStreng = EquipStrengModel.create(pID, closeChildCallback, createType)
                        LayerManager.addLayoutNoScale(widgetStreng, LayerManager.getModuleRootLayout())
                        PlayerPanel.addForPartnerStrength()
                        -- LayerManager.setPaomadeng(widgetStreng, 10) -- zhangqi, 2015-06-26, 显示跑马灯
                    else
                        if (not SwitchModel.getSwitchOpenState(ksSwitchEquipFixed,true)) then
                            return
                        end
                        require "script/module/equipment/EquipFixModel"
                        local isCanFix = EquipFixModel.isEuipCanFixByTid(pID.item_template_id)
                        if(tonumber(isCanFix) ~= 1) then
                            ShowNotice.showShellInfo(m_i18n[5201])
                            return 
                        end

                        require "script/module/equipment/EquipFixCtrl"
                        TimeUtil.timeStart("EquipFixCtrl.create")
                        EquipFixCtrl.create(pID, createType, _heroPageNum, closeChildCallback)
                        TimeUtil.timeEnd("EquipFixCtrl.create")
                    end
                end
        	end)
        	-- 装备信息
            local armInfo = ItemUtil.getItemById(tonumber(itemTemid))
            local armColor = HeroPublicUtil.getDarkColorByStarLv(armInfo.quality)
            -- 名字
            lay.TFD_NAME:setText(armInfo.name)
            lay.TFD_NAME:setColor(armColor)
            UIHelper.labelEffect(lay.TFD_NAME)
            -- 头像
            lay.IMG_ICON:loadTexture(armInfo.iconBigPath)

            local pNow = 0
            local pMaxLevel = 0
            -- 强化页
            if(isStrengthPage()) then
                --当前强化等级
                pNow = pID.va_item_text.armReinforceLevel or 0
                --目标强化等级
                pMaxLevel = (armInfo.level_limit_ratio * UserModel.getHeroLevel()) or 0

                _mainLayer.TFD_INFO:setText(m_i18n[5006])

            -- 附魔页
            else
                require "script/module/equipment/EquipFixModel"
                local isCanFix = EquipFixModel.isEuipCanFixByTid(pID.item_template_id)
                if(tonumber(isCanFix) ~= 1) then
                    lay.TFD_CANT_REFINE:setVisible(true)
                    lay.IMG_LOAD_BG:setVisible(false)
                    lay.TFD_CANT_REFINE:setText(m_i18n[5025])
                else
                    pMaxLevel = ItemUtil.getMaxEnchatLevel(pID)
                    pMaxLevel = pMaxLevel or 0
                    pNow = pID.va_item_text.armEnchantLevel or 0
                end
                _mainLayer.TFD_INFO:setText(m_i18n[5026])
            end
            pMaxLevel = pMaxNum
            --进度条上显示 0 / 10
            --lay.TFD_LVNUM:setText(tostring(pNow).."/"..tostring(pMaxLevel))
            UIHelper.labelAddNewStroke(lay.TFD_LVNUM, tostring(pNow).."/"..tostring(pMaxLevel), ccc3(0x8e, 0x46, 0x00))
            --设置进度
            local pPercent = pMaxLevel == 0 and 0 or (tonumber(pNow)/tonumber(pMaxLevel) or 0)
            pPercent = pPercent > 1 and 1 or pPercent
            lay.LOAD_PROGRESS:setPercent(tonumber(pPercent)*100)
        end
    end
end

-- 刷新宝物显示
local function reload_Treasure( ... )
	-- 不在宝物界面则不加载
	if (isEquipPage()) then
		return
	end

	local treasureInfo = _heroInfo.equip.treasure
	local openTreasureLvArr = FormationUtil.getTreasureOpenLvInfo()
    local pLevel = UserModel.getHeroLevel()
    --该伙伴没有魔防型宝物...
    local pTreaStrings = {m_i18n[5014],m_i18n[5015],m_i18n[5016],m_i18n[5017]}
    
    _left_widgets[4]:setVisible(false)
    _left_widgets[4]:setEnabled(false)
    for i = 1, kTREASURE_NUM do 
    	local lay = _left_widgets[i]
        lay:setVisible(true)
        lay:setEnabled(true)
    	--宝物
        local pID = treasureInfo[tostring(i)] or nil
        local pLv = tonumber(openTreasureLvArr[i]) or 0
        	
        -- 没开启
        if(pLv > pLevel) then
        	lay.TFD_NO_EQUIP:setVisible(false)
        	lay.TFD_NAME:setVisible(false)
        	lay.IMG_LOAD_BG:setVisible(false)
        	lay.TFD_CANT_REFINE:setVisible(false)
        	lay.IMG_ICON:setVisible(false)
        	lay.IMG_LOCK:setVisible(true)
        	lay.TFD_UNLOCK_LV:setVisible(true)

        	lay.TFD_NO_EQUIP:setText(pTreaStrings[i])
        	lay.TFD_UNLOCK_LV:setText(tostring(pLv)..tostring(m_i18n[5027]))
            --提示 该伙伴没有xxx
            lay.BTN_FRAME:addTouchEventListener(function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    require "script/module/public/ShowNotice"
                    local pStr = pLv .. m_i18n[1201]
                    ShowNotice.showShellInfo(pStr)
                end
            end)
        --没有装备对应装备
        elseif(not pID or tonumber(pID) == 0) then
        	lay.TFD_NO_EQUIP:setVisible(true)
        	lay.TFD_NAME:setVisible(false)
        	lay.IMG_LOAD_BG:setVisible(false)
        	lay.TFD_CANT_REFINE:setVisible(false)
        	lay.IMG_ICON:setVisible(false)
        	lay.IMG_LOCK:setVisible(false)
        	lay.TFD_UNLOCK_LV:setVisible(false)
        	--_mainLayer.BTN_ONEKEY:setVisible(false)
        	--_mainLayer.BTN_ONEKEY:setTouchEnabled(false)
        	--_mainLayer.TFD_ALL_STR:setVisible(false)

        	lay.TFD_NO_EQUIP:setText(pTreaStrings[i])
            --提示 该伙伴没有xxx
            lay.BTN_FRAME:addTouchEventListener(function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    require "script/module/public/ShowNotice"
                    ShowNotice.showShellInfo(pTreaStrings[i])
                end
            end)
        else
        	lay.TFD_NO_EQUIP:setVisible(false)
        	lay.TFD_NAME:setVisible(true)
        	lay.IMG_LOAD_BG:setVisible(true)
        	lay.TFD_CANT_REFINE:setVisible(false)
        	lay.IMG_ICON:setVisible(true)
        	lay.IMG_LOCK:setVisible(false)
        	lay.TFD_UNLOCK_LV:setVisible(false)

        	local pMaxNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.nScorelv + 1)
		    if(pMaxNum == 0) then
		        pMaxNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.nScorelv)
		    end

        	local itemTemid = tonumber(pID.item_template_id)
        	-- 装备详细按钮回调
        	lay.BTN_FRAME:addTouchEventListener(function ( sender, eventType )
        		if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    -- 动画播放中
                    if(_isAutoEnhance) then
                        return
                    end
                    if(isStrengthPage()) then
                        --强化某个装备
                        if (not SwitchModel.getSwitchOpenState(ksSwitchTreasureForge,true)) then
                            return
                        end
                        
                        logger:debug(_heroPageNum)

                        require "script/module/treasure/treaForgeCtrl"
                        local layout = treaForgeCtrl.create(pID.item_id,layFromForType, _heroPageNum , MainFormation.fnShowEquipMaster3)
                        LayerManager.changeModule(layout, treaForgeCtrl.moduleName(), {1, 3}, true)
                        PlayerPanel.addForPartnerStrength()
                    else
                        if (not SwitchModel.getSwitchOpenState(ksSwitchTreasureFixed,true)) then
                            return
                        end
                        require "script/module/treasure/treaInfoModel"
                        local treaData = treaInfoModel.fnGetTreasAllData(pID.item_id) -- zhangqi, 2015-06-15, 用开销小的fnGetTreasAllData代替
                        if(tonumber(treaData.dbData.isUpgrade) ~= 1) then
                            ShowNotice.showShellInfo(m_i18n[1720])
                            return 
                        end
                        require "script/module/treasure/treaRefineCtrl"
                        treaRefineCtrl.create(pID.item_id,layFromForType, _heroPageNum , MainFormation.fnShowEquipMaster4)
                    end
                end
        	end)
        	-- 装备信息
            local treaInfo = ItemUtil.getItemById(tonumber(itemTemid))
            local armColor = HeroPublicUtil.getDarkColorByStarLv(treaInfo.quality)
            -- 名字
            lay.TFD_NAME:setText(treaInfo.name)
            lay.TFD_NAME:setColor(armColor)
            UIHelper.labelEffect(lay.TFD_NAME)
            -- 头像
            lay.IMG_ICON:loadTexture(treaInfo.iconBigPath)

            local pNow = 0
            local pMaxLevel = 0

            -- 强化页
            if(isStrengthPage()) then
                pNow = tonumber(pID.va_item_text.treasureLevel) or 0
                    local pInt = tonumber(treaInfo.level_interval) or 0
                    local pn = 0
                    if(pInt == 0) then
                        pn = tonumber(treaInfo.level_limited) or 0
                    else
                        pn = math.modf(tonumber(UserModel.getHeroLevel())/pInt)
                    end
                    pMaxLevel = pn or 0

                _mainLayer.TFD_INFO:setText(m_i18n[5007])

            -- 附魔页
            else
            	pNow = tonumber(pID.va_item_text.treasureEvolve) or 0
            	local pmax = 0
                if(tonumber(treaInfo.isUpgrade) ~= 1) then
                    lay.TFD_CANT_REFINE:setVisible(true)
                    lay.IMG_LOAD_BG:setVisible(false)
                    lay.TFD_CANT_REFINE:setText(m_i18n[1720])--wm_todo
                else
                    require "db/DB_Treasurerefine"
                    local pFine = DB_Treasurerefine.getDataById(treaInfo.id) or nil
                    if(pFine) then
                        pmax = pFine.max_upgrade_level
                    end
                end
                pMaxLevel = tonumber(pmax) or 0
                _mainLayer.TFD_INFO:setText(m_i18n[5008])
            end
            pMaxLevel = pMaxNum
            --进度条上显示 0 / 10
            UIHelper.labelAddNewStroke(lay.TFD_LVNUM, tostring(pNow).."/"..tostring(pMaxLevel), ccc3(0x8e, 0x46, 0x00))
            --设置进度
            local pPercent = pMaxLevel == 0 and 0 or (tonumber(pNow)/tonumber(pMaxLevel) or 0)
            pPercent = pPercent > 1 and 1 or pPercent
            lay.LOAD_PROGRESS:setPercent(tonumber(pPercent)*100)
        end
    end
end

-- 刷新右面详细信息
local function reload_MasterInfo( ... )
	local infoStr = {m_i18n[5028],m_i18n[5029],m_i18n[5030],m_i18n[5031]}
    local infoStr_2 = {m_i18n[5032],m_i18n[5033],m_i18n[5034],m_i18n[5035]}
    local infoStr_3 = {m_i18n[5042],m_i18n[5043],m_i18n[5042],m_i18n[5044]} -- 强化到 抚摸到》。。。
    -- 升级前
    local bfLay = _mainLayer.LAY_BEFORE
	if (bfLay) then
		local bfLay_lv0 = _mainLayer.LAY_LV0_BEFORE
		local pAttrInfo = _masterdata.tbAttr_info
        local pcount = table.count(pAttrInfo)
        -- 当前没有达到任何等级
        if (pcount == 0) then
        	bfLay:setVisible(false)
        	bfLay_lv0:setVisible(true)

        	local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, 1)
        	local ptxt = string.format(infoStr_2[_curPage], pNum.."")
            -- 全身每件装备 饰品
            bfLay_lv0.TFD_LV0_DESC1:setText(isEquipPage() and m_i18n[5045] or m_i18n[5046])
            _mainLayer.TFD_LV0_LV:setText(infoStr_3[_curPage])
            _mainLayer.TFD_LV0_LV_NUM:setText(pNum)
            _mainLayer.TFD_JI:setText(m_i18n[3643])
            bfLay_lv0.TFD_LV0_DESC2:setText(m_i18n[5036])
            -- UIHelper.labelNewStroke(bfLay_lv0.TFD_LV0_DESC1)
            -- UIHelper.labelNewStroke(bfLay_lv0.TFD_LV0_DESC2)
            -- UIHelper.labelNewStroke(_mainLayer.TFD_LV0_LV)
            -- UIHelper.labelNewStroke(_mainLayer.TFD_LV0_LV_NUM)
            -- UIHelper.labelNewStroke(_mainLayer.TFD_JI)
        else
        	local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.nScorelv)
        	bfLay:setVisible(true)
        	bfLay_lv0:setVisible(false)
		    --bfLay.TFD_STRGURU_LV_BEFORE:setVisible(true)
		    bfLay.TFD_STRGURU_LV_BEFORE:setText(infoStr[_curPage])
		    --UIHelper.labelAddNewStroke(bfLay.TFD_STRGURU_LV_BEFORE, infoStr[_curPage], ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_STRGURU_LV_BEFORE_NUM:setVisible(true)
		    bfLay.TFD_STRGURU_LV_BEFORE_NUM:setText(tostring(_masterdata.nScorelv))
		    --UIHelper.labelAddNewStroke(bfLay.TFD_STRGURU_LV_BEFORE_NUM, tostring(_masterdata.nScorelv), ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_JI1:setVisible(true)
		    bfLay.TFD_JI1:setText(m_i18n[3643])
		    --UIHelper.labelAddNewStroke(bfLay.TFD_JI1, m_i18n[3643], ccc3(0x00, 0x20, 0x68))
		    local ptxt = string.format(infoStr_2[_curPage], pNum.."")
		    bfLay.TFD_LIMIT_BEFORE:setText(ptxt)
		    -- 属性
		    for i=1, 5 do
                local tfd_attr = m_fnGetWidget(bfLay , "TFD_ATTR"..i)
                local ftd_attr_num = m_fnGetWidget(bfLay , "TFD_ATTR"..i.."_NUM")
                if(i <= pcount) then
                    local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(pAttrInfo[i][1],pAttrInfo[i][2])
                    tfd_attr:setText(affixInfo.displayName)
                    ftd_attr_num:setText("+"..displayNum)
                else
                    tfd_attr:setText("")
                    ftd_attr_num:setText("")
                end
                -- 停靠的问题 手动设置坐标，不然会乱
                tfd_attr:setAnchorPoint(ccp(0, 0.5))
                ftd_attr_num:setAnchorPoint(ccp(0, 0.5))
                ftd_attr_num:setPosition(ccp(tfd_attr:getPositionX() + tfd_attr:getContentSize().width + 33, ftd_attr_num:getPositionY()))
            end
        end
		
	end

	-- 升级后
	local afLay = _mainLayer.LAY_AFTER
	if (afLay) then
		-- 下一级属性
		local pNextAttrInfo = _masterdata.tbAttr_afinfo
		local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage,_masterdata.nScorelv + 1)
		
        local pcount = table.count(pNextAttrInfo)
        if (pcount == 0) then
        	afLay:setVisible(false)
        	_mainLayer.IMG_ARROW:setVisible(false)
        	
        else
        	afLay:setVisible(true)
        	_mainLayer.IMG_ARROW:setVisible(true)
		    --bfLay.TFD_STRGURU_LV_BEFORE:setVisible(true)
		    afLay.TFD_STRGURU_LV_AFTER:setText(infoStr[_curPage])
		    --UIHelper.labelAddNewStroke(afLay.TFD_STRGURU_LV_AFTER, infoStr[_curPage], ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_STRGURU_LV_BEFORE_NUM:setVisible(true)
		    afLay.TFD_STRGURU_LV_AFTER_NUM:setText(tostring(_masterdata.nScorelv + 1))
		    --UIHelper.labelAddNewStroke(afLay.TFD_STRGURU_LV_AFTER_NUM, tostring(_masterdata.nScorelv + 1), ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_JI1:setVisible(true)
		    afLay.TFD_JI2:setText(m_i18n[3643])
		    --UIHelper.labelAddNewStroke(afLay.TFD_JI2, m_i18n[3643], ccc3(0x00, 0x20, 0x68))
		    local ptxt = string.format(infoStr_2[_curPage], pNum.."")
		    afLay.TFD_LIMIT_AFTER:setText(ptxt)
		    -- 属性
		    for i=1, 5 do
                local tfd_attr = m_fnGetWidget(afLay , "TFD_ATTR"..i)
                local ftd_attr_num = m_fnGetWidget(afLay , "TFD_ATTR"..i.."_NUM")
                
                if(i <= pcount) then
                    local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(pNextAttrInfo[i][1], pNextAttrInfo[i][2])
                    tfd_attr:setText(affixInfo.displayName)
                    ftd_attr_num:setText("+"..displayNum)
                else
                    tfd_attr:setText("")
                    ftd_attr_num:setText("")
                end

                -- 停靠的问题
                tfd_attr:setAnchorPoint(ccp(0, 0.5))
                ftd_attr_num:setAnchorPoint(ccp(0, 0.5))
                ftd_attr_num:setPosition(ccp(tfd_attr:getPositionX() + tfd_attr:getContentSize().width + 33, ftd_attr_num:getPositionY()))
            end
        end
		
	end
end

-- 清理动画效果
local function clearEffects( ... )
	-- if (_mainLayer) then
	-- 	_mainLayer:removeChildByTag(999991, true)
	-- 	_mainLayer:removeChildByTag(999992, true)
	-- 	_mainLayer:removeChildByTag(999993, true)
	-- 	_mainLayer:removeChildByTag(999994, true)
	-- end

	if (_animationData.aniData_1) then
		--_animationData.aniData_1:getAnimation():stop()
		--_animationData.aniData_1:removeFromParentAndCleanup(true)
		_animationData.aniData_1 = nil
	elseif (_animationData.aniData_2) then
		--_animationData.aniData_2:getAnimation():stop()
		--_animationData.aniData_2:removeFromParentAndCleanup(true)
		_animationData.aniData_2 = nil
	elseif (_animationData.aniData_3) then
		--_animationData.aniData_3:getAnimation():stop()
		--_animationData.aniData_3:removeFromParentAndCleanup(true)
		_animationData.aniData_3 = nil
	elseif (_animationData.aniData_4) then
		--_animationData.aniData_4:getAnimation():stop()
		--_animationData.aniData_4:removeFromParentAndCleanup(true)
		_animationData.aniData_4 = nil
	end

	if (_animationData.flyNode) then
		--_animationData.flyNode:removeFromParent()
		_animationData.flyNode = nil
	end
end

-- 刷新界面接口
function reload( ... )
	-- 清理动画效果
	clearEffects()
	-- 数据处理
	handleDatas()
	
	createFrame()
	-- 左边
	reload_Equip()

	reload_Treasure()
	-- 右边
	reload_MasterInfo()
end

-- 加载界面显示框架
function createFrame( ... )


	local titleStr
	if (isStrengthPage()) then
		titleStr = m_i18n[5004]
	elseif (isEquipPage()) then
		titleStr = m_i18n[5038]		-- yucong_todo
	else
		titleStr = m_i18n[5005]
	end
	UIHelper.labelAddNewStroke(_mainLayer.TFD_LOAD, titleStr, ccc3(0x9c, 0x4d, 0x00))

	-- 加载左边四个装备栏层
	_left_widgets[1] = _mainLayer.LAY_1
	_left_widgets[2] = _mainLayer.LAY_2
	_left_widgets[3] = _mainLayer.LAY_3
	_left_widgets[4] = _mainLayer.LAY_4
	
	-- 一键强化
	--_mainLayer.BTN_ONEKEY:addTouchEventListener(onOnekey)
	--UIHelper.titleShadow(_mainLayer.BTN_ONEKEY, m_i18n[5021])
	-- 右边的switch开关按钮
	-- _mainLayer.BTN_TREASURE_STR:addTouchEventListener(onSwitch)
	-- _mainLayer.BTN_ENHANCE:addTouchEventListener(onSwitch)
	-- local ttf_1 = tolua.cast(_mainLayer.BTN_TREASURE_STR:getTitleTTF(), "CCLabelTTF")
	-- local ttf_2 = tolua.cast(_mainLayer.BTN_ENHANCE:getTitleTTF(), "CCLabelTTF")
	-- -- 策划不会翻转，我替他翻转
	-- ttf_2:setFlipX(false)
	-- if (isEquipPage()) then
	-- 	_mainLayer.BTN_TREASURE_STR:setTag(1)
	-- 	_mainLayer.BTN_ENHANCE:setTag(2)
	-- 	ttf_1:setString(m_i18n[5001])
	-- 	ttf_2:setString(m_i18n[5037])	-- yucong_todo
	-- else
	-- 	_mainLayer.BTN_TREASURE_STR:setTag(3)
	-- 	_mainLayer.BTN_ENHANCE:setTag(4)
	-- 	ttf_1:setString(m_i18n[5002])
	-- 	ttf_2:setString(m_i18n[5003])
	-- end

	-- 装备强化界面显示全身强化按钮
	if (isEquipPage() and isStrengthPage()) then
		
		--_mainLayer.TFD_ALL_STR:setVisible(true)
        --_mainLayer.BTN_ONEKEY:setVisible(true)
        --_mainLayer.BTN_ONEKEY:setTouchEnabled(true)
        --_mainLayer.TFD_ALL_STR:setText(_masterdata.strOnekey_Str)
        -- if (not MainEquipMasterView.isOneKeyCannotUse()) then
        --     _mainLayer.TFD_ALL_STR:setVisible(false)
        -- end 
    else
    	--_mainLayer.TFD_ALL_STR:setVisible(false)
        --_mainLayer.BTN_ONEKEY:setVisible(false)
        --_mainLayer.BTN_ONEKEY:setTouchEnabled(false)
	end
	
	_mainLayer.IMG_STR_GURU:setZOrder(1)
end

local function init( parentWidget, heroInfo, heroPage )
	local parLayer = tolua.cast(parentWidget,"Widget")
	_mainLayer = m_fnGetWidget(parLayer, "LAY_STR_GURU")
	_mainLayer:setZOrder(1)
	_heroInfo = heroInfo
	_curPage = type or 1
	_heroPageNum = heroPage or 1

	createFrame()
end

function destroy(...)
	clearEffects()
	_mainLayer = nil
	_heroInfo = nil
	_autoEquip = {}		-- 自动强化的装备们~
	_equipIndex = 1
	_tBefore = nil
	_isAutoEnhance = false
	package.loaded["MasterEquipAndTreasure"] = nil
end


function moduleName()
	return "MasterEquipAndTreasure"
end

function create( parentWidget, heroInfo, heroPage )
	init(parentWidget, heroInfo, heroPage)

	return _mainLayer
end