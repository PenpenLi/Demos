
-- buff删除
require (BATTLE_CLASS_NAME.class)
local BSBuffDeleteBB = class("BSBuffDeleteBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
 		BSBuffDeleteBB.deleteEffectName 			= nil 		-- 删除buff特效
 		BSBuffDeleteBB.iconName 					= nil 		-- buff图标删除名字
 		BSBuffDeleteBB.hasDelEff					= false 	-- 有buff删除特效
 		BSBuffDeleteBB.needDelIcon 					= false 	-- 需要删除buff布标
 		BSBuffDeleteBB.targetUI 					= nil 		-- 目标
 		BSBuffDeleteBB.des							= "BSBuffDeleteBB"
 		BSBuffDeleteBB.targetId 					= nil
 		------------------ functions -----------------------
 		
		function BSBuffDeleteBB:reset( buffid,targetId )
			assert(targetId)
			--print("BSBuffDeleteBB:reset:",targetId)
			self.bufffId 			= buffid												-- buff数据 		外部数据
			self.targetId 			= targetId

			local target 			= BattleMainData.fightRecord:getTargetData(targetId)
			self.targetUI 			= target.displayData 					 			-- 目标
			self.target 			= target
			-- 有添加特效
			local deleteEffectName 	= db_buff_util.getRemoveEffectName(buffid)
			self.deleteEffectName 	= deleteEffectName 				-- 添加特效 		来自buffid 			
 			--print("BSBuffDeleteBB:deleteEffectName:",self.deleteEffectName)
 			self.iconName			= db_buff_util.getIcon(buffid)	 -- 来自buffid			-- buff图标名	

		 	-- 有添加icon(因为icon可能会被重复添加,所以需要检测是否需要显示类)
		 	local buffCount 		= target:getBuffCount(buffid)
		 	self.needDelIcon  		= self.iconName ~= nil-- and buffCount == 0				-- 是否需要添加icon 1.有图标 2.buff的count == 1
		 	--print("BSBuffDeleteBB:needDelIcon:",self.needDelIcon)
		 	-- 有添加特效
		 	self.hasDelEff 			= self.deleteEffectName ~= nil 						-- 是否有添加buff特效	
			
		end
		
return BSBuffDeleteBB