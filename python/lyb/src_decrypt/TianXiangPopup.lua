require "main.view.tianXiang.ui.TianXiangPageView";

TianXiangPopup=class(LayerPopableDirect);

function TianXiangPopup:ctor()
  self.class=TianXiangPopup;
  self.curIndex = 1;
  self.childLayer = Layer.new();
  self.childLayer:initLayer();
  self.renders = {};

end

function TianXiangPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TianXiangPopup.superclass.dispose(self);
  self.armature:dispose()
  BitmapCacher:removeUnused();
end

function TianXiangPopup:initialize()
  self.context=self
  self:initLayer();
  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(self.mainSize);
  self.skeleton=nil;
end
function TianXiangPopup:onDataInit()
  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);

  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  self.skeleton = getSkeletonByName("tianXiang_ui");
  local layerPopableData=LayerPopableData.new();
  -- layerPopableData:setHasUIBackground(true)
  -- layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(880,nil,true,1)
  layerPopableData:setArmatureInitParam(self.skeleton,"tianXiang_ui")
  -- layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
end

function TianXiangPopup:onPrePop()

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  armature_d.touchEnabled=true;


  local infoArmature = self.skeleton:buildArmature("info_ui");
  self.infoArmature = infoArmature
  self.infoArmature_d = infoArmature.display;

  self:addChild(self.infoArmature_d)

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(self.mainSize.width,56);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(125);
  -- layerColor:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)
  self.infoArmature_d:addChild(layerColor)
  self.infoArmature_d:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)

  -- armature_d:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY)

  self.curStar_txt=createTextFieldWithTextData(infoArmature:getBone("curStar_txt").textData, "当前星象");--新建文本
  self.curStar_txt.touchEnabled=false;
  self.curStar_txt.touchChildren=false;
  self.infoArmature_d:addChild(self.curStar_txt);

  self.common_big_card_star = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
  self.common_big_card_star:setScale(0.4)
  self.common_big_card_star:setPositionXY(707, 10);
  self.infoArmature_d:addChild(self.common_big_card_star)

  self.common_big_card_star2 = CommonSkeleton:getBoneTextureDisplay("hero_frame/common_big_card_star");
  self.common_big_card_star2:setScale(0.4)
  self.common_big_card_star2:setPositionXY(1035, 10);
  self.infoArmature_d:addChild(self.common_big_card_star2)



  self.star_txt=createTextFieldWithTextData(infoArmature:getBone("star_txt").textData, "10");--新建文本
  self.star_txt.touchEnabled=false;
  self.star_txt.touchChildren=false;
  self.infoArmature_d:addChild(self.star_txt);

  self.need_desc=createTextFieldWithTextData(infoArmature:getBone("need_desc").textData, "需要：");--新建文本
  self.need_desc.touchEnabled=false;
  self.need_desc.touchChildren=false;
  self.infoArmature_d:addChild(self.need_desc);


  self.silver_txt=createTextFieldWithTextData(infoArmature:getBone("silver_txt").textData, "20000");--新建文本
  self.silver_txt.touchEnabled=false;
  self.silver_txt.touchChildren=false;
  self.infoArmature_d:addChild(self.silver_txt);

  self.hasStar_desc=createTextFieldWithTextData(infoArmature:getBone("hasStar_desc").textData, "拥有：");--新建文本
  self.hasStar_desc.touchEnabled=false;
  self.hasStar_desc.touchChildren=false;
  self.infoArmature_d:addChild(self.hasStar_desc);

  self.hasStar_txt=createTextFieldWithTextData(infoArmature:getBone("hasStar_txt").textData, "10");--新建文本
  self.hasStar_txt.touchEnabled=false;
  self.hasStar_txt.touchChildren=false;
  self.infoArmature_d:addChild(self.hasStar_txt);


  self.common_copy_silver_bg=CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
  self.common_copy_silver_bg:setScale(0.7)
  self.common_copy_silver_bg:setPositionXY(813, 10);
  self.infoArmature_d:addChild(self.common_copy_silver_bg)



  self.left_arrow = self.armature.display:getChildByName("left_arrow");
  -- self.left_arrow.parent:removeChild(self.left_arrow, false)
  -- self.armature_d:addChild(self.left_arrow)

  SingleButton:create(self.left_arrow, nil, 0);
  self.left_arrow:addEventListener(DisplayEvents.kTouchTap, self.onLeftArrowTap, self);
  self.left_arrow:setAnchorPoint(ccp(0.5,0.5))


  self.right_arrow = self.armature.display:getChildByName("right_arrow");
  -- self.right_arrow.parent:removeChild(self.right_arrow, false)
  -- self.armature_d:addChild(self.right_arrow)

  SingleButton:create(self.right_arrow, nil, 0);
  self.right_arrow:addEventListener(DisplayEvents.kTouchTap, self.onRightArrowTap, self);
  self.right_arrow:setAnchorPoint(ccp(0.5,0.5))

  local askButton = self.armature_d:getChildByName("common_copy_ask_button");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onClickAskButton, self);
  self.askButton = askButton;

  self.askButton:setPositionY(self.askButton:getPositionY());-- + GameData.uiOffsetY

  -- local closeBtn = self.armature.display:getChildByName("common_copy_close_button")
  -- closeBtn:setPositionY(closeBtn:getPositionY() + GameData.uiOffsetY);
end

function TianXiangPopup:onUIInit()
  



  self:addChildAt(self.childLayer,1)
  self.childLayer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);

  self:createPageView()

  self:setData()
end
function TianXiangPopup:createPageView()
  self.scrollView=TianXiangPageView.new(CCPageView:create());
  self.scrollView:initialize(self);
  self.scrollView:setPositionXY(90,-self.mainSize.height-20);

  local function onPageViewScrollStoped()
      self.scrollView:onPageViewScrollStoped();
      local currentPage = self.scrollView:getCurrentPage();
      self:refreshBTN()
      print("currentPage.",currentPage)
  end

  self.scrollView:registerScrollStopedScriptHandler(onPageViewScrollStoped);
  self.childLayer:addChild(self.scrollView);
end
function TianXiangPopup:setData()

  if self.userProxy.zodiacId == 0 then
    self.scrollView:update({1})
  else
    print("\n\n\nself.userProxy.tianXiangZuIds = ", self.userProxy.tianXiangZuIds, #self.userProxy.tianXiangZuIds)
    self.scrollView:update(self.userProxy.tianXiangZuIds, #self.userProxy.tianXiangZuIds) -- self.userProxy.tianXiangZuIds
  end

  if self.userProxy.zodiacId == 0 then
    self.curTianxiangId = 10001;
  else
    self.curTianxiangId = self.userProxy:getNextTianXiang()
  end
  self:setStarInfo()
  self:refreshBTN()
end

function TianXiangPopup:setStarInfo()
  if self.curTianxiangId == 0 then--
    self.common_big_card_star:setVisible(false)
    self.common_copy_silver_bg:setVisible(false)
    self.curStar_txt:setString("恭喜你所有的天相守护都点亮了！");
    self.curStar_txt:setPositionX(470);
    self.need_desc:setVisible(false)
    self.silver_txt:setVisible(false)
    self.star_txt:setVisible(false)
  else
    local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",self.curTianxiangId)
    local shuXing = analysis("Shuxing_Shuju",tianxiangPo.attributeid, "name")
    shuXing = shuXing .. "+" .. tianxiangPo.attributeUp;

    self.curStar_txt:setString("当前星象：" .. tianxiangPo.name .. "     " .. shuXing);
    self.star_txt:setString(tianxiangPo.vigourPoint);-- .. "/" .. self.userCurrencyProxy.storyLineStar
    self.silver_txt:setString(tianxiangPo.money);-- .. "/" .. self.userCurrencyProxy.silver
    if tianxiangPo.vigourPoint > self.userCurrencyProxy.storyLineStar then
      self.star_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    else
      self.star_txt:setColor(CommonUtils:ccc3FromUInt(16776911));
    end
    -- self.silver_txt:setString(tianxiangPo.money);
    if tianxiangPo.money > self.userCurrencyProxy.silver then
      self.silver_txt:setColor(CommonUtils:ccc3FromUInt(16711680));
    else
      self.silver_txt:setColor(CommonUtils:ccc3FromUInt(16776911));
    end

    self.hasStar_txt:setString(self.userCurrencyProxy.storyLineStar);


  end
end
function TianXiangPopup:refreshData(bool)
  self.curTianxiangId = self.userProxy:getNextTianXiang()
  if bool then--换页了。
    self.renders = {};
    self.childLayer:removeChild(self.scrollView)
    self.scrollView = nil;
    self:createPageView()
    for k, v in pairs(self.userProxy.tianXiangZuIds)do
      print("k, v ", k, v);
    end
    print("#self.userProxy.tianXiangZuIds", #self.userProxy.tianXiangZuIds)
    self.scrollView:update(self.userProxy.tianXiangZuIds,#self.userProxy.tianXiangZuIds) 
  else
    local curTianXiangZuId = self.userProxy.tianXiangZuIds[#self.userProxy.tianXiangZuIds]
    for k, v in ipairs(self.renders)do
      if curTianXiangZuId == v.tianXiangZuId then
        v:refreshData()
      end
    end
  end

  self:setStarInfo()
end
function TianXiangPopup:refreshBTN()
  if 1 >= self.scrollView:getCurrentPage() then
    self.left_arrow:setVisible(false);
  else
    self.left_arrow:setVisible(true);
  end
  if self.scrollView:getCurrentPage() >= self.scrollView.maxPageNum then
    self.right_arrow:setVisible(false);
  else
    self.right_arrow:setVisible(true);
  end
end
function TianXiangPopup:onLeftArrowTap(event)
  print("onLeftArrowTap")
  local currentPage = self.scrollView:getCurrentPage();
  if currentPage > 1 then
    self.scrollView:setCurrentPage(currentPage-1)
  end

end
function TianXiangPopup:onRightArrowTap(event)
  print("onRightArrowTap")
  local currentPage = self.scrollView:getCurrentPage();
  if currentPage < self.scrollView.maxPageNum then
    self.scrollView:setCurrentPage(currentPage + 1)
  end
end
function TianXiangPopup:onUIClose()
  self:dispatchEvent(Event.new("TianXiangClose",nil,self));
end

function TianXiangPopup:onClickAskButton(event)
  -- add by mohai.wu 添加小问号
  local text=analysis("Tishi_Guizemiaoshu", 17, "txt");
  TipsUtil:showTips(self.askButton, text, 500, nil ,50);
end




