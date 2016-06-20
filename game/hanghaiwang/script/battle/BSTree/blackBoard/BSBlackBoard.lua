-- buffHurtLogic中buff伤害的
require (BATTLE_CLASS_NAME.class)
local BSBlackBoard = class("BSBlackBoard")
	 	BSBlackBoard.id 				= 1
		------------------ properties ----------------------
		-- 有的时候有多个同属性伤害,需要从新刷新黑板数据 才能保证数据正确(例如同时2个buff伤害正好导致死亡,但是blackboard在一开始就根据人物当前血量计算,所有会出现人物预判死亡错误)
		function BSBlackBoard:refresh( ... )
		 			
		end 		

 		function BSBlackBoard:reset(data)
 		
 		end
		

		function BSBlackBoard:ctor( ... )
			ObjectTool.setProperties(self)
		end

		------------------ functions -----------------------
		
return BSBlackBoard