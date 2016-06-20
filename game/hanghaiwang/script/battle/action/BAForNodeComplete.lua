
-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForNodeComplete = class("BAForNodeComplete",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	function BAForNodeComplete:start()
		if(self.blackBoard ~= nil and self.blackBoard.treeComplete ~= nil) then 
			-- --print("BAForNodeComplete:start:",self.des)
			self.blackBoard.treeComplete(target,data)
			-- self.blackBoard.treeComplete = nil
			--self:complete()
			-- self:release()
		end
	end

	------------------ functions -----------------------
		-- 释放函数
	function BAForNodeComplete:release(data)
		if(self.calllerBacker ~= nil ) then 
			self.calllerBacker:clearAll()
		end

		self.blackBoard = nil
	end
return BAForNodeComplete
 