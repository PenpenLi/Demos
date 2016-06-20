
-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForPreStartEvt = class("BAForPreStartEvt",require(BATTLE_CLASS_NAME.BaseAction))
 	
 	-- 延迟
 	BAForPreStartEvt.startDelay = nil
 	BAForPreStartEvt.timeCost 	   = nil
	------------------ properties ----------------------
	function BAForPreStartEvt:start()
		if(self.startDelay ~= nil and self.startDelay > 0 and self.startDelay < 2) then
			self.timeCost = 0
			self:addToRender()
		else
			self:sendEvt()
		end 
		
	end

	function BAForPreStartEvt:update( dt )
		self.timeCost = self.timeCost + dt
		if(self.timeCost >= self.startDelay) then
			self:sendEvt()
		end
	end
	function BAForPreStartEvt:sendEvt( ... )
		if(self.blackBoard and self.blackBoard.node) then
			EventBus.sendNotification(NotificationNames.EVT_RECORD_PLAY_NEXT_PLAYER_ROUND,self.blackBoard.node)
		end
		self:complete()
	end

	------------------ functions -----------------------
 
return BAForPreStartEvt
