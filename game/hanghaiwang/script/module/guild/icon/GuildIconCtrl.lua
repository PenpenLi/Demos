-- FileName: GuildIconCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-03-31
-- Purpose:联盟模块新增联盟Icon
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuildIconCtrl", package.seeall)
require "script/module/guild/icon/GuildIconView"
-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["GuildIconCtrl"] = nil
end

function moduleName()
    return "GuildIconCtrl"
end


function create(fnDelegate)
	local tbEvent = {}
	tbEvent.onIcon = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if fnDelegate then
				fnDelegate(sender:getTag())
				GuildDataModel.setGuildIconId(sender:getTag())
				LayerManager.removeLayout()
			end
		end
	end

	tbEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			LayerManager.removeLayout()
		end
	end
	local view = GuildIconView.create(tbEvent)
	LayerManager.addLayout(view)
end
