-- FileName: PartnerTransCtrl.lua
-- Author: sunyunpeng
-- Date: 2015-12-17
-- Purpose: function description of module
--[[TODO List]]

module("PartnerTransCtrl", package.seeall)

-- UI控件引用变量 --
local _mainLayout
local _transInfo 

--武将进化网络标石
local _sNetworkFlagOfHeroEvolve
-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local _sourceType -- 页面来源 1 阵容 2 背包
local _heroLocation -- 英雄在阵容上的位置

local function init(...)

end

function destroy(...)
	package.loaded["PartnerTransCtrl"] = nil
end

function moduleName()
    return "PartnerTransCtrl"
end



function create(  hid,sourceType,heroLocation)
    _sourceType = sourceType
    _heroLocation = HeroModel.getHeroPosByHid(hid)
	initForceValue(hid)
	initOtherInfo()
	initMaterial()
    require "script/module/partner/PartnerTransView"
	local layout = PartnerTransView.create(_transInfo)
	LayerManager.changeModule(layout, PartnerTransCtrl.moduleName(), {1}, true)
    PlayerPanel.addForPartnerStrength()
end


function initForceValue( hid,beforeForceValue )
	_transInfo = {}
	_transInfo.hid = hid
    local heroInfo = HeroModel.getHeroByHid(hid)
    _transInfo.heroInfo = heroInfo
    local heroDB = DB_Heroes.getDataById(heroInfo.htid)
    if (not heroDB) then
        heroDB = DB_Heroes.getDataById(heroInfo.htid)
    end
    _transInfo.transBeforHeroDB = heroDB
    if (not beforeForceValue) then
	    local forceValue = HeroFightUtil.getAllForceValuesByHidNew(hid)
	    _transInfo.beforeForceValue = forceValue
	else
	    _transInfo.beforeForceValue = beforeForceValue
	end

    local transid = PartnerTransUtil.getTransid(heroDB.id,heroInfo.evolve_level)

    if (transid ~= nil) then --是否进阶到最大等级
    	_transInfo.transid = transid
		local DBHeroTransfer = DB_Hero_transfer.getDataById(transid)
    	local translimitLevel = DBHeroTransfer.limit_lv
    	_transInfo.translimitLevel = translimitLevel
        local newHeroDB = DB_Heroes.getDataById(DBHeroTransfer.new_htid)
    	_transInfo.transAffterHeroDB = newHeroDB
    	_transInfo.DBHeroTransfer = DBHeroTransfer
    	local newHeroInfo = {}
        local newHeroInfo = table.hcopy(heroInfo,newHeroInfo)
        newHeroInfo.evolve_level = heroInfo.evolve_level + 1
        _transInfo.affterForceValue = HeroFightUtil.getNewAllForceValues(newHeroInfo,nil,nil,true)
    end
end

-- 解锁的技能和描述
function initOtherInfo( ... )
    local transid = _transInfo.transid 

	if (transid) then
		local growAwakeId = _transInfo.transAffterHeroDB.grow_awake_id
        local growAwake = string.split(growAwakeId, ",")
        local awakeLevel = _transInfo.heroInfo.evolve_level + 1
        for _,value in ipairs(growAwake) do
           local growAwake = string.split(value, "|")
           if (tonumber(growAwake[2]) == tonumber(awakeLevel)) then
                local awakeInfo = DB_Awake_ability.getDataById(growAwake[3])
    			_transInfo.awakeName = awakeInfo.name 
    			_transInfo.awakeDes = awakeInfo.des 
           end
       end
    end

end

-- 消耗的材料，贝里
function initMaterial( ... )
    local transid = _transInfo.transid 
    local DBHeroTransfer = _transInfo.DBHeroTransfer
    if (not transid) then
        return
    end
    --
    local costInfo = {}
    -- 进阶需要的物品ID及数量组
    require "db/DB_Item_normal"
    local sItemNeeded = DBHeroTransfer.need_items
    local tArrItemNeeded = string.split(sItemNeeded, ",")
    require "script/module/public/ItemUtil"

    local bag = DataCache.getRemoteBagInfo()
    local props = bag.props
    local heroFrag = bag.heroFrag

    for i,needItem in ipairs(tArrItemNeeded) do
    	local needInfo = {}

        local tbItemInfo = string.split(needItem, "|")
        local itemTid = tonumber(tbItemInfo[1])
        needInfo.itemTid = itemTid
        if #tbItemInfo < 2 then
            tbItemInfo[2] = 1
        end
        local ItemType = ItemUtil.getItemTypeByTid(itemTid)
        local needNum = tonumber(tbItemInfo[2])
        needInfo.needNum = needNum
        local checkBag = ItemType.isNormal and props or (ItemType.isShadow and heroFrag or {}) 
    	local haveNum = 0
    	for k, v in pairs( checkBag ) do
            if  (tonumber(v.item_template_id) == itemTid) then
        		needInfo.itemId = v.item_id
                haveNum = haveNum + tonumber(v.item_num)
            end
	    end
        needInfo.haveNum = haveNum
        table.insert(costInfo,needInfo)
    end
    _transInfo.costCoin = DBHeroTransfer.cost_coin
    _transInfo.costInfo = costInfo
    return costInfo
end

local function afterBagRefresh( ... )
    -- 重置信息界面
    initForceValue(_transInfo.hid,_transInfo.affterForceValue)
    initOtherInfo()
    initMaterial()
    PartnerTransView.refreshLayer(_transInfo)
end 

-- 网络事件处理
local function fnHandlerOfNetwork(cbFlag, dictData, bRet)
    logger:debug("request END")
    if not bRet then
        logger:debug("进阶失败")
        -- 移除屏蔽层
        LayerManager.removeLayout()
        return
    end 
    --武将卡牌强化
    ------------------------- new guide begin -------------------------------------------
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuidePartnerAdvView"
    if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 3) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.removeGuideView()   
    end

     require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 8) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.removeGuideView()
        GuideCtrl.setPersistenceGuide("copyBox","14")
    end

    ------------------------- new guide end -----------------------------------------------
    -- 进阶成功后处理
    local tRet = dictData.ret
    require "script/model/user/UserModel"
    -- 减去消耗的贝里数目
    local succeedInfo = {}
    table.hcopy(_transInfo,succeedInfo)
    -- 减去消耗的武将数组
    local length = 0
    if tRet.hero then
        length = #tRet.hero
    end

    require "script/model/hero/HeroModel"
    for i=1, length do
        HeroModel.deleteHeroByHid(tRet.hero[i])
    end
    -- 修改武将进阶次数
    HeroModel.addEvolveLevelByHid(_transInfo.hid, 1)

    -- 修改武将进阶后的模板id
    if (tonumber(_transInfo.htid) == tonumber(UserModel.getAvatarHtid()) ) then
        UserModel.setAvatarHtid(_transInfo.newHtid) -- 如果进阶的是玩家角色，需要更新htid
    end

    HeroModel.setHtidByHid(tonumber(_transInfo.hid), _transInfo.transAffterHeroDB.id)
    _transInfo.htid = _transInfo.newHtid
    -- 修改武将进阶后的等级
    _transInfo.evolve_level = tRet.evolve_level
    -- 播放动画


    PartnerTransView.transferAnimation(succeedInfo)
    UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
    UserModel.updateFightValueByValue(_transInfo.hid,_transInfo.affterForceValue)
    UserModel.addSilverNumber(-tonumber(tRet.silver))
end

-- 2015-11-17 sunyunpeng 判断是否可以进阶
function canTrans( )
	-- 判断主角等是否足够
	local transid = _transInfo.transid 
	--  是否到最大进阶等级
	if (not transid) then
        ShowNotice.showShellInfo(m_i18n[1043])
		return false
	end
    local DBHeroTransfer = _transInfo.DBHeroTransfer
    -- 判断主角等是否足够
    if(DBHeroTransfer.need_player_lv > tonumber(UserModel.getHeroLevel())) then
        ShowNotice.showShellInfo(m_i18nString(1108,DBHeroTransfer.need_player_lv))
        return false
    end
    -- 判断武将等级是否足够
    local nLimitLevel = DBHeroTransfer.limit_lv
    if(tonumber(nLimitLevel) > tonumber(_transInfo.heroInfo.level)) then
        ShowNotice.showShellInfo(m_i18nString(1044,nLimitLevel))
        return false
    end
    -- 判断材料是否够用
    local costInfo = _transInfo.costInfo
    for i,costItem in ipairs(costInfo) do
        if (tonumber(costItem.haveNum) < tonumber(costItem.needNum)) then
            local dropCallfn =  function ( ... )
                initMaterial()
                PartnerTransView.initMaterial(_transInfo.costInfo)
            end
            PublicInfoCtrl.createItemDropInfoViewByTid(costItem.itemTid,dropCallfn,true)  -- 进阶石不足引导界面
            ShowNotice.showShellInfo(m_i18n[1040])   --   道具不足r
            return false
        end
    end
    -- 判断玩家贝里数量是否足够
    if(tonumber(DBHeroTransfer.cost_coin) > UserModel.getSilverNumber()) then
        PublicInfoCtrl.createItemDropInfoViewByTid(60406)  -- 贝里不足引导界面
        ShowNotice.showShellInfo(m_i18n[1042])
        return false
    end
    return true
end


-- 进阶
function onBtnTransferStart( ... )
    local costInfo = _transInfo.costInfo 

    -- 判断进阶功能节点是否开启了，如果没开启则返回
    if (not SwitchModel.getSwitchOpenState(ksSwitchGeneralTransform,true)) then
        return
    end
    -- 是否可以进阶
    if(not canTrans()) then
        return 
    end

    require "script/network/RequestCenter"
    local args = CCArray:createWithObject(CCInteger:create(_transInfo.hid))
    local sub_args = CCArray:create()
    local args_item = CCDictionary:create()
    for i=1, #costInfo do
        local item = costInfo[i]
        args_item:setObject(CCInteger:create(item.needNum), tostring(item.itemId))
    end
    args:addObject(sub_args)
    args:addObject(args_item)
    -- 加屏蔽层，防止多次点击进阶和其他按钮
    local layout = Layout:create()
    layout:setName("layForShield")
    LayerManager.addLayout(layout)

    PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）
    RequestCenter.hero_evolve(fnHandlerOfNetwork, args)
end


-- 返回
function onBtnReturn( ... )
    if (_sourceType == 2) then
        local layPartner = MainFormation.create(_heroLocation)
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

    require "script/module/guide/GuideModel"
    require "script/module/guide/GuidePartnerAdvView"
    if (GuideModel.getGuideClass() == ksGuideGeneralTransform and GuidePartnerAdvView.guideStep == 4) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createPartnerAdvGuide(5,0)   
    end

    require "script/module/guide/GuideCopyBoxView"
    if (GuideModel.getGuideClass() == ksGuideCopyBox and GuideCopyBoxView.guideStep == 9) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createCopyBoxGuide(10)
    end

end







