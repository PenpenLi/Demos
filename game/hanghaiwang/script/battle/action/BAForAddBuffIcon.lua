



-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForAddBuffIcon = class("BAForAddBuffIcon",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	function BAForAddBuffIcon:start()
		if(self.blackBoard.heroUI ~= nil and self.blackBoard.iconName ~= nil) then 
			--print("BAForAddBuffIcon:start iconName:",self.blackBoard.iconName)
			self.blackBoard.heroUI:addBuffUI(self.blackBoard.iconName,self.blackBoard.addPostion)
			self.blackBoard.target:addBuff(self.blackBoard.bufffId)
			-- self.blackBoard.target:addBuff(self.blackBoard.bufffId)
		end
		self:complete()
	end

	------------------ functions -----------------------
 
return BAForAddBuffIcon