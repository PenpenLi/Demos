-- FileName: MysRecruitCtrl.lua
-- Author: menghao
-- Date: 2015-05-09
-- Purpose: 神秘招募ctrl


module("MysRecruitCtrl", package.seeall)


require "script/module/shop/MysRecruitView"


-- UI控件引用变量 --


-- 模块局部变量 --
local m_callBack 

local function init(...)

end

local T_TAG_PRO_ANI = 98765


function removeProAni(aniParent)
	aniParent:removeNodeByTag(T_TAG_PRO_ANI)
end

function addProAni(aniParent,_percent)
	removeProAni(aniParent)
	if(_percent == 100 )then
		local armatureZhaomu1 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhaomu_pro.ExportJson",
			animationName = "zhaomu_pro_1",
			loop = 0,
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 1) then
						sender:getAnimation():play("zhaomu_pro_2", -1, -1, -1)
				end
			end,
		})
		local  proSize =aniParent:getSize()
		aniParent:addNode(armatureZhaomu1,0,T_TAG_PRO_ANI)
	end
end


function destroy(...)
	package.loaded["MysRecruitCtrl"] = nil
end


function moduleName()
	return "MysRecruitCtrl"
end

-- 神秘招募招募网络请求后
function mysteryRecruitCallback( cbFlag, dictData, bRet )
	LayerManager:begainRemoveUILoading()
	if(dictData.err == "ok")then
		local shopInfo = DataCache.getShopCache()
		if( tonumber(shopInfo.mySteryFreeNum) > 0 )then
			DataCache.addMysteryFreeNum(-1)
		else
			local nCost = DB_Tavern_mystery.getDataById(1).cost
			UserModel.addGoldNumber(-nCost)
		end
		local preLuckPoint = tonumber(shopInfo.mystery_recruit_point)
		local bRreshShopRed = nil
		if(m_callBack) then
			bRreshShopRed = false
		end

		RecruitService.resetShopInfo(function (  )
			LayerManager.removeLayout()
			TenHeroRecruit.setAllHeroes(dictData.ret)
			TenHeroRecruit.setPreLuckPoint(preLuckPoint)
			TenHeroRecruit.create(6,m_callBack)
		end , bRreshShopRed)
		-- logger:debug(dictData.ret[7].mystery_recruit_point)
		-- logger:debug(dictData.ret[7])
		-- shopInfo.mystery_recruit_point = dictData.ret[7].mystery_recruit_point
		-- logger:debug(shopInfo)
	end
end

function onRecruit( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCommonEffect()
		-- TenHeroRecruit.stopAllAction()
		local shopInfo = DataCache.getShopCache()
		if (tonumber(shopInfo.mySteryFreeNum) > 0) then
			AudioHelper.playCommonEffect()
			LayerManager:addUILoading()
			RequestCenter.shop_mysteryRecruit(mysteryRecruitCallback)
			sender:setTouchEnabled(false)
		else
			require "db/DB_Tavern_mystery"
			local nCost = DB_Tavern_mystery.getDataById(1).cost
			if (UserModel.getGoldNumber() >= nCost) then
				AudioHelper.playBuyGoods()
				RequestCenter.shop_mysteryRecruit(mysteryRecruitCallback)
				sender:setTouchEnabled(false)
			else
				AudioHelper.playCommonEffect()
				local layDlg = UIHelper.createNoGoldAlertDlg()
				LayerManager.addLayout(layDlg)
			end
		end
	end
end



function create(mysRecruitInfo,fnCallBack)
	local tbEvents = {onRecruit = onRecruit}
	m_callBack = fnCallBack
	
	tbEvents.onBack = function ( sender, eventType )
	logger:debug("tbEvents.onBack")
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvents.onBack")
			AudioHelper.playBackEffect()
			LayerManager.removeLayout()
			if(fnCallBack) then
				fnCallBack()
			end
		end
	end

	local layMain = MysRecruitView.create(mysRecruitInfo, tbEvents)

    LayerManager.setPaomadeng(layMain, 10)
    -- UIHelper.registExitAndEnterCall(layMain, function ( ... )
    --     LayerManager.resetPaomadeng()
    --     layMain = nil
    -- end)

	LayerManager.addLayoutNoScale(layMain)
end

