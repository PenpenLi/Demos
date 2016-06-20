
 -- 战斗变换声音
local BAForChangeMusic = class("BAForChangeMusic",require(BATTLE_CLASS_NAME.BaseAction))

	------------------ properties ----------------------
	BAForChangeMusic.data 			 = nil	-- 外部指定数据

	------------------ functions -----------------------

	function BAForChangeMusic:start(...)

		if(self.data) then
	 		EventBus.sendNotification(NotificationNames.EVT_REQUEST_CHANGE_MUSIC_DIRECT,self.data)
	 		if(self.data and self.data ~= "" and self.data[1]) then
				local musicURL = BattleURLManager.getBGMusicURL(self.data[1])
				if(not file_exists( musicURL )) then
		        else

			        require "script/module/config/AudioHelper"
			        AudioHelper.playMusic(musicURL)
		        end
			end

		-- else
			
		end
		self:complete()
	end

return BAForChangeMusic