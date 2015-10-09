require "core.controls.CommonLayer";
require "core.utils.LayerColorBackGround";
require "main.view.rankList.ui.LangyabangPopLayer";
require "main.view.rankList.ui.LangyabangPopLayerItem";
require "main.view.rankList.ui.LangyabangDetailLayer";
require "main.view.rankList.ui.LangyabangDetailLayerItem";
require "core.display.LayerPopable";

RankListPopup=class(LayerPopableDirect);

function RankListPopup:ctor()
  self.class=RankListPopup;
end

function RankListPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	RankListPopup.superclass.dispose(self);
  self.armature4dispose:dispose()
  BitmapCacher:removeUnused();
end

function RankListPopup:onDataInit()  
  self.rankListProxy=self:retrieveProxy(RankListProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.chatListProxy=self:retrieveProxy(ChatListProxy.name);
  self.buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.skeleton=self.rankListProxy:getSkeleton();
  self.services={};

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_RANK_LIST, nil, true, 1);
  self:setLayerPopableData(layerPopableData);
end

function RankListPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  -- local image = Image.new();
  -- image:loadByArtID(717);
  -- -- image:setScale(2);
  -- self:addChildAt(image,0);

  --骨骼
  local armature=self.skeleton:buildArmature("rank_list_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.askBtn = Button.new(self.armature4dispose:findChildArmature("ask"),false,"");
  self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
end

function RankListPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",11,"txt");
  TipsUtil:showTips(self.askBtn,text,600,nil,50);
end

function RankListPopup:onUIInit()
  for i = 1,5 do
    local wenzi = self.armature4dispose.display:getChildByName("title_" .. i);
    wenzi:setPositionXY(29,363);
    local title = self.armature4dispose.display:getChildByName("title_bg_" .. i);
    title:addChild(wenzi);
    SingleButton:create(title);
    title:addEventListener(DisplayEvents.kTouchTap, self.onTitleTap, self, i);
  end

  self.closeButton =self.armature4dispose.display:getChildByName("common_copy_close_button");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);
end

function RankListPopup:onRequestedData()
  
end

function RankListPopup:onUIClose()
  self:dispatchEvent(Event.new(RankListNotifications.RANK_LIST_CLOSE,nil,self));
end

function RankListPopup:onPreUIClose()
  
end

function RankListPopup:refreshJuanzhou(bool)
  for i=1,5 do
    self.armature4dispose.display:getChildByName("title_bg_" .. i):setVisible(bool);
  end
end

function RankListPopup:onTitleTap(event, data)
  if 4 == data then
    sharedTextAnimateReward():animateStartByString("十大公子暂未开启哦 ~");
    return;
  end
  if 5 == data then
    sharedTextAnimateReward():animateStartByString("十大美人暂未开启哦 ~");
    return;
  end
  -- if 1 == data then
  --   sharedTextAnimateReward():animateStartByString("十大帮派暂未开启哦 ~");
  --   return;
  -- end

  local layer = LayerColorBackGround:getOpacityBackGround();
  self:addChild(layer);

  local function callFunc()
    self.selected_type = data;
    self.rankListPopLayer = LangyabangPopLayer.new();
    self.rankListPopLayer:initialize(self,data);
    self:addChild(self.rankListPopLayer);
    hecDC(3,11,2,{checklist = data});
    self:removeChild(layer);
    self:refreshJuanzhou(true);
  end

  -- local effect=cartoonPlayer(1717,1280*0.5,720*0.5,1,callFunc);
  -- self.parent:addChild(effect);
  self:refreshJuanzhou(false);
  self:requestData(data);

  callFunc();
end

function RankListPopup:requestData(data)
  -- if true then
  --   self:refreshData(data, {{ID=1,Ranking=1,ParamStr1="名字五个字",ParamStr2="8000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1,BooleanValue=0},{ConfigId=2,Grade=3,Level=1,BooleanValue=0},{ConfigId=3,Grade=4,Level=1,BooleanValue=0}}},
  --                            {ID=1,Ranking=2,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1,BooleanValue=0},{ConfigId=2,Grade=3,Level=1,BooleanValue=0},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=3,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1,BooleanValue=0},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4}}},
  --                            {ID=1,Ranking=4,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=5,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=6,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=7,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=8,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=9,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},
  --                            {ID=1,Ranking=10,ParamStr1="名字五个字",ParamStr2="9000",ParamStr3=12321,ParamStr4="123123",RankGeneralArray={{ConfigId=1,Grade=2,Level=1},{ConfigId=2,Grade=3,Level=1},{ConfigId=3,Grade=4,Level=1}}},});
  --   return;
  -- end
  if self.services[data] then
    --self:refreshData(data, self.services[data]);
  else
    initializeSmallLoading();
    self:dispatchEvent(Event.new(RankListNotifications.RANK_LIST_REQUEST_DATA,{Type=self:getType(data)},self));
  end
end

function RankListPopup:refreshData(type, rankArray)
  uninitializeSmallLoading();
  self.services[self:getTypeMap(type)]=rankArray;
  if self.rankListPopLayer and self:getTypeMap(type) == self.rankListPopLayer.type then
    self.rankListPopLayer:refreshData(self:getTypeMap(type),rankArray);
  end
end

function RankListPopup:getType(type)
  local tb = {4,5,1,2,3};
  return tb[type];
end

function RankListPopup:getTypeMap(type)
  local tb = {4,5,1,2,3};
  for k,v in pairs(tb) do
    if type == v then
      return k;
    end
  end
end