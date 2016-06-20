

-- 删除怒气遮罩
require (BATTLE_CLASS_NAME.class)
local BAForRemoveImageRageMask = class("BAForRemoveImageRageMask",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	------------------ functions -----------------------
 	function BAForRemoveImageRageMask:start()
		 
	
			
		self:complete()
	end

	function BAForRemoveImageRageMask:removeMask( ... )
		
		local layer = BattleLayerManager.battlePlayerLayer 
		if(
			layer and 
			not tolua.isnull(layer) and
			layer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG)
		  ) then
			 
			layer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
		end
	end

	function BAForRemoveImageRageMask:release( ... )
		self:removeMask()
		self.super.release(self)
	end
return BAForRemoveImageRageMask