
require "core.display.LayerPopable";
require "main.view.quickBattle.ui.MopUpResultUI";
StrongPointInfoPopup=class(LayerPopableDirect);

function StrongPointInfoPopup:ctor()
  self.class=StrongPointInfoPopup;
  self.renderItems = {};
  self.itemArray = {};
  self.zhanli = 0;
  self.count = 0;
end

function StrongPointInfoPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	StrongPointInfoPopup.superclass.dispose(self);
  self.armature:dispose()
	BitmapCacher:removeUnused();
end
function StrongPointInfoPopup:initializeUI()
  self.renderItems = {};

  -- self.bg_image = Image.new();
  -- self.bg_image:loadByArtID(StaticArtsConfig.BACKGROUD_STORYLINE)
  -- -- self.bg_image:setScale(2)
  -- self:addChild(self.bg_image)

  self.itemSize = CCSizeMake(639, 141  * 2);
  self.viewSize = CCSizeMake(1280, 141  * 2.5);

  self.curRenderIndex = 1;

end
function StrongPointInfoPopup:onDataInit()

  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name);
  self.heroHouseProxy=self:retrieveProxy(HeroHouseProxy.name);
  self.buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  self.skeleton = self.storyLineProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,true)
  layerPopableData:setArmatureInitParam(self.skeleton,"strongPoint_ui");
  self:setLayerPopableData(layerPopableData);
end

function StrongPointInfoPopup:onUIInit()
  
  self.uiHasInit = true;
  self:refreshStrongPointInfo(self.strongPointId)
end

function StrongPointInfoPopup:onPrePop()

  self:addChild(self.armature.display);

  -- local count_descTextData = self.armature:getBone("count_desc").textData;
  -- self.count_desc =  createTextFieldWithTextData(count_descTextData, "剩余次数0");
  -- self.armature.display:addChild(self.count_desc);
  -- self.count_desc.touchEnabled = false;

  local strongPoint_descTextData = self.armature:getBone("strongPoint_desc").textData;
  self.strongPoint_desc =  createTextFieldWithTextData(strongPoint_descTextData, "关卡信息");
  self.armature.display:addChild(self.strongPoint_desc);
  
  local shuoMing1Data = self.armature:getBone("shuoMing1").textData;
  self.shuoMing1 = createTextFieldWithTextData(shuoMing1Data, "简介：");
  self.armature.display:addChild(self.shuoMing1);

  local storyLineDesc1Data = self.armature:getBone("storyLineDesc1").textData;
  local storyLineDesc1text =  analysis("Juqing_Guanka", self.strongPointId, "info");
  self.storyLineDesc1 = createTextFieldWithTextData(storyLineDesc1Data, storyLineDesc1text);
  self.armature.display:addChild(self.storyLineDesc1);
  
  local expImage = Image.new();
  expImage:loadByArtID(768);
  expImage:setScale(0.45)
  self.armature.display:addChild(expImage);
  expImage:setPositionXY(921, 440);


  local tili_consume_txtTextData = self.armature:getBone("tili_consume_txt").textData;
  self.tili_consume_txt =  createTextFieldWithTextData(tili_consume_txtTextData, "体力消耗：6");
  self.armature.display:addChild(self.tili_consume_txt);
  self.tili_consume_txt.touchEnabled = false;


   local strongPointName_txtTextData = self.armature:getBone("strongPointName_txt").textData;
  self.strongPointName_txt =  createTextFieldWithTextData(strongPointName_txtTextData, "第一章");
  self.armature.display:addChild(self.strongPointName_txt);

   local storyLineDescTextData = self.armature:getBone("storyLineDesc").textData;
  self.storyLineDesc =  createTextFieldWithTextData(storyLineDescTextData, "琅琊山下描述");
  self.armature.display:addChild(self.storyLineDesc);
  
  local shuoMingTextData = self.armature:getBone("shuoMing").textData;
  self.shuoMing =  createTextFieldWithTextData(shuoMingTextData, "说明：");
  self.armature.display:addChild(self.shuoMing);

  local dropOutTextData = self.armature:getBone("dropOut").textData;
  self.dropOut =  createTextFieldWithTextData(dropOutTextData, "掉落：");
  self.armature.display:addChild(self.dropOut);

  local silver_txtTextData = self.armature:getBone("silver_txt").textData;
  self.silver_txt =  createTextFieldWithTextData(silver_txtTextData, "0");
  self.armature.display:addChild(self.silver_txt);

  local functionStart=analysis("Gongnengkaiqi_Gongnengkaiqi", 39, "generals")
  self.functionStartStr = "主角"..tostring(functionStart).."级开启扫荡功能"

  self.curItemCount = self.bagProxy:getItemNum(1015003)
  print("self.curItemCount", self.curItemCount)

  local saoDangQuan_txtTextData = self.armature:getBone("saoDangQuan_txt").textData;
  self.saoDangQuan_txt =  createTextFieldWithTextData(saoDangQuan_txtTextData, "剩余扫荡券：" .. self.curItemCount);
  self.armature.display:addChild(self.saoDangQuan_txt);
  self.saoDangQuan_txt.touchEnabled = false;

  local mopupCondition_txtTextData = self.armature:getBone("mopupCondition_txt").textData;
  self.mopupCondition_txt =  createTextFieldWithTextData(mopupCondition_txtTextData, self.functionStartStr);
  self.armature.display:addChild(self.mopupCondition_txt);
  self.mopupCondition_txt.touchEnabled = false;
 
  local mopup10Condition_txtTextData = self.armature:getBone("mopup10Condition_txt").textData;
  self.mopup10Condition_txt =  createTextFieldWithTextData(mopup10Condition_txtTextData, "vip4开启");
  self.armature.display:addChild(self.mopup10Condition_txt);
  self.mopup10Condition_txt.touchEnabled = false;

  local exp_txtTextData = self.armature:getBone("exp_txt").textData;
  self.exp_txt =  createTextFieldWithTextData(exp_txtTextData, "0");
  self.armature.display:addChild(self.exp_txt);


  local textArm = self.armature:findChildArmature("mopUp_button");
  local trimButtonData=textArm:getBone("common_small_blue_button").textData;

  self.mopUp_button = self.armature.display:getChildByName("mopUp_button");
  local mopUp_button_pos=convertBone2LB4Button(self.mopUp_button);
  self.armature.display:removeChild(self.mopUp_button);

  self.mopUp_button=CommonButton.new();
  self.mopUp_button:initialize("common_small_blue_button_normal",nil, CommonButtonTouchable.BUTTON);
  self.mopUp_button:initializeText(trimButtonData, "扫荡1次",true);
  self.mopUp_button:setPosition(mopUp_button_pos);
  self.mopUp_button:addEventListener(DisplayEvents.kTouchTap,self.onMopUp1,self);
  self.armature.display:addChild(self.mopUp_button);

 
  self.mopUp10_button = self.armature.display:getChildByName("mopUp10_button");
  local editTeam_button_pos=convertBone2LB4Button(self.mopUp10_button);
  self.armature.display:removeChild(self.mopUp10_button);

  self.mopUp10_button=CommonButton.new();
  self.mopUp10_button:initialize("common_small_blue_button_normal",nil, CommonButtonTouchable.BUTTON);
  self.mopUp10_button:initializeText(trimButtonData,"扫荡10次",true);
  self.mopUp10_button:setPosition(editTeam_button_pos);
  self.mopUp10_button:addEventListener(DisplayEvents.kTouchTap,self.onMopUp10,self);
  self.armature.display:addChild(self.mopUp10_button);

  local item1 = self.armature.display:getChildByName("item1");
  local item2 = self.armature.display:getChildByName("item2");

  self.item1Pos = convertBone2LB(item1);
  self.armature.display:removeChild(item1);

  local item2Pos = convertBone2LB(item2);
  self.skew_x = item2Pos.x - self.item1Pos.x;
  self.armature.display:removeChild(item2);

  self.enter_button = self.armature.display:getChildByName("enter_button");

  SingleButton:create(self.enter_button, nil, 0);
  self.enter_button:addEventListener(DisplayEvents.kTouchTap, self.onBattleTap, self);
  self.enter_button:setPositionXY(self.enter_button:getPositionX(),self.enter_button:getPositionY())
  -- self.enter_button:setAnchorPoint(ccp(0.5,0.5))
  -- self.mopUp_button:setVisible(self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_39))

  local darkstar3 = self.armature.display:getChildByName("darkstar3");
  local darkstar2 = self.armature.display:getChildByName("darkstar2");
  local darkstar1 = self.armature.display:getChildByName("darkstar1");

  local starNum = self.storyLineProxy:getStrongPointStarCount(self.strongPointId);
  local brightstar1 = self.armature.display:getChildByName("brightstar1");
  local brightstar2 = self.armature.display:getChildByName("brightstar2");
  local brightstar3 = self.armature.display:getChildByName("brightstar3");

  brightstar1:setVisible((starNum >= 1) and true or false)
  brightstar2:setVisible((starNum >= 2) and true or false)
  brightstar3:setVisible((starNum >= 3) and true or false)

end
function StrongPointInfoPopup:getItemPrice()
  local shopItems = analysisByName("Shangdian_Shangdianwupin", "itemid", 1015003);
  for k, v in pairs(shopItems)do
    if v.type == 3 then
      return v.price;
    end
  end
end
function StrongPointInfoPopup:onMopUp1(event)

      local function timerLoop()
        self.mopUp_button.touchEnabled = true;
        self.mopUp_button.touchChildren = true;
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
      end
      self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 2, false)

    if self.bagProxy:getBagIsFull() then
      sharedTextAnimateReward():animateStartByString("背包已满清理一下吧");
    else

      local itemCount = self.bagProxy:getItemNum(1015003)
      local itemPrice = self:getItemPrice();

      local function onConfirm()
        if itemCount < 1 and self.userCurrencyProxy.gold < itemPrice then
          sharedTextAnimateReward():animateStartByString("元宝不足~");
          self:dispatchEvent(Event.new("gotochongzhi",nil,self));
        else
          if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
            self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
          else
            self:popUpAndSendMessage(1)
          end
        end
      end

      local tipsStr = ""
      if itemCount < 1 then
        tipsStr = "扫荡券不足，是否花费" .. itemPrice .. "元宝直接购买?"
        local tips=CommonPopup.new();
        tips:initialize(tipsStr,self,onConfirm,nil,noToBuy,nil,nil,nil,nil,true);
        tips:setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
        self:addChild(tips)
      else
        onConfirm()
      end
    end
    self.mopUp_button.touchEnabled = false
    self.mopUp_button.touchChildren = false;
end
function StrongPointInfoPopup:onMopUp10(event)
  if self.userProxy:getVipLevel() <4 then
      sharedTextAnimateReward():animateStartByString("vip4级才开启哦");
      return;
  end
    if self.bagProxy:getBagIsFull() then
      sharedTextAnimateReward():animateStartByString("背包已满清理一下吧");
   
    else
      local maxCount = math.floor(self.userCurrencyProxy.tili/self.strongPointPo.depletion);
      maxCount = math.min(maxCount, 10)
      local itemCount = self.bagProxy:getItemNum(1015003)
      local itemPrice = self:getItemPrice();

      local function onConfirm()
        if itemCount < maxCount and self.userCurrencyProxy.gold < itemPrice *(maxCount - itemCount) then
          sharedTextAnimateReward():animateStartByString("元宝不足~");
          self:dispatchEvent(Event.new("gotochongzhi",nil,self));
        else
          if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
            self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
          else
            self:popUpAndSendMessage(maxCount)
          end
        end
      end

      if itemCount < maxCount then
        local tipsStr = "扫荡券不足，是否花费" .. itemPrice * (maxCount - itemCount) .. "元宝直接购买?"
        local tips=CommonPopup.new();
        tips:initialize(tipsStr,self,onConfirm,nil,noToBuy,nil,nil,nil,nil,true);
        tips:setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
        self:addChild(tips)
      else
        onConfirm()
      end
    end
end

function StrongPointInfoPopup:popUpAndSendMessage(count)
    print("count StrongPointId", count,self.strongPointId)
    sendMessage(7, 58, {StrongPointId = self.strongPointId, Count = count})

    self.mopUpResultUI = MopUpResultUI.new();
    self.mopUpResultUI:initializeUI(self.storyLineProxy:getSkeleton(), self)
    self:addChild(self.mopUpResultUI);
end

function StrongPointInfoPopup:refreshCount(count, saoDangQuanCount)
  self.count = count;
  if not self.count then
    self.count = 0;
  end
  print("saoDangQuanCount", saoDangQuanCount)
  if saoDangQuanCount ~= 0 then
    self.curItemCount = self.curItemCount + saoDangQuanCount;
    if self.curItemCount < 0 then
      self.curItemCount = 0;
    end
    self.saoDangQuan_txt:setString("剩余扫荡券：" .. self.curItemCount)
  else
    if self.curItemCount == 0 then
      self.saoDangQuan_txt:setString("剩余扫荡券：" .. saoDangQuanCount + 1)  
    else
      self.saoDangQuan_txt:setString("剩余扫荡券：" .. self.curItemCount)  
    end
  end

  -- self.count_desc:setString("剩余次数：" .. (self.strongPointPo.cishu - count));
end

function StrongPointInfoPopup:removeLayerData()
    for key,value in pairs(self.itemArray) do
        value.parent:removeChild(value)
    end
    self.itemArray = {}
    self.zhanli = 0
end
function StrongPointInfoPopup:initialize()
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
end

function StrongPointInfoPopup:refreshStrongPointInfo(strongPointId)
  self.strongPointId = strongPointId
  if not self.uiHasInit then return end;

  self:setStrongPointInfo();

end
function StrongPointInfoPopup:refreshTili()
  self.tili_consume_txt:setString("体力消耗："..self.strongPointPo.depletion);

  self.mopRemainCount = math.floor(self.userCurrencyProxy.tili/self.strongPointPo.depletion);
 
  if self.mopRemainCount >= 10 then
    self.mopUp10_button:setString("扫荡10次")
  elseif self.mopRemainCount >= 1 then
    self.mopUp10_button:setString("扫荡"..tostring(self.mopRemainCount).."次")
  elseif self.mopRemainCount == 0 then
    self.mopUp10_button:setString("扫荡10次")
  end

  if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
    self.tili_consume_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
  else
    self.tili_consume_txt:setColor(CommonUtils:ccc3FromUInt(16775892));
  end
end
function StrongPointInfoPopup:checkMopUp10()
    local vipLevel=0;
    while 15>vipLevel do
      vipLevel=1+vipLevel;
      if 0<analysis("Huiyuan_Huiyuantequan",13,"vip" .. vipLevel) then
        break;
      end
    end
    print("==================vipLevel", vipLevel)
    if self.userProxy.vipLevel >= vipLevel then
      return true;
    else
      return false
    end
end
function StrongPointInfoPopup:setStrongPointInfo()

  local strongPointData = self.storyLineProxy.strongPointArray["key_"..self.strongPointId];
--判断扫荡是否开启
  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_39) then
    self.mopupCondition_txt:setVisible(false)
    local isThreeStar = self.storyLineProxy:getStrongPointStarCount(self.strongPointId);
    if isThreeStar == 3 then

      self.mopUp_button:setVisible(true)
      self.mopUp10_button:setVisible(true)
      if self:checkMopUp10() then
        print("77777777777777777777777checkMopUp10 true")
        self.mopup10Condition_txt:setVisible(false)
      else
        print("88888888888888888888888checkMopUp10 false")
        self.mopup10Condition_txt:setVisible(true)
      end
      self.saoDangQuan_txt:setVisible(true)
    else
      self.saoDangQuan_txt:setVisible(false)
      self.mopupCondition_txt:setString("三星通关可扫荡本关卡")
      self.mopupCondition_txt:setVisible(true)
      
      print("99999999999999999999999999999999999999999")
      self.mopup10Condition_txt:setVisible(false)
      self.mopUp_button:setVisible(false)
      self.mopUp10_button:setVisible(false)
    end
  else
    self.saoDangQuan_txt:setVisible(false)
    self.mopupCondition_txt:setString(self.functionStartStr)
    self.mopupCondition_txt:setVisible(true)
    self.mopup10Condition_txt:setVisible(false)

    self.mopUp_button:setVisible(false)
    self.mopUp10_button:setVisible(false)
  end


  self.strongPointPo = analysis("Juqing_Guanka", self.strongPointId);
  self.storyLineDesc:setString(self.strongPointPo.describe);

  self.tili_consume_txt:setString("体力消耗："..self.strongPointPo.depletion);
  if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
    self.tili_consume_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
  end

  local strongPointLv = analysis("Zhandoupeizhi_Zhanchangpeizhi", self.strongPointPo.id, "lv");
  
  self.imag = Image.new()
  self.imag:loadByArtID(self.strongPointPo.art1)
  self.imag:setScale(0.9)
  self.armature.display:addChildAt(self.imag,0)
  self.imag.touchEnabled = false;
  self.imag:setPositionXY(0,0) 

  local boss_bg = self.armature.display:getChildByName("boss_bg");
  local jingying_bg = self.armature.display:getChildByName("jingying_bg");
  if self.strongPointPo.type ~= 3 then
    boss_bg:setVisible(false)
  end
  if self.strongPointPo.type ~= 2 then
    jingying_bg:setVisible(false)
  end

  self.strongPointName_txt:setString(self.strongPointPo.scenarioName)

 --设置掉落
  self.totalGlobalTable = {};
  local tempMap = {};
  local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", self.strongPointPo.id);

  for k, v in pairs(dropItems) do
     if not tempMap[v.itemId] then
      tempMap[v.itemId] = v.itemId
      table.insert(self.totalGlobalTable, v.itemId)
     end
  end

  local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
  for k, v in pairs(tempTotalGlobalTable) do
    if strongPointLv >= v.minLv and strongPointLv <= v.maxLv and 1 == v.Gtype then
       if not tempMap[v.itemId] then
        tempMap[v.itemId] = v.itemId
        table.insert(self.totalGlobalTable, v.itemId)
       end
    end
  end

  local function sortFun(a, b)
    local color1 = analysis("Daoju_Daojubiao", a, "color")
    local color2 = analysis("Daoju_Daojubiao", b, "color")
    if color1 > color2 then
      return true;
    elseif color1 < color2 then
      return false;
    else
      return false;
    end
  end
  table.sort(self.totalGlobalTable, sortFun);

  local index = 1;
  for k, v in pairs(self.totalGlobalTable) do
    if index > 3 then
      break;
    end
    local itemImage = BagItem.new(); 
    itemImage:initialize({ItemId = tonumber(v), Count = 1});
    itemImage:setBackgroundVisible(true)
    itemImage:setPositionXY(self.item1Pos.x + (index-1) * self.skew_x, self.item1Pos.y + 10);
    itemImage.touchEnabled=true
    itemImage.touchChildren=true
    itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
    self:addChild(itemImage);
    index = index + 1;
  end

  local dropCurrencys = StringUtils:stuff_string_split(self.strongPointPo.get)
  for k, v in pairs(dropCurrencys) do
    local itemId = tonumber(v[1]);
    if itemId == 1 then
      self.exp_txt:setString(v[2]);
    elseif itemId == 2 then
      self.silver_txt:setString(v[2]);
    end
  end

end

function StrongPointInfoPopup:onItemTip(event)
  print("StrongPointInfoPopup:onItemTip")
  self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self))
end


function StrongPointInfoPopup:onEnterBattle(event)

    
    if self.userCurrencyProxy.tili <  self.strongPointPo.depletion then
      self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
      return true;
    else
      self:dispatchEvent(Event.new("ENTER_BUTTON_CLICK",nil,self));
    end
end

--@overwrite
function StrongPointInfoPopup:onUIClose()
   self:dispatchEvent(Event.new("CLOSE_STORY_LINE_INFO",nil,self));
end

function StrongPointInfoPopup:clean()
  
end
function StrongPointInfoPopup:refreshByOther(event)

end

function StrongPointInfoPopup:onBattleTap(event)
  MusicUtils:playEffect(7,false);
  if self.userCurrencyProxy.tili <  self.strongPointPo.depletion then
    self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
    return true;
  -- elseif GameVar.tutorStage == TutorConfig.STAGE_1002 then
  --   self:onEnterBattle();
  else
    self:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterBattle, onClose = self.refreshByOther, ZhanChangWuXing=self.strongPointPo.showWuxing},self));
  end
end

function StrongPointInfoPopup:refreshData(RoundItemIdArray, StrongPointId)
  self.mopUpResultUI:refreshData(RoundItemIdArray, StrongPointId)
end
