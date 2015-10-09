-----------
--MusicUtils
-----------
local timer1

MusicUtils = {};

-- 播放
-- url：ID；isLoop：是否循环播放，默认不循环
function MusicUtils:play(musicID,isLoop)
	if not musicID then return;end
	if not GameData.isMusicOn then return end
	-- 如果有开着的音乐 先关掉
	local isRunning = SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()
	if isRunning then
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic();
	end

	local url = "resource/music/"..musicID..".mp3"
	url = fullPath(url,true)

	-- 默认不循环
	if isLoop == nil then
		isLoop = false
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(url, isLoop);
	else
		MusicUtils:playLoop(url)
	end

end

-- url：ID；isLoop：是否循环播放，默认不循环
function MusicUtils:playLoop(url)

	local function localFun()
		local isRunning = SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()
		if isRunning then

		else
			if timer1 then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
				timer1 = nil
			end

			local function localFun1()
				if timer1 then
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
					timer1 = nil
				end
				if GameData.isMusicOn then 
					SimpleAudioEngine:sharedEngine():playBackgroundMusic(url,false);
					timer1 = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 1, false)
				end
			end
			timer1 = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun1, 1, false)
		end
	end

	if timer1 then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
		timer1 = nil
	end

	SimpleAudioEngine:sharedEngine():playBackgroundMusic(url,false);
	timer1 = Director:sharedDirector():getScheduler():scheduleScriptFunc(localFun, 1, false)

end

-- 暂停
function MusicUtils:pause()
	SimpleAudioEngine:sharedEngine():pauseBackgroundMusic();
end

-- 继续
function MusicUtils:resume()
	SimpleAudioEngine:sharedEngine():resumeBackgroundMusic();
end

-- 停止
function MusicUtils:stop(bool)
	if timer1 then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(timer1)
		timer1 = nil
	end	
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(bool);
end

function MusicUtils:preloadEffect(musicID)

	if not GameData.isMusicOn then return end
	local url = "resource/music/"..musicID

	url = fullPath(url,true)
	SimpleAudioEngine:sharedEngine():preloadEffect(url);
end

function MusicUtils:playEffect(musicID,isLoop)
	-- if not GameData.isMusicOn then return end
	-- if GameData.clienttype == "GT-I9100" then return end -- 9100暂时无音效
	
	-- if not musicID then return;end;
	-- -- 默认不循环
	-- self:removeCollectHandle();
	-- local function collectHandle()--防止同一帧播太多音效
	-- 	self:removeCollectHandle();
	-- 	if isLoop == nil then
	-- 		isLoop = false
	-- 	end
	-- 	local url = "resource/music/"..musicID..".mp3"

	-- 	url = fullPath(url,true)
	-- 	return SimpleAudioEngine:sharedEngine():playEffect(url, isLoop);
	-- end
	-- self.collectHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(collectHandle, 0, false)
	if not GameData.isMusicOn then return end
	if GameData.clienttype == "GT-I9100" then return end -- 9100暂时无音效
	
	if not musicID then return;end;
	-- 默认不循环
	if isLoop == nil then
		isLoop = false
	end
	local url = "resource/music/"..musicID..".mp3"
	
	log("playEffect---url--"..url)

	url = fullPath(url,true)

	log("playEffect---fullPath--"..url)

	return SimpleAudioEngine:sharedEngine():playEffect(url, isLoop);
end

function MusicUtils:removeCollectHandle()
	if self.collectHandle then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.collectHandle);
		self.collectHandle = nil;
	end
end

-- 暂停
function MusicUtils:pauseEffect()
	SimpleAudioEngine:sharedEngine():pauseAllEffects();
end

-- 继续
function MusicUtils:resumeEffect()
	SimpleAudioEngine:sharedEngine():resumeAllEffects();
end

-- 停止
function MusicUtils:stopEffect()
	SimpleAudioEngine:sharedEngine():stopAllEffects();
end

-- 清理
function MusicUtils:unloadEffect(musicID)
	if not GameData.isPlaySoundEffect then return end
	local url = "resource/music/"..musicID
	--log("qqqqqqqqqqqqqqqqqqqqqqqqq"..url)
	url = fullPath(url,true)
	SimpleAudioEngine:sharedEngine():unloadEffect(url);
end

-- 视频播放
function MusicUtils:playVideo(videoID,context)

	MusicUtils.contextVideo = context

	if CommonUtils:getCurrentPlatform() == GameConfig.CC_PLATFORM_WIN32 
	or GameData.simulator == "1" 
	then -- pc 和模拟器 跳过视频
		videoComplete()
		return
	end
	
	local videoPath = "resource/image/arts/"..videoID..".mp4"
	videoPath = fullPath(videoPath,true)	
	
	-- MusicUtils:pause() --播放视频前先把音乐暂停

	MusicUtils:stop(true);

	userInfoSaver:playVideo(videoPath);
end

function skipVideo(videoPath)
	-- 点击跳过，直接到创建角色
	videoComplete(videoPath)
	hecDC(3,1)
end

function videoComplete(videoName)
	if MusicUtils.contextVideo then
		MusicUtils:removeTimeOutTimer()
		local function timeOutTimerFun()
			MusicUtils:removeTimeOutTimer()
			if MusicUtils.contextVideo then
				MusicUtils.contextVideo:videoBackFun()
				MusicUtils.contextVideo = nil
			end
		end
		MusicUtils.timeOutTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOutTimerFun, 0.3, false)
	end
	-- MusicUtils:resume()

	if GameData.isMusicOn then
		MusicUtils:play(1,true)
	end	
end

function MusicUtils:removeTimeOutTimer()
    if MusicUtils.timeOutTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(MusicUtils.timeOutTimer)
        MusicUtils.timeOutTimer = nil; 
    end
end

local scheNum = 0;
local musicIDX = 0;
local musicTable = nil;
local const_v = 100/3;
local musicID = 0;

function MusicUtils:onSche()
	scheNum = 1 + scheNum;
	if musicTable[2+musicIDX] then
		if musicTable[1+musicIDX]/const_v <= scheNum then
			scheNum = 0;
			musicIDX = 2 + musicIDX;
			log("----------------------musicTable[musicIDX]---" .. musicTable[musicIDX]);
			musicID = MusicUtils:playEffect(musicTable[musicIDX],false);
		end
	else
		removeSchedule(MusicUtils,MusicUtils.onSche);
	end
end

function MusicUtils:stopEffect4Card()
	if 0 ~= musicID then
		SimpleAudioEngine:sharedEngine():stopEffect(musicID)
	end
	removeSchedule(MusicUtils,MusicUtils.onSche);
	scheNum = 0;
	musicIDX = 0;
	musicTable = nil;
	musicID = 0;
end

function MusicUtils:playEffect4Card(configId)
	MusicUtils:stopEffect4Card();
	local id = analysis("Kapai_Kapaiku",configId,"shuashuai");
	if "" == id then
		return;
	end
	MusicUtils:playEffectByStr(id)
end

function MusicUtils:playEffectByStr(id)

  local idArr = StringUtils:stuff_string_split(id);
  local randomIndex = math.floor(getRadomValue() * table.getn(idArr)) + 1;

  scheNum = 0;
  musicIDX = 1;
  musicTable = idArr[randomIndex];
  print("----------------------id",id)
  print("----------------------musicTable[musicIDX]",musicTable[musicIDX])
  addSchedule(MusicUtils,MusicUtils.onSche);
  log("----------------------id---" .. id);
  log("----------------------musicTable[musicIDX]---" .. musicTable[musicIDX]);
  musicID = MusicUtils:playEffect(musicTable[musicIDX],false);
end

function MusicUtils:playHeroEffect(id)
	MusicUtils:stopEffect4Card();
	MusicUtils:playEffectByStr(id)
end