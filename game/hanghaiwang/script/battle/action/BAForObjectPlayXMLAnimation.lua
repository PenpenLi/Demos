
--指定人物播放xml动画
 
require (BATTLE_CLASS_NAME.class)
local BAForObjectPlayXMLAnimation = class("BAForObjectPlayXMLAnimation",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
	BAForObjectPlayXMLAnimation.heroUI 					= nil
	BAForObjectPlayXMLAnimation.animationName 			= nil
	BAForObjectPlayXMLAnimation.resumeState 			= true
	-- BAForObjectPlayXMLAnimation.beforeState 			= nil
	------------------ functions -----------------------
	function BAForObjectPlayXMLAnimation:start(data)

		-- print("------------------------ BAForObjectPlayXMLAnimation:",self.animationName)
		if self.heroUI ~= nil and self.animationName then
				-- 获取动画名称容器，然后播放
 			-- self.beforeState = {}
 			-- self.beforeState = self.heroUI:getDisplayState()
			-- local this = self
			--self:addToRender()
 			-- Logger.debug(self.heroUI.data.htid .. " player runaction:"..self.animationName)
 			local  callPacker = function() 
 				self:onAnimationComplete()
 			end  
	        self.heroUI:playXMLAnimationWithCallBack(self.animationName,self,callPacker)
	        self:addToRender()

		else
			--print("BAForObjectPlayXMLAnimation heroUI or animationName is nil ,")
			self:complete()
		end -- if end
	end -- function end

	function BAForObjectPlayXMLAnimation:onAnimationComplete()
		-- print("------------------------ BAForObjectPlayXMLAnimation complete:",self.animationName)
		if(self.disposed ~= true) then
		-- 	self.disposed											= true
			-- Logger.debug(self.heroUI.data.htid .. " player runaction:"..self.animationName .. " complete")
			if(self.resumeState and self.heroUI) then
				self.heroUI:toStandState()
				self.heroUI:playXMLAnimation("A009")
			end

			self:complete()
		end
		
	end

	function BAForObjectPlayXMLAnimation:release()
		-- print("------------------------ BAForObjectPlayXMLAnimation release:",tostring(self.animationName))
		-- if(self.disposed ~= true and self.animationName and self.heroUI ) then
		-- 	Logger.debug(self.heroUI.data.htid .. " BAForObjectPlayXMLAnimation release:"..self.animationName)
		-- end
		if(self.resumeState and self.heroUI) then
				self.heroUI:toStandState()
				self.heroUI:playXMLAnimation("A009")
		end

		self.super.release(self)
		-- self.calllerBacker:clearAll()
		-- self.disposed											= true
		self.blockBoard											= nil
		self.container 											= nil
		self.animationName 										= nil
	end
return BAForObjectPlayXMLAnimation