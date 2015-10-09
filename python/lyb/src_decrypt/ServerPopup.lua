
require "main.view.serverScene.ui.ServerLoginLayer";

ServerPopup=class(Layer);

function ServerPopup:ctor()
  self.class=ServerPopup;
  self.allServersArray = {};
  self.recServersArray = {};
  self.tempServerIP = nil;
  self.tempServerId = nil;
  self.tempServerIsOpen = nil;
  self.myServerId = "no";
  self.myServerId2 = "no";
  self.myServerId3 = "no";
  self.myServerId4 = "no";
  self.clickCount = 0 -- 点击次数 防止多次命令 暂时没想到更好的方法
end

function ServerPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ServerPopup.superclass.dispose(self);
  self:removeTimeOut()
  BitmapCacher:removeUnused();
  self.clickCount = 0 -- 点击次数 防止多次命令 暂时没想到更好的方法
end

function ServerPopup:intializeServerUI(skeleton)
  self:initLayer();

  self.skeleton = skeleton;
  self.serverLoginLayer = ServerLoginLayer.new();
  self.serverLoginLayer:initialize(self);
  self:addChild(self.serverLoginLayer);
  self:initMyServer();
  
  self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT));

  AddUIBackGround(self,StaticArtsConfig.BACKGROUD_SEVERR_UI,nil,true);

  local logoImage = Image.new()
  logoImage:loadByArtID(StaticArtsConfig.IMAGE_1063)
  logoImage:setScale(0.8)
  logoImage:setPositionXY(640,415)
  self:addChild(logoImage)

  local cartoon1 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_129,440,495,0,nil,2,nil,false)
  local cartoon2 = cartoonPlayer(StaticArtsConfig.FRAME_EFFECT_128,1200,440,0,nil,2,nil,false)

  self:addChild(cartoon1)
  self:addChild(cartoon2)

  if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN 
  or GameData.platFormID == GameConfig.PLATFORM_CODE_DEBUG
  or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_BASE
  --测试 
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_MI
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_360  
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_BAIDU
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI
  or GameData.platFormID == GameConfig.PLATFORM_CODE_YINGYONGBAO
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ  
  or GameData.platFormID == GameConfig.PLATFORM_CODE_YJ
  -- or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI  

  or GameData.platFormID == GameConfig.PLATFORM_CODE_VIVO
  or GameData.platFormID == GameConfig.PLATFORM_CODE_LENOVO
  or GameData.platFormID == GameConfig.PLATFORM_CODE_JINLI
  or GameData.platFormID == GameConfig.PLATFORM_CODE_COOLPAD

  then
     self:setServerList();
     self:analysisLocalServer();
    -- self:setWebServerList()

  elseif GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then

    local channel_id = CommonUtils:getChannelID()
    if channel_id == "0" then
      self:setServerListForWan()
      self:analysisLocalServer(); 
    elseif channel_id == "1" then -- android官方
      self:setWebServerList();
    elseif channel_id == "2" then  -- qa分支
      self:setServerList()    
      self:analysisLocalServer();   
    end

  elseif GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_APPLE then  --ios官方
    self:setServerListForIOS()
    -- self:setServerList();
    self:analysisLocalServer();

  elseif GameData.platFormID == GameConfig.PLATFORM_CODE_MI
      or GameData.platFormID == GameConfig.PLATFORM_CODE_360  
      or GameData.platFormID == GameConfig.PLATFORM_CODE_UC
      or GameData.platFormID == GameConfig.PLATFORM_CODE_BAIDU
      or GameData.platFormID == GameConfig.PLATFORM_CODE_HUAWEI
      or GameData.platFormID == GameConfig.PLATFORM_CODE_OPPO
      or GameData.platFormID == GameConfig.PLATFORM_CODE_IQIYI
      or GameData.platFormID == GameConfig.PLATFORM_CODE_YINGYONGBAO
      or GameData.platFormID == GameConfig.PLATFORM_CODE_ZZ  
      or GameData.platFormID == GameConfig.PLATFORM_CODE_YJ
      or GameData.platFormID == GameConfig.PLATFORM_CODE_IOS_TONGBUTUI then

      self:setWebServerList();

  end
  
  AddUIFrame(self);
  self:particleRun()
end

function ServerPopup:setWebServerList()


    local delayAddTimer

    local function addSmallLoadingFunc()

      if delayAddTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayAddTimer)
      end

      initializeSmallLoading(3)

      if requestServersTable then
        self:analysisWebServer();
      else
        local requestServersTimer
        local getServerListCount = 0
        local function goonRequestServerData()

          if getServerListCount > 2 then

            uninitializeSmallLoading();
            if requestServersTimer then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(requestServersTimer)
              requestServersTimer = nil
            end

            local function onReconnect()
              initializeSmallLoading(3)
              getServerListCount = 0
              goonRequestServerData()
              requestServersTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(goonRequestServerData, 5, false)
            end

            local function onQuit()
              Director:sharedDirector():endGame();
            end

            local tips = CommonPopup.new();
            local tipsStr = "获取服务器列表失败,请重试"
            local textTable = {"重连","退出"}
            tips:initialize(tipsStr,self,onReconnect,nil,onQuit,nil,false,textTable,nil,true,3);
            tips:closeButtonVisible(false)
            self:addChild(tips)
          end

          local service = HttpService.new();
          local function onAllServerConfigLoaded(statusCode, responseData)

            if responseData then
                local JSON = require("core.net.JSON");
                local serverListData = JSON:decode(responseData).data;
                requestServersTable = serverListData.area01.servers;

                self:analysisWebServer();

                if requestServersTimer then
                  Director:sharedDirector():getScheduler():unscheduleScriptEntry(requestServersTimer)
                end

            else
              log("responseData====nil")
              service:send();
            end
          end    

          local server_url="http://partition.cn.happyelements.com/queryAllServerConfig?app_id=7800109651";
          service:setUrl(server_url);
          service:setResponseCallback(onAllServerConfigLoaded);
          service:send();
          getServerListCount = getServerListCount + 1
        end

        requestServersTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(goonRequestServerData, 5, false)
      end      
    end

  delayAddTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(addSmallLoadingFunc, 0.2, false)
end

function ServerPopup:particleRun()
  self.particleLayer = sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_PARTICLE_SYSTEM_UI)
  require "core.utils.ParticleSystem"
  ParticleSystem:particleRunForEver(self.particleLayer,"leaf6");
end

local function sortOnIndex(a, b) return a.sort > b.sort end
function ServerPopup:analysisWebServer()

    for k1,v1 in pairs(requestServersTable) do
        local id = self:getServerId(v1.id)
        if tonumber(id) < 9000 then--写死的 
            local serverVO = self:getServerVO(v1,id)
            table.insert(self.allServersArray,serverVO);
        else -- 9999 白名单服务器
            if self:isInMac(v1.gameSwfUrl) then
                local serverVO = self:getServerVO(v1,id)
                table.insert(self.allServersArray,serverVO);
            end
        end
    end

    for k2,v2 in pairs(self.allServersArray) do
      v2 = copyTable(v2)
      if v2.id == self.myServerId then
        v2.sort = 1006;
        table.insert(self.recServersArray,v2);
      elseif v2.id == self.myServerId2 then
        v2.sort = 1005;
        table.insert(self.recServersArray,v2);
      elseif v2.id == self.myServerId3 then
        v2.sort = 1004;
        table.insert(self.recServersArray,v2);
      elseif v2.id == self.myServerId4 then
        v2.sort = 1003;
        table.insert(self.recServersArray,v2);
      else
        if v2.tags == "new" then
          v2.sort = 1002;
          table.insert(self.recServersArray,v2);
        elseif v2.tags == "recommend" then
          v2.sort = 1001;
          table.insert(self.recServersArray,v2);
        end
      end
    end
    
    table.sort(self.recServersArray, sortOnIndex)
    
    self.serverLoginLayer:setLoginServer();
    
    uninitializeSmallLoading();
  -- local function onAllServerConfigLoaded(statusCode, responseData)
  --   if responseData then
  --       local JSON = require("core.net.JSON");
  --       local serverListData = JSON:decode(responseData).data;
  --       local serversTable = serverListData.area01.servers;

  --       for k1,v1 in pairs(serversTable) do
  --           local id = self:getServerId(v1.id)
  --           if tonumber(id) < 9000 then--写死的 
  --               local serverVO = self:getServerVO(v1,id)
  --               table.insert(self.allServersArray,serverVO);
  --           else -- 9999 白名单服务器
  --               if self:isInMac(v1.gameSwfUrl) then
  --                   local serverVO = self:getServerVO(v1,id)
  --                   table.insert(self.allServersArray,serverVO);
  --               end
  --           end
  --       end

  --       for k2,v2 in pairs(self.allServersArray) do
  --         v2 = copyTable(v2)
  --         if v2.id == self.myServerId then
  --           v2.sort = 1006;
  --           table.insert(self.recServersArray,v2);
  --         elseif v2.id == self.myServerId2 then
  --           v2.sort = 1005;
  --           table.insert(self.recServersArray,v2);
  --         elseif v2.id == self.myServerId3 then
  --           v2.sort = 1004;
  --           table.insert(self.recServersArray,v2);
  --         elseif v2.id == self.myServerId4 then
  --           v2.sort = 1003;
  --           table.insert(self.recServersArray,v2);
  --         else
  --           if v2.tags == "new" then
  --             v2.sort = 1002;
  --             table.insert(self.recServersArray,v2);
  --           elseif v2.tags == "recommend" then
  --             v2.sort = 1001;
  --             table.insert(self.recServersArray,v2);
  --           end
  --         end
  --       end
        
  --       table.sort(self.recServersArray, sortOnIndex)
  --     end
  --     self.serverLoginLayer:setLoginServer();
  -- end
  -- -- require "core.net.HttpService";
  -- local server_url="";
  -- -- if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
  -- --   server_url="http://partitiontw.he-games.com/queryAllServerConfig?app_id=7800106528"
  -- -- else
  -- --   server_url="http://partition.cn.happyelements.com/queryAllServerConfig?app_id=7800106502"
  -- -- end

  -- server_url="http://partition.cn.happyelements.com/queryAllServerConfig?app_id=7900108704"

  -- self.service = HttpService.new();
  -- self.service:setUrl(server_url);
  -- self.service:setResponseCallback(onAllServerConfigLoaded);
  -- self.service:send();
end

function ServerPopup:setServerList()
  self.allServersArray = {}

  self.table1 = {id = "1", name = "1区-内网",ip = "10.130.130.203",state = "crowd",isOpen = "1",tags = "recommend",sort = 5,gameBlock = "没开服就是没开服!"}
  self.table2 = {id = "2", name = "2区-开发L",ip = "10.130.133.75",state = "busy",isOpen = "1",tags = "new",sort = 7}
  self.table3 = {id = "3", name = "3区-开发G",ip = "10.130.133.243",state = "free",isOpen = "1",tags = "new",sort = 8}
  self.table4 = {id = "4", name = "4区-开发Z",ip = "10.130.133.241",state = "free",isOpen = "1",tags = "recommend",sort = 10}
  self.table5 = {id = "5", name = "6区-iOS外(测)",ip = "119.29.32.200",state = "free",isOpen = "1",sort = 11}
  self.table6 = {id = "6", name = "测试android",ip = "10.130.130.43",state = "busy",isOpen = "1",sort = 12}
  self.table7 = {id = "7", name = "外网",ip = "123.59.13.98",state = "busy",isOpen = "1",sort = 12}
  self.table8 = {id = "8", name = "数值服务器",ip = "10.130.133.239",state = "free",isOpen = "1",tags = "recommend",sort = 15}

  table.insert(self.allServersArray,self.table1);
  table.insert(self.allServersArray,self.table2);
  table.insert(self.allServersArray,self.table3);
  table.insert(self.allServersArray,self.table4);
  table.insert(self.allServersArray,self.table5);
  table.insert(self.allServersArray,self.table6);
  table.insert(self.allServersArray,self.table7);
  table.insert(self.allServersArray,self.table8);
end

function ServerPopup:setServerListForIOS()
  self.table1 = {id = "1", name = "江左梅郎",ip = "119.29.32.200",state = "free",isOpen = "1",tags = "recommend",sort = 6}
  table.insert(self.allServersArray,self.table1);
end

function ServerPopup:setServerListForWan()
  self.table1 = {id = "100", name = "体验服",ip = "123.59.13.98",state = "busy",isOpen = "1",tags = "recommend",sort = 6}
  table.insert(self.allServersArray,self.table1);
end

-- function ServerPopup:setServerListForWan2()
--   self.table1 = {id = "100", name = "体验服",ip = "119.29.13.37",state = "busy",isOpen = "1",tags = "recommend",sort = 6}
--   table.insert(self.allServersArray,self.table1);
-- end

function ServerPopup:analysisLocalServer()

  for k2,v2 in pairs(self.allServersArray) do
    if v2.tags == "new" then
      v2.sort = 1002;
    elseif v2.tags == "recommend" then
      v2.sort = 1001;
    end
  end
  self.recServersArray = {}
  for k1,v1 in pairs(self.allServersArray) do
    v1 = copyTable(v1)
    if v1.id == self.myServerId then
      v1.sort = 1006;
      table.insert(self.recServersArray,v1);
    elseif v1.id == self.myServerId2 then
      v1.sort = 1005;
      table.insert(self.recServersArray,v1);
    elseif v1.id == self.myServerId3 then
      v1.sort = 1004;
      table.insert(self.recServersArray,v1);
    elseif v1.id == self.myServerId4 then
      v1.sort = 1003;
      table.insert(self.recServersArray,v1);
    else
      if v1.tags == "new" then
        v1.sort = 1002;
        table.insert(self.recServersArray,v1);
      elseif v1.tags == "recommend" then
        v1.sort = 1001;
        table.insert(self.recServersArray,v1);
      end
    end
  end
  if not self.recServersArray[1] then
      self.recServersArray[1] = self.allServersArray[1];
  end
  table.sort(self.recServersArray, sortOnIndex)
  self.serverLoginLayer:setLoginServer();
end

-- function ServerPopup:analysisLocalServerForGoogle()
--   table.insert(self.allServersArray,self.table1);
--   table.insert(self.allServersArray,self.table11);

--   for k2,v2 in pairs(self.allServersArray) do
--     if v2.tags == "new" then
--       v2.sort = 1002;
--     elseif v2.tags == "recommend" then
--       v2.sort = 1001;
--     end
--   end

--   for k1,v1 in pairs(self.allServersArray) do
--     v1 = copyTable(v1)
--     if v1.id == self.myServerId then
--       v1.sort = 1006;
--       table.insert(self.recServersArray,v1);
--     elseif v1.id == self.myServerId2 then
--       v1.sort = 1005;
--       table.insert(self.recServersArray,v1);
--     elseif v1.id == self.myServerId3 then
--       v1.sort = 1004;
--       table.insert(self.recServersArray,v1);
--     elseif v1.id == self.myServerId4 then
--       v1.sort = 1003;
--       table.insert(self.recServersArray,v1);
--     else
--       if v1.tags == "new" then
--         v1.sort = 1002;
--         table.insert(self.recServersArray,v1);
--       elseif v1.tags == "recommend" then
--         v1.sort = 1001;
--         table.insert(self.recServersArray,v1);
--       end
--     end
--   end
--   if not self.recServersArray[1] then
--       self.recServersArray[1] = self.allServersArray[1];
--   end
--   table.sort(self.recServersArray, sortOnIndex)
--   self.serverLoginLayer:setLoginServer();
-- end

function ServerPopup:getMyServerData()
  return self.recServersArray[1],self:hasMyServerData();
end

function ServerPopup:hasMyServerData()
  local bool;
  if self.myServerId~="no" or self.myServerId2~="no" or self.myServerId3~="no" or self.myServerId4~="no" then
      bool = true
  end
  return bool;
end

function ServerPopup:initMyServer()
  self.myServerId = "" ~= GameData.local_serverId and GameData.local_serverId or self.myServerId;
  GameData.ServerId = self.myServerId
  self.myServerId2 = "" ~= GameData.local_serverId2 and GameData.local_serverId2 or self.myServerId2;
  self.myServerId3 = "" ~= GameData.local_serverId3 and GameData.local_serverId3 or self.myServerId3;
  self.myServerId4 = "" ~= GameData.local_serverId4 and GameData.local_serverId4 or self.myServerId4;
end
--返回
function ServerPopup:returnButtonHandler()
    if not self.tempServerIP then
      sharedTextAnimateReward():animateStartByString("未刷新服务器列表！")
      return
    end

    self.myServerId = self.tempServerId

  -- 刷新列表
  -- self:setServerList();
  self:analysisLocalServer();

  if self.serverListLayer then
    self:removeChild(self.serverListLayer,true)
  end

end

--进入游戏
function ServerPopup:interButtonHandler(event)

  if not self.tempServerIP then
    sharedTextAnimateReward():animateStartByString("未刷新服务器列表！")
    return
  end

  if self:getServerById() and self:getServerById().isOpen ~= "1" then
    local popup1=CommonPopup.new();
      popup1:initialize(self:getServerById().gameBlock,self,self.closeGame,nil,nil,nil,true);
      self:addChild(popup1);
    GameData.serverAdd = "";
    GameData.ServerId = "";
    GameData.serverIsOpen = "0";
    return
  end

  self:setTimeOut()
  require "main.config.SmallLoadingConifg"

  initializeSmallLoading(SmallLoadingConifg.TYPE_3);
  
    print("connectBoo")
  GameData.heartHitCount = 0
  connectBoo = connectTo(self.tempServerIP,8081,true);

  if(connectBoo) then

    GameData.isConnecting = true
    GameData.isConnect = true

    self.serverLoginLayer:removeCacheHandleTimer()

    sendFirstMessageToServer()

    local itemClickEvent = Event.new("beginLoad",nil, self);
    self:dispatchEvent(itemClickEvent);

    if self.particleLayer then
      ParticleSystem:removeParticleByUI(self.particleLayer)
      self.particleLayer = nil
    end

    if  self.tempServerId ~= self.myServerId and 
        self.tempServerId ~= self.myServerId2 and
        self.tempServerId ~= self.myServerId3 and
        self.tempServerId ~= self.myServerId4 then
          saveLocalInfo("serverId",self.tempServerId);
          saveLocalInfo("serverId2",GameData.ServerId);
          saveLocalInfo("serverId3",self.myServerId2);
          saveLocalInfo("serverId4",self.myServerId3);
    else
          saveLocalInfo("serverId",self.tempServerId);

          if self.myServerId2 == self.tempServerId then
            saveLocalInfo("serverId2",GameData.ServerId);
          else
            saveLocalInfo("serverId2",self.myServerId2);            
          end
          if self.myServerId3 == self.tempServerId then
            saveLocalInfo("serverId3",GameData.ServerId);
          else
            saveLocalInfo("serverId3",self.myServerId3);            
          end
          if self.myServerId4 == self.tempServerId then
            saveLocalInfo("serverId4",GameData.ServerId);
          else
            saveLocalInfo("serverId4",self.myServerId4);            
          end
    end
    GameData.serverAdd = self.tempServerIP;
    GameData.ServerId = self.tempServerId;
    GameData.serverIsOpen = self.tempServerIsOpen;
    -- GameData.isConnect = connectBoo;  
  else
    self.clickCount = 0
    sharedTextAnimateReward():animateStartByString("服务器连接失败，请稍后重试！")
    if OfficialServerMediator and Facade.getInstance():retrieveMediator(OfficialServerMediator.name) then
      Facade.getInstance():retrieveMediator(OfficialServerMediator.name):onWanError();
    end
    uninitializeSmallLoading();
  end
end

function ServerPopup:closeGame()
  if GameData.platFormID == GameConfig.PLATFORM_CODE_UC then
    UCExit();
  end
  Director:sharedDirector():endGame();
end

function ServerPopup:getServerById()
  for k,v in pairs(self.allServersArray) do
    if v.id == self.tempServerId then
        return v;
    end
  end
end

function ServerPopup:interButtonVisible(bool)
  self.serverLoginLayer:interButtonVisible(bool)
  self.serverLoginLayer:setLoginServer()
end

function ServerPopup:setTempServerData(recTable)
  self.tempServerIP = recTable.ip;
  self.tempServerId = recTable.id;
  self.tempServerIsOpen = recTable.isOpen;
end

function ServerPopup:refreshLoginServer(serverVO,bool)
  self.serverLoginLayer:refreshLoginServer(serverVO,bool)
end

function ServerPopup:getServerId(serverId)
  local str = string.sub(serverId, 1, 1);
  if str == "0" then
    local long = string.len(serverId);
    return string.sub(serverId, 2, long);
  end
  return serverId;
end

function ServerPopup:isInMac(macString)
    log("GameData.mac=="..GameData.mac)
    log("GameData.udid=="..GameData.udid)
    local array = StringUtils:lua_string_split(macString, "#")
    for key,value in pairs(array) do
      -- log("value=="..value)
      if value ~= "" and (value == GameData.mac or value == GameData.udid) then
          return true
      end
    end
end

function ServerPopup:getServerVO(v1,id)
    local tempTable = {}
    tempTable.id  = id;
    tempTable.name = v1.name;
    tempTable.ip,tempTable.port = self:getServerIP(v1.canvasUrl)
    tempTable.isOpen = v1.isOpen;
    tempTable.state = v1.status;
    tempTable.tags = v1.tags;
    tempTable.sort = tonumber(tempTable.id)
    tempTable.gameBlock = v1.gameBlock;
    if tempTable.tags == "new" then
      tempTable.sort = 1002;
    elseif tempTable.tags == "recommend" then
        tempTable.sort = 1001;
    end
    return tempTable
end

function ServerPopup:getServerIP(serverIp)
  local array = StringUtils:lua_string_split(serverIp, ":")
  return array[1],array[2];
end

function ServerPopup:getServerTags(tags)
  local array = StringUtils:lua_string_split(tags, ",")
  return array[1],array[2];
end

function ServerPopup:getServerState(state)
  if state == "free" then
    return "[流畅]";
  elseif state == "busy" then
    return "[爆满]";
  elseif state == "crowd" then
    return "[拥挤]";
  elseif state == "0" then
    return "[维护]";
  end
end

function ServerPopup:getServerTags(tags)
  if tags == "new" then
    return "[新服]"
  elseif tags == "recommend" then
    return "[推荐]"
  end
end

function ServerPopup:getcolorNumber(state)
  if state == "free" then
    return 2;
  elseif state == "busy" then
    return 6;
  elseif state == "crowd" then
    return 6;
  elseif state == "0" then
    return 3
  end
end

function ServerPopup:backButtonHandler(event)
  self:dispatchEvent(Event.new(OfficialServerNotifications.OPEN_OFFICIAL_SERVER,nil,self));
end

function ServerPopup:fbButtonHandler(event)
  GoogleLogin();
end

function ServerPopup:setTimeOut()
    local function timeOut()
        self:removeTimeOut()
        self.touchEnabled=true;
        self.touchChildren=true;
    end
    self.touchEnabled=false;
    self.touchChildren=false;
    self.timeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOut, 1, false);
end

function ServerPopup:removeTimeOut()
    if self.timeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
        self.timeOut = nil;
    end
end
function ServerPopup:refreshClickCount()
  self.clickCount = 0
end
