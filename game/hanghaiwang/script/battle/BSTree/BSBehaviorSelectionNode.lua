






-- 行为选择树节点

require (BATTLE_CLASS_NAME.class)
local BSBehaviorSelectionNode = class("BSBehaviorSelectionNode",require(BATTLE_CLASS_NAME.BSNode))

  
	------------------ properties ----------------------
  

	------------------ functions -----------------------
	function BSBehaviorSelectionNode:travel()
		--
	end


	function BSBehaviorSelectionNode:init(data)
		-- --print("BSNode:init->",data.des)
		self.data										= data
		self:generateChildrenNode()
	end


return BSBehaviorSelectionNode