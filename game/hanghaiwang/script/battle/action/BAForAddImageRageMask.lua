
-- 添加怒气遮罩
require (BATTLE_CLASS_NAME.class)
local BAForAddImageRageMask = class("BAForAddImageRageMask",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForAddImageRageMask.anchorPoint = ccp(0.1,0.1)
	BAForAddImageRageMask.rageMaskName = nil
	------------------ functions -----------------------
 	function BAForAddImageRageMask:start()

 		if(
			BattleLayerManager.battlePlayerLayer and 
			BattleLayerManager.battlePlayerLayer:getChildByTag(BATTLE_CONST.RAGE_MASK_TAG)
		  ) then
			 
			BattleLayerManager.battlePlayerLayer:removeChildByTag(BATTLE_CONST.RAGE_MASK_TAG,true)	
		end
		local sp = nil
		if(self.rageMaskName == nil or file_exists( self.rageMaskName ) == false) then
			sp = CCSprite:create(BATTLE_CONST.RAGE_MASK_URL)
		else
			sp = CCSprite:create(self.rageMaskName)
		end
	
		sp:setTextureRect(CCRectMake(0,0,g_winSize.width * 1.2,g_winSize.height  * 1.2))
		local x = 1
		sp:setAnchorPoint(self.anchorPoint)
		BattleLayerManager.battlePlayerLayer:addChild(sp,200,BATTLE_CONST.RAGE_MASK_TAG)

		self:complete()
	end
return BAForAddImageRageMask