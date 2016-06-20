-- FileName: CannonStrenCtrl.lua
-- Author: sunyunpeng
-- Date: 2016-02-04
-- Purpose: function description of module
--[[TODO List]]

module("CannonStrenCtrl", package.seeall)
local m_i18n = gi18n
local m_i18nString = gi18nString

-- UI控件引用变量 --

-- 模块局部变量 --
local TAGTB = {}
local MES = {}
local _cannonDB
local _cannonCacheInfo
local _cannonBallAttr
local _cannonId
local _cannonIndex
local _cannnonLimitLel

local function init(...)
	TAGTB = {
		CANNONDB = 1,           -- 炮的DB
		CANNONDATACACHE = 2,    -- 炮的缓存
		CANNONBALLATTR = 3,     -- 炮弹的属性
		COSTINFO = 4,           -- 炮升级需呀的材料
		CANNONBALLDB = 5,       -- 炮蛋DB
	}
	MES = {
		STREN_OK = "STRENOK"
	}
end

function destroy(...)
	package.loaded["CannonStrenCtrl"] = nil
end

function moduleName()
    return "CannonStrenCtrl"
end

-- 关闭按钮
function onColse( ... )
	LayerManager.removeLayout()
end


-- 背包回调
local function afterBagRefresh( ... )
	resetCannnonData()
	CannonStrenView.resetView()

	GlobalNotify.postNotify("strenOberver",_cannonIndex,_cannonId)

	-- ArmShipCtrl.resetCannonView(_cannonIndex,_cannonId)
	-- 播放特效
	CannonStrenView.creatStrenOkAnimate()
	-- 设置触摸
	-- CannonStrenView.setBtnCanTouch(true)
end 


-- 强化回调
local function fnHandlerOfNetwork( cbFlag, dictData, bRet )

	logger:debug("fnHandlerOfNetwork")
	logger:debug(cbFlag)
	logger:debug(dictData)
	logger:debug(bRet)

    if not bRet then
        logger:debug("进阶失败")
        -- 移除屏蔽层
        LayerManager.removeLayout()
        return
    end 

    local curCAnnonLel = _cannonCacheInfo and tonumber(_cannonCacheInfo[1]) or 0
	CannonModel.setCannonReinforceLevelBy(_cannonId,curCAnnonLel + 1)

	UserModel.setInfoChanged(true) -- zhangqi, 标记需要刷新战斗力
	CannonModel.setFightValue()
    UserModel.updateFightValueByValue()
    local needBeili = _costInfo.costBeili
    UserModel.addSilverNumber(-tonumber(needBeili))


    MainFormationTools.removeFlyText()
	MainFormationTools.fnShowFightForceChangeAni()
end 

-- 强化按钮
function onBtnStren( ... )

	-- if (1) then
	-- 	afterBagRefresh()
	-- 	return
	-- end
	-- 材料是否够用
	local costNormal = _costInfo.costNormal
	for i=1,#costNormal do
		local tempCostNormal = costNormal[i]
		if (tonumber(tempCostNormal.haveNum) < tonumber(tempCostNormal.needNum)) then
			local dropcallfn = function ( ... )
				logger:debug(" CannonStrenCtrl refrshConsumInfo")
				initCannonData()
				CannonStrenView.refrshConsumInfo()
			end
			PublicInfoCtrl.createItemDropInfoViewByTid(tempCostNormal.tid,dropcallfn,true)  -- cailiao掉落

	        ShowNotice.showShellInfo(m_i18n[6938])
			return
		end
	end

	-- 判断贝里数量是否足够
    require "script/model/user/UserModel"
    local nUserSilver = UserModel.getSilverNumber()
    local needBeili = _costInfo.costBeili

    if tonumber(nUserSilver) < tonumber(needBeili) then
        PublicInfoCtrl.createItemDropInfoViewByTid(60406,nil,true)  -- 贝里不足引导界面
        ShowNotice.showShellInfo(m_i18n[1057])
        return
    end

    -- 判断强化等级是否已达上限

    if (tonumber(_cannonCacheInfo[1]) >= tonumber(_cannnonLimitLel)) then
        ShowNotice.showShellInfo(m_i18n[1620])
        return
	end
	-- 设置触摸
	CannonStrenView.setBtnCanTouch(false)

    local args = CCArray:create()
    args:addObject(CCInteger:create(_cannonId))
    args:addObject(CCInteger:create(1))

    RequestCenter.mainship_strengthenCannon(fnHandlerOfNetwork,args)
    PreRequest.setBagDataChangedDelete(afterBagRefresh) -- 注册后端推送背包信息时的回调，以便刷新道具和宝物列表，人物属性，红色圆圈提示等（做不需要立刻变的）
    -- 向后端发送数据
	
end

-- 根据tag获取强化数据
function getDataByTag( TAG )
	if (TAG == 1) then
		return _cannonDB
	elseif (TAG == 2) then
		return _cannonCacheInfo
	elseif (TAG == 3) then
		return _cannonBallAttr
	elseif (TAG == 4) then
		return _costInfo
	elseif (TAG == 5) then
		return _cannonBallDB
	end	
end

--  重置强化所需的数据
function resetCannnonData( ... )
	_cannonCacheInfo = CannonModel.getCannonInfoById(_cannonId)

	local _cannonBallId = _cannonCacheInfo[2]
	if (_cannonBallId and tonumber(_cannonBallId)~= 0) then
		_cannonBallAttr = ArmShipData.getCannonBallAttrByLel(_cannonBallId,_cannonCacheInfo[1] or 0)
	end
	_costInfo =  ArmShipData.getCostInfoByTidAndLel(_cannonDB,_cannonCacheInfo and _cannonCacheInfo[1] or 0)

 end 

-- 初始化强化所需的数据
function initCannonData( ... )
	_cannonBallDB = nil
	_cannonBallAttr = {}
	_costInfo = {}

	_cannonDB = DB_Ship_cannon.getDataById(_cannonId)
	_cannonCacheInfo = CannonModel.getCannonInfoById(_cannonId)

	local _cannonBallId = _cannonCacheInfo[2]

	if (_cannonBallId and tonumber(_cannonBallId)~= 0) then
		logger:debug({initCannonData = _cannonBallId})

		_cannonBallDB = DB_Ship_skill.getDataById(_cannonBallId)
		_cannonBallAttr = ArmShipData.getCannonBallAttrByLel(_cannonBallId,_cannonCacheInfo[1] or 0)

		logger:debug({_cannonBallAttr = _cannonBallAttr})
		
	end

	_costInfo =  ArmShipData.getCostInfoByTidAndLel(_cannonDB,_cannonCacheInfo and _cannonCacheInfo[1] or 0)
	_cannnonLimitLel = math.floor(_cannonDB.lv_limit_factor * UserModel.getHeroLevel() / 100)


end
-------------------------------------------------------  通知 ---------------------------------------------
----------------------------------------------------------------------------------------------------------
-- 断线重连
local function offlineObserver( ... )
	-- 设置背包数据
    RequestCenter.bag_bagInfo(function (  cbFlag, dictData, bRet  )
                    			PreRequest.preBagInfoCallback(cbFlag, dictData, bRet)
                          end)
    -- 刷新界面
    afterBagRefresh()
end

function addAllObserver( ... )
	GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
                offlineObserver()
            end, nil, moduleName() .. "_RemoveUILoading")

end

function removeAllObserver( ... )
	PreRequest.removeBagDataChangedDelete()
    GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, moduleName() .. "_RemoveUILoading")
	-- body
end


function create(cannonId,cannonIndex)
	_cannonId = cannonId
	_cannonIndex = cannonIndex

	init()
	initCannonData()
	local cannonStrenView = CannonStrenView.create()
	LayerManager.addLayout(cannonStrenView)
end
