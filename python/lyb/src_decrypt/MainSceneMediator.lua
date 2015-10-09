require "core.mvc.ext.ProxyRetriever"
require "main.view.mainScene.ui.MainScene";
require "main.controller.notification.MainSceneNotification";
require "main.controller.notification.TaskNotification";
require "main.controller.notification.SmallChatNotification";
require "core.utils.LayerColorBackGround";
require "main.controller.notification.MonthCardNotification";
--开服七天乐 add by mohai.wu
require "main.controller.notification.SevenDaysNotification";
require "main.controller.notification.SecondPayNotification"

MainSceneMediator = class(Mediator);

function MainSceneMediator:ctor()
  self.class = MainSceneMediator;
  self.viewComponent = MainScene.new();
  
  gameSceneIns = self.viewComponent.mapScene;
end

rawset(MainSceneMediator,"name","MainSceneMediator");

function MainSceneMediator:onRegister()
  

  local proxyRetriever  = ProxyRetriever.new();

  self.vipProxy=proxyRetriever:retrieveProxy(VipProxy.name);
  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=proxyRetriever:retrieveProxy(GeneralListProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.openFunctionProxy=proxyRetriever:retrieveProxy(OpenFunctionProxy.name);
  self.itemUseQueueProxy=proxyRetriever:retrieveProxy(ItemUseQueueProxy.name);
  self.heroHouseProxy=proxyRetriever:retrieveProxy(HeroHouseProxy.name)
  self.huodongProxy = proxyRetriever:retrieveProxy(HuoDongProxy.name);

  self.viewComponent:initScene(); 

  -- self.viewComponent.mainUI.shezhiButtonDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  -- self.viewComponent.mainUI.liaotiandiDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

  self.viewComponent.mainUI.gongnengDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.chongzhiDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.liaotiandiDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.headImageDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.mainui_vip:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.common_return_button:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.huodongDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.langyabangDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.monthCardDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self.viewComponent.mainUI.userInfoGroupUI.firstPayDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  --开服七天乐 add by mohai.wu
  self.viewComponent.mainUI.userInfoGroupUI.sevendays:addEventListener(DisplayEvents.kTouchBegin, self.onTipsBegin, self);
end

function MainSceneMediator:onOpenPlatformCharge(event)
   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end
function MainSceneMediator:changeStoryLine(mapSceneData)
  local from = mapSceneData["from"]
  local isShowMainUI = mapSceneData["sceneType"] ==  GameConfig.SCENE_TYPE_1
  self.viewComponent.mainUI:setVisibleByBool(isShowMainUI);

  self.viewComponent.mapScene:changeStoryLine(mapSceneData)

  setButtonGroupVisible(isShowMainUI)
  setHButtonGroupVisible(isShowMainUI)

  if from == GameConfig.SCENE_TYPE_1 then
    setCurrencyGroupVisible(true);
    --TODO BY YINHAO
    self:refreshFamilyContribute(false)
  elseif from == GameConfig.SCENE_TYPE_4 then
    local bool = false;
    if isShowMainUI then
      local count = #LayerManager.showCurrencys;
      if count == 0 then
        bool = true
      else
        bool = LayerManager.showCurrencys[count]
      end
    else
      bool = true;
    end
    setCurrencyGroupVisible(bool);
    --TODO BY YINHAO
    self:refreshFamilyContribute(true)
  end
end

function MainSceneMediator:refreshFamilyContribute(bool)
    local currencyGroupMediator=Facade.getInstance():retrieveMediator(CurrencyGroupMediator.name);
    if currencyGroupMediator then
      currencyGroupMediator:refreshFamilyContribute(bool)
    end
end


function MainSceneMediator:refreshGeneralRoleLayer()
  self.viewComponent.mapScene:refreshGeneralRoleLayer();
end

function MainSceneMediator:refreshMainGeneral()
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene.mapOuterLayer:addMainRole()
    self.viewComponent.mainUI.userInfoGroupUI:refreshHeadImage()
    self.viewComponent.mainUI.userInfoGroupUI.headImageDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  end
end
function MainSceneMediator:onTipsBegin(event)
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
  
  if event.target.imageButton then
    event.target.imageButton:setScale(0.88);
  else
    local targetName = event.target.name
    if targetName ~= "tiliProgressBar" and targetName ~= "liaotiandi" then
        event.target:setScale(0.88);
    else
        event.target:setScale(0.99);
    end
  end

  if event.target.effect then
    event.target.effect:setScale(0.88);
  end
end

function MainSceneMediator:onTipsEnd(event)
  -- if GameData.isMusicOn then
  --   MusicUtils:playEffect(14,false)
  -- end
  local targetName = event.target.name

  print("MainSceneMediator:onTipsEnd",targetName)
  if targetName == "liaotiandi" then -- chat
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_CHAT));
  elseif targetName == "common_return_button" then --+号按钮
    sendMessage(27,22);
    local mapSceneData = {}
    self.userProxy.sceneType = GameConfig.SCENE_TYPE_1
    mapSceneData["from"] = GameConfig.SCENE_TYPE_4
    mapSceneData["sceneType"] = self.userProxy.sceneType
    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
    self:sendNotification(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))
  elseif targetName == "gongneng" then --+号按钮
    if not self.isMoving and (GameVar.tutorStage == TutorConfig.STAGE_99999 or GameVar.tutorStage == TutorConfig.STAGE_1027)then
      self.isMoving = true;
      local isHMenuOpen = not GameData.isHMenuOpen
      if isHMenuOpen then
        local function rollBack()
          self.isMoving = false;
        end
        local ccActionArray = CCArray:create()
        ccActionArray:addObject(CCRotateBy:create(0.2 , 45));
        ccActionArray:addObject(CCDelayTime:create(0.2));
        ccActionArray:addObject(CCCallFunc:create(rollBack));
        self.viewComponent.mainUI.gongnengDO:runAction(CCSequence:create(ccActionArray))
      else
        local function rollBack2()
          self.isMoving = false;
        end
        local ccActionArray = CCArray:create()
        ccActionArray:addObject(CCRotateBy:create(0.2 , -45));
        ccActionArray:addObject(CCDelayTime:create(0.2));
        ccActionArray:addObject(CCCallFunc:create(rollBack2));
        self.viewComponent.mainUI.gongnengDO:runAction(CCSequence:create(ccActionArray))
      end
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_MENU_COMMAND, {isOpen = isHMenuOpen}));
    end

  elseif targetName == "mainui_vip"  then
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP)); 
  elseif targetName == "langyabang"  then
     self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_RANK_LIST));
  elseif targetName == "huodong"  then
    self:sendNotification(HuoDongNotification.new(HuoDongNotifications.OPEN_HUODONG_UI));
  elseif targetName == "monthcard"  then
    self:sendNotification(MonthCardNotification.new(MonthCardNotifications.MONTH_CARD));
  elseif targetName == "firstpay"  then
    print("\n\n\n\n\n\n\n------------------------------------self.huodongProxy.IsFirstPay = ", self.huodongProxy.IsFirstPay )
    if self.huodongProxy.IsFirstPay == true then
      self:sendNotification(FirstPayNotification.new(FirstPayNotifications.FIRST_PAY));
    else
      print("sendNotification SECOND_PAY")
      self:sendNotification(SecondPayNotification.new(SecondPayNotifications.SECOND_PAY));
    end
  elseif targetName == "chongzhiButton" then -- Ã¥â€¦â€¦Ã¥â‚¬Â¼
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
    self:setIconEffectVip(true);
  elseif targetName == "firstChargeButton" then -- Ã¥Â°ÂÃ¨Å“Å“
     self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_FIRST_CHARGE_UI));
  elseif targetName == "gantanhaoButton" then -- 感叹号
    self:onClickGantanhao(event)
  elseif targetName == "chongzhi" then -- 充值
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP)); 
  elseif targetName == "headImage" then
      self:refreshRedIcon(false)
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPERATION));  
  elseif targetName == "sevendays" then
    --开服七天乐 add by mohai.wu
    self:sendNotification(SevenDaysNotification.new(SevenDaysNotifications.OPEN_SEVENDAYS_UI));
  end
  
  if event.target.imageButton then
    event.target.imageButton:setScale(1);
  else
    event.target:setScale(1);
  end
  if event.target.effect then
    event.target.effect:setScale(1);
  end
  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self,data);

  MusicUtils:playEffect(7,false)
end

function MainSceneMediator:onClickGantanhao(event)

  if self.viewComponent.mainUI.gantanhaoData == nil then
    return
  end
  local data = self.viewComponent.mainUI.gantanhaoData[1]  
  self.viewComponent.mainUI:setGantanhao();  
  if not data then
     return;
  end
  
  self.tips=CommonPopup.new();
  local id = data["id"]
  local content = data["content"]
  
  local textTable = {}
  textTable[1] = data["button1"]; 
  textTable[2] = data["button2"];
  
  if id == 3 or id == 23 or id == 24 or id == 27 or id == 83 then  --2个按钮的有字的,字是彩色的
    self.tips:initialize(content,self,self.gantanhaoConfirm,data,nil,nil,nil,textTable,true,true);
  elseif id == 12 or id == 13 or id == 10 or id == 14 or id == 15 or id == 16 or id == 17 or id == 20 or id == 26 or id == 38 or id == 39 or id==40 or id == 41 or id == 42 or id ==57 or id == 72 or id == 73 or id == 77 or id == 79 or id == 81 then    
    self.tips:initialize(content,self,self.gantanhaoConfirm,data,nil,nil,nil,textTable,false,true);
  elseif id == 4 or id == 5 then --1个按钮的有字的
    self.tips:initialize(content,self,self.gantanhaoConfirm,data,nil,nil,true,textTable,nil,true);
  elseif id == 22 then --单按钮/多颜色
    self.tips:initialize(content,self,self.gantanhaoConfirm,data,nil,nil,true,nil,true,true);
  else -- 默认就一个确定按钮/单颜色
    self.tips:initialize(content,self,self.gantanhaoConfirm,data,nil,nil,true,nil,nil,true);
  end
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.tips);
  
end

function MainSceneMediator:refreshVip()
  self.viewComponent.mainUI.userInfoGroupUI:refreshVip()
end

function MainSceneMediator:refreshUserLevel()
  self.viewComponent.mainUI.userInfoGroupUI:refreshUserLevel()
end
function MainSceneMediator:refreshUserName()
  self.viewComponent.mainUI.userInfoGroupUI:refreshUserName()
end

function MainSceneMediator:refreshFirstPayToSecondPay( booleanValue)
  self.viewComponent.mainUI.userInfoGroupUI:refreshFirstPayToSecondPay(booleanValue);
end

function MainSceneMediator:refreshSecondPay( booleanValue )
  self.viewComponent.mainUI.userInfoGroupUI:refreshSecondPay( booleanValue );
end

function MainSceneMediator:openBagUICallBack()
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_AVATAR));
end
function MainSceneMediator:gantanhaoConfirm(event)
  local data = self.tips.confirmData
  local id = data["id"] 
  local uiid = data["uiid"]

end

function MainSceneMediator:openFunctionEffect(functionID)
  if self.viewComponent and self.viewComponent.mainUI then
    self.viewComponent.mainUI:openFunctionEffect(functionID);
  end
end

function MainSceneMediator:onSmallChatMenu(event)
  self:sendNotification(SmallChatNotification.new(SmallChatNotifications.SMALL_CHAT_MENU));
end

--Ã¥Ââ€¡Ã§ÂºÂ§
function MainSceneMediator:showLevelUp(effectProxy,currentLvInfo,nextLvInfo)
  self.viewComponent.mapScene:showLevelUp(effectProxy,currentLvInfo,nextLvInfo);
end
function MainSceneMediator:onRemove()

end

function MainSceneMediator:setGantanhao(dataTable)
  self.viewComponent.mainUI:setGantanhao(dataTable)
end
-------------------------------------------------effect----------------------------------------------------------

function MainSceneMediator:refreshChatNumber()
  self:getViewComponent().mainUI.effectChatNumber:refresh();
  self:getViewComponent().mainUI:refreshChatPrivateAndBuddyEffect();
end

function MainSceneMediator:refreshChatNumberByBuddyDelete(num)
  self:getViewComponent().mainUI.effectChatNumber:setNum(num);
  self:getViewComponent().mainUI:refreshChatPrivateAndBuddyEffect();
end
----------------------------------------------touch-----------------------------------------------

function MainSceneMediator:recoveryTouch()
  self.viewComponent.mainUI.touchChildren = true;
end

--------------------------------------------------------------------------------------------------

function MainSceneMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND,event.data));
end

function MainSceneMediator:onItemTipRemove(event)
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND));
end

function MainSceneMediator:cleanMapScene()
  self:getViewComponent().mapScene:clean();
end

function MainSceneMediator:refreshBuddyCommendButton()
  self:getViewComponent().mainUI:refreshBuddyCommendButton();
end

function MainSceneMediator:addOrUpdateOtherPlayer(otherPlayerInfo,isOtherPlayerOn)
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene:addOrUpdateOtherPlayer(otherPlayerInfo,isOtherPlayerOn)
  end
end
function MainSceneMediator:refreshFamilyBanquet(BanquetInfoArray)
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene:refreshFamilyBanquet(BanquetInfoArray)
  end
end
function MainSceneMediator:removeOtherPlayer(userId)
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene:removeOtherPlayer(userId)
  end
end
function MainSceneMediator:refreshGongGao(gongGao)
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene.mapOuterLayer:refreshGongGao(gongGao)
  end
end
function MainSceneMediator:refreshBangZhu(userName, confingId)
  if self.viewComponent and self.viewComponent.mapScene then
    self.viewComponent.mapScene.mapOuterLayer:refreshBangZhu(userName, confingId)
  end
end
-- function MainSceneMediator:addBanquetPerson(id, count)
--   if self.viewComponent and self.viewComponent.mapScene then
--     self.viewComponent.mapScene.playerLayer:addBanquetPerson(id, count);
--     -- self.viewComponent.mapScene:setBanquetIdArray(userIdNameArray);
--   end
-- end

function MainSceneMediator:refreshHuoDongLogin()
  self.viewComponent.mainUI.userInfoGroupUI:refreshHuoDongLogin();
end

function MainSceneMediator:refreshHuoDong()
  self.viewComponent.mainUI.userInfoGroupUI:refreshHuoDong();
end
function MainSceneMediator:refreshHuoDongReddot(boolean)
  -- add by mohai.wu 
  self.viewComponent.mainUI.userInfoGroupUI:refreshHuoDongReddot(boolean);
end


function MainSceneMediator:refreshMonthCard()
  self.viewComponent.mainUI.userInfoGroupUI:refreshMonthCard();
end

function MainSceneMediator:refreshFirstPayLogin(booleanValue)
  self.viewComponent.mainUI.userInfoGroupUI:refreshFirstPayLogin(booleanValue);
end

function MainSceneMediator:refreshSevenDays( booleanValue )
  self.viewComponent.mainUI.userInfoGroupUI:refreshSevenDays(booleanValue);
end

function MainSceneMediator:openSevenDaysIcon(  )
  self.viewComponent.mainUI.userInfoGroupUI:openSevenDaysIcon();
end

function MainSceneMediator:openButtons(displayMenuHTable)
  self.viewComponent.mainUI.userInfoGroupUI:openButtons(displayMenuHTable);
end

function MainSceneMediator:closeButtonsByFunctionID( FUNCTION_ID )
  self.viewComponent.mainUI.userInfoGroupUI:closeButtonsByFunctionID(FUNCTION_ID);
end

function MainSceneMediator:refreshRedIcon(value)
  self.viewComponent.mainUI.userInfoGroupUI:refreshRedIcon(value);
end

function MainSceneMediator:getTargetButtonPosition(functionId)
  local returnData = self.viewComponent.mainUI.userInfoGroupUI:getTargetButtonPosition(functionId);
  print("returnData.x, returnData.y", returnData.x, returnData.y)
  return returnData;
end

