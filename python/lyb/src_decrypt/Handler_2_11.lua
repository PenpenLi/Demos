
Handler_2_11 = class(Command);

local function closeGame()
  if GameData.platFormID == GameConfig.PLATFORM_CODE_UC then
    UCExit();
  end
  Director:sharedDirector():endGame();
end

function Handler_2_11:execute()
  
  log("--------Handler_2_11")
  local loginStatus = recvTable["LoginState"]
    
  GameData.platFormUserId = recvTable["YunyingUserId"];

  -- 把userid 告诉gsp
  local severAndUserid = GameData.ServerId .. "_" .. GameData.platFormID .. "_" .. GameData.platFormUserId

  log("loginStatus="..loginStatus)
  log("severAndUserid="..severAndUserid)
  if GameData.platFormID ~= GameConfig.PLATFORM_CODE_LAN then
      setGameUserIdForGSP(severAndUserid)
  end
  
  -- for dataeye
  deSetGameServer(GameData.ServerId.."")

  if loginStatus == 0 then -- 登录成功
    local allRoleArr = recvTable["UserAccountInfoArray"]
    local allRoleLength = table.getn(allRoleArr)
    if 0 == allRoleLength then
        GameData.userKey = recvTable["YunyingUserId"]
        self:sendTo2_1(GameData.ServerId);

    elseif 1 == allRoleLength then
      GameData.userKey = recvTable["YunyingUserId"]
      self:sendTo2_1(allRoleArr[1].OrigainalServerId);

    elseif allRoleLength > 1 then
      require "main.controller.command.server_merge.MainSceneToServerMergeCommand";
      MainSceneToServerMergeCommand.new():execute(Notification.new("",allRoleArr));
    end

  elseif loginStatus == 1 then -- 帐号密码错误

    uninitializeSmallLoading();
    local serverMediator=self:retrieveMediator(ServerMediator.name);
    if serverMediator then
      serverMediator:refreshClickCount();
    end

    sharedTextAnimateReward():animateStartByString("帐号或密码错误!");
  elseif loginStatus == 2 then -- 邀请码
    uninitializeSmallLoading();
    GameData.userKey = recvTable["YunyingUserId"]
    log("GameData.userKey="..GameData.userKey)
    local serverMediator=self:retrieveMediator(ServerMediator.name);
    if serverMediator then
      serverMediator:refreshClickCount();
    end    

      require "core.controls.CommonInput";
          inputTips = CommonInput.new();
          -- sendToserver
          local function sendCodeToServer()
          
            -- body
            local inputText = inputTips.inputText:getString()
            local str = GameConfig.HTTP_IP .. "checkandbindInviteCode?code=" .. inputText
                      .. "&key=" .. GameData.platFormID .. "_" .. GameData.userKey
                      .. "&sig=" .. getMD5();

            local service4Invite = HttpService.new();
            service4Invite:setUrl(str);
            service4Invite:setResponseCallback(bindInviteCodeSuccess);
            service4Invite:setErrorCallback(bindInviteCodeError);
            service4Invite:send();
            initializeSmallLoading();

          end
          -- open url
          local function openGetCodeUrl()
              uninitializeSmallLoading();
              openUrl("http://tieba.baidu.com/p/3760678060")
          end

          -- quit game
          local function closeUIFunction()
            Director:sharedDirector():endGame();
          end

      local tableName = {"提交","领取"}
      inputTips:initialize(nil,"邀请码验证",self,sendCodeToServer,nil,openGetCodeUrl,nil,nil,tableName,nil,true,closeUIFunction);
      commonAddToScene(inputTips, true)

    elseif loginStatus == 3 
        or loginStatus == 4 then -- Mac地址被封-- IP地址被封     
      local quitStr = StringUtils:getString4Popup(PopupMessageConstConfig.ID_256)
      local text_table = StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_256)        
      local tips=CommonPopup.new();
      tips:initialize(quitStr,self,closeGame,nil,nil,nil,true,text_table,nil,nil,true);

      commonAddToScene(tips, true)    
    elseif loginStatus == 5 then
      local tips=CommonPopup.new();
      tips:initialize("服务器暂未开放",self,closeGame,nil,nil,nil,true,nil,nil,nil,true);
      commonAddToScene(tips, true)    

  end
end

function Handler_2_11:sendTo2_1(origainalServerId)
  local hefuChangeName = ""
  sendMessage(2,1,{UserName = hefuChangeName,OrigainalServerId = origainalServerId});

  -- local dcParamStr =  "install_key="..GameData.install_key
  --                   .."&mac="..GameData.mac
  --                   .."&udid="..GameData.udid
  --                   .."&gameversion="..clientgameVersion
  --                   .."&clienttype="..GameData.clienttype
  --                   .."&clientversion="..GameData.clientversion
  --                   .."&channel_id="..""
  --                   .."&networktype="..GameData.networktype
  --                   .."&clientpixel="..GameData.clientpixel
  --                   .."&serial_number="..GameData.serial_number
  --                   .."&android_id="..GameData.android_id
  --                   .."&google_aid="..GameData.google_aid                    
  --                   .."&location=".."cn"
  --                   .."&src=".."home"
  --                   .."&equipment="..GameData.equipment
  --                   .."&carrier="..GameData.carrier
  --                   .."&idfa="..GameData.idfa
  --                   .."&simulator="..GameData.simulator

  -- log("DCParamStr="..dcParamStr)
  -- tableData["DCParamStr"] = dcParamStr
 end

Handler_2_11.new():execute();