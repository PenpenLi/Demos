





-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForRemoveBuffIcon = class("BAForRemoveBuffIcon",require(BATTLE_CLASS_NAME.BaseAction))
 	
	------------------ properties ----------------------
	BAForRemoveBuffIcon.heroUI						= nil
	BAForRemoveBuffIcon.iconName					= nil
	BAForRemoveBuffIcon.addPostion 					= nil
	BAForRemoveBuffIcon.target						= nil
	BAForRemoveBuffIcon.buffid						= nil
	------------------ functions -----------------------
 	function BAForRemoveBuffIcon:start()
		if(self.heroUI ~= nil and self.iconName ~= nil and self.target ~= nil) then 
			print("BAForRemoveBuffIcon:start iconName:",self.iconName," buffid:",self.buffid)
			self.target:removeBuff(tonumber(self.buffid))
			-- local buffCount 		= self.target:getBuffCount(tonumber(self.buffid))
			-- if(buffCount == nil or buffCount<= 0) then
			-- 	self.heroUI:removeBuffUI(self.iconName)
			-- end
		end
		self:complete()
	end
return BAForRemoveBuffIcon

