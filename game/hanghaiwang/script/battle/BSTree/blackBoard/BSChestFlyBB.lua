

-- buff删除
require (BATTLE_CLASS_NAME.class)
local BSChestFlyBB = class("BSChestFlyBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 
	------------------ properties ----------------------
	BSChestFlyBB.target				= nil			-- 目标ui实例
	BSChestFlyBB.chestDataes 		= nil			-- 宝箱数据
	BSChestFlyBB.hasItemDrop 		= false			-- 是否有物品掉落
	BSChestFlyBB.uiPosition			= nil			-- ui飞向的图标位置
	------------------ functions -----------------------
	function BSChestFlyBB:reset( data , id)
		
	end

return BSChestFlyBB
