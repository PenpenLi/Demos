-- FileName: MineGrabGuard.lua
-- Author: huxiaozhou
-- Date: 2015-06-04
-- Purpose: 抢夺协助军界面
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /



MineGrabGuard = class("MineGrabGuard")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

function MineGrabGuard:ctor()
	self.layMain = g_fnLoadUI("ui/resource_grab.json")
end

function MineGrabGuard.create(tbArgs)
	local view = MineGrabGuard.new()
	view.tbArgs = tbArgs

	local layMain = view.layMain
	-- view.labTitle = layMain.TFD_TITLE
	-- view.labTitle:setText(m_i18n[5652])
	view.btnClose = layMain.BTN_CLOSE
	view.btnClose:addTouchEventListener(UIHelper.onClose)
	view.labDesc = layMain.tfd_desc
	view.labDesc:setText(m_i18n[5614])
	local tbLayName = {"LAY_GRAB_1", "LAY_GRAB_2", "LAY_GRAB_3"}
	local arrGuard = tbArgs.arrGuard
	local count = table.count(arrGuard)
	for i,v in ipairs(tbLayName) do
		local layout = m_fnGetWidget(layMain, v)
		if i > count then
			layout:removeFromParent()
		else
			logger:debug({arrGuard = arrGuard})
			local tGuard = arrGuard[i]
			local labName = layout.TFD_NAME
			labName:setText(tGuard.uname)
			labName:setColor(UserModel.getPotentialColor({htid = tGuard.figure})) -- 2015-07-29
			local labLvl = layout.TFD_LV
			labLvl:setText("Lv." .. tGuard.level)
			local imgIcon = layout.IMG_ICON
			local icon = HeroUtil.createHeroIconBtnByHtid(tGuard.figure, nil, function ( sender, eventType)
				tbArgs.fnRobGuard(tGuard.uid)
			end)
			imgIcon:addChild(icon)

		end
	end

	return view
end