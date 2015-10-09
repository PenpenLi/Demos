
require "main.config.XiShuConfig";
CurrencyGroupUI=class(Layer);

function CurrencyGroupUI:ctor()
  self.class=CurrencyGroupUI;
end

function CurrencyGroupUI:dispose()
  self.removeArmature:dispose();
  self.removeArmature = nil;
  self:removeAllEventListeners();
  self:removeChildren();
	CurrencyGroupUI.superclass.dispose(self);
end

function CurrencyGroupUI:initialize()
    self:initLayer();
    
    local winSize = Director:sharedDirector():getWinSize();



    local proxyRetriever  = ProxyRetriever.new();
    self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
    self.userProxy=proxyRetriever:retrieveProxy(UserProxy.name);
    self.heroHouseProxy=proxyRetriever:retrieveProxy(HeroHouseProxy.name);
    self.openFunctionProxy = proxyRetriever:retrieveProxy(OpenFunctionProxy.name)

    local armature=CommonSkeleton:buildArmature("huobiGroup");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.removeArmature = armature;
    local armature_d=armature.display;
    self.armature_d = armature_d;

    armature_d:setPositionXY(0,winSize.height - 118 -GameData.uiOffsetY)    

    self:addChild(armature_d);
	
    self.tiliTextBone = armature:getBone("tiliText")
    self.yinliangTextBone = armature:getBone("yinliangText")
    self.yuanbaoTextBone = armature:getBone("yuanbaoText")

    self.jia_yingliangDO = armature:getBone("jia_yingliang"):getDisplay()
    self.jia_yingliangDO:setAnchorPoint(ccp(0.5,0.5))
    self.jia_yingliangDO:setPositionXY(self.jia_yingliangDO:getPositionX()+self.jia_yingliangDO:getContentSize().width/2, self.jia_yingliangDO:getPositionY()-self.jia_yingliangDO:getContentSize().height/2)
    
    self.jia_yuanbaoDO = armature:getBone("jia_yuanbao"):getDisplay()
    self.yuanbao_bantouDO = armature:getBone("yuanbao_bantou"):getDisplay()
    self.jia_yuanbaoDO:setAnchorPoint(ccp(0.5,0.5))
    self.jia_yuanbaoDO:setPositionXY(self.jia_yuanbaoDO:getPositionX()+self.jia_yuanbaoDO:getContentSize().width/2, self.jia_yuanbaoDO:getPositionY()-self.jia_yuanbaoDO:getContentSize().height/2)

    self.jia_tiliDO = armature:getBone("jia_tili"):getDisplay()
    self.jia_tiliDO:setAnchorPoint(ccp(0.5,0.5))
    self.jia_tiliDO:setPositionXY(self.jia_tiliDO:getPositionX()+self.jia_tiliDO:getContentSize().width/2, self.jia_tiliDO:getPositionY()-self.jia_tiliDO:getContentSize().height/2)

    self.tili_bantouDO = armature:getBone("tili_bantou"):getDisplay()


    self.yingliang_bantouDO = armature:getBone("yingliang_bantou"):getDisplay()


    print("@@@@@@@@@@@@@@@@@@@@CurrencyGroupUI:initialize()");

    self:setHuobiText()

    if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_54) then
      self.jia_tiliDO:setVisible(false)
    end

end



function CurrencyGroupUI:setHuobiText()
  local tili = self.userCurrencyProxy.tili.."/" .. analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1014,"constant");
  if not self.tiliText then
    self.tiliTextBone.textData.y = self.tiliTextBone.textData.y;
    self.tiliText = createStrokeTextFieldWithTextData(self.tiliTextBone.textData,tili,nil,1,ccc3(0,0,0));
    self.tiliText.touchEnabled = false;
    self.armature_d:addChild(self.tiliText)
  else
    self.tiliText:setString(tili);
  end

  local gold_wan = self.userCurrencyProxy.gold
  if gold_wan >= 1000000 then
    gold_wan = math.floor(gold_wan / 10000) .. " 万";
  end
  local sliver_wan = self.userCurrencyProxy.silver
  if sliver_wan >= 1000000 then
    sliver_wan = math.floor(sliver_wan / 10000) .. " 万";
  end   
  if not self.goldText then
    self.goldText = createTextFieldWithTextData(self.yuanbaoTextBone.textData,gold_wan)
    self.goldText.touchEnabled = false;
    self.armature_d:addChild(self.goldText)
  else
    self.goldText:setString(gold_wan);
  end


  if not self.sliverText then

    self.sliverText = createTextFieldWithTextData(self.yinliangTextBone.textData,sliver_wan)
    self.sliverText.touchEnabled = false;
    self.armature_d:addChild(self.sliverText)
  else
    self.sliverText:setString(sliver_wan)
  end

  if self.contributeText then
    self.contributeText:setString(self.userCurrencyProxy:getValueByMoneyType(10));
  end
  

end

function CurrencyGroupUI:refreshAreaRongYu(bool)
  if not self.tiliImage then
    self.tiliImage = self.removeArmature:getBone("tili"):getDisplay()
  end
  self.tiliImage:setVisible(bool)
  self.jia_tiliDO:setVisible(bool)
  self.tiliText:setVisible(bool)
  if not self.rongYuImage then
      local art = analysis("Daoju_Daojubiao", 11,"art");
      self.rongYuImage = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_honor_bg");
      self.rongYuImage:setPositionXY(self.tiliImage:getPosition().x,self.tiliImage:getPosition().y - 47);
      -- self.rongYuImage:setScale(0.60)
      self.armature_d:addChild(self.rongYuImage)
  end
  self.rongYuImage:setVisible(not bool)
  if not self.rongYuText then
    local textData = copyTable(self.tiliTextBone.textData)
    textData.y = textData.y - 4
    self.rongYuText = createTextFieldWithTextData(textData,"");
    self.rongYuText.touchEnabled = false;
    self.armature_d:addChild(self.rongYuText)
  end
  self.rongYuText:setString(self.userCurrencyProxy:getScore());
  self.rongYuText:setVisible(not bool)
end


function CurrencyGroupUI:refreshFamilyContribute(bool)
  print("###################### bool",bool)
  if not self.tiliImage then
    self.tiliImage = self.removeArmature:getBone("tili"):getDisplay()
  end
  self.tiliImage:setVisible(bool)
  self.jia_tiliDO:setVisible(bool)
  self.tiliText:setVisible(bool)
  if not self.contributeImage then
      local art = analysis("Daoju_Daojubiao", 10,"art");
      self.contributeImage = Image.new();
      self.contributeImage:loadByArtID(art);
      self.contributeImage:setPositionXY(self.tiliImage:getPosition().x,self.tiliImage:getPosition().y - 52);
      self.contributeImage:setScale(0.60)
      self.armature_d:addChild(self.contributeImage)
  end
  self.contributeImage:setVisible(not bool)
  if not self.contributeText then
    local textData = copyTable(self.tiliTextBone.textData)
    textData.y = textData.y - 4
    self.contributeText = createTextFieldWithTextData(textData,"");
    self.contributeText.touchEnabled = false;
    self.armature_d:addChild(self.contributeText)
  end
  self.contributeText:setString(self.userCurrencyProxy:getValueByMoneyType(10));
  print("self.userCurrencyProxy:getValueByMoneyType(10)",self.userCurrencyProxy:getValueByMoneyType(10))
  self.contributeText:setVisible(not bool)
end



