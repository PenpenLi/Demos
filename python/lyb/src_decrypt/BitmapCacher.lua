
BitmapCacher = {};

function BitmapCacher:initCacher()
	GameData.bitmapFrameArr = {};
	self.plistArray = {};
	self.artDataArray = self:getArtDataArray()
	
	-------------查内存泄露时打开,不要删-------------
	 -- local results = {};
	 -- setmetatable(results, { __mode = "v" });
	 -- self.results = results;
	 -- self:chickMemory()
	-------------查内存泄露时打开,不要删-------------
	----table.insert(BitmapCacher.results,self)
	-- Director:setDisplayStats(true)
end
--获得素材的宽高
function BitmapCacher:getArtDataArray()
	local artArray = {}
	for key,value in pairs(artData) do
		local pos = string.find(value.source, ".jpg");
		if not pos then
			artArray[value.source] = value.width*value.height
		else
			artArray[value.source] = value.width*value.height*3
		end
	end
	return artArray
end

function loadCompleteFunction(artID,callBackTexture)
	if artID ~= -1 then
		local luaPathStr = BattleConfig.SOURCE_URL.."P"..artID
		log("hascache33=="..luaPathStr)
		local plist = require(luaPathStr);	
		-- log("require--------luaPathStr======="..luaPathStr)
		local animationTable = plist["animation"];
		local ccSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache();
		for k1,v1 in ipairs(animationTable) do
				if not GameData.bitmapFrameArr[v1["name"]] then
					local frameTable = StringUtils:lua_string_split(v1["frame"],",");
					local animFrames = CCArray:create();
					for k2,v2 in pairs(frameTable) do
						local frame = ccSpriteFrameCache:spriteFrameByName(v2);
						animFrames:addObject(frame);
					end
	
					local animation = CCAnimation:createWithSpriteFrames(animFrames, GameConfig.Animate_FreamRate);
					-- log("zhangke---4")
					local animCache = CCAnimationCache:sharedAnimationCache();
					animCache:addAnimation(animation, v1["name"]);
					--if string.find(v1["frame"], "_"..BattleConfig.HIT_FALL..".") then
						--GameData.bitmapFrameArr[v1["name"]] = v1["frame"];--存死亡用
					--else
					-- log("zhangke---5")
						GameData.bitmapFrameArr[v1["name"]] = v1["name"];
					--end
				end
		end		
	else
		log("hascache444=="..artID)
	end
	if GameData.backFun and GameData.backContext then
		GameData.backFun(GameData.backContext);
	end		
end	

---------------------------
--缓存动画，只能用于loading界面使用，如其它界面使用，会造成loading停止
---------------------------
local function sortOnIndex(a, b) return a.sizeT > b.sizeT end
function BitmapCacher:animationCacheByArray(cacheArray, context, backFun)
	if GameData.bitmapFrameArr == nil then
		self:initCacher();
	end
	GameData.backFun = backFun
	GameData.backContext = context
	
	local totalCacheArray = {}
	for k1,v1 in pairs(cacheArray) do
		log("allloadsource=="..v1)
		if self.plistArray[v1] then
			if GameData.backFun and GameData.backContext then
				GameData.backFun(GameData.backContext);
			end
			log("hascache11=="..v1)
		else
			table.insert(totalCacheArray,{url=v1,sizeT=self.artDataArray[v1] or 0});
		end
	end

	--ccSpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache();
	self:removeCacheTimer()
	local length = table.getn(totalCacheArray)
	table.sort(totalCacheArray,sortOnIndex)
	local i = 1;
	local function cacheTimerBack()
			local VO = totalCacheArray[i];
			if not VO then
			  return;
			end
			local url = VO.url
			-- log("-------VO.url======="..VO.url)
			local pos1 = string.find(url, ".lua");
			local pos2 = string.find(url, ".mp3");
			local pos3 = string.find(url, ".ssba");
			
			-- if "resource/image/arts/P4.lua"~= url then
				log("urlurlurl==========="..url)
				if pos1 then
					BitmapCacher:animationCacheAsync(url);
				elseif pos2 then
					MusicUtils:preloadEffect(url)
					if GameData.backFun and GameData.backContext then
						GameData.backFun(GameData.backContext);
					end
					log("hascache22=="..url)
				-- elseif pos3 then -- 骨骼动画

					-- url = string.gsub(url,".ssba",".png")
					-- log("$$$$$$$$$$$$zhangke$$$$$$$$$$$$$$$==="..url)
					-- ImageASync:getInst():LoadImageAsync(url,-1,nil);
				else
					ImageASync:getInst():LoadImageAsync(url,-1,nil);
				end
			-- else
			-- 		if GameData.backFun and GameData.backContext then
			-- 			GameData.backFun(GameData.backContext);
			-- 		end
			-- end
			i = i + 1;

			if i > length then
				self:removeCacheTimer()
			end
	end	
	self.cacheTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(cacheTimerBack,0,false);
end

function BitmapCacher:cacheImage(url)
	ImageASync:getInst():LoadImageAsync(url,-1,nil);
end

function BitmapCacher:removeCacheTimer()
	if self.cacheTimer then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.cacheTimer);
		self.cacheTimer = nil
	end	
end
--------------------------------------
--plist,analytical plist and XML files
--------------------------------------
function BitmapCacher:animationCacheAsync(luaUrl)
	--log("--animationCacheAsync---------animationCache_luaUrl:::"..luaUrl)
	local strR1 = string.gsub(luaUrl, ".lua", "");
	local strR2 = string.gsub(strR1, "/", ".");
	local strR3 = string.gsub(strR1, "P", "");
	-- log("strR2========="..strR2)
	local plist = require(strR2);
	local plistId = plist["id"];
	
	--if not self.plistArray[luaUrl] then
		ImageASync:getInst():LoadFrameImage(BattleConfig.SOURCE_URL..plistId..".plist",string.gsub(plistId, "P", ""));
		self.plistArray[luaUrl] = luaUrl;
	--end
end

--------------------------------------
--plist,analytical plist and XML files
--------------------------------------
function BitmapCacher:animationCache(luaUrl)
			--log("animationCache_luaUrl:::"..luaUrl)
			if not luaUrl then return;end;
            if GameData.bitmapFrameArr == nil then
                self:initCacher();
            end
            local strR1 = string.gsub(luaUrl, ".lua", "");
            local strR2 = string.gsub(strR1, "/", ".");
            local strR3 = string.gsub(strR1, "P", "");
            local plist = require(strR2);
            local plistId = plist["id"];
            
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache();
            --if not self.plistArray[luaUrl] then
                cache:addSpriteFramesWithFile(BattleConfig.SOURCE_URL..plistId..".plist");  
                self.plistArray[luaUrl] = luaUrl;
            --end
    
            local animationTable = plist["animation"];
            for k1,v1 in ipairs(animationTable) do
                    if not GameData.bitmapFrameArr[v1["name"]] then
                        local frameTable = StringUtils:lua_string_split(v1["frame"],",");
                        
                        local animFrames = CCArray:create();
                        for k2,v2 in pairs(frameTable) do
                                    local frame = cache:spriteFrameByName(v2);
                                    animFrames:addObject(frame);
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, GameConfig.Animate_FreamRate);
                        
                        local animCache = CCAnimationCache:sharedAnimationCache();
                        animCache:addAnimation(animation, v1["name"]);
                        GameData.bitmapFrameArr[v1["name"]] = v1["name"];
                    end
            end
end

function BitmapCacher:removeAllCache()
        -- print("-------------------------------before--------------------------")
        --CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();

        self:deleteTextureMap(GameData.deleteBattleTextureMap)
        self:deleteTextureMap(GameData.deleteAllMainSceneTextureMap)
        self:deleteTextureMap(GameData.deletePreloadTextureMap)
        --end
        GameData.deleteBattleTextureMap = {};
        GameData.deleteAllMainSceneTextureMap = {};
        GameData.deletePreloadTextureMap = {};
			
        -- print("-------------------------------after--------------------------")
       -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
end


function BitmapCacher:deleteTextureMap(textureMap)
    for k1,v1 in pairs(textureMap) do
        local pos1 = string.find(v1, ".lua");
        local pos2 = string.find(v1, ".mp3");
        print("==========deleteTextureMap===================",v1)
        if pos1 then
		    self:deleteTextureLua(v1)
        elseif pos2 then
        	-- log("delete soundEffect "..v1)
        	MusicUtils:unloadEffect(v1);
        end
    end
end
function BitmapCacher:deleteCallBackTextureMap(textureMap,context,callBack)
        local isComplete = false;
		local function tickFun(time)
            if #textureMap == 0 then
               BitmapCacher:removeTickIdTimer()
            end

            local removeTable = {};
            for i = 1, 7 do 
   				local v1 = table.remove(textureMap);
   				if  v1 then
                   table.insert(removeTable, v1);
   				else
   					isComplete = true;
 					BitmapCacher:removeTickIdTimer()
 					break;
   				end
            end
           
            if #textureMap == 0 then
				isComplete = true;
				BitmapCacher:removeTickIdTimer()
            end
            
	        for i_k, i_v in pairs(removeTable) do
	            local pos1 = string.find(i_v, ".lua");
		        local pos2 = string.find(i_v, ".mp3");
		        if pos1 then
				    self:deleteTextureLua(i_v)
		        elseif pos2 then
		        	-- log("delete soundEffect "..i_v)
		        	MusicUtils:unloadEffect(i_v);
		        end
	        end

            if context and callBack then
				callBack(context, #removeTable, isComplete);
			end	

		end
  	    self.tickId = Director:sharedDirector():getScheduler():scheduleScriptFunc(tickFun, 0, false)
end

function BitmapCacher:removeTickIdTimer()
	if self.tickId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.tickId);
		self.tickId = nil
	end	
end

function BitmapCacher:deleteTextureLua(urlLua)
	if not urlLua then return;end;
    -- log("delete texture "..urlLua)
    local strR1 = string.gsub(urlLua, ".lua", "");
    local strR2 = string.gsub(strR1, "/", ".");
    local strR3 = string.gsub(strR1, "P", "");
    local plist = require(strR2);
    local plistId = plist["id"];
    
    self.plistArray[urlLua] = nil;
    local animationTable = plist["animation"];
    for k2,v2 in ipairs(animationTable) do
        GameData.bitmapFrameArr[v2["name"]] = nil;
        CCAnimationCache:sharedAnimationCache():removeAnimationByName(v2["name"]);
    end

    CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(BattleConfig.SOURCE_URL..plistId..".plist")
end

function BitmapCacher:removeUnused()
	-- print("-------------------------------before--------------------------")
	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
    CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames();
    CCTextureCache:sharedTextureCache():removeUnusedTextures(); 
    self:autoCollect()
	-- print("-------------------------------after--------------------------")
	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
 --    self:showMemoryUsage()
end

function BitmapCacher:autoCollect()
	self:removeCollectHandle();
	local function collectHandle()
        self:removeCollectHandle();
        log("=============Recycling can delete the memory===============")
        collectgarbage("collect");
	end
	self.collectHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(collectHandle, 0, false)
end
--用于断线处理
function BitmapCacher:dispose()

	-- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();

	--self:deleteTextureMap(self.plistArray);
	--self:initCacher();
	CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames();
    CCTextureCache:sharedTextureCache():removeUnusedTextures(); 
    self:removeCollectHandle()
    self:removeCacheTimer()
    self:removeTickIdTimer()
	-- BattleData.attackSkillArray = {}; 
	-- BattleData.beAttackSkillArray = {};
	-- BattleData.screenSkillArray = {};
	 GameData.backFun = nil
	 GameData.backContext = nil
end

function BitmapCacher:removeCollectHandle()
	if self.collectHandle then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.collectHandle);
		self.collectHandle = nil;
	end
end

function BitmapCacher:chickMemory()
	local function cacheHandle()
        print("timer++++++++++++++++++++")
        for k1,v1 in pairs(self.results) do
          print(k1,v1)
        end
        local len = 0;
        for k2,v2 in pairs(self.results) do
        	len = len + 1
        end
        print(len)
    end
    self.cacheHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(cacheHandle, 1, false)
end
function BitmapCacher:showMemoryUsage()
	local ttlMem = collectgarbage("count");
    print(string.format("LUA VM MEMORY USED: %0.2f KB (%0.2f MB)", ttlMem,ttlMem/1024))
    print("---------------------------------------------------")
    return ttlMem;
end
function BitmapCacher:snapshotBegin()
	self.S1 = he_snapshot()
end
function BitmapCacher:snapshotEnd()
	local S2 = he_snapshot()
	print("---------------snapshot begin------------------")
	for k,v in pairs(S2) do
		if self.S1[k] == nil then
			print("--->  ",k,v);
		end
	end
	print("---------------snapshot end------------------")
	self.S1 = nil;
end