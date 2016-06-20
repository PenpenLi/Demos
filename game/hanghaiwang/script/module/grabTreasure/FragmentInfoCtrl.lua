-- FileName: FragmentInfoCtrl.lua
-- Author: menghao
-- Date: 2014-5-13
-- Purpose: 碎片信息ctrl


module("FragmentInfoCtrl", package.seeall)


require "script/module/grabTreasure/FragmentInfoView"


-- UI控件引用变量 --


-- 模块局部变量 --


local function init(...)

end


function destroy(...)
	package.loaded["FragmentInfoCtrl"] = nil
end


function moduleName()
	return "FragmentInfoCtrl"
end


function create(iData)
	local tbInfo = {}

	tbInfo.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()

			LayerManager.removeLayout()
		end
	end

	tbInfo.onSure = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			LayerManager.removeLayout()
		end
	end

	tbInfo.id = iData.id
	tbInfo.quality = iData.quality
	tbInfo.fragmentName = string.gsub(iData.name, gi18n[2448], "") 	-- 把碎片干掉

	tbInfo.fragmentIntroduce = iData.info
	tbInfo.numHave = iData.numHas
	tbInfo.numNeed = iData.numNeed
	tbInfo.imgBg = iData.bgFullPath
	tbInfo.imgIcon = iData.imgFullPath

	local layMain = FragmentInfoView.create(tbInfo)
	return layMain
end

