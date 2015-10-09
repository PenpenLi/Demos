require "main.view.family.ui.familyBanquet.FamilyBanquetHeadItem"
require "main.model.UserProxy"

FamilyBanquetPopup=class(LayerPopableDirect);

function FamilyBanquetPopup:ctor()
  self.class=FamilyBanquetPopup;
end
function FamilyBanquetPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FamilyBanquetPopup.superclass.dispose(self);
  self:disposeRefreshTime();
end

--在FamilyBanquetCommand里的LayerManager:addLayerPopable(familyBanquetMediator:getViewComponent())执行
--先执行
function FamilyBanquetPopup:onDataInit()
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.skeleton = self.familyProxy:getBanquetSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setShowCurrency(true);
  layerPopableData:setArmatureInitParam(self.skeleton,"banquet_ui")
  self:setLayerPopableData(layerPopableData);
  MusicUtils:playEffect(7,false)
  
end

function FamilyBanquetPopup:initialize(selectIndex, banquetID)

  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));

  local jiuyanPo = analysis("Bangpai_Bangpaijiuyan", selectIndex)

  local functionTable1 = StringUtils:stuff_string_split(jiuyanPo.doGet);
  local functionTable2 = StringUtils:stuff_string_split(jiuyanPo.joinGet);
  
  self.juban_tili = functionTable1[1][1];
  self.canjia_tili = functionTable2[1][1];

  self.tili_Increase = analysis("Xishuhuizong_Xishubiao",1061,"constant");
  self.wenJiu_Consume = analysis("Xishuhuizong_Xishubiao",1062,"constant");

  self.selectIndex = selectIndex
  self.banquetID = banquetID;

  self.wenjiuData = {};
  self.participateData = {};
  self.headArmatureTable = {};
  self.haveParticipate = false;
  self.isHoldUser = false;
  
end

--后执行
function FamilyBanquetPopup:onPrePop()
  hecDC(3, 25, 2, {id  = self.banquetID});
  local armature_d=self.armature.display;
  self.armature_d = armature_d;

  local text_data = self.armature:getBone("yinJiuXiaoGuo_txt").textData;
  self.pmText = createTextFieldWithTextData(text_data,"饮酒效果 :",true);
  self:addChild(self.pmText);

  local text_data = self.armature:getBone("yinJiuXiaoGuo_value_txt").textData;
  self.pmNumText = createTextFieldWithTextData(text_data,"+25",true);
  self:addChild(self.pmNumText);


  local yinJiuBiaoTi_txt_data = self.armature:getBone("yinJiuBiaoTi_txt").textData;
  self.yinJiuBiaoTi_txt = createTextFieldWithTextData(yinJiuBiaoTi_txt_data,"把酒言欢来温酒",true);
  self:addChild(self.yinJiuBiaoTi_txt);

  self.wenjiuButton =armature_d:getChildByName("wenJiu_button");
  SingleButton:create(self.wenjiuButton);
  self.wenjiuButton:addEventListener(DisplayEvents.kTouchTap, self.wenJiuTap, self);

  local text_data = self.armature:getBone("wenjiu_tili_txt").textData;
  self.wenjiu_tili = createTextFieldWithTextData(text_data,"+3",true);
  self:addChild(self.wenjiu_tili);

  self.wenjiu_tili =armature_d:getChildByName("wenjiu_tili_bg");
  self.wenjiu_tili:setScale(0.6,true);
  local x = self.wenjiu_tili:getPosition().x + 15;
  local y = self.wenjiu_tili:getPosition().y - 12;
  self.wenjiu_tili:setPositionXY(x, y);
  
  self.topTili =armature_d:getChildByName("common_copy_tili_bg"); 
  local x = self.topTili:getPositionX() + 5; 
  local y = self.topTili:getPositionY() - 7;
  self.topTili:setScale(0.8);
  self.topTili:setPositionXY(x, y)

  self.askButton =armature_d:getChildByName("common_copy_ask_button");
  SingleButton:create(self.askButton);
  self.askButton:addEventListener(DisplayEvents.kTouchTap, self.askTap, self);
  
  --创建左侧5条温酒消息
  self:addListScrollViewLayer(self.wenjiuData);

  --刷新底部琅琊榜小贴士倒计时
  self.holdUserName = "举办者";
  local remainSeconds = 600;
  self.refreshTime=RefreshTime.new();
  self.refreshTime:initTime(remainSeconds, self.onRefreshTime, self, 3);
  self:onRefreshTime();

  self.headLayer = Layer.new();
  self.headLayer:initLayer();
  self:addChild(self.headLayer);
  
end

function FamilyBanquetPopup:onRefreshTime()

    self.remainTime = self.refreshTime:getTimeStr();
      self.remainTime = string.gsub(self.remainTime, "00 : ", "", 1)
    if not self.time then
      local timeTextData = self.armature:getBone("xiaoTieShi_txt").textData;
      self.time= createMultiColoredLabelWithTextData(timeTextData, "<content><font color='#ffae00'>"..self.holdUserName.."的酒宴:酒宴将在</font><font color='#ffae00'>"..self.remainTime.."</font><font color='#ffae00'>后结束，结束后将会收到邮件</font><content>");

      self.armature_d:addChild(self.time)
    else
      self.time:setString("<content><font color='#ffae00'>"..self.holdUserName.."的酒宴:酒宴将在</font><font color='#ffae00'>"..self.remainTime.."</font><font color='#ffae00'>后结束，结束后将会收到邮件</font><content>");
    end

    local remainSeconds = self.refreshTime:getTotalTime()
    if remainSeconds == 0 then
       self:closeUI();
    end
end

function FamilyBanquetPopup:disposeRefreshTime()
  if self.refreshTime then
    self.refreshTime:dispose();
    self.refreshTime=nil;
  end
end

--添加温酒信息列表
function FamilyBanquetPopup:addListScrollViewLayer(wenjiuData)
  self.listScrollViewLayer = ListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setPositionXY(150, 130);
  self.list_width = 200;
  self.list_height = 350;
  self.listScrollViewLayer:setViewSize(makeSize(self.list_width, self.list_height));
  self.listScrollViewLayer:setItemSize(makeSize(self.list_width, self.list_height/5));
  self.listScrollViewLayer:setDirection(kCCScrollViewDirectionVertical);

  self:addChild(self.listScrollViewLayer);
end



function FamilyBanquetPopup:wenJiuTap()

  for i,v in ipairs(self.countControlProxy.data) do
    if v.ID == 13 then 
      self.wenjiuCount = v.TotalCount - v.CurrentCount;
    end
  end

  local tipStr = "是否花费"..tostring(self.wenJiu_Consume).."元宝温酒，饮酒效果将会+"..tostring(self.tili_Increase).."体力。";

  if self.holdUserID == self.userProxy.userId then
      if self.wenjiuCount >= 1 then
        local commonPopup=CommonPopup.new();
    commonPopup:initialize(tipStr,self,self.onConfirm,nil,self.onCancel,nil,nil,{"确认","取消"},nil,true,false);
    self:addChild(commonPopup);
    
      else
        sharedTextAnimateReward():animateStartByString("您的温酒次数不够！");
      end
  elseif self.holdUserID ~= self.userProxy.userId then
    if self.haveParticipate == false then
        sharedTextAnimateReward():animateStartByString("您尚未入宴！");
    elseif self.wenjiuCount >= 1 then
        local commonPopup=CommonPopup.new();
    commonPopup:initialize(tipStr,self,self.onConfirm,nil,self.onCancel,nil,nil,{"确认","取消"},nil,true,false);
    self:addChild(commonPopup);
    else 
        sharedTextAnimateReward():animateStartByString("您的温酒次数不够！");
    end
  end
end

function FamilyBanquetPopup:onConfirm()
  
  local moneyNum = self.userCurrencyProxy:getMoneyByItemID(3);
  if moneyNum < self.wenJiu_Consume then
    sharedTextAnimateReward():animateStartByString("亲，元宝不够了哦！");
    self:dispatchEvent(Event.new("FamilyBanquetToChongZhi",nil,self));
    return;
  end
  self.wenjiuButton.touchEnabled = false;
  local index;
  if table.getn(self.wenjiuData) ==5 then
    index = 5;
    table.remove(self.wenjiuData, 1);
  else index = table.getn(self.wenjiuData) + 1;
  end

  table.insert(self.wenjiuData, index, {UserName = self.userProxy.userName , Count = 3});
  
  self:refreshListScrollViewLayer();
  print(table.getn(self.wenjiuData));
  
  sendMessage(27, 35, {ID = self.banquetID});
  hecDC(3, 25, 4, {id = self.banquetID})
end

function FamilyBanquetPopup:refreshListScrollViewLayer()
  local startNum = 1;
  local endNum = 1;
  if table.getn(self.wenjiuData) <=5 then
      startNum = 1;
      endNum = table.getn(self.wenjiuData);
  else 
      startNum = table.getn(self.wenjiuData) -4;
      endNum = table.getn(self.wenjiuData);
  end
  self.listScrollViewLayer:removeAllItems();
  
  for i=startNum, endNum do
    local textField = MultiColoredLabel.new("<content><font color='#ffb400'>"..self.wenjiuData[i].UserName.."</font><font color='#fae6b4'> 温了一杯酒,饮后体力+</font><font color='#fae6b4'>"..self.wenjiuData[i].Count.."</font><content>", FontConstConfig.OUR_FONT, 22,  CCSizeMake(self.list_width, 70), kCCTextAlignmentLeft);
    local layer = LayerColor.new();
    layer:initLayer();
    layer:setOpacity(true)
    layer:addChild(textField)
    textField:setPositionXY(0, 40)
   self.listScrollViewLayer:addItem(layer);
  end
end


function FamilyBanquetPopup:askTap(event)
  local functionStr = analysis("Tishi_Guizemiaoshu",14,"txt");
  
  TipsUtil:showTips(event.target,functionStr,nil,0);
end



function FamilyBanquetPopup:onUIClose()
  sendMessage(27, 32, {ID = self.banquetID});
  self:dispatchEvent(Event.new("FamilyBanquetClose",nil,self));
end

function FamilyBanquetPopup:refreshUserHeadAndHeatRecord(userIdNameArray, HeatWineArray, ID, userId)
    self.wenjiuButton.touchEnabled = true;
    self.holdUserID = userId;
    self.banquetID = ID;

    --判定是否入宴
    for i,v in ipairs(userIdNameArray) do
      if self.userProxy.userId == v.UserId then 
        self.haveParticipate = true;
      end
      if v.UserId == self.holdUserID then
        self.holdUserName = v.UserName;
        self.time:setString("<content><font color='#ffae00'>"..self.holdUserName.."的酒宴:酒宴将在</font><font color='#ffae00'>"..self.remainTime.."</font><font color='#ffae00'>后结束，结束后将会收到邮件</font><content>");
      end
    end
    --判定是否是举办者
    if self.holdUserID == self.userProxy.userId then
        self.isHoldUser = true;
    else
        self.isHoldUser = false;
    end

    self:refreshUserHead(userIdNameArray, ID);
    self.wenjiuData = HeatWineArray;
    self:refreshListScrollViewLayer();
   
end

function FamilyBanquetPopup:refreshUserHead(userIdNameArray, ID)
    self.banquetID = ID;
    self.partiPersonsData = userIdNameArray;
    --根据假数据加载右侧6个头像
    if self.headArmatureTable then
      for i=1,table.getn(self.headArmatureTable) do
        self:removeChild(self.headArmatureTable[i]);
      end
    end
    self.participateData = {}

  --##############################################################################

  self.headItemNum = 4;
  if self.selectIndex == 1 then
    self.headItemNum = 4;
  elseif self.selectIndex == 2 then
    self.headItemNum = 6;
  end

  for i=1,self.headItemNum do
    if self.partiPersonsData[i] then
      table.insert(self.participateData, self.partiPersonsData[i]);
    else 
      table.insert(self.participateData, {id =1});
    end
  end

 for i=1,self.headItemNum do
    if self.headItemNum == 4 then
  
     x = 560 + (i-1)%2*270;
     y = 374 - (math.ceil(i/2)-1)*228;
    elseif self.headItemNum == 6 then
  
     x = 465 + (i-1)%3*208;
     y = 374 - (math.ceil(i/3)-1)*228;

    end

    local familyBanquetHeadItem = FamilyBanquetHeadItem.new();
    headItem_armature = familyBanquetHeadItem:initializeUI(self.skeleton, self.participateData[i], i, self.holdUserID, self.userProxy.userId, self.banquetID, self, self.userProxy);

    headItem_armature:setPosition(ccp(x, y))

    self.headLayer:addChild(headItem_armature);

    table.insert(self.headArmatureTable, headItem_armature)
 end
end


function FamilyBanquetPopup:refreshTimeAndPhysicalPower(remainSeconds, physicalPower, ID)
    self.pmNumText:setString("+"..tostring(physicalPower));
    self.banquetID = ID;
    self.refreshTime:setTotalTime(remainSeconds);
    self:onRefreshTime();
end