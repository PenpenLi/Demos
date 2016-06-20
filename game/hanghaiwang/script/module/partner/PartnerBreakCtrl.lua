-- FileName: PartnerBreakCtrl.lua
-- Author: sunyunpeng
-- Date: 2016-01-15
-- Purpose: function description of module
--[[TODO List]]

module("PartnerBreakCtrl", package.seeall)

-- UI控件引用变量 --
local _mainLayout
local _breakInfo 

--武将进化网络标石
local _sNetworkFlagOfHeroEvolve
-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local _sourceType -- 页面来源 1 阵容 2 背包
local _heroLocation -- 英雄在阵容上的位置

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["PartnerBreakCtrl"] = nil
end

function moduleName()
    return "PartnerBreakCtrl"
end

function create( hid,sourceType,heroLocation)
	_sourceType = sourceType
    _heroLocation = HeroModel.getHeroPosByHid(hid)
	initForceValue(hid)
	initOtherInfo()
	initMaterial()
    require "script/module/partner/PartnerBreakView"
	local layout = PartnerBreakView.create()
	LayerManager.changeModule(layout, PartnerTransCtrl.moduleName(), {1}, true)
    PlayerPanel.addForPartnerStrength()
end


function initForceValue( hid,beforeForceValue )
	_breakInfo = {}
    _breakInfo.sourceType = _sourceType
    _breakInfo.heroLocation = _heroLocation

	_breakInfo.hid = hid
    local heroInfo = HeroModel.getHeroByHid(hid)
    _breakInfo.heroInfo = heroInfo
    local heroDB = DB_Heroes.getDataById(heroInfo.htid)
    _breakInfo.breakBeforHeroDB = heroDB
    if (not beforeForceValue) then
	    local forceValue = HeroFightUtil.getAllForceValuesByHidNew(hid)
	    _breakInfo.beforeForceValue = forceValue
	else
	    _breakInfo.beforeForceValue = beforeForceValue
	end

    local breakID = heroDB.break_id

    if (breakID ~= nil) then --是否进阶到最大等级
    	_breakInfo.breakID = breakID
		require "db/DB_Hero_break"
		local DBHeroBreak = DB_Hero_break.getDataById(breakID)
        local newHeroDB = DB_Heroes.getDataById(DBHeroBreak.after_id)
    	_breakInfo.breakAffterHeroDB = newHeroDB
    	_breakInfo.DBHeroBreak = DBHeroBreak
    	local newHeroInfo = {}
        local newHeroInfo = table.hcopy(heroInfo,newHeroInfo)
        newHeroInfo.htid = DBHeroBreak.after_id
        _breakInfo.affterForceValue = HeroFightUtil.getNewAllForceValues(newHeroInfo,nil,nil,true)
    end
end

function getBreakInfo( ... )
	return _breakInfo
end


-- 解锁的技能和描述
function initOtherInfo( ... )
    local breakID = _breakInfo.breakID 

	if (breakID) then
		local growAwakeId = _breakInfo.breakAffterHeroDB.grow_awake_id
        local growAwake = string.split(growAwakeId, ",")
        local evolveLevel = _breakInfo.heroInfo.evolve_level 
        local heroLel = _breakInfo.heroInfo.level
        -- for _,value in ipairs(growAwake) do
        if (#growAwake > 0 and growAwake[#growAwake]) then
			local growAwake = string.split(growAwake[#growAwake], "|")
			local awakeInfo = DB_Awake_ability.getDataById(growAwake[3])
			_breakInfo.awakeName = awakeInfo.name 
			_breakInfo.awakeDes = awakeInfo.des 
       end
    end

end

-- 消耗的材料，贝里
function initMaterial( ... )
    local evolveLevel = _breakInfo.heroInfo.evolve_level 

    local breakID = _breakInfo.breakID 
    local DBHeroBreak = _breakInfo.DBHeroBreak
    if (not breakID) then
        return
    end
    --
    local costInfo = {}
    -- 进阶需要的物品ID及数量组
    require "db/DB_Item_normal"
    local costItem = DBHeroBreak.cost_item
    local sItemNeeded = string.split(costItem, ",")

    require "script/module/public/ItemUtil"
    local bag = DataCache.getRemoteBagInfo()
    local props = bag.props

    for i,needNormal in ipairs(sItemNeeded) do
    	local needInfo = {}

        local tbItemInfo = string.split(needNormal, "|")
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

    -- 进阶需要的英雄碎片ID及数量组
    require "db/DB_Item_normal"
    local sFragNeeded = DBHeroBreak.cost_fragment
    logger:debug({sFragNeeded = sFragNeeded})
    local tArrFragNeededNeeded = string.split(sFragNeeded, ",")
    require "script/module/public/ItemUtil"

    local heroFrag = bag.heroFrag
    for i,needItem in ipairs(tArrFragNeededNeeded) do

        local tbItemInfo = string.split(needItem, "|")
        local brakBeforeEvole = tonumber(tbItemInfo[1])
        if (brakBeforeEvole == tonumber(evolveLevel)) then
            logger:debug("tArrFragNeededNeeded")
    		local needInfo = {}
    		local itemTid = tonumber(tbItemInfo[2])
	        needInfo.itemTid = itemTid
	        local ItemType = ItemUtil.getItemTypeByTid(itemTid)
	        local needNum = tonumber(tbItemInfo[3])
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
	        break
	    end
    end
    _breakInfo.costCoin = _breakInfo.DBHeroBreak.cost_belly
    _breakInfo.costInfo = costInfo
    return costInfo
end

local function afterBagRefresh( ... )
    -- 重置信息界面
    initForceValue(_breakInfo.hid,_breakInfo.affterForceValue)
    initOtherInfo()
    initMaterial()
    PartnerTransCtrl.refreshLayer(_breakInfo)
end 

-- 网络事件处理
local function fnHandlerOfNetwork(cbFlag, dictData, bRet)

	if not bRet then
        -- 移除屏蔽层
		LayerManager.removeLayout()
		return
	end
	--武将卡牌强化
	if (cbFlag == _sNetworkFlagOfHeroBreak) then
		-- 进阶成功后处理
		local tRet = dictData.ret
		-- 减去消耗的武将数组

		-- 修改武将进阶后的模板id
		if (tonumber(_breakInfo.htid) == tonumber(UserModel.getAvatarHtid()) ) then
			UserModel.setAvatarHtid(_breakInfo.breakAffterHeroDB.id) -- 如果进阶的是玩家角色，需要更新htid
		end
		HeroModel.setHtidByHid(_breakInfo.hid, _breakInfo.breakAffterHeroDB.id)
		-- 添加图鉴
		DataCache.addHeroBook({_breakInfo.breakAffterHeroDB.id})
        PartnerBreakView.showBreakSuccedAni()
		
		require "script/model/user/UserModel"       
	 	local curHeroHid = tonumber(_breakInfo.heroInfo.hid)
        -- local updataInfo = {[hid] = {HeroFightUtil.FORCEVALUEPART.LEVEL , HeroFightUtil.FORCEVALUEPART.UNION},}
		UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
		UserModel.updateFightValue({[curHeroHid] = {}})-- 生成新的hid 所以所有部分战斗力都要重新计算
		UserModel.addSilverNumber(-tonumber(_breakInfo.costCoin)) -- 减去消耗的贝里数目

	end
end

-- 2015-11-17 sunyunpeng 判断是否可以进阶
function canBreak( )
    -- if (1) then
    --     PartnerBreakView.showBreakSuccedAni()
    --     return
    -- end

	-- 判断主角等是否足够
	local breakID = _breakInfo.breakID 
	--  是否到最大进阶等级
	if (not breakID) then
        ShowNotice.showShellInfo(m_i18n[1120])
		return false
	end
    local DBHeroBreak = _breakInfo.DBHeroBreak
    -- 判断武将等级是否足够和进阶等级是否足够
	local level = tonumber(_breakInfo.heroInfo.level)
	local evolve_level = tonumber(_breakInfo.heroInfo.evolve_level)
	-- 进阶需要的进阶等级
	local need_advancelv = tonumber(DBHeroBreak.need_advancelv) or 0
	-- 进阶需要的英雄等级
	local need_strlv = tonumber(DBHeroBreak.need_strlv) or 0

	if(need_strlv > level or need_advancelv > evolve_level) then
		local pstring = m_i18nString(1158,tostring(need_strlv),tostring(need_advancelv))
		--local pstring = string.format("伙伴达到%s级并进阶＋%s才可以突破",tostring(m_tbHeroAttr.need_strlv ),tostring(m_tbHeroAttr.need_advancelv))--wm_todo
		ShowNotice.showShellInfo(pstring)
		return
	end

    -- if(DBHeroBreak.need_player_lv > tonumber(UserModel.getHeroLevel())) then
    --     ShowNotice.showShellInfo(m_i18nString(1108,DBHeroTransfer.need_player_lv))
    --     return false
    -- end
    -- -- 判断武将等级是否足够
    -- local nLimitLevel = DBHeroTransfer.limit_lv
    -- if(tonumber(nLimitLevel) > tonumber(_breakInfo.heroInfo.level)) then
    --     ShowNotice.showShellInfo(m_i18nString(1044,nLimitLevel))
    --     return false
    -- end
    -- 判断材料是否够用
    local costInfo = _breakInfo.costInfo
    for i,costItem in ipairs(costInfo) do
        if (tonumber(costItem.haveNum) < tonumber(costItem.needNum)) then
            local dropCallfn =  function ( ... )
                initMaterial()
                PartnerBreakView.fnInitConsum(_breakInfo.costInfo)
            end
            PublicInfoCtrl.createItemDropInfoViewByTid(costItem.itemTid,dropCallfn,true)  -- 进阶石不足引导界面
            local materialType = ItemUtil.getItemTypeByTid(costItem.itemTid)
            local noticeString = materialType.isNormal and m_i18n[1150] or m_i18n[1191]
            ShowNotice.showShellInfo(noticeString)   --   道具不足
            return false
        end
    end
    -- 判断玩家贝里数量是否足够
    if(tonumber(DBHeroBreak.cost_belly) > UserModel.getSilverNumber()) then
        PublicInfoCtrl.createItemDropInfoViewByTid(60406)  -- 贝里不足引导界面
        ShowNotice.showShellInfo(m_i18n[1151])
        return false
    end
    return true
end


-- 突破
function onBtnBreakStart( ... )
	-- 判断进阶功能节点是否开启了，如果没开启则返回
	require "script/model/DataCache"
	if (not SwitchModel.getSwitchOpenState(ksSwitchHeroBreak,true)) then
		return
	end
	-- 是否可以突破 
    if(not canBreak()) then
        return 
    end

    require "script/network/RequestCenter"
    local costInfo = _breakInfo.costInfo

    local args = CCArray:createWithObject(CCInteger:create(_breakInfo.hid))
    logger:debug({onBtnBreakStart = _breakInfo.hid})
    local sub_args = CCArray:create()
    local args_item = CCDictionary:create()
    for i=1, #costInfo do
        local item = costInfo[i]
        logger:debug({onBtnBreakStart_item = item})

        args_item:setObject(CCInteger:create(item.needNum), tostring(item.itemId))
    end
    -- args:addObject(sub_args)
    args:addObject(args_item)

    -- 加屏蔽层，防止多次点击进阶和其他按钮
    -- local layout = Layout:create()
    -- layout:setName("layForShield")
    -- LayerManager.addLayout(layout)
    PartnerBreakView.setBtnTouchEnable(false)


    -- PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）
	_sNetworkFlagOfHeroBreak = RequestCenter.hero_heroBreak(fnHandlerOfNetwork, args)
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
