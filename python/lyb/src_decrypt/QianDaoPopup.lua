require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "main.view.qianDao.ui.render.QianDaoRender"
require "main.view.qianDao.ui.render.QianDaoLeftRender"

QianDaoPopup=class(LayerPopableDirect);

function QianDaoPopup:ctor()
  self.class=QianDaoPopup;
  self.count = 5;
  self.bg_image = nil;
end
function QianDaoPopup:dispose()
  QianDaoPopup.superclass.dispose(self);
end
function QianDaoPopup:onDataInit()
  self.qiandaoProxy=self:retrieveProxy(QianDaoProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)
  self.bagProxy = self:retrieveProxy(BagProxy.name);

  self.skeleton = self.qiandaoProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(false)
  layerPopableData:setHasUIFrame(true)
  -- layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_QIANDAO,nil,nil,2)
  layerPopableData:setArmatureInitParam(self.skeleton,"qiandao_ui")
  layerPopableData:setShowCurrency(false);
  self:setLayerPopableData(layerPopableData)
end


function QianDaoPopup:initialize()
  self.context=self
  self.channel=1;
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.skeleton=nil;

  -- self.bgImage = Image.new();
  -- self.bgImage:loadByArtID(StaticArtsConfig.BACKGROUD_HERO_HOUSE);
  -- -- self.bgImage:setAnchorPoint(makePoint(0.5, 0.5));
  -- self.bgImage:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  -- self:addChild(self.bgImage)
end

function QianDaoPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  
  self.layerColor = LayerColorBackGround:getTransBackGround()
  self.layerColor:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self.armature.display:addChildAt(self.layerColor, 0);
  
  local render1=armature_d:getChildByName("shop_render1");
  local render2=armature_d:getChildByName("shop_render2");
  
  self.render_width=render1:getGroupBounds().size.width
  self.render_height=render1:getGroupBounds().size.height
  self.render_pos=convertBone2LB(render1)
  self.render_width=render1:getContentSize().width
  self.render_height=render1:getPositionY()-render2:getPositionY()
  self.list_x = self.render_pos.x;
  self.list_y = self.render_pos.y + render1:getContentSize().height;

  armature_d:removeChild(render1);
  armature_d:removeChild(render2);


  self.leftrender=QianDaoLeftRender.new();
  -- local sign_in_txtTextData = self.armature:getBone("word").textData;
  -- self.sign_in =  createTextFieldWithTextData(sign_in_txtTextData, "今天已签到");
  -- self.armature_d:addChild(self.sign_in);
  -- self.word_bg=armature_d:getChildByName("word_bg");
  -- self.word_bg:setVisible(false)
  -- self.sign_in:setVisible(false)
  self.biaoti_bg=armature_d:getChildByName("biaoti_bg");
  self.biaoti_bg:setScale(1.1)
  self.biaoti_bg_pos=convertBone2LB(self.biaoti_bg)
  self.libaobg=armature_d:getChildByName("libaobg");

  self.title_bg=armature_d:getChildByName("title_bg");
  self.title_bg:setPositionY(self.title_bg:getPositionY() - 5)

  self.listScrollViewLayer=ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(self.list_x-30, self.list_y - 440);
  self.listScrollViewLayer:setViewSize(makeSize(750, 440));
  self.listScrollViewLayer:setItemSize(makeSize(750, self.render_height-5));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);
  self.listScrollViewLayer:setItemAnchorPoint(ccp(0.5, 0.5))
  self.listScrollViewLayer.touchEnabled=true;
  self.listScrollViewLayer.touchChildren=true
  self:addChild(self.listScrollViewLayer);

  local text_Data = self.armature:getBone("world").textData;
  self.world = createTextFieldWithTextData(text_Data, "累计签到奖励通过邮件方式发放，请注意查收。",nil,0);
  self.armature_d:addChild(self.world)
  local text_Data1 = self.armature:getBone("world1").textData;
  self.world1 = createTextFieldWithTextData(text_Data1, "今日未签到");
  -- self.world1 = createStrokeTextFieldWithTextData(text_Data1, "今日未签到");
  self.armature_d:addChild(self.world1)

  if self.qiandaoProxy ~= nil and self.qiandaoProxy.month ~= nil then 
    self:refreshData();
  end
end


function QianDaoPopup:refreshData()
  self.listScrollViewLayer:removeAllItems();
  self.count=self.qiandaoProxy:getMonthQianDao()
  self.yijingqiandao=self.qiandaoProxy:yiJingLingQu()
  self.leiji=self.qiandaoProxy:getLeiJiQianDao()
  self:addChild(armature_d)

  if self.yijingqiandao == 1 then
    self.world1:setString("今日已签到")
  end
  print("\n\n\n\n\n\n\n\n\n\n============================================= qianDao")
  print(self.count, self.yijingqiandao, self.leiji, self.month);
  -- print("self.yijingqiandao", self.yijingqiandao)
  -- delete by mohai.wu 海跃要求更改领取方式
  -- if self.yijingqiandao == 0 then
  --   self.sign_button=CommonButton.new();
  --   self.sign_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --   self.sign_button:initializeBMText("签到","anniutuzi");
  --   self.sign_button:setPosition(self.common_copy_blue_button_pos);
  --   self.sign_button:addEventListener(DisplayEvents.kTouchTap, self.onSign, self);
  --   self.armature_d:addChild(self.sign_button);
  -- else
  --   self.armature_d:removeChild(self.sign_button);
  -- end

  -- if(self.yijingqiandao==1) then
  --   self.word_bg:setVisible(true)
  --   self.sign_in:setVisible(true)
  -- else
  --   self.word_bg:setVisible(false)
  --   self.sign_in:setVisible(false)
  -- end
  self.month=self.qiandaoProxy.month
  print(" self.month = ", self.month)
  local qiandaoPo= analysis2key("Huodong_Leijiqiandao", "month",self.month,"days",self.count);
  self.biaoti=BitmapTextField.new(self.month.."月签到奖励", "anniutuzi");
  self:addChild(self.biaoti)
  if self.month>= 10 then
    self.biaoti:setPositionXY(self.biaoti_bg_pos.x+65,self.biaoti_bg_pos.y+3)
  else
    self.biaoti:setPositionXY(self.biaoti_bg_pos.x+74,self.biaoti_bg_pos.y+3)
  end

  local tab={}
  local qdtable= analysisByName("Huodong_Leijiqiandao","month",self.month)
  for k,v in pairs(qdtable) do
    table.insert(tab,v)
  end
  local function sortFun(v1, v2)
    if(v1.id < v2.id) then
      return true;
    elseif v1.id > v2.id then
      return false
    else
      return false;
    end
  end
  table.sort(tab, sortFun)

  local data={}
  for i,v in pairs(tab) do
    local ss=StringUtils:lua_string_split(v.awards,',');
    table.insert(data,{id=v.id, itemId=ss[1], count=ss[2]});
    -- log(v.days)
  end
  -- print("self.count",self.count)
  --t为当前签到所在的行数
  local t=math.floor(self.count/5+1);
  for i=1,math.floor(#tab/5+1) do
    local columnIndex = 0;
    local render=QianDaoRender.new();
    if(i<t) then 
      columnIndex=6
    elseif i==t then
      columnIndex=self.count%5+1
    else
      columnIndex=0;
    end

    local arr={}
    for i2=(i-1)*5+1,i*5  do
      table.insert(arr,data[i2])
    end
    render:initialize(self,arr,columnIndex,self.yijingqiandao);
    self.listScrollViewLayer:addItem(render)
    --t=1时，y=shift，t=renderNum时，y=0,两点确定一条直线，求得斜率k，计算得到y
    local renderNum=math.floor(#tab/5+1)
    local shift=116*renderNum-432
    local k=shift/(renderNum-1) 
    local y=(t-1)*k-shift
    self.listScrollViewLayer:setContentOffset(makePoint(0,y),true)
  end


self.leftrender:initialize(self,self.leiji);
self.leftrender:setPositionXY(100,108)
self:addChild(self.leftrender)

end
function QianDaoPopup:onSign()
  sendMessage(24,5)
  GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_29] = nil;
  -- if GameVar.tutorStage == TutorConfig.STAGE_2003 then--2003是签到
  --   sendServerTutorMsg({BooleanValue = 0})
  --   openTutorUI({x=1150, y=632, width = 78, height = 75, alpha = 125});
  -- end

  if self.leftrender:checkPopUpTip() then
    sharedTextAnimateReward():animateStartByString("累计签到奖励已发放至您的邮件内，请注意查收！");
  end

end

function QianDaoPopup:onUIClose( )
  self:dispatchEvent(Event.new("QianDaoClose",nil,self));
end

