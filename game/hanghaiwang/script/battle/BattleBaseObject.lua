require(BATTLE_CLASS_NAME.class)
local BattleBaseObject = class("BattleBaseObject")
 
	------------------ properties ----------------------
	BattleBaseObject.__instanceName					= nil -- 实例
	------------------ functions -----------------------

	function BattleBaseObject:ctor()
		self.__instanceName = BattleFactory.getInstaceName()
		----print("BattleBaseObject:ctor() ->",__instanceName)
	end

	function BattleBaseObject:instanceName()
	 	return self.__instanceName
	end

return BattleBaseObject
