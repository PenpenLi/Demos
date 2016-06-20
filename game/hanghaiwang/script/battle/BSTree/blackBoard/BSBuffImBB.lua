-- buff免疫
require (BATTLE_CLASS_NAME.class)
local BSBuffImBB = class("BSBuffImBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
 		BSBuffImBB.addEffectName 				= nil 	-- buff添加特效
 		BSBuffImBB.hasAddEff 					= false -- 有添加特效
 		BSBuffImBB.buffid 						= nil 	-- buffid
 		BSBuffImBB.imEffectName 				= nil 	-- 免疫特效名字
 		BSBuffImBB.des							= "BSBuffImBB"
 		------------------ functions -----------------------
 		
		function BSBuffImBB:reset( buffid , targetId )

			-- EFFECT_IMMUNITY
			self.bufffId 				= buffid						-- buff数据 		外部数据
			self.targetid 				= targetId
			--print("BSBuffImBB:reset:",buffid)
			local target 				= BattleMainData.fightRecord:getTargetData(targetId)
			self.targetUI 				= target.displayData 					 -- 目标
 
			-- 有添加特效
			local addEffectName 		= db_buff_util.getAddEffectName(buffid)
			self.addEffectName 			= addEffectName 				-- 添加特效 		来自buffid 			
			 --print("BSBuffImBB get addbuff effect:",self.addEffectName)
		 	self.addPostion 			= db_buff_util.getAddPostion(buffid) 				-- buff图标挂点 	来自buffid
			--print("BSBuffImBB get buff add postion:",self.addPostion)
 			-- 是否需要添加icon 1.有图标 2.buff的count == 1
		 	-- 有添加特效
		 	self.hasAddBuffEff 			= self.addEffectName ~= nil 						-- 是否有添加buff特效	
			self.imEffectName			= BATTLE_CONST.IMMUNITY_IMG_TEXT
		 
		end

return BSBuffImBB