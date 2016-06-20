-- FileName: SkyPieaChooseCtrl.lua
-- Author: menghao
-- Date: 2015-1-14
-- Purpose: 空岛选择对手ctrl


module("SkyPieaChooseCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBattle/SkyPieaChooseView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaChooseCtrl"] = nil
end


function moduleName()
	return "SkyPieaChooseCtrl"
end


function onBack( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playCloseEffect()
		MainSkyPieaView.backLufei()
		LayerManager.removeLayout()
	end
end

--查看阵容
function onTabInfo( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("onTabInfo click")
		AudioHelper.playTabEffect()
		SkyPieaChooseView.showPlayerInfoUI(false)
	end
end

--查看玩家信息
function onTabPlay( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		logger:debug("onTabPlayer click")
		AudioHelper.playTabEffect()
		SkyPieaChooseView.showPlayerInfoUI(true)
	end
end


function create(...)
	logger:debug(SkyPieaModel.getIsAllDead())
	if (SkyPieaModel.getIsAllDead()) then
		ShowNotice.showShellInfo(gi18n[5440])
		return
	end

	if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
		return
	end

	local tbEvents = { onBack = onBack, onTabPlay = onTabPlay ,onTabInfo = onTabInfo}

	local args = Network.argsHandler(SkyPieaModel.getCurFloor())
	RequestCenter.skyPieaGetOpponentList(function ( cbFlag, dictData, bRet )
		if (dictData.err ~= "ok") then
			ShowNotice.showShellInfo(dictData.err)
			return
		end
		logger:debug("对手信息")
		logger:debug(dictData.ret)

		local layMain = SkyPieaChooseView.create(tbEvents, dictData.ret)
		LayerManager.lockOpacity(layMain)
		LayerManager.addLayoutNoScale(layMain)
	end, args)
end

