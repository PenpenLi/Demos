require "core.display.Scene"

--
-- Director ---------------------------------------------------------
--

-- initialize
local instance = nil;
local globalUpdateID = -1;
local sceneStack={};
Director = {resourceAnimationFPS = 30, gameFPS = 60, __runningScene = nil};

local function onUpdateGlobal(dt)
    local runningScene = Director.__runningScene;
    if runningScene then runningScene:onUpdate(dt) end;
end

function Director.sharedDirector()
	if not instance then
		instance = Director;
		
		--update
		if globalUpdateID > -1 then
		    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(globalUpdateID);
		end
		globalUpdateID = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onUpdateGlobal,0,false);
	end
	return instance;
end

--
-- public props -------------------
--

function Director:getAnimationInterval() return CCDirector:sharedDirector():getAnimationInterval() end;
function Director:isDisplayStats() return CCDirector:sharedDirector():isDisplayStats() end;
function Director:setDisplayStats(v) CCDirector:sharedDirector():setDisplayStats(v) end;
function Director:isPaused() return CCDirector:sharedDirector():isPaused() end;
function Director:endGame() return CCDirector:sharedDirector():endToLua() end;
function Director:getTotalFrames() return CCDirector:sharedDirector():getTotalFrames() end;

function Director:getWinSize() 
	local winsize = CCDirector:sharedDirector():getWinSize()
	local gameUIScaleRate = CommonUtils:getGameUIScaleRate();
	return CCSize(winsize.width / gameUIScaleRate,winsize.height / gameUIScaleRate)
end;

function Director:getMetaWinSize() 
	return CCDirector:sharedDirector():getWinSize();
end;

function Director:getWinSizeInPixels() return CCDirector:sharedDirector():getWinSizeInPixels() end;
function Director:getContentScaleFactor() return CCDirector:sharedDirector():getContentScaleFactor() end;
function Director:getZEye() return CCDirector:sharedDirector():getZEye() end;
--CCScheduler
function Director:getScheduler() return CCDirector:sharedDirector():getScheduler() end;
--CCActionManager
function Director:getActionManager() return CCDirector:sharedDirector():getActionManager() end;
--CCTouchDispatcher
function Director:getTouchDispatcher() return CCDirector:sharedDirector():getTouchDispatcher() end;
--CCKeypadDispatcher
function Director:getKeypadDispatcher() return CCDirector:sharedDirector():getKeypadDispatcher() end;
--CCAccelerometer
function Director:getAccelerometer() return CCDirector:sharedDirector():getAccelerometer() end;
--CCNode
function Director:getNotificationNode() return CCDirector:sharedDirector():getNotificationNode() end;
--CCSize
function Director:getVisibleSize() return CCDirector:sharedDirector():getVisibleSize() end;
--CCPoint
function Director:getVisibleOrigin() return CCDirector:sharedDirector():getVisibleOrigin() end;
--CCPoint
function Director:convertToGL(v) return CCDirector:sharedDirector():convertToGL(v) end;
function Director:convertToUI(v) return CCDirector:sharedDirector():convertToUI(v) end;
--CCEGLViewProtocol
function Director:getOpenGLView() return CCDirector:sharedDirector():getOpenGLView() end;
--ccDirectorProjection
function Director:getProjection() return CCDirector:sharedDirector():getProjection() end;
function Director:setProjection(v) CCDirector:sharedDirector():setProjection(v) end;

--
-- public control -------------------
--

function Director:pause() CCDirector:sharedDirector():pause() end;
function Director:resume() CCDirector:sharedDirector():resume() end;
function Director:purgeCachedData() CCDirector:sharedDirector():purgeCachedData() end;

local function indexOf(scene)
	if not scene then return -1 end;

	local idx = -1;
	for i, v in ipairs(sceneStack) do
		if v == scene then
			idx = i;
			break;
		end
	end
	return idx;
end

function Director:getRunningScene()
	local s = CCDirector:sharedDirector():getRunningScene();
	for i, v in ipairs(sceneStack) do
		if v.sprite == s then
			return v;
		end
	end
	return nil;
end

function Director:runWithScene(s)
	local idx = indexOf(s);
	if s and idx == -1 then
		table.insert(sceneStack, s);
		CCDirector:sharedDirector():runWithScene(s.sprite);
		s:onEnter();
		self.__runningScene = s;
	end
end

function Director:pushScene(s)
    --print("pushScene", table.getn(sceneStack));
	local idx = indexOf(s);
	if s and idx == -1 then
		table.insert(sceneStack, s);
		CCDirector:sharedDirector():pushScene(s.sprite);
		s:onEnter();
		self.__runningScene = s;
	end
end

function Director:popScene(cleanup)
    --print("popScene", table.getn(sceneStack));
	local s = self:getRunningScene();
    if s then
		local idx = indexOf(s);
		if idx ~= -1 then table.remove(sceneStack, idx) end;
		CCDirector:sharedDirector():popScene();
		s:onExit();
		local isCleanup = true;
		if cleanup ~= nil then isCleanup = cleanup end;
		if isCleanup then s:dispose() end;
		
		local length = table.getn(sceneStack); 
		if length > 0 then
		    sceneStack[length]:onEnter();
		    self.__runningScene = sceneStack[length];
		else
		    self.__runningScene = nil;
		end
	end
end

function Director:replaceScene(s)
	local currentRunningScene = nil;
	local currentRunningIndex = -1;
	--print("replaceScene", table.getn(sceneStack));
	
	local ccRunning = CCDirector:sharedDirector():getRunningScene();
	for i, v in ipairs(sceneStack) do
		if v.sprite == ccRunning then
			currentRunningScene = v;
			currentRunningIndex = i;
			break;
		end
	end

  --print(currentRunningIndex)
  
	local idx = indexOf(s);
	if idx == -1 then
		table.insert(sceneStack, s);
		CCDirector:sharedDirector():replaceScene(s.sprite);
		s:onEnter();
		self.__runningScene = s;

		if currentRunningScene then 
		    currentRunningScene:onExit();
            currentRunningScene:dispose();
            if currentRunningIndex ~= -1 then table.remove(sceneStack, currentRunningIndex) end;
        end
	end
end

--winsize
function Director:setResolutionSize(width, height, frameScale)
	CommonUtils:setResolutionSize(width, height, frameScale);
end

-- 取得底层的缩放比率
function Director:getScaleX()
	CCDirector:sharedDirector():getOpenGLView():getScaleX();
end

-- 设置游戏帧率
function Director:setAnimationInterval(frameRate)
	CCDirector:sharedDirector():setAnimationInterval(frameRate);
end