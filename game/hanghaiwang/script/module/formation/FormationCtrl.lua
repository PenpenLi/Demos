-- FileName: FormationCtrl.lua 
-- Author: zhaoqiangjun 
-- Date: 14-3-29 
-- Purpose: function description of module 


module("FormationCtrl", package.seeall)

local heroId
local _isShowPvpBtn = false

local function solveOtherUserData( cbFlag, dictData, bRet )
	if bRet then
        local externHeroInfo = dictData.ret[heroId ..""]
        logger:debug("wm----user_getBattleDataOfUsers : ")
        logger:debug(externHeroInfo)
		require "script/module/formation/MainFormation"
        -- 设置对方的羁绊开始状态
        BondData.setOtherData(externHeroInfo.union)
		local formationLayer = MainFormation.createWithOtherUserInfo(heroId, externHeroInfo, _isShowPvpBtn)
		-- LayerManager.addLayout(formationLayer)
    end
end

-- @param uid 玩家id
-- @param isShowPvpBtn 是否显示切磋按钮
function loadFormationWithUid( uid, isShowPvpBtn )

    local args      = CCArray:create()
    args:addObject(CCInteger:create(uid))
    local args2     =CCArray:create()
    args2:addObject(args)
    RequestCenter.user_getBattleDataOfUsers(solveOtherUserData ,args2)

    heroId 			= uid
    _isShowPvpBtn   = false
    -- 查看自己不显示
    if (isShowPvpBtn and UserModel.getUserUid() ~= tonumber(uid)) then
        _isShowPvpBtn   = isShowPvpBtn
    end
end


function loadDiffServerFormation(dictData)
    _isShowPvpBtn   = false

        require "script/module/formation/MainFormation"
        -- 设置对方的羁绊开始状态
        BondData.setOtherData(dictData.union)
        local formationLayer = MainFormation.createWithOtherUserInfo(nil, dictData, _isShowPvpBtn)

    logger:debug({loadDiffServerFormation = dictData})
    -- solveOtherUserData(nil ,dictData, true)
end