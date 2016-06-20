

module("db_normal_config_util",package.seeall)
	

	require "db/DB_Normal_config"
	
	local config = nil

	--通过id来检索
	function getConfig()
		
		if(config == nil ) then
			config = DB_Normal_config.getDataById(1)
		end 

		return config
	end

-- 获取工会战最大回合数
	function getBellyCopyBattleMaxRound()
		
		getConfig()

		if(config) then
			
			Logger.debug("DB_Normal_config belly_copy_round:" .. tostring(config.belly_copy_round))
		
			return tonumber(config.belly_copy_round)
		end
		return 5
	end

	-- 获取工会战最大回合数
	function getGuideCopyBattleMaxRound()
		
		getConfig()

		if(config) then
			
			Logger.debug("DB_Normal_config lcopy_round:" .. tostring(config.lcopy_round))
		
			return tonumber(config.lcopy_round)
		end
		return 10
	end

 