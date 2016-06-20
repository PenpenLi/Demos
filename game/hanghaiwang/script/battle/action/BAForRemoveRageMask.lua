

-- 删除怒气遮罩
require (BATTLE_CLASS_NAME.class)
local BAForRemoveRageMask = class("BAForRemoveRageMask",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	------------------ functions -----------------------
 	function BAForRemoveRageMask:start()
		 
	
			
		self:complete()
	end

	function BAForRemoveRageMask:removeMask( ... )
		
		local layer = BattleLayerManager.battlePlayerLayer 
		if(
			layer and 
			not tolua.isnull(layer) and
			layer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG)
		  ) then
			 
			layer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
		end
	end

	function BAForRemoveRageMask:release( ... )
		self:removeMask()
		self.super.release(self)
	end
return BAForRemoveRageMask