-- FileName: PartnerStrenCtrl.lua
-- Author: sunyunpeng
-- Date: 2015-12-00
-- Purpose: function description of module
--[[TODO List]]

module("PartnerStrenCtrl", package.seeall)
require "script/module/partner/PartnerStrenView"


-- UI控件引用变量 --

-- 模块局部变量 --
local _heroInfo 
local _addInfo
local _allHeros
local _shadowList
local _tbSelectShadow
local _shadowAddType = 0  --1  自动添加了影子完毕 2 手动添加完毕
local _shadowbagRefreshStatus = 0 --   1点击了强化背白没推送回来  0 默认和推送回来了
local _soureType 
local m_i18n = gi18n

-- 断线重连
local NET_STATUS = {ONLINE,SENDING,REVEIVED,BAGSENDED}
local netStatus = NET_STATUS.ONLINE

local function init(...)

end

function destroy(...)
    package.loaded["PartnerStrenCtrl"] = nil
end

function moduleName()
    return "PartnerStrenCtrl"
end

function create(hid,sourceType)
    clearAllPara()
    -- 界面当前所处的状态
    _soureType = sourceType

    initAllHero(hid)
    --影子列表
    initShadowData()
    initHeroInfo(hid,sourceType)
    local partnerStrenView = PartnerStrenView.create()
    LayerManager.changeModule(partnerStrenView, PartnerStrenCtrl.moduleName(), {1,3},true)
    PlayerPanel.addForPartnerStrength()

end

-- 清空 初始化 全部变量
function clearAllPara( ... )
    _shadowAddType = 0
    _shadowbagRefreshStatus = 0
    _shadowList = {}
    _allHeros = {}
    _addInfo = {}
    _heroInfo = {}
    _tbSelectShadow = {}
end


-- 获取影子数据刷新状态
function getBagShadowRrfreshStatus(  )
    return _shadowbagRefreshStatus
end

-- 设置影子添加的状态
function setAddShadowType( shadowAddType )
    _shadowAddType = shadowAddType 
end

-- 获取滑动列表所有英雄信息
function getAllHero( ... )
    return _allHeros
end

-- 获取呗强化的伙伴的所有信息
function getHeroInfo( ... )
    return _heroInfo
end

-- 获取所有影子列表
function getShadowList( ... )
    return _shadowList
end

--
function setShadowList( shadowList )
    _shadowList = shadowList
end

-- 获取选择的影子列表
function getSelectShadowList( ... )
    return _tbSelectShadow
end

function initHeroInfo( hid )
    _heroInfo = {}
    local heroInfo = HeroModel.getHeroByHid(hid)
    logger:debug({initHeroInfo = hid})
    logger:debug({initHeroInfo = heroInfo})
    -- 基础战斗力
    local forceValue = HeroFightUtil.getNewAllForceValues(heroInfo,{0})
    -- 升满级所需的经验
    heroInfo.heroDB = DB_Heroes.getDataById(heroInfo.htid)
    heroInfo.exp_id = heroInfo.heroDB.exp
    local maxLelNeedExp = HeroPublicUtil.getHeroSoulByFullLevel(heroInfo.exp_id) - heroInfo.soul
    heroInfo.forceValue = forceValue
    heroInfo.maxLelNeedExp = maxLelNeedExp
    _heroInfo = heroInfo
    _heroInfo.bluePersent = fnGetExpPercent(_heroInfo.soul,_heroInfo.level)
    _heroInfo.greenPersent = 0

    return _heroInfo
end 

--强化完毕后 重新设置HeroInfo
function restHeroInfo( hid,forceValue, bluePersent )
    _heroInfo = {}
    local heroInfo = HeroModel.getHeroByHid(hid)
    heroInfo.heroDB = DB_Heroes.getDataById(heroInfo.htid)
    heroInfo.exp_id = heroInfo.heroDB.exp
    -- 基础战斗力
    local forceValue = forceValue
    -- 升满级所需的经验
    local maxLelNeedExp = HeroPublicUtil.getHeroSoulByFullLevel(heroInfo.exp_id) - heroInfo.soul
    heroInfo.forceValue = forceValue
    heroInfo.maxLelNeedExp = maxLelNeedExp
    _heroInfo = heroInfo
    _heroInfo.bluePersent = bluePersent
    _heroInfo.greenPersent = 0
    _addInfo = {}
    _tbSelectShadow = {}
    -- 重置按钮状态
    PartnerStrenView.setBtnTouchEnable("onStren",true)
    PartnerStrenView.setBtnTouchEnable("auotoAdd",true)
end

--获取伙伴当前经验百分比
function fnGetExpPercent( pSoul, pLevel)
    local mSoul = pSoul 
    local mLevel = pLevel 
    local tArgs = {}
    tArgs.exp_id = _heroInfo.exp_id
    tArgs.soul = mSoul
    tArgs.level = mLevel
    tArgs.htid = _heroInfo.htid
    local nNextLevelNeedSoul = HeroPublicUtil.getSoulToNextLevel(tArgs)
    local nCurLevelNeedSoul = HeroPublicUtil.getSoulOnLevel(tArgs)

    local nCurHaveSoul = tonumber(mSoul) - tonumber(nCurLevelNeedSoul)
    -- local nCurLevelTotal = tonumber(nCurHaveSoul) + tonumber(nNextLevelNeedSoul)
    local db_level = DB_Level_up_exp.getDataById( _heroInfo.exp_id)
    local nSoul = db_level["lv_"..(mLevel + 1)]
    local nCurLevelTotal = tonumber(nSoul)
    local nPercent = intPercent(nCurHaveSoul, nCurLevelTotal)

    return nPercent
end

-- 获取当前pageView所有英雄
function initAllHero( hid )
    local allHeroInfos = {}
    if(_soureType == 2) then
        local pSquad = DataCache.getSquad()
        local pBench = DataCache.getBench()
        local squadNum =  MainFormationTools.fnGetSquadNum() and tonumber(MainFormationTools.fnGetSquadNum())

        for i=0,squadNum - 1 do
            local hid  = pSquad[i .. ""]
            if (hid and tonumber(hid) > 0) then
                local squadHeroInfo = HeroModel.getHeroByHid(hid)
                squadHeroInfo.heroDB = DB_Heroes.getDataById(squadHeroInfo.htid)
                squadHeroInfo.pos = i
                table.insert(allHeroInfos,squadHeroInfo)
            end
        end

        if (pBench[0 .. ""] and tonumber(pBench[0 .. ""]) > 0) then
            local benchHeroInfo = HeroModel.getHeroByHid(pBench[0 .. ""])
            benchHeroInfo.heroDB = DB_Heroes.getDataById(benchHeroInfo.htid)
            benchHeroInfo.pos = squadNum 
            table.insert(allHeroInfos,benchHeroInfo)
        end
    else
        local heroInfo = HeroModel.getHeroByHid(hid)
        table.insert(allHeroInfos,heroInfo)
    end
    _allHeros =  allHeroInfos
end

-- 获取当前英雄的index
function getHeroIndex(  )
    local curHeroHid = _heroInfo.hid
    local heroIndex = 1
    local allNum = 1
    allNum = _allHeros and #_allHeros or 1
    for i,heroInfo in ipairs(_allHeros or {}) do
        if (tonumber(curHeroHid) == tonumber(heroInfo.hid)) then
            heroIndex = i
            break
        end
    end
    return heroIndex,allNum
end

-- 强化后端返回后回调
function fnHandlerOfNetwork(cbFlag, dictData, bRet)
    -- 后端强化完成
    netStatus = NET_STATUS.REVEIVED

    if not bRet then
        return
    end

    -- 武将卡牌强化
    if cbFlag == "hero.enforceByHeroFrag" or cbFlag == "hero.enforce" then
        require "script/module/guide/GuideFiveLevelGiftView"
        if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 12) then
            LayerManager.addLayoutNoScale(Layout:create()) -- 添加屏蔽层
            require "script/module/guide/GuideCtrl"
            GuideCtrl.removeGuideView()  
            GuideCtrl.setPersistenceGuide("shop","15")
        end

        require "script/module/guide/GuideFormationView"
        if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 5) then
            require "script/module/guide/GuideCtrl"
            LayerManager.addLayoutNoScale(Layout:create()) -- 添加屏蔽层
            GuideCtrl.removeGuideView()  
            GuideCtrl.setPersistenceGuide("fmt","6")
        end

       require "script/module/guide/GuideCopy2BoxView"
        if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 16) then
            require "script/module/guide/GuideCtrl"
            LayerManager.addLayoutNoScale(Layout:create()) -- 添加屏蔽层
            GuideCtrl.removeGuideView()  
            GuideCtrl.setPersistenceGuide("copy2Box","19")
        end

        require "script/model/user/UserModel"
        require "script/model/hero/HeroModel"
        
        -- 修改武将等级
        local nowLevel = tonumber(dictData.ret.level)
        HeroModel.setHeroLevelByHid(_heroInfo.hid, nowLevel)
        -- 修改武将武魂数量
        local nowSoul = _heroInfo.soul + tonumber(dictData.ret.soul)
        HeroModel.setHeroSoulByHid(_heroInfo.hid, nowSoul)
        -- 修改经验条

        -- local retConsumeFrag = dictData.ret.consume_frag
        -- local tbherolist = {}

        -- for k,v in pairs(_shadowList) do
        --     if(v.checkIsSelected) then
        --         local consumeNum = tonumber(retConsumeFrag[""..v.item_id])
        --         if (consumeNum ~= nil) then
        --             local reduceNum = tonumber(v.item_num) - consumeNum
        --             if (reduceNum > 0) then
        --                 v.item_num = reduceNum
        --                 v.soul = tonumber(v.exp) * tonumber(v.item_num)
        --                 v.decompos_soul = v.soul
        --                 v.checkIsSelected = false
        --                 table.insert(tbherolist,v)
        --             else
        --                 _shadowList[k] = nil
        --             end
        --         else
        --             v.checkIsSelected = false
        --             table.insert(tbherolist,v)
        --         end
        --     else
        --         table.insert(tbherolist,v)
        --     end
        -- end
        -- _shadowList = tbherolist

        UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
        -- 直接更新战斗力
        -- local updataInfo = {[hid] = {HeroFightUtil.FORCEVALUEPART.LEVEL , HeroFightUtil.FORCEVALUEPART.UNION},}
        -- UserModel.updateFightValue(updataInfo)
        local hid = _heroInfo.hid
        local forceValue = _addInfo.forceValue
        local bluePersent = _addInfo.blueShowPersent

        -- 修改用户贝里数量
        if (_addInfo.forceValue)then
            UserModel.updateFightValueByValue(hid,_addInfo.forceValue)
        end
        UserModel.addSilverNumber(-tonumber(dictData.ret.silver))
        PartnerStrenView.playForgeEffect() --播放动画特效
        restHeroInfo(hid,forceValue,bluePersent)

    end
end


local function afterBagRefresh( ... )
    -- 背包推送完成
    netStatus = NET_STATUS.BAGSENDED

    initShadowData()
    _shadowbagRefreshStatus = 0
end 

-- 强化按钮
function onStren(  )
    ----------------------------------
    -----------------------------------
    local addInfo = _addInfo 
    -- -- 判断强化功能节点是否开启了，如果没开启则返回
    local status = SwitchModel.getSwitchOpenState(ksSwitchGeneralForge,true)
    if (not status) then
        -- ShowNotice.showShellInfo("强化功能节点未开启")
        return
    end

    -- 判断是否已选择卡牌
    if (not _tbSelectShadow or #_tbSelectShadow == 0 ) then
        ShowNotice.showShellInfo(m_i18n[1056])
        return
    end

    
    -- 判断贝里数量是否足够
    require "script/model/user/UserModel"
    local nUserSilver = UserModel.getSilverNumber()
    local needBeili = addInfo.totalBelly
    if nUserSilver < needBeili then
        PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
        ShowNotice.showShellInfo(m_i18n[1057])
        return
    end
    -- 判断武将是否已达上限
    local nLimitLevel = UserModel.getAvatarLevel()
    if tonumber(_heroInfo.level) >= nLimitLevel then
        ShowNotice.showShellInfo(m_i18n[1059])
        return
    end
    logger:debug("PartnerStrenCtrl.lua_onStren")

    PartnerStrenView.setBtnTouchEnable("onStren",false)
    PartnerStrenView.setBtnTouchEnable("auotoAdd",false)

    local tHids = {_heroInfo.hid, }
    for k,v in pairs(_shadowList) do
        if(v.checkIsSelected) then
            table.insert(tHids, v.hid)
        end
    end
    local args = CCArray:create()
    args:addObject(CCInteger:create(_heroInfo.hid))
    local subArgs = CCArray:create()
    local args_item =  CCDictionary:create()
    for k,v in pairs(_tbSelectShadow) do
        if(v.checkIsSelected) then
            args_item:setObject(CCInteger:create(v.useNums), tostring(v.item_id))
            args:addObject(args_item)
        end
    end
    _shadowbagRefreshStatus = 1
    setAddShadowType(1)
    
    RequestCenter.hero_enforceByHeroFrag(fnHandlerOfNetwork,args)
    PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）
    -- 向后端发送数据
    netStatus = NET_STATUS.SENDING
end

function initShadowData( ... )
    -- 武将数值
    local shadowList = {}
    local heroFrag = DataCache.getHeroFragFromBag()
    if (heroFrag ~= nil) then
        require "script/utils/LuaUtil"
        require "db/DB_Heroes"
        require "script/model/hero/HeroModel"
        require "script/module/partner/HeroFightSimpleUtil"
        for i,v in pairs(heroFrag) do
            local heroFragment = DB_Item_hero_fragment.getDataById(v.item_template_id)
            if (tonumber(heroFragment.quality) < 4 or tonumber(heroFragment.isExp) == 1) then
                local value = {}
                value.item_num = tonumber(v.item_num)
                value.item_id = tonumber(v.item_id)
                local db_hero = DB_Heroes.getDataById(heroFragment.aimItem)
                value.htid = db_hero.id
                value.level = db_hero.lv

                if (db_hero.country ~= nil and tonumber(db_hero.country)~=0) then
                    countrys = 1
                else
                    countrys = 0
                end
                value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
                
               -- value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
                value.name = db_hero.name
                value.exp = tonumber(heroFragment.exp)
                value.soul = tonumber(heroFragment.exp) * tonumber(v.item_num)
                value.decompos_soul = value.soul
                value.lv_up_soul_coin_ratio = db_hero.lv_up_soul_coin_ratio
                value.star_lv = db_hero.star_lv
                value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
                value.body_img = "images/base/hero/body_img/" .. db_hero.body_img_id
                value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
                value.quality_h = "images/hero/quality/highlighted.png"
                value.price = tonumber(db_hero.recruit_gold)
                value.exp_id = db_hero.exp  --经验表ID
                value.heroQuality = heroFragment.quality
                value.potential = db_hero.potential
                value.type = "HeroSelect"
                value.checkIsSelected = false
                shadowList[#shadowList+1] = value
            end
        end

        -- 按经验值排序
        local function sort(w1, w2)
            return w1.soul < w2.soul
        end
        table.sort(shadowList, sort)
    end
    _shadowList = shadowList
end




-- 判断经验和贝里够不够用
function checkSliverAndExp( tbHeroInfo )

    local totalBelly = 0
    local totalExp = 0
    local belOwn = UserModel.getSilverNumber()
    local tbPos = {}
    local expNeed = _heroInfo.maxLelNeedExp
    for i, shadow in ipairs(tbHeroInfo) do
        local expTotal = shadow.item_num*shadow.exp
        print("expTotal", expTotal)
        shadow.useNums = 0
        if (expNeed > 0) then
            -- local en = math.floor((expTotal * shadow.lv_up_soul_coin_ratio)/expNeed)
            local en = math.floor(expTotal /expNeed)
            print("en", en,"expNeed",expNeed,"shadow.exp",shadow.exp)

            if (en == 0) then -- 经验不够用
                count = shadow.item_num
                
            elseif (en > 0) then -- 超过需要的经验
                count = math.ceil(expNeed/shadow.exp)       
            end

            print("count", count)

            local belNeed = math.floor(count * shadow.exp * shadow.lv_up_soul_coin_ratio / 100)
            local expSuply = math.floor(count * shadow.exp) 

            print("belNeed", belNeed, "belOwn", belOwn)

            if (belNeed <= belOwn) then
                tbPos[#tbPos + 1] = i
                -- shadow.checkIsSelected = true
                belOwn = belOwn - belNeed
                expNeed = expNeed - expTotal
                totalBelly = totalBelly + belNeed -- (expTotal > expNeed and expNeed or expTotal)
                totalExp = totalExp + expSuply
                shadow.useNums = count
            else
                local shadowBelly = math.floor(shadow.exp * shadow.lv_up_soul_coin_ratio / 100)
                local leftCount = math.floor(belOwn / shadowBelly)

                if (leftCount == 0 ) then
                    shadow.checkIsSelected = false
                else
                    shadow.checkIsSelected = true
                    local leftUseBeili = math.floor(leftCount * shadow.exp * shadow.lv_up_soul_coin_ratio / 100)
                    local leftsupplyExp = math.floor(leftCount * shadow.exp )
                    totalBelly = totalBelly + leftUseBeili
                    totalExp = totalExp + leftsupplyExp
                    shadow.useNums = leftCount
                    expNeed = expNeed - leftCount * shadow.exp
                    belOwn = belOwn - leftUseBeili
                end
               
            end
        else
            print("first enough")
            shadow.checkIsSelected = false
        end
      
        if (#tbPos >= 5) then
            return totalBelly,totalExp
        end
        
    end

    return totalBelly,totalExp
end

-- 从已选择的影子列表中选择
function checkExpFromSelected(  )
    local totalBelly = 0
    local totalExp = 0
    local expNeed = _heroInfo.maxLelNeedExp
    local tbSelectShadow = {}

    for i, shadow in ipairs(_shadowList) do
        if (shadow.checkIsSelected) then
            local expTotal = shadow.item_num*shadow.exp
            print("expTotal", expTotal)
            shadow.useNums = 0
            if (expNeed > 0) then
                -- local en = math.floor((expTotal * shadow.lv_up_soul_coin_ratio)/expNeed)
                local en = math.floor(expTotal /expNeed)
                print("en", en,"expNeed",expNeed,"shadow.exp",shadow.exp)

                if (en == 0) then -- 经验不够用
                    count = shadow.item_num
                    
                elseif (en > 0) then -- 超过需要的经验
                    count = math.ceil(expNeed/shadow.exp)       
                end

                print("count", count)

                local belNeed = math.floor(count * shadow.exp * shadow.lv_up_soul_coin_ratio / 100)
                local expSuply = math.floor(count * shadow.exp) 

                expNeed = expNeed - expTotal
                totalBelly = totalBelly + belNeed -- (expTotal > expNeed and expNeed or expTotal)
                totalExp = totalExp + expSuply
                shadow.useNums = count
                table.insert(tbSelectShadow,shadow) 
            end
        end
        
    end

    return totalBelly,totalExp,tbSelectShadow


end

-- 判断经验和贝里够不够用
function checkExpNOSilveLimit(  )
    local totalBelly = 0
    local totalExp = 0
    local tbPos = {}
    local tbSelectShadow = {}
    local expNeed = _heroInfo.maxLelNeedExp

    for i, shadow in ipairs(_shadowList) do
        local expTotal = shadow.item_num*shadow.exp
        print("expTotal", expTotal)
        shadow.useNums = 0
        if (expNeed > 0) then
            -- local en = math.floor((expTotal * shadow.lv_up_soul_coin_ratio)/expNeed)
            local en = math.floor(expTotal /expNeed)
            print("en", en,"expNeed",expNeed,"shadow.exp",shadow.exp)

            if (en == 0) then -- 经验不够用
                count = shadow.item_num
                
            elseif (en > 0) then -- 超过需要的经验
                count = math.ceil(expNeed/shadow.exp)       
            end

            print("count", count)

            local belNeed = math.floor(count * shadow.exp * shadow.lv_up_soul_coin_ratio / 100)
            local expSuply = math.floor(count * shadow.exp) 

            tbPos[#tbPos + 1] = i
            shadow.checkIsSelected = true
            table.insert(tbSelectShadow,shadow)
            expNeed = expNeed - expTotal
            totalBelly = totalBelly + belNeed -- (expTotal > expNeed and expNeed or expTotal)
            totalExp = totalExp + expSuply
            shadow.useNums = count
            
        else
            print("first enough")
            shadow.checkIsSelected = false
        end
      
        if (#tbPos >= 5) then
            return totalBelly,totalExp,tbSelectShadow
        end
        
    end

    return totalBelly,totalExp,tbSelectShadow
end


--添加个人信息中增加了多少属性的强化提示
local function fnAddProperty( addExp )
    local greenShowPersent = 0
    local blueShowPersent = _heroInfo.bluePersent
    local tArgs = {}
    tArgs.soul = _heroInfo.soul
    tArgs.added_soul = addExp
    tArgs.exp_id = _heroInfo.exp_id
    tArgs.level = _heroInfo.level
    local nCurLevelNeedSoul = HeroPublicUtil.getSoulOnLevel(tArgs)
    local nowLeftoul = tonumber(tArgs.soul) - nCurLevelNeedSoul
    tArgs.nowLeftoul = nowLeftoul
    local afterLevel,updataLeftSoul,blueShowPersent = HeroPublicUtil.getHeroLevelByAddSoul(tArgs)

    local afterLevel = tonumber(afterLevel) >= tonumber(UserModel.getHeroLevel()) and UserModel.getHeroLevel() or afterLevel
    if tonumber(afterLevel) > tonumber(_heroInfo.level) then
        greenShowPersent =  100
    else
        greenShowPersent = blueShowPersent 
    end

    return blueShowPersent,greenShowPersent,afterLevel
end

-- 重置页面
function resetShadowStatus( ... )
    -- 重置影子添加的方式
    _shadowAddType = 0
    -- 重置已经选择的影子列表
    _tbSelectShadow = {}
    local shadowList = _shadowList 
    for i,shadow in ipairs(shadowList) do
        shadow.checkIsSelected = false
    end
    local addInfo = {}
    PartnerStrenView.setAddAttrInfo(addInfo,0)
end

-- 手动添加影子返回
function shadowChooseReturn( returenShadowList )
    local heroInfo = _heroInfo
    _shadowList = returenShadowList
    local shadowList = _shadowList 

    local addInfo = {}
    local totalBelly,totalExp,tbSelectShadow =  checkExpFromSelected(shadowList)

    addInfo.totalBelly = totalBelly
    addInfo.totalExp = totalExp
    _tbSelectShadow = tbSelectShadow
    addInfo.tbSelectShadow = tbSelectShadow

    local newheroInfo = {}
    local newheroInfo = table.hcopy(heroInfo,newheroInfo)

    local blueShowPersent, greenShowPersent,afterLevel = fnAddProperty(totalExp)
    newheroInfo.level = afterLevel
    addInfo.level = afterLevel
    addInfo.blueShowPersent = blueShowPersent
    addInfo.greenShowPersent = greenShowPersent

    if (tonumber(afterLevel) >  tonumber(_heroInfo.level))then
        local forceValue = HeroFightUtil.getNewAllForceValues(newheroInfo,{1,2},nil,true)
        addInfo.forceValue = forceValue
    end
    PartnerStrenView.setAddAttrInfo(addInfo,2)
    _addInfo = {}
    _addInfo = table.hcopy(addInfo,_addInfo)

end


-- 自动添加
function onAutoAdd(  )
    local heroInfo = _heroInfo
    logger:debug({onAutoAdd = heroInfo})
    local shadowList = _shadowList 
    -- 已经自动添加上了
    if (_shadowAddType == 1) then
        return
    end
    -- 判断武将是否已达上限
    local nLimitLevel = UserModel.getAvatarLevel()
    if tonumber(heroInfo.level) >= tonumber(nLimitLevel) then
        ShowNotice.showShellInfo(m_i18n[1059])
        return
    end
    -- 影子不足
    if(table.count(shadowList) == 0) then
        ShowNotice.showShellInfo(m_i18n[1065])  
        return
    end

    local addInfo = {}
    local totalBelly,totalExp,tbSelectShadow =  checkExpNOSilveLimit()

    addInfo.totalBelly = totalBelly
    addInfo.totalExp = totalExp
    _tbSelectShadow = tbSelectShadow
    addInfo.tbSelectShadow = tbSelectShadow

    local newheroInfo = {}
    local newheroInfo = table.hcopy(heroInfo,newheroInfo)

    local blueShowPersent, greenShowPersent,afterLevel = fnAddProperty(totalExp)
    newheroInfo.level = afterLevel
    addInfo.level = afterLevel
    addInfo.greenShowPersent = greenShowPersent
    addInfo.blueShowPersent = blueShowPersent

    if (tonumber(afterLevel) >  tonumber(_heroInfo.level))then
        local forceValue = HeroFightUtil.getNewAllForceValues(newheroInfo,{1,2},nil,true)
        addInfo.forceValue = forceValue
    end

    logger:debug({PartnerStrenView = addInfo})
    _addInfo = addInfo
    -- 由于强化成功后 数值变了 重新设置界面数据
    PartnerStrenView.reSetHeroInfo()

    PartnerStrenView.setAddAttrInfo(addInfo,1)
    -- _addInfo = {}
    -- _addInfo = table.hcopy(addInfo,_addInfo)

        require "script/module/guide/GuideFiveLevelGiftView"
    if (GuideModel.getGuideClass() == ksGuideFiveLevelGift and GuideFiveLevelGiftView.guideStep == 11) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createkFiveLevelGiftGuide(12,0)
    end  

    require "script/module/guide/GuideCopy2BoxView"
    if (GuideModel.getGuideClass() == ksGuideCopy2Box and GuideCopy2BoxView.guideStep == 15) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopy2BoxGuide(16)
    end

    require "script/module/guide/GuideFormationView"
    if (GuideModel.getGuideClass() == ksGuideFormation and GuideFormationView.guideStep == 4) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createFormationGuide(5)
    end
end

-- 手动选择影子
function onSlectShadow(  )
    -- 背包没推送回来，影子列表没准备好
    if (_shadowbagRefreshStatus ~= 0) then
        return
    end
      -- 判断武将是否已达上限
    local nLimitLevel = UserModel.getAvatarLevel()
    
    if (tonumber(_heroInfo.level) >= tonumber(nLimitLevel)) then
        ShowNotice.showShellInfo(m_i18n[1059])
        return
    end
    require "script/module/partner/PartnerStrenShadowChoose"
    -- 由于强化成功后 数值变了 重新设置界面数据
    PartnerStrenView.reSetHeroInfo()

    --
    local tArgs = {}
    tArgs.exp_id = _heroInfo.exp_id
    tArgs.soul = _heroInfo.soul
    tArgs.level = _heroInfo.level

    local layer = PartnerStrenShadowChoose.create( _shadowList,tArgs)
    if (layer) then
        LayerManager.addLayoutNoScale(layer)
    end
end



--播放获取一个progresstimer对象的升级动画
-- changeTimes 升级次数，
-- stratPercent 起始百分比，
-- finalPercent 最终百分比，
-- callBack 完成的回调
function blueProgressChangeAni( progress, changeTimes, stratPercent, finalPercent, callBack ,delaytime)

    progress:setPercentage(stratPercent)
    local time1 = 0.05 
    local time2 = 0.3
    local time3 = 0.5

    local arr = CCArray:create()
    if(changeTimes > 0) then
        for i=1,changeTimes do
            arr:addObject(CCProgressTo:create(2*time1 , 100))
        end
        arr:addObject(CCProgressTo:create(time2 , finalPercent))
    else
        arr:addObject(CCProgressTo:create(time3 , finalPercent))
    end
    arr:addObject(CCDelayTime:create(delaytime or 0))
    arr:addObject(CCCallFunc:create(function( ... )
        progress:setPercentage(finalPercent)
        if(callBack) then
            callBack()
        end
    end))

    progress:runAction(CCSequence:create(arr))
end

function onBack( heroIndex )
    local localtion = _heroInfo.pos or 0
    if (_soureType == 2) then
        local layPartner = MainFormation.create(localtion)
        if (layPartner) then
            -- zhangqi, 不需要重新创建定制信息面板时指定true把以前的清理一下，避免更新人物属性导致找不到对象的问题
            LayerManager.changeModule(layPartner, MainFormation.moduleName(), {1,3}, true)
        end
    else
        require "script/module/partner/MainPartner"
        local layPartner = MainPartner.create()
        if (layPartner) then
        LayerManager.changeModule(layPartner, MainPartner.moduleName(), {1, 3})
        PlayerPanel.addForPartnerStrength()
        end
    end
end



-- 删除断线的观察
function removeOfflineObserver( ... )
    PreRequest.removeBagDataChangedDelete()
    GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, moduleName() .. "_RemoveUILoading")
    logger:debug("removeOfflineObserver PartnerStrenCtrl")
end

-- 增加断线的观察
function addOfflineObserver( ... )
    logger:debug("addOfflineObserver PartnerStrenCtrl")
    RequestCenter.bag_bagInfo(function (  cbFlag, dictData, bRet  )
                                PreRequest.preBagInfoCallback(cbFlag, dictData, bRet)
                              end)

    RequestCenter.hero_getAllHeroes(function ( cbFlag, dictData, bRet )
        logger:debug({hero_getAllHeroes_dictData = dictData})
        if (bRet and cbFlag == "hero.getAllHeroes") then
            require "script/model/hero/HeroModel"
            HeroModel.setAllHeroes(dictData.ret)
            UserModel.setInfoChanged(true)
            UserModel.updateFightValue() -- 然后更新战斗力数值
            updateInfoBar() -- zhangqi, 2015-12-24, 增加重连后刷新信息条的处理
            
            if (callback) then
                callback()
            end
        end
        initHeroInfo(_heroInfo.hid)
        PartnerStrenView.resetAllMes()
            -- 重置按钮状态
        PartnerStrenView.setBtnTouchEnable("onStren",true)
        PartnerStrenView.setBtnTouchEnable("auotoAdd",true)
    end)
end


