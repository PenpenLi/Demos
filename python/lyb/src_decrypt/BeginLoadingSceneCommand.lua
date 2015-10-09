--开始加载
require "main.managers.BetterEquipManager";

BeginLoadingSceneCommand = class(MacroCommand);

function BeginLoadingSceneCommand:ctor()
  self.class = BeginLoadingSceneCommand;
end

function BeginLoadingSceneCommand:execute(notification)
  require "main.view.loading.LoadingMediator"
  require "core.utils.Utils"
  
  BetterEquipManager:removeLayers();
  
   --CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
   for i_k, i_v in pairs(GameData.deleteSubMainSceneTextureMap) do
      GameData.deleteAllMainSceneTextureMap[i_v]  = nil;
   end
  
    local deleteList = {}
    deleteList = GameData.deleteSubMainSceneTextureMap;
    GameData.deleteSubMainSceneTextureMap = {}
   -- BitmapCacher:deleteTextureMap(GameData.deleteSubMainSceneTextureMap);
   -- GameData.deleteSubMainSceneTextureMap = {};

  local loadingProxy=self:retrieveProxy(LoadingProxy.name);
  local loadingMediator=self:retrieveMediator(LoadingMediator.name);  
  -- log("=========================loading====================004")
  if nil == loadingMediator then
    loadingMediator = LoadingMediator.new();
    self:registerMediator(loadingMediator:getMediatorName(), loadingMediator);
    loadingMediator:initialize(loadingProxy.skeleton)
	  loadingMediator:addLoadImage()
  else
    loadingMediator:resetLoadData(0, nil);
  end

  -- log("=========================loading====================005")
  --local scene = Director.sharedDirector():getRunningScene();	
 	--scene:addChild(loadingMediator:getViewComponent())
	local userProxy = self:retrieveProxy(UserProxy.name);
	local artsToLoad = {};
  local isLoadScence = false;
  if notification.data.type == GameConfig.SCENE_TYPE_1 then
    -- if StargazingMediator then
    --   self:removeMediator(StargazingMediator.name);
    -- end
    if FunctionSceneMediator then
      self:removeMediator(FunctionSceneMediator.name);
    end
    if CurrencyGroupMediator then
      self:removeMediator(CurrencyGroupMediator.name)
    end
     -- local mapSceneData = notification.data.mapSceneData;
     isLoadScence = true;
     artsToLoad = self:getCityArts(userProxy);

    if userProxy.outFromBattle then
        local battleProxy = self:retrieveProxy(BattleProxy.name);
        if not battleProxy.isContinueBattle then
  		    sharedBattleLayerManager():disposeBattleLayerManager()
                
    			deleteList = GameData.deleteBattleTextureMap
          GameData.deleteBattleTextureMap = {}
    			-- self:deleteTextureMap(GameData.deleteBattleTextureMap)
    			-- GameData.deleteBattleTextureMap = {};
        end
    end	 
  elseif notification.data.type == GameConfig.SCENE_TYPE_2 then
     isLoadScence = true;
     local battleProxy = self:retrieveProxy(BattleProxy.name);
     local userProxy = self:retrieveProxy(UserProxy.name);
     local generalProxy=self:retrieveProxy(GeneralListProxy.name);
     local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
     battleProxy:artsClassify();
     battleProxy:downlandData(userProxy,generalProxy,storyLineProxy);
     local resultTable = {};
     for i_k, i_v in pairs(battleProxy.cachMap) do 
       table.insert(resultTable, i_v);
     end
     artsToLoad = resultTable;
  elseif notification.data.type == GameConfig.SCENE_TYPE_3 then
     local battleProxy = self:retrieveProxy(BattleProxy.name);
     if not battleProxy.isContinueBattle then
          -- BitmapCacher:removeAllCache()
		  -- sharedMainLayerManager():disposeMainLayerManager()
		  
		  deleteList = GameData.deleteAllMainSceneTextureMap
		  -- BitmapCacher:deleteTextureMap(GameData.deleteAllMainSceneTextureMap)
		  GameData.deleteAllMainSceneTextureMap = {};
		  -- log("!!!!!!!!!!!!!!!!!!!!!!!!!!--------------------------------  heiping  -----in battle-----!!!!")
     end
     isLoadScence = true;
     local userProxy = self:retrieveProxy(UserProxy.name);
     local generalProxy=self:retrieveProxy(GeneralListProxy.name);
     local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
     battleProxy:artsClassify();
     battleProxy:downlandData(userProxy,generalProxy,storyLineProxy);
     local resultTable = {};
     for i_k, i_v in pairs(battleProxy.cachMap) do 
       table.insert(resultTable, i_v);
     end
     artsToLoad = resultTable;
  end

  local function blackFadeInBackFun(flag)
      if isLoadScence then
        if MainSceneMediator then
            local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
            if mainSceneMediator then
              mainSceneMediator:cleanMapScene();
            end
        end
        if notification.data.type == GameConfig.SCENE_TYPE_3 then
        -- 切换场景时需要做的事
            require "main.controller.command.mainScene.EnterBattleStuffCommand";
            self:addSubCommand(EnterBattleStuffCommand)--处理进战场做的事
            self:addSubCommand(MainSceneCloseCommand)
            self:complete()
        end
      end
      if not flag then
        blackFadeOut()
      end
      if not userProxy.hasInit then -- 进入游戏时不要loading条
        if notification.data.type == GameConfig.SCENE_TYPE_2 then
            local preloadSceneMediator=self:retrieveMediator(PreloadSceneMediator.name);
            sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(loadingMediator:getViewComponent()); 
            sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_SHIFT_UI):removeChildren()
        end
      else
        loadingMediator:addLoadImage()    
        commonAddToScene(loadingMediator:getViewComponent())
        -- loadingMediator:getViewComponent():setScale(GameData.gameUIScaleRate)
        local winSize = Director:sharedDirector():getWinSize();
        loadingMediator:getViewComponent():setPositionXY((winSize.width - GameConfig.STAGE_WIDTH)/2 * GameData.gameUIScaleRate,(winSize.height - GameConfig.STAGE_HEIGHT)/2* GameData.gameUIScaleRate)
        -- loadingMediator:getViewComponent():setPositionXY(GameData.uiOffsetX, GameData.uiOffsetY)    
      end
      -- log("=========================loading====================006")

      local deleteListResult = {};
      for i_k, i_v in pairs(deleteList) do
        table.insert(deleteListResult, i_v)
      end
      deleteList = {};
    	if isLoadScence then
        local enterFramFunction
        local function localEnterFrameFun()
        	-- local function loadArtsAfterDelete(time)
         --    local data = {};
         --    data["artsToLoad"] = artsToLoad;
         --    data["callBackFun"] = nil;
         --    -- data["isReset"] = time == nil;
         --    data["coefficient"] = 1;
         --    data["msg"] = nil--notification.data;
         --    loadingMediator:initLoadData(data);
        	-- end

        	if enterFramFunction then
        		Director:sharedDirector():getScheduler():unscheduleScriptEntry(enterFramFunction)
        	end

          local data = {};
          data["artsToDelete"] = deleteListResult;
          data["artsToLoad"] = artsToLoad;
          data["msg"] = notification.data
          -- data["callBackFun"] = loadArtsAfterDelete;
          -- data["isReset"] = true;
          -- data["coefficient"] = 1;
          -- data["msg"] = nil;
          loadingMediator:initLoadData(data);           
        	 -- print("--------*************deleteListResult count", #deleteListResult);
        	-- if #deleteListResult ~= 0 then
      			-- --sharedMainLayerManager():disposeMainLayerManager()

         --    -- print("--------*************deleteListResult count", #deleteListResult);

         --    local data = {};
         --    data["artsToDelete"] = deleteListResult;
         --    data["artsToLoad"] = artsToLoad;
         --    -- data["callBackFun"] = loadArtsAfterDelete;
         --    -- data["isReset"] = true;
         --    -- data["coefficient"] = 1;
         --    -- data["msg"] = nil;
      			-- loadingMediator:initLoadData(data);	
        	-- else
      	  -- 	loadArtsAfterDelete(nil)
        	-- end
        end
        enterFramFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(localEnterFrameFun, 0, false)
      end
  end
  if notification.data.type == GameConfig.SCENE_TYPE_3 or notification.data.type == GameConfig.SCENE_TYPE_2 or userProxy.outFromBattle then
    blackFadeIn(blackFadeInBackFun)
  else
    blackFadeInBackFun(true)
  end
end

function BeginLoadingSceneCommand:getCityArts(userProxy)
    local tempTable = {}
    if userProxy.sceneType == GameConfig.SCENE_TYPE_4 then
      local totalTable = analysisTotalTable("Bangpai_Bangpaichangjing")
      for k, v in pairs(totalTable)do
          if v.type == 1 then
            local modelId = v.artId

            -- if v.id == 1 then
            --   local familyProxy = self:retrieveProxy(FamilyProxy.name)
            --   modelId = analysis("Kapai_Kapaiku", familyProxy.bangZhuConfigId, "material_id")
            -- end
            -- local url = "key_"..modelId.."_"..BattleConfig.HOLD
            -- local source = plistData[url].source
            -- local source2 = artData[modelId].source
            -- table.insert(tempTable, source);
            if v.id ~= 1 then
              local url = "key_"..modelId.."_"..BattleConfig.HOLD
              local source = plistData[url].source
              local source2 = artData[modelId].source
              table.insert(tempTable, source);
            end
          end
      end     
    end
    return tempTable;
end

function BeginLoadingSceneCommand:checkAndAddItem(artsToLoad, tempTable)
   for i_k, i_v in pairs(tempTable) do
      if not Utils:contain(artsToLoad, i_v) then
            table.insert(artsToLoad, i_v);
      end
   end
end
function BeginLoadingSceneCommand:getStoryLineArts(storyLineId)
   local mapId = analysis("Juqing_Juqing", storyLineId ,"mapId");
   local artsToLoad = {};

    return artsToLoad;
end