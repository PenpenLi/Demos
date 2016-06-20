-- FileName: StuffDrop.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]
-- self.itemType -- 碎片类 isFragment 装备碎片 isShadow 影子碎片 isTreasureFragment 宝物碎片  isSpeTreasureFragment 专属宝物碎片
-- self.dropListBg -- 背景图片
-- self.mListView  --列表控件
-- self.fragDB -- 碎片DB
-- self.fragOwnNum --  碎片拥有数量
-- self.iconBg  -- 图标icon11
 -- GuildCopyMapCtrl. getGuildType() 还用这个接口，改成这个获取值＝1 表示当前在分配记录。
 -- GuildCopyMapCtrl. getGuildType()＝2 表示当前在伤害排行榜

StuffDrop = class("StuffDrop")

local m_fnGetWidget  =  g_fnGetWidgetByName 
local m_i18n = gi18n
local m_i18nString = gi18nString
function StuffDrop:ctor( ... )
    -- self:initMaps()         -- 初始话参数
end

function StuffDrop:create( ... )

end

function StuffDrop:insertDropReturnCallFn( ... )

end

function StuffDrop:exileModule( ... )
    local curModuleName = LayerManager.curModuleName()
    local isPlaying = BattleState.isPlaying()
    logger:debug({exileModule=curModuleName})
    if (isPlaying) then                     -- 战斗场景没退出
        return true
    elseif (curModuleName == "ArenaCtrl" and ArenaCtrl.getCurType() == 2) then              -- 竞技场商店
        return true
    elseif (curModuleName == "MysteryCastleCtrl" and self.entireTid ~= 60034) then  -- 神秘商店,海魂不排除
        return true
    elseif (curModuleName == "MainGuildCtrl") then      -- 公会商店
        return true
    elseif (curModuleName == "ImpelShopCtrl") then      -- 装备商店
        return true
    elseif (curModuleName == "TreaShopCtrl") then       -- 宝物商店
        return true
    elseif (curModuleName == "SkyPieaShopCtrl") then   
        return true
    elseif (curModuleName == "MainCopy" ) then            -- 副本
        return true
    elseif (curModuleName == "GuildCopyMapView" ) then    -- 公会副本
        return true
    elseif (curModuleName == "MainWonderfulActCtrl") then   -- 活动
        return true
    elseif (curModuleName == "AdventureMainCtrl") then   -- 奇遇
        return true
    elseif (curModuleName == "MainShopCtrl") then   -- VIP 特权  
        return true
    elseif (curModuleName == "GuildCopyMapCtrl") then   -- VIP 觉醒副本  
        return true
    elseif (curModuleName == "OpenServerCtrl") then   -- 开服抢购 
        return true
    elseif (curModuleName == "WAMainView") then   -- 海盗激斗
        return true
    elseif (curModuleName == "WAEntryView") then   -- 海盗激斗
        return true
    end
    return false
end

function StuffDrop:initMaps( ... )
    local SwitchOpenState = {
        SNALITREA = {openState =  ksSwitchActivityCopy, gofuncall = gotoSnailTrea},
        BELISHOP = {openState =  ksSwitchBuyBox, gofuncall = gotoBeiliBy},
        MINERESOURCE = {openState =  ksSwitchResource, gofuncall = gotoMineResource},
        UNIONSHOP = {openState =  ksSwitchGuild, gofuncall = gotoUnionShop},
        MYSTREYSHOP = {openState =  ksSwitchResolve, gofuncall = gotoMysteryShop},
        ARENASHOP = {openState =  ksSwitchArena, gofuncall = gotoArenaShop},
        NORMALCOPY = {openState =  ksSwitchExplore, gofuncall = gotoNormalCopy},
        ELITECOPY = {openState =  ksSwitchEliteCopy, gofuncall = gotoEliteCopy},
        EXPLORE = {openState =  ksSwitchExplore, gofuncall = gotoExplore},
        HERORESOLVE = {openState =  ksSwitchResolve, gofuncall = gotoHeroResolve},
        EQUIPSHOP = {openState =  ksSwitchImpelDown, gofuncall = goEquipShop},
        TREASHOP = {openState =  ksSwitchSpeShop, gofuncall = goTreaShop},
        SHIPRESOLVE = {openState =  ksSwitchResolve, gofuncall = gotoShipResolve},
        SPTREARESOLVE = {openState =  ksSwitchResolve, gofuncall = gotoSPTreaResolve},
        TREASSOLVE = {openState =  ksSwitchResolve, gofuncall = gotoTreasResolve},
        ARERESOLVE = {openState =  ksSwitchResolve, gofuncall = gotoArmResolve},
        BAQIBAOZHUAN = {openState =  ksSwitchActivityCopy, gofuncall = gotoBaqiBaoZuan},
        TAVERN = {openState =  ksSwitchMysteryShop, gofuncall =  function ( ... )
            local stuffTid = self:getStuffTid()
            gotoTavern(stuffTid)
        end  },
        SHADOWRESOLVE = {openState =  ksSwitchResolve, gofuncall = gotoShadowResolve},
        DISILLUSIONSHOP = {openState =  ksSwitchResolve, gofuncall = goDisillusionShop},
        ACCREWARD = {openState =  ksSwitchActivity, gofuncall = gotoAccreward},
        LEVELREWARD = {openState =  ksSwitchActivity, gofuncall = gotolevelReward},
        IMPELDOWN = {openState =  ksSwitchImpelDown, gofuncall = gotoimpelDown},
        DISILLUSIONBAG = {openState =  ksSwitchAwake, gofuncall = goDisillusionBag},
        AWAKECOPY = {openState =  ksSwitchSignIn, gofuncall = goToAwakeCopy},
        LIANYUCOPY = {openState =  ksSwitchSignIn, gofuncall = goToLianYuCopy},
        MAINSHOP = {openState =  ksSwitchShop, gofuncall = gotoMainShop},
        FIRSTRECHARGE = {openState =  ksSwitchActivity, gofuncall = function ( ... )   end},

    }
    self.SwitchOpenState = SwitchOpenState
    local PROPERTYSOURCETYPE = {
        ["1"] =  "SNALITREA" ,                    --- 巨蛇宝藏
        ["2"] = "BELISHOP",                   --  购买贝里
        ["3"] = "MINERESOURCE" ,               --  资源矿
        ["4"] = "UNIONSHOP" ,                  --  公会商店
        ["5"] = "MYSTREYSHOP",                --  神秘商店
        ["6"] = "ARENASHOP",              --  竞技场商店
        ["7"] = "NORMALCOPY",              --  普通副本
        ["8"] = "ELITECOPY",              --  精英副本
        ["9"] = "EXPLORE",              --  探索
        ["10"] = "HERORESOLVE",              --  回收
        ["11"] = "EQUIPSHOP",              --  装备商店
        ["12"] = "TREASHOP",              --  饰品商店
        ["13"] = "SHIPRESOLVE",              --  主船回收
        ["14"] = "SPTREARESOLVE",              --  宝物回收
        ["15"] = "ARERESOLVE",              --  装备回收
        ["16"] = "TREASSOLVE",              --  饰品回收
        ["17"] = "BAQIBAOZHUAN",              --  巴奇宝钻
        ["18"] = "TAVERN",              --  神秘招募
        ["19"] = "SHADOWRESOLVE",              --  影子回收
        ["20"] = "DISILLUSIONSHOP",              --  觉醒商店
        ["21"] = "ACCREWARD",              --  开服礼包
        ["22"] = "LEVELREWARD",              --  等级礼包
        ["23"] = "IMPELDOWN",              --  深海监狱
        ["24"] = "DISILLUSIONBAG",              --  觉醒背包
        ["25"] = "AWAKECOPY",              --  觉醒副本
        ["26"] = "LIANYUCOPY",              --  炼狱副本
        ["27"] = "MAINSHOP",              --  酒馆 第二页
        ["28"] = "FIRSTRECHARGE",              -- 首冲

    }
    self.PROPERTYSOURCETYPE = PROPERTYSOURCETYPE
end


function StuffDrop:removeReturnCallFn( ... )
    logger:debug("insertDropReturnCallFn")
    local curModuleName = LayerManager.curModuleName()
    DropUtil.destroyCallFn(curModuleName,curModuleName)
end


function StuffDrop:initBG( ... )
	self.mListView = m_fnGetWidget(self.dropListBg, "LSV_LIST") 
	self.tfdTitle = m_fnGetWidget(self.dropListBg, "tfd_title") 
	self.btnClose = m_fnGetWidget(self.dropListBg, "BTN_CLOSE") 
    UIHelper.labelShadowWithText(self.tfdTitle,m_i18n[1098])  -- 获取途径
    UIHelper.labelNewStroke(self.tfdTitle,ccc3(0x7c,0x4f,0x32))

    self.btnClose:addTouchEventListener(function ( sender, eventType )
    	if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
            -- self:removeReturnCallFn()
	 		LayerManager.removeLayout(self.dropListBg)
	 	end
    end)
    -- require "script/module/public/UIHelper"
    -- -- -- listview 初始化，设置默认cell
    -- -- UIHelper.initListView(self.mListView) 

end

function StuffDrop:getStuffTid( ... )
    return self.stuffTid
end


function StuffDrop:chenkNumClass( num )

    local checkNum = tonumber(num)
        logger:debug({chenkNumClass = checkNum}) 

    if (checkNum == 0) then
        logger:debug({chenkNumClass = 1}) 

        return 1
    end

    if (math.floor(checkNum/10000) ~= 0 ) then
        logger:debug({chenkNumClass = 5}) 

        return 5
    elseif (math.floor(checkNum/1000) ~= 0) then
        logger:debug({chenkNumClass = 4}) 

        return 4
    elseif (math.floor(checkNum/100) ~= 0) then
        logger:debug({chenkNumClass = 3}) 

        return 3
    elseif (math.floor(checkNum/10) ~= 0) then
        logger:debug({chenkNumClass = 2}) 

        return 2
    elseif (math.floor(checkNum/1) ~= 0) then
        logger:debug({chenkNumClass = 1}) 

        return 1
    end
end

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

-- 巨蛇宝藏
function gotoSnailTrea( ... )
    require "script/module/copyActivity/MainCopyCtrl"
    MainCopyCtrl.create()
end

-- 购买贝里
function gotoBeiliBy( ... )
    require "script/module/wonderfulActivity/MainWonderfulActCtrl"
    local buyUI = MainWonderfulActCtrl.create(WonderfulActModel.tbShowType.kShowBuyMoney)
    LayerManager.changeModule(buyUI, MainWonderfulActCtrl.moduleName(), {1, 3}, true)
end

-- 去资源矿
function gotoMineResource( ... )
    require "script/module/mine/MainMineCtrl"
    MainMineCtrl.create()
end

-- 公会商店
function gotoUnionShop( ... )
    require "script/module/guild/GuildDataModel"
    require "script/module/guild/MainGuildCtrl"
    require "script/module/guild/shop/GuildShopCtrl"
    local isInUnion = false
    isInUnion = GuildDataModel.getIsHasInGuild()
    logger:debug({isInUnion=isInUnion})
    if (isInUnion and LayerManager.curModuleName() ~= GuildShopCtrl.moduleName()) then         -- 已经加入公会
        local returnFn = function ( sender, eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playBackEffect()
                DropUtil.getReturn(LayerManager.curModuleName())
                LayerManager.removeLayout() -- 关闭屏蔽层
            end
        end
        -- 添加屏蔽层 因为网络回调后才能进入商店 但是此阶段 按钮还可以继续点击
        local layout = Layout:create()
        layout:setName("layForShield")
        LayerManager.addLayout(layout)
        MainGuildCtrl.enterShop(returnFn, 1)
    elseif (not isInUnion and LayerManager.curModuleName() ~= GuildShopCtrl.moduleName()) then  -- 没加入公会
        ShowNotice.showShellInfo(m_i18n[1925])
    else
        LayerManager.removeLayout()           -- 已在当前界面
    end
end

-- 神秘商店
function gotoMysteryShop( ... )
    require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleCtrl"
    if (LayerManager.curModuleName() ~= MysteryCastleCtrl.moduleName()) then
       local function treaShopReturn( sender,eventType )
            if eventType == TOUCH_EVENT_ENDED then
                AudioHelper.playBackEffect()
                local curModuleName = LayerManager.curModuleName()
                DropUtil.getReturn(curModuleName)
            end
        end 
        local funcall = treaShopReturn
        MysteryCastleCtrl.create(funcall, 1)
    else
        LayerManager.removeLayout()             -- 已在当前界面
    end
end

-- 竞技场商店
function gotoArenaShop( ... )
    require "script/module/arena/MainArenaCtrl"     
    require "script/module/arena/ArenaCtrl"
    if (LayerManager.curModuleName() ~= ArenaCtrl.moduleName()) then

       local returnFn = function ( sender, eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playBackEffect()
                DropUtil.getReturn(LayerManager.curModuleName())
            end
        end
        -- ArenaCtrl.create(ArenaCtrl.tbType.shop,returnFn, 1)
        MainArenaCtrl.getArenaInfo(function (  )
                ArenaCtrl.create(ArenaCtrl.tbType.shop, returnFn, 1)
        end)

    else
        LayerManager.removeLayout()          -- 已在当前界面
    end
end
-- 普通副本
function gotoNormalCopy( ... )
    local layout = Layout:create()
    LayerManager.changeModule(layout,"temp_module_change", {3}, true)
    local layCopy = MainCopy.create()
    if (layCopy) then
        LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
        PlayerPanel.addForCopy()
        MainCopy.updateBGSize()
        MainCopy.setFogLayer()
    end
end
-- 精英副本
function gotoEliteCopy( ... )
    local layout = Layout:create()
    LayerManager.changeModule(layout,"temp_module_change", {3}, true)
    local layCopy = MainCopy.create(2,false)
    if (layCopy) then
        LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
        PlayerPanel.addForCopy()
        MainCopy.updateBGSize()
        MainCopy.setFogLayer()
    end
end
-- 探索
function gotoExplore( ... )
    -- local resumLayerCallFn = self.resumLayerCallFn
    local layCopy = MainCopy.create(3,nil,nil)
    if (layCopy) then
        LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true) --MainCopy.moduleName()
        PlayerPanel.addForExplorMapNew()
        MainCopy.updateBGSize()
        MainCopy.setFogLayer()
    end
end

-- 装备回收
function gotoArmResolve( ... )
    gotoResolve(ResolveTabType.E_Equip)
end


-- 主船回收
function gotoShipResolve( ... )
    gotoResolve(ResolveTabType.E_SuperShip)
end

-- 宝物回收
function gotoSPTreaResolve( ... )
    gotoResolve(ResolveTabType.E_SPTreas)
end


-- 伙伴回收
function gotoHeroResolve( ... )
    gotoResolve(ResolveTabType.E_Parnter)
end

-- 影子回收
function gotoShadowResolve( ... )
    gotoResolve(ResolveTabType.E_Shadow)
end

--饰品回收
function gotoTreasResolve( ... )
    logger:debug("gotoTreasResolve")
    gotoResolve(ResolveTabType.E_Treas)
end

-- 分解屋
function gotoResolve( resolveType )
    if (SwitchModel.getSwitchOpenState( ksSwitchResolve,true)) then
        require "script/module/resolve/MainRecoveryCtrl"

        local layResolve = MainRecoveryCtrl.create(resolveType)
        if (layResolve) then
            LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
            PlayerPanel.addForPublic()
        end
    end

end


-- 去装备商店
function goEquipShop( ... )
    require "script/module/impelDown/ImpelShop/ImpelShopCtrl"
    local Arg = {}
    Arg.from = function ( ... )
        AudioHelper.playBackEffect()
        require "script/module/public/DropUtil"
        local curModuleName = LayerManager.curModuleName()
        DropUtil.getReturn(curModuleName)
    end
    Arg.cache = true
    ImpelShopCtrl.create(Arg)
end

-- 去宝物商店
function goTreaShop( ... )
    local function treaShopReturn( sender,eventType )
        if eventType == TOUCH_EVENT_ENDED then
            AudioHelper.playBackEffect()
            local curModuleName = LayerManager.curModuleName()
            logger:debug({curModuleName=curModuleName})
            DropUtil.getReturn(curModuleName)
        end
    end 

    local funcall = treaShopReturn
    require "script/module/treaShop/TreaShopCtrl"
    TreaShopCtrl.create(nil,funcall,1)
end

-- 去觉醒商店
function goDisillusionShop( ... )
    local function disillusionShopReturn( sender,eventType )
        if eventType == TOUCH_EVENT_ENDED then
            AudioHelper.playBackEffect()
            local curModuleName = LayerManager.curModuleName()
            logger:debug({curModuleName=curModuleName})
            DropUtil.getReturn(curModuleName)
        end
    end

    AwakeShopCtrl.create(disillusionShopReturn,1)
end

-- 去巴奇宝钻
function gotoBaqiBaoZuan( ... )
    MainCopyCtrl.create(300003)
end

-- 去神秘招募
function gotoTavern( tid )
    logger:debug("{gotoTavern = htid}")
    logger:debug({gotoTavern = htid})
    --判断神秘招募是否配置了时间段
    local function isOpenMystery( )
        local time = TimeUtil.getSvrTimeByOffset()
        time = tonumber(time)
        local format = "%Y%m%d%H%M%S"
        local pei = tonumber(TimeUtil.getLocalOffsetDate(format,time) ) 

        local tbCount = table.count(DB_Tavern_mystery.Tavern_mystery)

        for i=1,tbCount do
            local mysteryInfo   = DB_Tavern_mystery.getDataById(i) 
            local endtime       =   mysteryInfo["end"]
            local start         =   mysteryInfo.start
            if((pei > tonumber(start))  and  (tonumber(endtime) > pei)) then
                return true
            end
        end
        return false
    end

    require "db/DB_Vip"
    local bRightVIP = false
    if ( tonumber(UserModel.getVipLevel()) ~= 0) then
        local dbVipInfo = DB_Vip.getDataById(UserModel.getVipLevel())
        bRightVIP = (tonumber(dbVipInfo.mystical_tavern) == 1)
    end
    -- 如果神秘招募已开启
    -- local bRightTime        = isOpenMystery()
    local bRightTime        = true
    if (not bRightVIP) then
        ShowNotice.showShellInfo(m_i18n[7203])
        --不合适就删掉回调
        local curModuleName = LayerManager.curModuleName()
        DropUtil.destroyCallFn(curModuleName,curModuleName)
        return
    elseif ( not bRightTime) then
        ShowNotice.showShellInfo(m_i18n[7202])
        --不合适就删掉回调
        local curModuleName = LayerManager.curModuleName()
        DropUtil.destroyCallFn(curModuleName,curModuleName)
        return
    end

    local function tavernReturn(  )
        local curModuleName = LayerManager.curModuleName()
        logger:debug({tavernReturn_curModuleName=curModuleName})
        DropUtil.setSourceAndAim(curModuleName,curModuleName)
        DropUtil.getReturn(curModuleName)
    end 

    RecruitService.getMysClicked(tid,tavernReturn)
end

function gotoMainWonder( gotoType )
    local act = MainWonderfulActCtrl.create(gotoType)
    LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
    
    local scene = CCDirector:sharedDirector():getRunningScene()
    performWithDelay(scene, function(...)
        MainWonderfulActView.updateLSVPos(gotoType)
    end, 0.1)

end

-- 开服礼包
function gotoAccreward( ... )
    if  not AccSignModel.accIconNeedShow() then 
        return
    else
        gotoMainWonder("accReward")
    end
end

-- 精彩活动
function gotolevelReward( ... )
    if  not LevelRewardCtrl.getCurRewardInfo() then 
        
        return
    else
        gotoMainWonder("levelReward")
    end
end

-- 深海监狱
function gotoimpelDown( ... )
    local Arg = {}
    Arg.returnType = 1
    Arg.returnCallFn = function ( ... )
        AudioHelper.playBackEffect()
        require "script/module/public/DropUtil"
        local curModuleName = LayerManager.curModuleName()
        DropUtil.getReturn(curModuleName)
    end
    MainImpelDownCtrl.create(Arg)
end

-- 进入觉醒背包
function goDisillusionBag( ... )
    AwakeBagCtrl.create()
end

-- 进入觉醒副本
function goToAwakeCopy( ... )
    copyAwakeCtrl.create()
end

-- 进入炼狱副本
function goToLianYuCopy( ... )
    local layout = Layout:create()
    LayerManager.changeModule(layout,"temp_module_change", {3}, true)
    local layCopy = MainCopy.create()
    if (layCopy) then
        LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
        PlayerPanel.addForCopy()
        MainCopy.updateBGSize()
        MainCopy.setFogLayer()
    end
end

--  酒馆第二页
function gotoMainShop( ... )
    local layShop = MainShopCtrl.create(2)
    if (layShop) then
        LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
        PlayerPanel.addForPublic()
    end
end




