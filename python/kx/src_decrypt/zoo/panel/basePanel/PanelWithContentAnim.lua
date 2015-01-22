--
--
---- Copyright C2009-2013 www.happyelements.com, all rights reserved.
---- Create Date:	2013年10月25日 12:18:27
---- Author:	ZhangWan(diff)
---- Email:	wanwan.zhang@happyelements.com
--
--
--require "zoo.common.PanelContentAnim"
--
-----------------------------------------------------
---------------- PanelWithContentAnim
-----------------------------------------------------
--
--assert(not PanelWithContentAnim)
--assert(BasePanel)
--PanelWithContentAnim = class(BasePanel)
--
--function PanelWithContentAnim:ctor()
--end
--
--function PanelWithContentAnim:init(ui, ...)
--	assert(ui)
--	assert(#{...} == 0)
--
--	-- Init Base
--	self.ui = ui
--	BasePanel.init(self, self.ui)
--
--	self.fadeArea		= self.ui:getChildByName("fadeArea")
--	self.clippingAreaAbove	= self.ui:getChildByName("clippingAreaAbove")
--	self.greenBar		= self.ui:getChildByName("greenBar")
--	self.clippingAreaBelow	= self.ui:getChildByName("clippingAreaBelow")
--	assert(self.fadeArea)
--	assert(self.clippingAreaAbove)
--	assert(self.greenBar)
--	assert(self.clippingAreaBelow)
--
--	self.panelContentAnim	= PanelContentAnim:create(self.fadeArea, self.clippingAreaAbove, self.greenBar, self.clippingAreaBelow)
--end
--
--function PanelWithContentAnim:playShowAnim(finishCallback, ...)
--	assert(finishCallback == false or type(finishCallback) == "function")
--	assert(#{...} == 0)
--
--	self.panelContentAnim:playShowAnim(finishCallback) 
--end
--
--function PanelWithContentAnim:playHideAnim(finishCallback, ...)
--	assert(finishCallback == false or type(finishCallback) == "function")
--	assert(#{...} == 0)
--
--	self.panelContentAnim:playHideAnim(finishCallback)
--end
--
--function PanelWithContentAnim:getPanelContentAnim(...)
--	assert(#{...} == 0)
--
--	--return self.panelContentAnim
--end
