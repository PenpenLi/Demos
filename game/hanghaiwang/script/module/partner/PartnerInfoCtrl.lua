-- FileName: PartnerInfoCtrl.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("PartnerInfoCtrl", package.seeall)
require "script/module/partner/PartnerInfoView"
require "script/module/partner/PartnerInfoModle"


-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["PartnerInfoCtrl"] = nil
end

function moduleName()
    return "PartnerInfoCtrl"
end


-- HerosInfo.tbheros = { htid  -模板id  hid- 唯一标示  strengthenLevel -- 强化等级 ， transLevel -- 进阶等级 }
-- HerosInfo.index
--_layoutStyle 1 获取途径 可以进阶 2  确定 可以进阶  3 获取途径 不可以进阶 4 确定 不可以进阶 5 阵容上（替换）(控制底部按钮)
function create(HerosInfo , layType )
	local partnerInfoModle = PartnerInfoModle:new()
	local infoModleInstance = partnerInfoModle:create(HerosInfo , layType )
    local partnerInfoView = PartnerInfoView:new(1)
    local infoViewInstance = partnerInfoView:create(infoModleInstance)
    return infoViewInstance,partnerInfoView
end


function showJiBan(HerosInfo , layType )
    local partnerInfoModle = PartnerInfoModle:new()
    local infoModleInstance = partnerInfoModle:create(HerosInfo , layType)
    local partnerInfoView = PartnerInfoView:new(2)
    local infoViewInstance = partnerInfoView:fnShowInitCell(infoModleInstance,1)
    return infoViewInstance,partnerInfoView
end


function showJeuXing(HerosInfo , layType )
    local partnerInfoModle = PartnerInfoModle:new()
    local infoModleInstance = partnerInfoModle:create(HerosInfo , layType)
    local partnerInfoView = PartnerInfoView:new(2)
    local infoViewInstance = partnerInfoView:fnShowInitCell(infoModleInstance,2)
    return infoViewInstance,partnerInfoView
end

-- 突破
function OnBreak( heroInfo )
    if(not SwitchModel.getSwitchOpenState(ksSwitchHeroBreak,true)) then
        return
    end

    local heroDB = heroInfo.heroDB
    local breakID = heroDB.break_id
    local layCurType = heroInfo.curModuleName == "MainFormation" and 2 or 1

    if(breakID) then
        require "script/module/partner/PartnerBreakCtrl"
        PartnerBreakCtrl.create(heroInfo.hid,layCurType,heroInfo.location)
        return
    end
    ShowNotice.showShellInfo(m_i18n[1120])
end

-- 进阶
function OnTrans( heroInfo )
    local heroDB = heroInfo.heroDB
    local advanced_id = heroDB.advanced_id
    local layCurType = heroInfo.curModuleName == "MainFormation" and 2 or 1

    if(advanced_id) then
        require "script/module/partner/PartnerTransCtrl"
        local tHeroValue = heroInfo.heroValue
        PartnerTransCtrl.create(heroInfo.hid,layCurType,heroInfo.location)
        return
    end
    ShowNotice.showShellInfo(m_i18n[1107])
end

-- 强化
function OnStrength( heroInfo )
    require "script/module/partner/PartnerStrenCtrl"
    require "script/module/main/PlayerPanel"
    local layCurType = heroInfo.curModuleName == "MainFormation" and 2 or 1
    PartnerStrenCtrl.create(heroInfo.hid,layCurType,heroInfo.location)
end

-- 觉醒
function OnAwake( heroInfo )
    local awakeLv = DB_Switch.getDataById(ksSwitchAwake or 40).level
    if(not SwitchModel.getSwitchOpenState(ksSwitchAwake or 40,true)) then
        return
    end

    if (tonumber(UserModel.getHeroLevel()) < tonumber(awakeLv)) then
        ShowNotice.showShellInfo(awakeLv .. "级解锁")
        return
    end

    local hid = heroInfo.hid
    local layCurType = heroInfo.curModuleName == "MainFormation" and 1 or 0
    require "script/module/partnerAwakening/MainAwakeCtrl"
    MainAwakeCtrl.create( layCurType,hid)
end

--羁绊界面
function onBtnPartnerBond( heroInfo )
    local layCurType = heroInfo.curModuleName == "MainFormation" and 2 or 1
    require "script/module/partner/PartnerBond/PartnerBondCtrl"
    LayerManager.changeModule(PartnerBondCtrl.create( layCurType , heroInfo.hid ),PartnerBondCtrl.moduleName(),{1,3})
    PlayerPanel.addForPartnerStrength()
end

--  确定
function onBtnClose( )
    LayerManager.removeLayout()
end

-- 获取途径
function onBtnGet( heroInfo  )
    local heroFragDB = heroInfo.heroFragDB
    require "script/module/public/FragmentDrop"
    local fragmentDrop = FragmentDrop:new()
    local fragmentDropLayer = fragmentDrop:create(heroFragDB.id,Dropcallfn)
    LayerManager.addLayout(fragmentDropLayer)
end


--换个小伙伴
function onBtnChangeHeroBattle( heroInfo )
    AudioHelper.playCommonEffect()
    require "script/module/formation/MainFormationTools"
    local pString = MainFormationTools.fnCheckChangeID(heroInfo.hid) or nil
    if(pString) then
        ShowNotice.showShellInfo(pString)
        return
    end

    require "script/module/formation/FriendSelectCtrl"
    local changType = 1
    if (heroInfo.location == 6) then
        changType = 3
    else
        changType = 1
    end
    local battleCompanModule = FriendSelectCtrl.create(changType, heroInfo.location , heroInfo.hid)
    if (battleCompanModule) then
        LayerManager.removeLayout()
        LayerManager.addLayoutNoScale(battleCompanModule, LayerManager.getModuleRootLayout())
        UIHelper.changepPaomao(battleCompanModule) -- zhangqi, 2015-05-16, 跑马灯要放在下面层级不档返回按钮
    end
end

-- 加通用的阴影描边
function fnlabelNewStroke( widget )
    UIHelper.labelNewStroke(widget,ccc3(0x92,0x53,0x1b),2)
end


function getAwakes( heroInfo )
    local heroDB = heroInfo.heroDB

    local arrAwakeId = nil
    if heroDB.awake_id then
        arrAwakeId = string.split(heroDB.awake_id, ",")
    end
    local arrGrowAwakeId = nil
    if heroDB.grow_awake_id then
        arrGrowAwakeId = string.split(heroDB.grow_awake_id, ",")
    end
    
    require "db/DB_Awake_ability"
    -- 如果存在天赋ID
    local tAwakes = {}
    if arrAwakeId then
        for i=1, #arrAwakeId do
            tAwakes[#tAwakes+1] = {}
            local awake =  tAwakes[#tAwakes]
            awake.id = arrAwakeId[i]
        end
    end
    if arrGrowAwakeId then
        for i=1, #arrGrowAwakeId do
            tAwakes[#tAwakes+1] = {}
            local awake =  tAwakes[#tAwakes]
            local levelAndId = string.split(arrGrowAwakeId[i], "|")
            local awkae_type = tonumber(levelAndId[1])
            if awkae_type == 1 then
                awake.id = tonumber(levelAndId[3])
                awake.level = tonumber(levelAndId[2])
                awake.evolve_level = 0
            elseif awkae_type == 2 then
                awake.id = tonumber(levelAndId[3])
                awake.evolve_level = tonumber(levelAndId[2])
                awake.level = 0
            end
        end
    end
    return tAwakes
end



