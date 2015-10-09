require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";
VipPopup=class(LayerPopableDirect);

function VipPopup:ctor()
  self.class=VipPopup;
  
end

function VipPopup:dispose()
  self.rightScl:removeAllItems();
  self.right_tmp:removeChildren();
  self.rightScl = nil;
	VipPopup.superclass.dispose(self);

end

function VipPopup:initialize()
  
  self.skeleton=nil;
  self.userProxy = nil;
  self.countProxy = nil;
  self.openProxy = nil;
end
function VipPopup:onDataInit()
  -- local proxyRetriever=ProxyRetriever.new();
  self.dataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);--获取数据
  self.skeleton = getSkeletonByName("vip_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,true);
  layerPopableData:setArmatureInitParam(self.skeleton,"vip_ui");
  layerPopableData:setShowCurrency(true);
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);
  hecDC(3,17,1);
end


function VipPopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end
function VipPopup:onUpdateView()
  local userProxy=self:retrieveProxy(UserProxy.name);
  self.vipLvl:setData(userProxy.vipLevel,"common_vip",30);
  self.vipLvl1:setData(userProxy.vipLevel+1,"common_vip",30);
  local lvlVo = analysis("Huiyuan_Huiyuandengji",userProxy.vipLevel)
  local lvlnVo = analysis("Huiyuan_Huiyuandengji",userProxy.vipLevel+1)
  local ttl;
  local vipP;
  self.vipCountTF:setVisible(false);
  self.vipTtlTF:setVisible(false);
  self.common_copy_gold_bg:setVisible(false);
  if userProxy.vipLevel >= userProxy.vipLevelMax then
    --self.vipMaxTF:setVisible(true);
    self.progressBar:setProgress(0);
    --self.vipCountTF:setVisible(false);
    --self.vipTtlTF:setVisible(false);
    self.vip_num1_con:setVisible(false);
    self.common_vip_ttl_1:setVisible(false);
    --self.common_copy_gold_bg:setVisible(false);
    self.vipMaxTF:setString("亲你的VIP满级了！撒花啊大贵宾啊！");
  else
    --self.vipMaxTF:setVisible(false);
    if not lvlVo.max then
      ttl = lvlnVo.min;
      vipP = userProxy.vip;
    elseif not lvlnVo.min then
      ttl = lvlVo.max - lvlVo.min;
      vipP = userProxy.vip-lvlVo.min;
    else
      ttl = lvlnVo.min - lvlVo.min;
      vipP = userProxy.vip-lvlVo.min;
    end
    self.progressBar:setProgress(vipP/ttl);
    local str = "再充值"..(ttl-vipP).."元宝 将升级到";
    --self.vipTtlTF:setString(str);
    self.vipMaxTF:setString(str);
  end
  self.ifP_showLvl = userProxy.vipLevel;
  if not self.ifP_showLvl or self.ifP_showLvl <=0 then
    self.ifP_showLvl=1;
  end
  self:onSetInfoPageData(self.ifP_showLvl);
  self.rightScl:removeAllItems();
  self:initRightListData();
end
function VipPopup:onPrePop()
  self.userProxy = self:retrieveProxy(UserProxy.name);
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 
  self.vip_num_con = self.armature.display:getChildByName("vip_num_con");
  self.vipLvl = CartoonNum.new();
  self.vipLvl:initLayer();
  self.vipLvl:setData(0,"common_vip",30);
  self.vip_num_con:addChild(self.vipLvl);

  self.vip_num1_con = self.armature.display:getChildByName("vip_num1_con");
  self.vipLvl1 = CartoonNum.new();
  self.vipLvl1:initLayer();
  self.vipLvl1:setData(1,"common_vip",30);
  self.vip_num1_con:addChild(self.vipLvl1);
   --exp_progress
  local progressBar = self.armature:findChildArmature("common_progress_bar");
  self.progressBar = ProgressBar.new(progressBar, "pro_up");
  self.vipCountTF = generateText(self,self.armature,"vipCountTF","再充值 ",true,ccc3(0,0,0),2);
  self.dangqianTF = generateText(self,self.armature,"dangqianTF","当前",true,ccc3(0,0,0),2);
  self.vipMaxTF = generateText(self,self.armature,"vipMaxTF","亲你的VIP满级了！撒花啊大贵宾啊！",true,ccc3(0,0,0),2);
  self.vipTtlTF = generateText(self,self.armature,"vipTtlTF","",true,ccc3(0,0,0),2);
  self.common_vip_ttl_1 = self.armature.display:getChildByName("common_vip_ttl_1");
  self.common_copy_gold_bg = self.armature.display:getChildByName("common_copy_gold_bg");
  self.right_tmp = self.armature.display:getChildByName("right_tmp");
  self:initInfoPage(self.armature:findChildArmature("vip_infoPage"));

  local scroll=ListScrollViewLayer.new();
  scroll:initLayer();
  --info_scroll:setPositionXY(text_data.x,-text_data.height*10.5);
  local rdWidth = 525;
  local rdHeight = 140;
  scroll:setViewSize(makeSize(rdWidth,rdHeight*3.3));
  scroll:setContentSize(makeSize(rdWidth,rdHeight*3.3));
  scroll:setItemSize(makeSize(rdWidth,rdHeight));
  self.right_tmp:addChild(scroll);
  self.rightScl = scroll;
  --self:initRightListData();
  self:onUpdateView();
  --self:initBackGround();
end
function VipPopup:initBackGround()
  local winSize = Director:sharedDirector():getWinSize()
  local uiSize = self:getGroupBounds(false).size
  local offsetX,offsetY = winSize.width / 2,winSize.height / 2

  local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
  --backHalfAlphaLayer:setAnchorPoint(ccp(0.5,0.5));
  backHalfAlphaLayer:setOpacity(185)
  backHalfAlphaLayer:setScale(1.6)
  backHalfAlphaLayer:setPositionY(-GameData.uiOffsetY)
  self:addChildAt(backHalfAlphaLayer,0)
end
local function shortFun(a,b)
  return a.id > b.id;
end

function VipPopup:initRightListData()
  local dataArr = analysisTotalTableArray("Huodong_Chongzhi");
  table.sort( dataArr, shortFun )
  for i,v in ipairs(dataArr) do
    self.rightScl:addItem(self:createRender(v));
  end
  
end

function VipPopup:onClickRightBegin(event)
  if self.tTarget then
    self.tTarget:setScale(1);
    self.tTarget:setPositionXY(0,self.tTarget:getPositionY()-5);
  end
  self.tTarget = event.target;
  self.tTarget:setScale(0.9);
  self.tTarget:setPositionXY(25,self.tTarget:getPositionY()+5);
  self.rightStartY = self.rightScl:getContentOffset().y
end
function VipPopup:onClickRightEnd(event)
  if self.tTarget then
    self.tTarget:setScale(1);
    self.tTarget:setPositionXY(0,self.tTarget:getPositionY()-5);
    self.tTarget = nil;
  end
end

function VipPopup:onClickRightRender(event,data)
  if math.abs(self.rightStartY - self.rightScl:getContentOffset().y)>20 then return end
  -- if GameData.platFormID == GameConfig.PLATFORM_CODE_LAN then
  --   -- sendMessage(3,28,{ID=data.id});
  -- else
  --   self:dispatchEvent(Event.new("TO_PAY_COMMOND",data,self))
  -- end

  self:dispatchEvent(Event.new("TO_PAY_COMMOND",data,self))
end

function VipPopup:createRender(data)
  local armature = self.skeleton:buildArmature("vip_pay_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;
  armature_d:addEventListener(DisplayEvents.kTouchBegin,self.onClickRightBegin,self);
  armature_d:addEventListener(DisplayEvents.kTouchEnd,self.onClickRightEnd,self);
  armature_d:addEventListener(DisplayEvents.kTouchTap,self.onClickRightRender,self,data);
  local pay_ttl_TF = generateText(armature_d,armature,"pay_ttl_TF","");
  local pay_ttl1_TF = generateText(armature_d,armature,"pay_ttl1_TF",data.rmb.."元");
  local pay_ttl2_TF = generateText(armature_d,armature,"pay_ttl2_TF","");
  local itemTmp = armature_d:getChildByName("itemTmp");
  local img = Sprite.new(CCSprite:create(artData[data.sucai].source));
  itemTmp:addChild(img);
  img:setAnchorPoint(ccp(0.5,0.5))
  local times = self.dataAccumulateProxy:getCount(GameConfig.ACCUMULATE_TYPE_52,data.id);
  times = times and tonumber(times) or 0;
  if tonumber(data.monthrebate)>0 then
    pay_ttl_TF:setString(data.recharge.."元宝月度礼包")
    pay_ttl2_TF:setString("连续30天每天可领 "..data.monthrebate.."元宝")
  elseif tonumber(data.firstrebate)>0 and times<1 then
    pay_ttl_TF:setString(data.recharge.."元宝")
    pay_ttl2_TF:setString("另赠送 "..data.recharge.."元宝（限购一次）")
  elseif tonumber(data.rebate)>0 then
    pay_ttl_TF:setString(data.recharge.."元宝")
    pay_ttl2_TF:setString("另赠送 "..data.rebate.."元宝")
  else
    pay_ttl_TF:setString(data.recharge.."元宝")
  end 

  return armature_d;
end


function VipPopup:initInfoPage(armature)
  local armature_d = armature.display;
  --local ttl_TF = armature_d:getChildByName("ttl_TF");
  local vip = armature_d:getChildByName("vip");
  vip:setScale(0.9);
  --self.ifP_infoTF =  generateText(armature_d,armature,"info_TF","再充值1235");
  self.vipNum = armature_d:getChildByName("vipNum");
  self.vipLvl2 = CartoonNum.new();
  self.vipLvl2:initLayer();
  self.vipLvl2:setData(0,"common_vip",30);
  self.vipNum:addChild(self.vipLvl2);
  self.vipNum:setScale(0.9)
  --self.ifP_ttlTF = BitmapTextField.new("VIP1特权","biaotituzi");
  --ttl_TF:addChild(self.ifP_ttlTF)

  local text_data=armature:getBone("info_TF").textData;
  local info_scroll=ListScrollViewLayer.new();
  info_scroll:initLayer();

  info_scroll:setPositionXY(text_data.x,-text_data.height*10.5);
  info_scroll:setViewSize(makeSize(text_data.width,text_data.height*9));
  info_scroll:setContentSize(makeSize(text_data.width,text_data.height*9));
  info_scroll:setItemSize(makeSize(text_data.width,text_data.height));
  info_scroll:setAnchorPoint(ccp(0,1))
  armature_d:addChild(info_scroll);
  self.ifP_infoScl = info_scroll;
  self.ifP_textData = text_data;


  self.ifP_preBtn =  Button.new(armature:findChildArmature("common_copy_blue_button_1"),false,"上一级",true);
  self.ifP_preBtn:addEventListener(Events.kStart,self.onClickPreBtn,self);
  self.ifP_nextBtn =  Button.new(armature:findChildArmature("common_copy_blue_button_2"),false,"下一级",true);
  self.ifP_nextBtn:addEventListener(Events.kStart,self.onClickNextBtn,self);
  --self.ifP_showLvl = 1;
  --self:onSetInfoPageData(self.ifP_showLvl);
end
function VipPopup:onClickPreBtn()
  self.ifP_showLvl = self.ifP_showLvl-1;
  self:onSetInfoPageData(self.ifP_showLvl);
end
function VipPopup:onClickNextBtn()
  self.ifP_showLvl = self.ifP_showLvl+1;
  self:onSetInfoPageData(self.ifP_showLvl);
end
function VipPopup:onSetInfoPageData(vipLvl)
  if vipLvl > self.userProxy.vipLevelMax then vipLvl = self.userProxy.vipLevelMax end
  --self.ifP_ttlTF:setString("VIP"..vipLvl.."特权");
  self.vipLvl2:setData(vipLvl,"common_vip",30);
  self.ifP_preBtn:setEnabled(vipLvl>1);
  self.ifP_nextBtn:setEnabled(vipLvl<self.userProxy.vipLevelMax);
  self.lvlVo = analysis("Huiyuan_Huiyuandengji",vipLvl)
  --self.ifP_infoTF:setString(self.lvlVo.text);
  local infoArr = StringUtils:lua_string_split(self.lvlVo.text, "#");
  self.ifP_infoScl:removeAllItems();
  local resetColor = self.ifP_textData.color;
  for i,v in ipairs(infoArr) do
    local infoCT = StringUtils:lua_string_split(v, "|");
    if infoCT[2] then
      self.ifP_textData.color = tonumber(infoCT[1]);
      v = infoCT[2]
    end
    local textField=createTextFieldWithTextData(self.ifP_textData,v,true);
    self.ifP_infoScl:addItem(textField);
    self.ifP_textData.color = resetColor;
  end
  
end

function VipPopup:onUIInit()
  --CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
end

function VipPopup:onRequestedData()

end

function VipPopup:onUIClose()
  self:dispatchEvent(Event.new("closeNotice",nil,self));
end
