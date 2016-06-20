
-- 添加怒气遮罩
require (BATTLE_CLASS_NAME.class)
local BAForAddRageMask = class("BAForAddRageMask",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	
	------------------ functions -----------------------
 	function BAForAddRageMask:start()

 		if(
			BattleLayerManager.battlePlayerLayer and 
			BattleLayerManager.battlePlayerLayer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG)
		  ) then
			 
			BattleLayerManager.battlePlayerLayer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
		end
		
		local sp = CCSprite:create(BATTLE_CONST.RAGE_MASK_URL)
		sp:setTextureRect(CCRectMake(0,0,g_winSize.width,g_winSize.height))
		sp:setAnchorPoint(CCP_ZERO)
		BattleLayerManager.battlePlayerLayer:addChild(sp,200,BATTLE_CONST.RAGE_MASK_TAG)

		self:complete()
	end
return BAForAddRageMask