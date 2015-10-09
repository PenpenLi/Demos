require "main.view.shadow.ui.heroImage.ShadowItemPageView"
require "main.view.shadow.ui.heroImage.ShadowHeroImageRender";
require "main.view.shadow.ui.heroImage.ShadowZhuanPopup"
ShadowHeroImagePopup=class(LayerPopableDirect);

function ShadowHeroImagePopup:ctor()
  self.class=ShadowHeroImagePopup;
  self.curIndex = 1;
  self.isChangeEnable = true;
  self.curItemCount = 0;
end

function ShadowHeroImagePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ShadowHeroImagePopup.superclass.dispose(self);
	BitmapCacher:removeUnused();
end
function ShadowHeroImagePopup:initializeUI(strongPointId)
  self.strongPointId = strongPointId;
  self.renderItems = {};
end
function ShadowHeroImagePopup:onDataInit()

  self.shadowProxy=self:retrieveProxy(ShadowProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name)
  self.dataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);

  self.skeleton = self.shadowProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroImage_ui");
  self:setLayerPopableData(layerPopableData);

  self.renders = {};
  self.longBodyRenders = {};
  self.itemRenders = {};
end

function ShadowHeroImagePopup:initialize()
  self:initLayer();

  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));
end

function ShadowHeroImagePopup:onPrePop()

  self.armature.display.touchEnabled=true;
  self:addChild(self.armature.display)

end
function ShadowHeroImagePopup:onUIInit()



  local layerColor1 = LayerColor.new();
  layerColor1:initLayer();
  layerColor1:changeWidthAndHeight(self.mainSize.width, self.mainSize.height);
  layerColor1:setColor(ccc3(0,0,0));
  layerColor1:setOpacity(170);
  layerColor1:setPositionXY(-GameData.uiOffsetX, -GameData.uiOffsetY)
  self:addChildAt(layerColor1,1)   


  local layerColor2 = LayerColor.new();
  layerColor2:initLayer();
  layerColor2:changeWidthAndHeight(self.mainSize.width, 130);
  layerColor2:setColor(ccc3(0,0,0));
  layerColor2:setOpacity(100);
  layerColor2:setPositionXY(0,568)
  self:addChildAt(layerColor2,2)   


  self.armature_d = self.armature.display;

  local text1_TextData = self.armature:getBone("text1").textData;
  self.text1 =  createTextFieldWithTextData(text1_TextData, "战斗掉落");
  self.text1.touchEnabled = false;
  self.armature_d:addChild(self.text1); 


  local text2_TextData = self.armature:getBone("text2").textData;
  self.text2 =  createTextFieldWithTextData(text2_TextData, "剩余次数：");
  self.text2.touchEnabled = false;
  self.armature_d:addChild(self.text2);  

  local text3_TextData = self.armature:getBone("text3").textData;
  self.text3=  createTextFieldWithTextData(text3_TextData, "需要体力：");
  self.text3.touchEnabled = false;
  self.armature_d:addChild(self.text3);  



  print("strongPointId", strongPointId)

  local cishu_TextData = self.armature:getBone("cishu").textData;
  self.cishu =  createTextFieldWithTextData(cishu_TextData, 1);
  self.armature_d:addChild(self.cishu); 
  self.cishu.touchEnabled = false; 

  local tili_TextData = self.armature:getBone("tili").textData;
  self.tili =  createTextFieldWithTextData(tili_TextData,"1");
  self.tili.touchEnabled = false; 
  self.armature_d:addChild(self.tili);  

  local saoDangQuan_txtData = self.armature:getBone("saoDangQuan_txt").textData;
  self.saoDangQuan_txt =  createTextFieldWithTextData(saoDangQuan_txtData, "剩余扫荡券: 10");
  self.armature_d:addChild(self.saoDangQuan_txt); 
  self.saoDangQuan_txt.touchEnabled = false; 

  local saoDangDesc_txtData = self.armature:getBone("saoDangDesc_txt").textData;
  self.saoDangDesc_txt =  createTextFieldWithTextData(saoDangDesc_txtData, "三星通关可扫荡");
  self.armature_d:addChild(self.saoDangDesc_txt); 
  self.saoDangDesc_txt.touchEnabled = false; 

  self.enter_button = self.armature.display:getChildByName("enter_button");

  SingleButton:create(self.enter_button, nil);
  self.enter_button:addEventListener(DisplayEvents.kTouchTap, self.onBattleTap, self);
  self.enter_button:setPositionXY(self.enter_button:getPositionX(),self.enter_button:getPositionY())
  self.enter_button:setAnchorPoint(ccp(0.5,0.5))

  self.mopUp_button = self.armature.display:getChildByName("mopUp_button");
 
  SingleButton:create(self.mopUp_button, nil);
  self.mopUp_button:addEventListener(DisplayEvents.kTouchTap, self.onMopUpTap, self);
  self.mopUp_button:setPositionXY(self.mopUp_button:getPositionX(),self.mopUp_button:getPositionY())
  self.mopUp_button:setAnchorPoint(ccp(0.5,0.5))

  self.zhuan_bg = self.armature.display:getChildByName("zhuan_bg");

  self.armature.display:removeChild(self.zhuan_bg, false);

  SingleButton:create(self.zhuan_bg, nil);
  self.zhuan_bg:addEventListener(DisplayEvents.kTouchTap, self.onZhuanTap, self);
  self.zhuan_bg:setAnchorPoint(ccp(0.5,0.5))


  self.scrollView=ShadowItemPageView.new(CCPageView:create());

  self.scrollView:initialize(self);
  
  self.scrollView:setPositionXY(118,550);
  self.armature_d:addChild(self.scrollView);

  self:addChild(self.zhuan_bg)
  
  local function onPageViewScrollStoped()
    self.scrollView:onPageViewScrollStoped();
    if self.scrollView:getCurrentPage() == 1 then
      if self.left_arrow then
        self.left_arrow:setVisible(false)
        self.right_arrow:setVisible(true)
      end
    elseif self.scrollView:getCurrentPage() == 2 then
      if self.left_arrow then
        self.left_arrow:setVisible(true)
        self.right_arrow:setVisible(false)
      end
    end
  end
  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);

  self.luaTable = analysisTotalTableArray("Juqing_Yingxiongzhi")
  local function sortfunction(a, b)
    if a.shunxuID < b.shunxuID then
      return true
    elseif a.shunxuID > b.shunxuID then
      return false
    else
      return false;
    end
  end
  table.sort(self.luaTable, sortfunction )
  self.scrollView:update(self.luaTable)

  self.left_arrow = self.armature.display:getChildByName("left_arrow");
  self.left_arrow.parent:removeChild(self.left_arrow, false)
  self.armature_d:addChild(self.left_arrow)

  SingleButton:create(self.left_arrow, nil, 0);
  self.left_arrow:addEventListener(DisplayEvents.kTouchTap, self.onLeftArrowTap, self);
  self.left_arrow:setAnchorPoint(ccp(0.5,0.5))


  self.right_arrow = self.armature.display:getChildByName("right_arrow");
  self.right_arrow.parent:removeChild(self.right_arrow, false)
  self.armature_d:addChild(self.right_arrow)


  SingleButton:create(self.right_arrow, nil, 0);
  self.right_arrow:addEventListener(DisplayEvents.kTouchTap, self.onRightArrowTap, self);
  self.right_arrow:setAnchorPoint(ccp(0.5,0.5))

  local common_copy_close_button = self.armature.display:getChildByName("common_copy_close_button");
  common_copy_close_button.parent:removeChild(common_copy_close_button, false);
  self.armature_d:addChild(common_copy_close_button);

  local strongPointId
  if self.strongPointId then
    strongPointId = self.strongPointId
  else
    strongPointId = self.shadowProxy:getCurStrongPointId(self.storyLineProxy)
  end
  print("setData strongPointId", strongPointId)

  self.curItemCount = self.bagProxy:getItemNum(1015003);
  self.saoDangQuan_txt:setString("剩余扫荡券: " .. self.curItemCount);

  self:setData(strongPointId);
end
function ShadowHeroImagePopup:refreshItems(strongPointId)


  local function callBackFun()
    self:removeChild(self.boneCartoon);
    self.boneCartoon = nil;
    self.isChangeEnable = true;
    self:playCallBack(strongPointId)
  end
  self.boneCartoon = cartoonPlayer("1160",640,362,1,callBackFun,2,nil)
  self:addChild(self.boneCartoon)
  self.isChangeEnable = false;





end

function ShadowHeroImagePopup:playCallBack(strongPointId)
  for k, v in pairs(self.renders)do
    if v.yxzPo then
      if strongPointId == v.yxzPo.id then
        v:setNormalScale();
      else
        v:setSmallScale();
      end
    end
  end

  self:refreshLongBody(strongPointId);
  self:refreshDropItem(strongPointId);
  self:setDescribe(strongPointId);
  self.strongPointId = strongPointId;

  self.strongPointPo = analysis("Juqing_Guanka", self.strongPointId)

  local finishCount = self.storyLineProxy:getStrongPointFinishCount(self.strongPointId);
  self.count = finishCount;
  print("strongPointId, finishCount", strongPointId, finishCount)
  self.cishu:setString((self.strongPointPo.cishu - finishCount) .. "次")
  self:refreshTili()
  self:refreshButton()

  if self.zhuanCartoon then
    self:removeChild(self.zhuanCartoon);
    self.zhuanCartoon = nil;
  end
  local totalCount = self.storyLineProxy:getStrongPointTotalCount(strongPointId);
  if totalCount > 0 then
    self.zhuan_bg:setVisible(true)  
    self:swapChildren(self.zhuan_bg, self.boneCartoon)
    self:setZhuanEffect(strongPointId);

  else
    self.zhuan_bg:setVisible(false)  
  end

end  
function ShadowHeroImagePopup:setZhuanEffect(strongPointId)

  local value = self.dataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_28, strongPointId)
  print("self.dataAccumulateProxy value", value)

  if value == 1 then
    self.zhuanCartoon = cartoonPlayer("1386",1130,491,0,0,1,nil)
    self:addChild(self.zhuanCartoon)
    sharedTextAnimateReward():animateStartByString("新的传记开启了哦");
  else
    
  end
end
function ShadowHeroImagePopup:onLeftArrowTap(event)
  print("onLeftArrowTap")
  self.scrollView:setCurrentPage(1)
  MusicUtils:playEffect(7,false);

end
function ShadowHeroImagePopup:onRightArrowTap(event)
  print("onRightArrowTap")
  self.scrollView:setCurrentPage(2)
  MusicUtils:playEffect(7,false);
end
function ShadowHeroImagePopup:onZhuanTap(event)
  print("onZhuanTap")

  hecDC(3,30,3)

  self.shadowZhuanPopup = ShadowZhuanPopup.new();
  self.shadowZhuanPopup:initialize(self, self.strongPointId)


  LayerManager:addLayerPopable(self.shadowZhuanPopup);
  -- self:addChild(self.shadowZhuanPopup)
  -- self.shadowZhuanPopup:addEventListener("CLOSE_ZHUAN", self.onCloseZhuan, self)

  self.scrollView:setMoveEnabled(false);
  
  self.shadowZhuanPopup:setData();

  local value = self.dataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_28, self.strongPointId)
  if value == 1 then
    if self.zhuanCartoon then
      self:removeChild(self.zhuanCartoon);
      self.zhuanCartoon = nil;
    end
    sendMessage(4,8,{StrongPointId=self.strongPointId});
  end
  if  GameVar.tutorStage == TutorConfig.STAGE_1008  then
    openTutorUI({x=0, y=625, width = 74, height = 113, hideTutorHand = true, fullScreenTouchable = true});
  end

  -- self.shadowZhuanPopup:setAnchorPoint(ccp(0.5,0.5));
  -- self.shadowZhuanPopup:setRotation(-90)
  -- self.shadowZhuanPopup:setPositionXY(1280/2, 720/2);
  -- Tweenlite:CardFlipHalf(self.shadowZhuanPopup,0.5)
  -- Tweenlite:flip(self.shadowZhuanPopup,0,20);
end
-- function ShadowHeroImagePopup:onCloseZhuan(event)
--   self.shadowZhuanPopup.parent:removeChild(self.shadowZhuanPopup)
-- end
function ShadowHeroImagePopup:setData(strongPointId)
  self.strongPointId = strongPointId;
  self.strongPointPo = analysis("Juqing_Guanka", self.strongPointId)
  local index = 1;
  for k, v in pairs(self.luaTable)do
    if v.id == strongPointId then
      break;
    end
    index = index + 1;
  end
  if index > 5 then
    self.scrollView:setCurrentPage(2);
    self.right_arrow:setVisible(false);
  else
    self.left_arrow:setVisible(false);
  end
  for k, v in pairs(self.renders)do
    if k == index then
      v:setNormalScale();
    end
  end

  self:refreshLongBody(strongPointId);
  self:refreshDropItem(strongPointId);
  self:setDescribe(strongPointId);


  local finishCount = self.storyLineProxy:getStrongPointFinishCount(strongPointId);
  self.count = finishCount;
  self.cishu:setString((self.strongPointPo.cishu - finishCount) .. "次")

  self:refreshTili()

  local totalCount = self.storyLineProxy:getStrongPointTotalCount(strongPointId);
  if totalCount > 0 then
    self.zhuan_bg:setVisible(true) 
    self:setZhuanEffect(strongPointId);
  else
    self.zhuan_bg:setVisible(false)  
  end

  local state = self.storyLineProxy:getStrongPointState(self.strongPointId);
  local starCount = self.storyLineProxy:getStrongPointStarCount(self.strongPointId);
  print("----------------------------self.strongPointId,state", self.strongPointId, state)
  if state == 1 and starCount == 3 then
    self.saoDangDesc_txt:setVisible(false)
    self.saoDangQuan_txt:setVisible(true)
    self.mopUp_button:setVisible(true)

    self.saoDangQuan_txt:setString("剩余扫荡券: " .. self.curItemCount);
  else
    self.saoDangDesc_txt:setVisible(true)
    self.saoDangQuan_txt:setVisible(false)
    self.mopUp_button:setVisible(false)
  end

end
function ShadowHeroImagePopup:setDescribe(strongPointId)
  local yxzPo = analysis("Juqing_Yingxiongzhi", strongPointId);
  if not self.hero_desc then
    local hero_desc_TextData = self.armature:getBone("hero_desc").textData;
    self.hero_desc =  createTextFieldWithTextData(hero_desc_TextData, yxzPo.describe);
    self.armature_d:addChild(self.hero_desc); 
  else
    self.hero_desc:setString(yxzPo.describe);
  end


  if self.name_img then
    self:removeChild(self.name_img);
    self.name_img = nil;
  end
  local name = yxzPo.name
  local str = "";
  local _count = -1;
  while (-1-string.len(name)) < _count do
    str = str .. string.sub(name, -2 + _count, _count) .. "\n";
    _count = -3 + _count;
  end
  self.name_img=BitmapTextField.new(str,"yingxiongzhi");
  local size = self.name_img:getContentSize();
  self.name_img:setPositionXY(94,408 - size.height);
  self:addChild(self.name_img)



end
function ShadowHeroImagePopup:refreshLongBody(strongPointId)
  for k, v in pairs(self.longBodyRenders)do
    v.parent:removeChild(v);
  end
  self.longBodyRenders = {};

  local heroIdStr = analysis("Juqing_Yingxiongzhi", strongPointId, "heroId");
  local heroIds = StringUtils:lua_string_split(heroIdStr, ",")
  for k,v in pairs(heroIds) do
    local render = ShadowHeroImageRender.new();
    render:initializeUI(self, tonumber(v));
    render:setScale(0.65)
    render:setPositionXY(k* 124 + 50, 106);
    self.armature.display:addChild(render);
    table.insert(self.longBodyRenders, render);
  end
end
function ShadowHeroImagePopup:refreshDropItem(strongPointId)

  for k, v in pairs(self.itemRenders)do
    v.parent:removeChild(v);
  end
  self.itemRenders = {};

  local zcpzPo = analysis("Zhandoupeizhi_Zhanchangpeizhi", strongPointId);
  local strongPointLv = analysis("Zhandoupeizhi_Zhanchangpeizhi", zcpzPo.id, "lv");
  self.totalGlobalTable = {};
  local tempMap = {};
  local dropItems = analysisByName("Diaoluo_Putongdiaoluo", "battleId", zcpzPo.id);

  for k, v in pairs(dropItems) do
     if not tempMap[v.itemId] then
      tempMap[v.itemId] = v.itemId
      table.insert(self.totalGlobalTable, v.itemId)
     end
  end

  local tempTotalGlobalTable = analysisTotalTable("Diaoluo_Guankaquanjudiaoluo")
  for k, v in pairs(tempTotalGlobalTable) do
    if 2 == v.Gtype and strongPointLv >= v.minLv and strongPointLv <= v.maxLv  then
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

  -- print("#self.totalGlobalTable", #self.totalGlobalTable);
  for k, v in pairs(self.totalGlobalTable) do
    if index > 3 then
      break;
    end
    local category = math.floor(v/1000);
    if category == 9900 or category == 9901 or category == 8000 then 
      self:createDropItem(v, index)
      index = index + 1;
    end
  end

  for k, v in pairs(self.totalGlobalTable) do
    if index > 3 then
      break;
    end
    local category = math.floor(v/1000);
    if category ~= 9900 and category ~= 9901 and category ~= 8000 then 
      self:createDropItem(v, index)
      index = index + 1;
    end
  end

end
function ShadowHeroImagePopup:createDropItem(itemId, index)
    local itemPo = analysis("Daoju_Daojubiao", tonumber(itemId))
    print("+++++++++++++++itemId", itemId)
    local xPos = 692 + (index-1) * 96;
    local itemImage = BagItem.new(); 
    itemImage:initialize({ItemId = itemId, Count = 1});
    itemImage:setBackgroundVisible(true)
    itemImage:setPositionXY(xPos, 245);
    itemImage.touchEnabled=true
    itemImage.touchChildren=true
    itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
    self:addChild(itemImage);
    itemImage:setScale(0.8)

    table.insert(self.itemRenders, itemImage);
    self.armature_d:addChild(itemImage);


    -- local diaoluoname_TextData = self.removeArmature:getBone("heroDropItem_txt"..index).textData;
    -- self.diaoluoname =  createTextFieldWithTextData(diaoluoname_TextData, itemPo.name);
    -- self.armature_d:addChild(self.diaoluoname);  
end

function ShadowHeroImagePopup:onItemTip(event)
  self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target},self))
end

function ShadowHeroImagePopup:refreshCount(Count, saoDangQuanCount)
  self.count = Count;
  print("===========================================Count,", Count,saoDangQuanCount)
  if not Count then Count = 0 end
  self.cishu:setString((self.strongPointPo.cishu - Count) .. "次")


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


  local value = self.dataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_28, self.strongPointId)
  print("self.dataAccumulateProxy value", value)

  if value == 1 and not self.zhuanCartoon then
    self.zhuanCartoon = cartoonPlayer("1386",1130,491,0,0,1,nil)
    self:addChild(self.zhuanCartoon)
    sharedTextAnimateReward():animateStartByString("新的传记开启了哦");
  end

end


function ShadowHeroImagePopup:onBattleTap(event)
    print("self:onBattleTap()")
  local finishCount = self.storyLineProxy:getStrongPointFinishCount(self.strongPointId);
  if not finishCount then
    finishCount = 0;
  end

  if self.strongPointPo.cishu <= finishCount then
    sharedTextAnimateReward():animateStartByString("次数已用完");
  elseif self.userCurrencyProxy.tili <  self.strongPointPo.depletion then
    print("self:dispatchEvent")
    self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
  else
    print("self:onEditTeam()")
    self:onEditTeam()
  end
end

function ShadowHeroImagePopup:onMopUpTap(event)

    local function timerLoop()
        self.mopUp_button.touchEnabled = true;
        self.mopUp_button.touchChildren = true;
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
    end
    self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 2, false)

    if self.bagProxy:getBagIsFull() then
      sharedTextAnimateReward():animateStartByString("背包已满清理一下吧");
    else
      local finishCount = self.storyLineProxy:getStrongPointFinishCount(self.strongPointId);
      if self.strongPointPo.cishu <= finishCount then
        sharedTextAnimateReward():animateStartByString("次数已用完");
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
    end
    self.mopUp_button.touchEnabled = false
    self.mopUp_button.touchChildren = false;
end

function ShadowHeroImagePopup:popUpAndSendMessage(count)


    local extensionTable = {}
    extensionTable["yingxiongzhiID"] = self.strongPointId
    hecDC(3,30,2,extensionTable)

    print("count StrongPointId", count,self.strongPointId)
    sendMessage(7, 58, {StrongPointId = self.strongPointId, Count = count})

    self.mopUpResultUI = MopUpResultUI.new();
    self.mopUpResultUI:initializeUI(self.storyLineProxy:getSkeleton(), self)
    self:addChild(self.mopUpResultUI);
end
function ShadowHeroImagePopup:getItemPrice()
  local shopItems = analysisByName("Shangdian_Shangdianwupin", "itemid", 1015003);
  for k, v in pairs(shopItems)do
    if v.type == 3 then
      return v.price;
    end
  end
end
function ShadowHeroImagePopup:onEnterCallBack(event)
   print("self.strongPointId", self.strongPointId)
   local finishCount = self.storyLineProxy:getStrongPointFinishCount(self.strongPointId);
   if not finishCount then
    finishCount = 0;
   end
   if self.strongPointPo.cishu <= finishCount then
      print("ON_ADD_TILI")
      sharedTextAnimateReward():animateStartByString("次数已用完");
      return true;
   elseif self.userCurrencyProxy.tili <  self.strongPointPo.depletion then
      print("ON_ADD_TILI")
      self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
      return true;
   else
      print("ENTER_BUTTON_CLICK")
      self:dispatchEvent(Event.new("ENTER_BUTTON_CLICK",{strongPointId = self.strongPointId},self));
   end
end
function ShadowHeroImagePopup:onEditTeam()

  local strongPointPo = analysis("Juqing_Guanka", self.strongPointId)
  self:dispatchEvent(Event.new(MainSceneNotifications.TO_HEROTEAMSUB,{context = self, onEnter = self.onEnterCallBack, onClose = self.refreshByOtherr,funcType = "Shadow"},self));
end
--@overwrite
function ShadowHeroImagePopup:onUIClose()
   self:dispatchEvent(Event.new("CLOSE_JUANZHOU_PARENT",nil,self));
end

function ShadowHeroImagePopup:clean()
 
end

function ShadowHeroImagePopup:onAsk(event)
  local text=analysis("Tishi_Guizemiaoshu",3,"txt");
  TipsUtil:showTips(self.ask,text,500,nil,50);
end
function ShadowHeroImagePopup:onShowTip()
  local text=analysis("Tishi_Guizemiaoshu",3,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function ShadowHeroImagePopup:refreshTili()
  self.tili:setString(self.strongPointPo.depletion);
  if self.strongPointPo.depletion > self.userCurrencyProxy.tili then
    self.tili:setColor(CommonUtils:ccc3FromUInt(16711680));
  else
    self.tili:setColor(CommonUtils:ccc3FromUInt(0));
  end
end
function ShadowHeroImagePopup:refreshInfo()

end

function ShadowHeroImagePopup:refreshButton()
    local state = self.storyLineProxy:getStrongPointState(self.strongPointId);
    local starCount = self.storyLineProxy:getStrongPointStarCount(self.strongPointId);
    if state == 1 and starCount == 3 then
      self.saoDangDesc_txt:setVisible(false)
      self.saoDangQuan_txt:setVisible(true)
      self.mopUp_button:setVisible(true)
    else
      self.mopUp_button:setVisible(false)
      self.saoDangDesc_txt:setVisible(true)
      self.saoDangQuan_txt:setVisible(false)
    end
end
function ShadowHeroImagePopup:refreshData(RoundItemIdArray, StrongPointId)
  self.mopUpResultUI:refreshData(RoundItemIdArray, StrongPointId)
end
function ShadowHeroImagePopup:showNewHeroEffect()
  for k, v in pairs(self.longBodyRenders)do
    v:showNewHeroEffect();
  end
end

-- showNewHeroEffect