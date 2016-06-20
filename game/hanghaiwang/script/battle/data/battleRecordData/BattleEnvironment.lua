
-- 战斗环境设置 
 	-- 背景,音乐等
 	-- 这个类基本废了,目前后端也没有用这个数据,属于海贼遗留数据
local BattleEnvironment = class("BattleEnvironment")
 
	------------------ properties ----------------------
	

	------------------ functions -----------------------
	function BattleEnvironment:reset(data)
		-- bgId : int			//背景图片ID
		-- musicId : int		//音乐ID
		-- brid : int			//战报ID
		-- url_brid : string	//战斗ID加密编码后端串，用于产生战报url

		self.bgId 			= data.bgId
		self.musicId		= data.musicId
		self.brid 			= data.brid
		self.url_brid 		= data.url_brid
		-- --print("BattleEnvironment:reset->bgId",data.bgId)
		-- --print("BattleEnvironment:reset->musicId",data.musicId)

		self.bgImgURL		= "图片URL"
		self.bgSoundURL		= "音乐URL"
	end

return BattleEnvironment