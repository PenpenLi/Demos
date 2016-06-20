module("BattleFactory",package.seeall)

 
	------------------ properties ----------------------
	local count 									= 0
	local idMax 									= 18014398509481984 -- 2^54
	------------------ functions -----------------------
	-- 获取类实例
	-- 以后可以做一个 弱引用的缓存，用于检测内存泄露
	function getClsIns(clsName)
		return require(clsName).new()
	end

	function getInstaceName()
		count 						= count + 1
		if count >= idMax then 
			count = 0
		end -- if end
		return "a" .. count--.."_"..os.time()
	end