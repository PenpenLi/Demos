
require (BATTLE_CLASS_NAME.class)
local BSTree = class("BSTree",require(BATTLE_CLASS_NAME.BSNode))
 
	------------------ properties ----------------------
	function BSTree:travel()
		-- --print(self.treeName,"->traveled",self.name)
		--  local result 									= self:travelSelf()
		--  if result == true then
		--  	return self:travelChildren()
		--  end
		--  return false
	end




	function BSTree:init(data)
		-- --print("BSNode:init->",data.des)
		-- self.data										= data
		-- self:generateChildrenNode()
		-- 
	end

	------------------ functions -----------------------

return BSTree

