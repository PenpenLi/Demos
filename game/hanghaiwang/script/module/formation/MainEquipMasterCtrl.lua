-- FileName: MainEquipMasterCtrl.lua
-- Author: wangming
-- Date: 2014-12-11
-- Purpose: 装备大师模块
--[[TODO List]]

module("MainEquipMasterCtrl", package.seeall)
-- require "script/module/formation/MainEquipMasterView"
-- UI控件引用变量 --
local m_i18n    = gi18n
-- 模块局部变量 --
local m_heroInfo    = nil
local m_curPageNum
local m_all_str_openVip = -1
local m_all_str_openLv = -1
local m_tipStr = nil
local _tbMasterChangeData = nil

local function init(...)

end

function destroy(...)
    m_heroInfo = nil
	package.loaded["MainEquipMasterCtrl"] = nil
end

function moduleName()
    return "MainEquipMasterCtrl"
end

--[[desc:修改装备等级
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function changeAutoArmInfo( _armHid , _realArmLevel )
    local changePos = -1
    local armInfos = m_heroInfo.equip.arming
    for i = 1 , 4 do 
        local pID = armInfos[tostring(i)] or nil
         if ((not pID) == false and (tonumber(pID) ~= 0)) then
            local itemTemid = tonumber(pID.item_id)
            if( (tonumber(_armHid) == itemTemid) and (tonumber(_realArmLevel) > tonumber(pID.va_item_text.armReinforceLevel)) ) then
                -- local pV = {site = i , key = _armHid , varNew = _realArmLevel , varOld = pID.va_item_text.armReinforceLevel}
                -- table.insert(_autoEquip , pV)
                changePos = i
                if(m_heroInfo.hid~=nil)then
                    -- 修改伙伴身上的
                    HeroModel.setHeroEquipReinforceLevelBy(m_heroInfo.hid, pID.item_id, _realArmLevel)
                    pID.va_item_text.armReinforceLevel = _realArmLevel
                else
                    -- 修改背包中的
                    DataCache.setArmReinforceLevelBy( itemTemid, _realArmLevel )
                end
            end
        end
    end
    return changePos
end

function onAutoStren( heroInfo, func )
    logger:debug({heroInfoxxx = heroInfo})
    m_heroInfo = heroInfo
    local armInfos = m_heroInfo.equip.arming
    local pHaveArm = 4
    local pCanEnhance = false
    local pUnMoeny = false
    local pUnLevel = false
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
            local pHave = tonumber(UserModel.getSilverNumber()) or 0
            if( (pNowLevel < pMaxLevel))then
                pCanEnhance = true
            else
                if(pNowLevel >= pMaxLevel) then
                    pUnLevel = true
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
                            -- local layout = Layout:create()
                            -- layout:setName("layForShield")
                            -- LayerManager.addLayout(layout)
                            -- -- 获得强化前的状态
                            -- _tBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(heroInfo)
                            local args = Network.argsHandler(m_heroInfo.hid)
                            RequestCenter.forge_autoReinforceAll( function ( ... )
                                onAutoStrenOK(...)
                                if (func) then
                                    func(_tbMasterChangeData)
                                    _tbMasterChangeData = nil
                                end
                            end , args)
                        end
                    end)
                    
                    LayerManager.addLayout(layer)
                else
                    PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里掉落界面
                    ShowNotice.showShellInfo(m_i18n[5018])  --贝里不足，无法全身强化
                    return 
                end
            end
        end, Network.argsHandlerOfTable({m_heroInfo.hid, 1}))  
    else
        require "script/module/public/ShowNotice"
        if(pHaveArm == 0) then
            ShowNotice.showShellInfo(m_i18n[5019])  --该伙伴没有任何装备，无法全身强化
            return
        end
        if(pUnLevel) then
            ShowNotice.showShellInfo(m_i18n[5020])  --该伙伴的所有装备已经强化至满级
            return 
        end
    end
end

function onAutoStrenOK( cbFlag, dictData, bRet )
    if (bRet) then
        local pResult = table.isEmpty(dictData.ret)
        if(pResult)then
            assert(pResult , "doCallbackAutoReinforce dictData == nil")
            return
        end
        -- _autoEquip = {}
        logger:debug(dictData.ret)
        -- _nCrit = tonumber(dictData.ret[tostring(1)]) or 0
        local nCost = tonumber(dictData.ret[tostring(0)]) or 0
        UserModel.addSilverNumber( -nCost )

        local pHero = HeroModel.getHeroByHid(m_heroInfo.hid) or nil
        if(pHero) then
            m_heroInfo = pHero
        end
        -- 记录初始数据
        local armPos = {}
        local masterBefore = fnGetMasterInfoByHeroInfo(m_heroInfo)
        local orignForceData = HeroFightUtil.getAllForceValuesByHid(m_heroInfo.hid)
        local orignFightForce = UserModel.getFightForceValue()
        -- 修改数据
        local tChangePos = {}
        local armInfos = m_heroInfo.equip.arming
        for i = 1 , 4 do 
            local pID = armInfos[tostring(i)] or nil
            if ((not pID) == false and (tonumber(pID) ~= 0)) then
                local itemTemid = tostring(pID.item_id)
                local pLevel = tonumber(dictData.ret[itemTemid]) or 0
                if (tonumber(pLevel) > tonumber(pID.va_item_text.armReinforceLevel)) then
                    if(m_heroInfo.hid~=nil)then
                        -- 修改伙伴身上的
                        HeroModel.setHeroEquipReinforceLevelBy(m_heroInfo.hid, pID.item_id, pLevel)
                        pID.va_item_text.armReinforceLevel = pLevel
                    else
                        -- 修改背包中的
                        DataCache.setArmReinforceLevelBy( itemTemid, pLevel )
                    end
                    MainEquipmentCtrl.replaceEquipDataByItemId(tonumber(itemTemid))
                    tChangePos[i] = 1
                    ItemUtil.setEquipEnchantLevel(tonumber(itemTemid))
                end
            end
        end

        UserModel.setInfoChanged(true) 
        UserModel.updateFightValue({[m_heroInfo.hid] = {HeroFightUtil.FORCEVALUEPART.ARM}})
        local strenForceData = HeroFightUtil.getAllForceValuesByHid(m_heroInfo.hid)
        -- logger:debug({orignForceData = orignForceData})
        -- logger:debug({strenForceData = strenForceData})

        UserModel.setInfoChanged(true) 
        UserModel.updateFightValue({[m_heroInfo.hid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER}}) 
        -- 记录当前数据
        local masterAfter = fnGetMasterInfoByHeroInfo(m_heroInfo)
        local masterForceData = HeroFightUtil.getAllForceValuesByHid(m_heroInfo.hid)
        local finalFightForce = UserModel.getFightForceValue()
        -- logger:debug({orignForceData = orignForceData})
        -- logger:debug({strenData = strenData})
        --logger:debug({masterForceData = masterForceData})
        -- 相减的元方法
        local mt = {}
        mt.__sub = function ( t1, t2 )
            return {
                life            = t1.life - t2.life, 
                physicalAttack  = t1.physicalAttack - t2.physicalAttack, 
                physicalDefend  = t1.physicalDefend - t2.physicalDefend, 
                magicAttack     = t1.magicAttack - t2.magicAttack, 
                magicDefend     = t1.magicDefend - t2.magicDefend, 
                speed           = t1.speed - t2.speed,
            }
        end
        setmetatable(orignForceData, mt)
        setmetatable(strenForceData, mt)
        setmetatable(masterForceData, mt)
        
        -- orignData 原始属性数值
        -- armData 装备强化属性变化的数值
        -- masterData 强化大师属性变化的数值
        -- finalData 最终属性
        -- masterChangeString 强化大师当前的描述
        -- orignFightForce 原始战斗力
        -- finalFightForce 现在战斗力
        _tbMasterChangeData = {}
        _tbMasterChangeData.orignData           = orignForceData
        _tbMasterChangeData.armData             = strenForceData - orignForceData -- armData
        _tbMasterChangeData.masterData          = masterForceData - strenForceData -- masterData
        _tbMasterChangeData.finalData           = masterForceData
        _tbMasterChangeData.masterChangeString  = fnGetAllMasterChangeString2(masterBefore, masterAfter)
        _tbMasterChangeData.orignFightForce     = orignFightForce
        _tbMasterChangeData.finalFightForce     = finalFightForce
        _tbMasterChangeData.tChangePos          = tChangePos
        --logger:debug({_tbMasterChangeData = _tbMasterChangeData})
        m_heroInfo = nil
    end
end

-- 获得开启等级
function fnGetAllStrOpenLv( ... )
    m_all_str_openVip = -1
    m_all_str_openLv = -1
    m_tipStr = nil
    local vipData = nil
    local pCount = table.count(DB_Vip.Vip)
    local pVerTab = nil
    for i=1,pCount do
        vipData = DB_Vip.getDataById(i)
        if(vipData and vipData.all_str_limit) then
            pVerTab = string.split(vipData.all_str_limit, "|") 
            local pOpen = tonumber(pVerTab[1]) or 0
            if(pOpen == 1 and m_all_str_openVip == -1) then
                m_all_str_openVip = i
                m_all_str_openLv = tonumber(pVerTab[2]) or 0
                m_tipStr = string.format(m_i18n[5022],tostring(m_all_str_openVip),tostring(m_all_str_openLv))
                return m_all_str_openVip, m_all_str_openLv, m_tipStr
            end
        end
    end
    return m_all_str_openVip, m_all_str_openLv, m_tipStr
end

function isOneKeyEnabled( isShowInfo )
    local pShow = isShowInfo or false
    -- return ( not SwitchModel.getSwitchOpenState(ksSwitchMasterOneKey , pShow))
    local pherolv = UserModel.getHeroLevel()
    local pviplv = UserModel.getVipLevel()
    if(pherolv < m_all_str_openLv and pviplv < m_all_str_openVip) then
        if(pShow and m_tipStr) then
            require "script/module/public/ShowNotice"
            ShowNotice.showShellInfo(m_tipStr)
        end
        return false
    end
    return true
end

--装备大师相关飘字动画
-- @param strings 来自fnGetMasterChangeStringByHeroInfo()，也可以来自别处
-- isKeep：特效结束后是否保留根节点，默认删除  isKeep=true:保留 。
function fnGetMasterFlyInfo( strings, setH, callBack ,isKeep)
    if(table.isEmpty(strings)) then
        if(callBack) then
            callBack()
        end
        return nil
    end
    local pStrings = strings.string or ""
    logger:debug({wm____strings = strings})

    local mFontSize = 28
    local mFontColor = ccc3(0x00, 0xff, 0x06)
    local mFontName = g_FontCuYuan
    local strokeC = ccc3(0x00, 0x31, 0x00)
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    local pSize = runningScene:getContentSize()
    local pH = tonumber(setH) or pSize.height*0.5

    local pNode = CCNode:create()
    local pcount = 0
    local pHeight = 0
    local ttfTbs = {}
    local partH = 10
    local topH = 17 --距离背景的上下边距


    local sp1 = CCSprite:create("images/common/showflytext_bg1.png")    
    local oriSize = sp1:getContentSize()
    local rect = CCRect(oriSize.width/2-80,oriSize.height/2-15,160,30)
    local bgSp = CCScale9Sprite:create(rect,"images/common/showflytext_bg1.png")    
    pNode:addChild(bgSp)
    bgSp:setScale(0)
    bgSp:setOpacity(0)
    bgSp:setPosition(ccp(pSize.width/2,pSize.height/2))
    local bgSpW = oriSize.width
    local bgSpH 

    if(pStrings ~= "") then
        pcount = pcount + 1
        local ttfMain = UIHelper.createStrokeTTF(pStrings,mFontColor,strokeC,nil,mFontSize,mFontName)
        ttfMain:setAnchorPoint(ccp(0.5,0.5))
        pHeight = ttfMain:getContentSize().height 
        bgSp:addChild(ttfMain)
        table.insert(ttfTbs,ttfMain)
    end


    local pTb = strings.tb
    local masterTotalData = fnGetAttrInfo(pTb.type, pTb.level)
    if(not table.isEmpty(masterTotalData)) then
        for i,v in ipairs(masterTotalData) do
            pcount = pcount + 1
            local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(v[1], v[2])
            local pS = string.format("%s +%s",affixInfo.displayName,displayNum)
            local ttfMain = UIHelper.createStrokeTTF(pS,mFontColor,strokeC,nil,mFontSize,mFontName)
            ttfMain:setAnchorPoint(ccp(0.5,0.5))     
            bgSp:addChild(ttfMain)
            table.insert(ttfTbs,ttfMain)
            if(pHeight == 0) then
                pHeight = ttfMain:getContentSize().height
            end
        end
    end

    local bgSpH = #ttfTbs * mFontSize + (#ttfTbs-1)*partH + topH*2
    bgSp:setContentSize(CCSizeMake(bgSpW,bgSpH))


    local pY = bgSpH - topH - mFontSize*0.5
    local pX = bgSpW*0.5
    for i,v in ipairs(ttfTbs) do
        local pI = tonumber(i) or 0
        v:setPosition(ccp(pX,pY - (pI-1)*(partH+mFontSize)))
    end


    -- 背景的运动 
    local function getAction( ... ) 
        local fadeto0 = CCFadeTo:create(FRAME_TIME,128)
        local scale0 = CCScaleTo:create(FRAME_TIME,0.09)
        local spawn0 = CCSpawn:createWithTwoActions(fadeto0,scale0)
        local fadeto1 = CCFadeTo:create(FRAME_TIME*4,170)
        local fadeto2 = CCFadeTo:create(FRAME_TIME*8,255)
        local scale = CCScaleTo:create(FRAME_TIME*8,1.0)
        local spawn = CCSpawn:createWithTwoActions(scale,fadeto2)
        local delay = CCDelayTime:create(1.5)
        local fadeto3 = CCFadeTo:create(0.5,0)
        local func1 = CCCallFunc:create(function ( ... )
            if (not isKeep and pNode) then 
                pNode:removeFromParentAndCleanup(true)
                pNode = nil
            elseif(isKeep) then 
                bgSp:removeFromParentAndCleanup(true)
                bgSp=nil
            end  
        end)

        -- local func2 = CCCallFunc:create(callBack)
        local array = CCArray:create()
        
        array:addObject(spawn0)
        array:addObject(fadeto1)
        array:addObject(spawn)
        array:addObject(delay)
        array:addObject(fadeto3)
        array:addObject(func1)
        -- array:addObject(func2)
        if (callBack) then 
           array:addObject(CCCallFunc:create(callBack)) 
        end 

        local seq = CCSequence:create(array)
        return seq
    end

    bgSp:runAction(getAction())
    
    AudioHelper.playSpecialEffect("texiao_zhandouli_feichu.mp3")
    -- UIHelper.fnPlayLR_FlyEff(pNode,callBack)
    
    return pNode
end

--根据 heroinfo 获取 1-5类型 大师的等级数组
function fnGetMasterInfoByHeroInfo( _heroInfo )
    local pInfo = {}
    if(not _heroInfo) then
        return pInfo
    end
    for i=1, 5 do
        local pNum = fnGetNumByType(i,_heroInfo)
        local pAttrLv = fnGetAttrLv(i,pNum)
        table.insert(pInfo,pAttrLv)
    end
    return pInfo
end

-- 获取强化大师的变化属性
-- {
-- des,     -- 强化大师的描述
-- level,   -- 等级
-- }
function fnGetAllMasterChangeString2( info1, info2 )
    local pStrings = {}
    local tDes = {m_i18n[5028],m_i18n[5029],m_i18n[5030],m_i18n[5031],m_i18n[5023]}
    for i = 1, 5 do
        local pS = fnGetMasterChangeStringByHeroInfo(info1, info2, i, true)
        if(pS and pS ~= "") then
            table.insert(pStrings, {des = tDes[i], level = info2[tonumber(i)]})
        end
    end
    if (table.isEmpty(pStrings)) then
        return nil
    end
    return pStrings
end

-- 获取强化大师的变化属性
-- 例：
-- {
-- 装备强化大师10级,
-- 装备附魔大师10级,
-- }
function fnGetAllMasterChangeString( info1, info2 )
    local pStrings = {}
    for i=1,5 do
        local pS = fnGetMasterChangeStringByHeroInfo(info1, info2, i, true)
        if(pS and pS ~= "") then
            table.insert(pStrings,pS)
        end
    end
    if (table.isEmpty(pStrings)) then
        return nil
    end
    return pStrings
end

--根据 变化前后info数组， 获取 发生变化的大师数据数组
-- type : 1装备强化，2装备附魔，3宝物强化，4宝物精炼，5品级大师
-- isContainDes: 是否包含强化大师x级的描述
function fnGetMasterChangeStringByHeroInfo( info1, info2, type, notTb, isContainDes)
    local pType = tonumber(type) or 0
    local pShow = nil
    if(pType < 1 or pType >= 5) then
        return pShow
    end
    isContainDes = isContainDes or false
    local pInfo1 = info1 or {}
    local pInfo2 = info2 or {}
    local pS = {m_i18n[5028],m_i18n[5029],m_i18n[5030],m_i18n[5031],m_i18n[5023]}

    local pNum = tonumber(pInfo1[pType]) or 0
    local pNum2 = tonumber(pInfo2[pType]) or 0
    if(pNum < pNum2) then
        local pString = pS[pType]..pNum2..m_i18n[3643]
        if(notTb) then
            pShow = pString
        else
            if (not isContainDes) then
                pString = ""
            end
            pShow = {string = pString}
            local pAttrInfo1 = fnGetAttrInfo(pType,pNum) 
            local pAttrInfo2 = fnGetAttrInfo(pType,pNum2) 
            if(not table.isEmpty(pAttrInfo2)) then
                local pTb = {}
                for i,v in ipairs(pAttrInfo2) do
                    local pID = tonumber(v[1]) or 0
                    local pVal = tonumber(v[2]) or 0
                    if(pID ~= 0) then
                        local pHave = false
                        for i2,v2 in ipairs(pAttrInfo1) do
                            local pID2 = tonumber(v2[1]) or 0
                            local pVal2 = tonumber(v2[2]) or 0
                            if(pID == pID2) then
                                pHave = true
                                pVal = pVal - pVal2
                            end
                        end
                        table.insert(pTb,{pID,pVal})
                    end
                end
                pTb.type = pType
                pTb.level = info2[pType]
                pShow.tb = pTb
            end
        end
    end
    return pShow
end

--根据 heroinfo 获取 伙伴身上装备加成的装备大师相关属性
--return attrTb 最多5个table，每个tabel里会有几组属性相关表，［1］为属性info，［2］为属性数值
-- 举例:attrTb = { 
--         { 
--             {info,num},
--             {info,num},
--         },
--         { 
--             {info,num},
--             {info,num}, 
--         },
--     }
function fnGetAttrTbByHeroInfo( _heroInfo )
    if(not _heroInfo) then
        return
    end
    local attrTb = {}
    for i=1, 5 do
        local pNum = fnGetNumByType(i,_heroInfo)
        local pAttrLv = fnGetAttrLv(i,pNum)
        local pAttrInfo = fnGetAttrInfo(i,pAttrLv)
        -- if(pNum ~= 0 and pAttrLv ~= 0) then
        --     logger:debug({wm___i=i})
        --     logger:debug({wm___num=pNum})
        --     logger:debug({wm___attrLv=pAttrLv})
        --     logger:debug({wm___attrinfo=pAttrInfo})
        -- end
        if(not table.isEmpty(pAttrInfo)) then
            table.insert(attrTb,pAttrInfo)
        end
    end
    return attrTb
end
--根据类型，heroinfo 获取对应 总和或最小等级
function fnGetNumByType( type, _heroInfo )
	local pHeroInfo = _heroInfo or nil
	if(not pHeroInfo or not pHeroInfo.equip) then
		return 0
	end
    local pType = tonumber(type) or 5
    if(pType < 0 or pType > 5) then
        return 0
    end

    local armInfos = pHeroInfo.equip.arming
    local treasureInfo = pHeroInfo.equip.treasure
    local pT_Score = 999
	if(pType == 5) then
		local function getPscore( pID )
			local pScore = 0
			if(pID and tonumber(pID) ~= 0) then
				local itemTemid = tonumber(pID.item_template_id)
				local pInfo = ItemUtil.getItemById(itemTemid)
				pScore = tonumber(pInfo.base_score) or 0
	        end
	        return pScore
		end
        pT_Score = 0
	    for i = 1 , 4 do
	        pT_Score = pT_Score + getPscore(armInfos[tostring(i)])
	        --pT_Score = pT_Score + getPscore(treasureInfo[tostring(i)])
	    end
        for i = 1 , 3 do
            --pT_Score = pT_Score + getPscore(armInfos[tostring(i)])
            pT_Score = pT_Score + getPscore(treasureInfo[tostring(i)])
        end
    elseif(pType == 1) then
    	for i = 1 , 4 do
    		local pID = armInfos[tostring(i)]
			if(pID and tonumber(pID) ~= 0) then
				local pNow = tonumber(pID.va_item_text.armReinforceLevel) or 0
    			if(pNow <= pT_Score) then
    				pT_Score = pNow
    			end
            else
                pT_Score = 0
                break
			end
    	end
    elseif(pType == 2) then
        for i = 1 , 4 do
            local pID = armInfos[tostring(i)]
            if(pID and tonumber(pID) ~= 0) then
                local pNow = tonumber(pID.va_item_text.armEnchantLevel) or 0
                if(pNow <= pT_Score) then
                    pT_Score = pNow
                end
            else
                pT_Score = 0
                break
            end
        end
    elseif(pType == 3) then
    	for i = 1 , 3 do
			local pID = treasureInfo[tostring(i)]
    		if(pID and tonumber(pID) ~= 0) then
    			local pNow = tonumber(pID.va_item_text.treasureLevel) or 0
    			if(pNow <= pT_Score) then
    				pT_Score = pNow
    			end
            else
                pT_Score = 0
                break
    		end
    	end
    elseif(pType == 4) then
    	for i = 1 , 3 do
    		local pID = treasureInfo[tostring(i)]
    		if(pID and tonumber(pID) ~= 0) then
    			local pNow = tonumber(pID.va_item_text.treasureEvolve) or 0
    			if(pNow <= pT_Score) then
    				pT_Score = pNow
    			end
            else
                pT_Score = 0
                break
    		end
    	end
	end
	return pT_Score
end
--根据类型，数值 获取对应 属性等级
function fnGetAttrLv( type, num )
    local pType = tonumber(type) or 0
    local pNum = tonumber(num) or 0
    local pAttrLv = 0
    if(pType < 0 or pType >= 5) then
        return pAttrLv
    end
    require "db/DB_Guru"
    local pDbInfo = DB_Guru.getDataById(pType)
    if(not pDbInfo or not pDbInfo.needlv) then
        return pAttrLv
    end
    require "script/utils/LuaUtil"
    local pNeedLvs = lua_string_split(pDbInfo.needlv,"|")
    if(not table.isEmpty(pNeedLvs)) then
        for i,v in ipairs(pNeedLvs) do
            local plv = tonumber(v) or 0
            if(plv <= pNum) then
                pAttrLv = tonumber(i)
            else
                break
            end
        end
    end
    return pAttrLv
end
--根据类型，属性等级 获取对应 条件数值
function fnGetNumByLv( type, lv )
    local pType = tonumber(type) or 0
    local pLv = tonumber(lv) or 0
    local pNum = 0
    if(pType < 0 or pType >= 5) then
        return pNum
    end
    require "db/DB_Guru"
    local pDbInfo = DB_Guru.getDataById(pType)
    if(not pDbInfo or not pDbInfo.needlv) then
        return pNum
    end
    require "script/utils/LuaUtil"
    local pNeedLvs = lua_string_split(pDbInfo.needlv,"|")
    if(not table.isEmpty(pNeedLvs)) then
        for i,v in ipairs(pNeedLvs) do
            local pI = tonumber(i) or 0
            if(pI == pLv) then
                pNum = tonumber(v)
                break
            end
        end
    end
    return pNum
end
--根据类型，属性等级 获取对应 属性信息数组
function fnGetAttrInfo( type, attrLv )
    local pType = tonumber(type) or 0
    local pNum = tonumber(num) or 0
    local pAttrInfo = {}
    if(pType < 0 or pType >= 5) then
        return pAttrInfo
    end
    require "db/DB_Guru"
    local pDbInfo = DB_Guru.getDataById(pType)
    local pString = "attr"..attrLv
    if(not pDbInfo or not pDbInfo[pString]) then
        return pAttrInfo
    end
    require "script/utils/LuaUtil"
    local pInfo = lua_string_split(pDbInfo[pString], ",")
    for i,v in ipairs(pInfo) do
        local pValue = lua_string_split(v, "|")
        table.insert(pAttrInfo, pValue)
    end
    return pAttrInfo
end

local _layBg
function create(_heroInfo , _curPageNum , _showTag, _widgetBg)
   m_heroInfo = _heroInfo
   m_curPageNum = _curPageNum
   local pShowTag = _showTag

    _layBg = MainEquipMasterView.create(m_heroInfo , m_curPageNum , pShowTag)
    --LayerManager.addLayoutNoScale(layBg, _widgetBg)
    return _layBg
end