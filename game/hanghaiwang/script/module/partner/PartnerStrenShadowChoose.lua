-- FileName: PartnerStrenShadowChoose.lua
-- Author: sunyunpeng
-- Date: 2015-12-16
-- Purpose: function description of module
--[[TODO List]]

module("PartnerStrenShadowChoose", package.seeall)
require "script/module/public/Cell/HeroCell"

-- UI控件引用变量 --

-- 模块局部变量 --
local _shadowList 				-- 所有可选择的影子列表
local _expInfo    				--当前的经验状态
local _layMain
local _nTotalExp  = 0			--目前已经选择的影子可获得的总经验
local _nSelectCount  = 0		--目前已经选择的影子数量
local _nSelectMaxCount = 5      --最多能选择武将的个数
local _nCurSelectHeroIndex      --当前所选的影子
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["PartnerStrenShadowChoose"] = nil
end

function moduleName()
    return "PartnerStrenShadowChoose"
end


-- 读取初始化时选择的伙伴数量与经验总值
local function fnGetTotalPartner( ... )
    _nTotalExp = 0
    _nSelectCount = 0
    local nHeroCount = #_shadowList
    for i=1, nHeroCount do
        if (_shadowList[i]) then
            if (_shadowList[i].checkIsSelected) then
                _nSelectCount = _nSelectCount + 1
                _nTotalExp = _nTotalExp + _shadowList[i].soul
            end
        end
    end
end

--[[desc:判断当前已选择的影子所添加的经验值是否已经够伙伴满级了
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
local function fnCheckExpHaveFull( ... )
    if( not _shadowList ) then
        return false
    end

    local nTotalExp = 0
    if _shadowList then 
        for k,v in pairs(_shadowList) do
            if (v.checkIsSelected) then
                local nHeroSoul = v.soul
                nTotalExp = nTotalExp + nHeroSoul
            end
        end
    end
    
    local tArgs = {}
    tArgs.soul = _expInfo.soul
    tArgs.added_soul = nTotalExp
    tArgs.exp_id = _expInfo.exp_id
    tArgs.level = _expInfo.level

    local nCurLevelNeedSoul = HeroPublicUtil.getSoulOnLevel(tArgs)
    local nowLeftoul = tonumber(tArgs.soul) - nCurLevelNeedSoul
    tArgs.nowLeftoul = nowLeftoul

    local pAfterAddLevel = HeroPublicUtil.getHeroLevelByAddSoul(tArgs)

    if(pAfterAddLevel >= UserModel.getAvatarLevel()) then
        return true
    end
    return false
end 


--[[desc:判断当前已选择的影子所需要的呗里是否够用
    arg1: 
    return: 是否有返回值，返回值说明  
—]]
local function fnCheckSilverHaveFull( preSelected )
    if( not m_SelectHeroInfo ) then
        return false
    end

    local nTotalCost = 0
    if m_tbAllHeroesInfo then 
        for k,v in pairs(m_tbAllHeroesInfo) do
            if (v.checkIsSelected) then
                   logger:debug("here")
                local nHeroCost = v.exp * v.item_num 
                nTotalCost = nTotalCost + nHeroCost
                  logger:debug(nTotalCost)
            end
            if (k == preSelected ) then
                   logger:debug("here")
                local nHeroCost = v.exp 
                nTotalCost = nTotalCost + nHeroCost
                  logger:debug(nTotalCost)
            end
        end
    end
    
    local tArgs = {}
    tArgs.needed_siver = nTotalCost
   
    local maxSilver = UserModel.getSilverNumber()

    if(nTotalCost > maxSilver) then
        return false
    end
    return true
end 

local function selectedListCell( ... )
    if (_nSelectCount >= _nSelectMaxCount and not _shadowList[_nCurSelectHeroIndex+1].checkIsSelected) then
        require "script/module/public/ShowNotice"
        ShowNotice.showShellInfo(m_i18n[1058])
        return false
    end
    
    if(_shadowList[_nCurSelectHeroIndex+1]) then
        if (_shadowList[_nCurSelectHeroIndex+1].checkIsSelected) then
            _nSelectCount = _nSelectCount - 1
            logger:debug("m_nTotalExp1" .. _nTotalExp)
            _nTotalExp = _nTotalExp - _shadowList[_nCurSelectHeroIndex+1].soul
            _shadowList[_nCurSelectHeroIndex+1].checkIsSelected = false
        else
            if(fnCheckExpHaveFull()) then
                require "script/module/public/ShowNotice"
                ShowNotice.showShellInfo(m_i18n[5519])
                return false
            end
            _nSelectCount = _nSelectCount + 1
            _nTotalExp = _nTotalExp + _shadowList[_nCurSelectHeroIndex+1].soul
            _shadowList[_nCurSelectHeroIndex+1].checkIsSelected = true
        end
    end
    
    return true
end 

local function onBtnSure( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
      	LayerManager.removeLayout()
      	GlobalNotify.postNotify("SHADOWSLELECT_OK",_shadowList) -- 刷新强化界面UI
    end
end

local function onBtnBack( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playBackEffect()
        LayerManager.removeLayout()
        GlobalNotify.postNotify("SHADOWSLELECT_OK",_shadowList) -- 刷新强化界面UI
    end
end

-- 构造伙伴影子列表需要的数据
local function getPartnerListData( ... )
    local tbListInfo = {}

    for i,v in ipairs(_shadowList) do
    	local tbData = {}
        tbData.id = v.item_id
        tbData.name = v.name
        tbData.sign = v.country_icon

        tbData.icon = { id = v.htid, bHero = true }
        tbData.sLevel = v.level
        tbData.nStar = v.star_lv
        tbData.nQuality = v.heroQuality 
        tbData.item_num = v.item_num 
        tbData.sExp = v.soul
        tbData.bSelect = v.checkIsSelected or false

        table.insert(tbListInfo, tbData)
    end

    logger:debug({getPartnerListData_tbListInfo = tbListInfo})
    return tbListInfo
end


function initListView( ... )
    local instTableView
    local tbInfo = {}

    require "script/module/public/ChooseList"
	tbInfo.sType = CHOOSELIST.PARTNER
    tbInfo.onBack = onBtnBack
    tbInfo.tbState = {sChoose = m_i18n[1020],sChooseNum = _nSelectCount,
        sExp = m_i18n[1060], sExpNum = _nTotalExp, onOk = onBtnSure}

    tbInfo.tbView = {}

    local szCell = g_fnCellSize(CELLTYPE.PARTNER)
    tbInfo.tbView.szCell = CCSizeMake(szCell.width, szCell.height)
    tbInfo.tbView.tbDataSource = getPartnerListData()
     
    tbInfo.tbView.CellAtIndexCallback = function (tbDat)
        local instCell = PartnerCell:new()
        instCell:init(CELL_USE_TYPE.STRONG)

        logger:debug({CellAtIndexCallback = tbDat})
        instCell:refresh(tbDat)
        return instCell
    end

    tbInfo.tbView.CellTouchedCallback = function ( view, cell, objCell)
        AudioHelper.playCommonEffect()
    
        local index = cell:getIdx()
        _nCurSelectHeroIndex = index
        local pChoose = selectedListCell()
        if(pChoose) then
            tbInfo.tbState.sChooseNum = _nSelectCount
            tbInfo.tbState.sExpNum = _nTotalExp
            if (tbInfo.tbView.tbDataSource[index+1].bSelect == true ) then 
                tbInfo.tbView.tbDataSource[index+1].bSelect = false 
            else
                tbInfo.tbView.tbDataSource[index+1].bSelect = true
            end
            objCell.cbxSelect:setSelectedState(_shadowList[index+1].checkIsSelected or false) 
            instTableView:refreshChooseStateNum(tbInfo.tbState)
        end
    end

    instTableView = ChooseList:new()
    _layMain = instTableView:create(tbInfo)
end


function create( shadowList, expInfo )
	_shadowList = shadowList
	_expInfo = expInfo
	fnGetTotalPartner()
	initListView()
    LayerManager.hideAllLayout(_layMain)
	LayerManager.setPaomadeng(_layMain)
    UIHelper.registExitAndEnterCall(_layMain, function ( ... )
         -- 重新设置跑马灯
        LayerManager.resetPaomadeng()
        LayerManager.remuseAllLayoutVisible(_layMain)
    end)
    return _layMain
end
