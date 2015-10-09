--

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

HeroTeamMainPopup=class(LayerPopableDirect);

function HeroTeamMainPopup:ctor()
  self.class=HeroTeamMainPopup;
end

function HeroTeamMainPopup:dispose()
	HeroTeamMainPopup.superclass.dispose(self);
end

function HeroTeamMainPopup:onDataInit()
  self.skeleton = getSkeletonByName("hero_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroTeamMain_ui");
  self:setLayerPopableData(layerPopableData);
end

function HeroTeamMainPopup:initialize()
 
end

function HeroTeamMainPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  self:setContentSize(makeSize(1280,720));  

  --initUI
  self.heroTeamTitleBG = self.armature.display:getChildByName("heroTeamTitleBG");
  self.heroTeamTitleBG:setScale(0.8);
  self.bishuaLeft = self.armature.display:getChildByName("bishuaLeft");
  self.bishuaLeft:setScaleY(0.9);
  self.bishuaRight = self.armature.display:getChildByName("bishuaRight");
  self.bishuaRight:setScaleY(0.9);

  self.heroHeaderCon = self.armature.display:getChildByName("heroHeaderCon");
  local userProxy = self:retrieveProxy(UserProxy.name);
  local carrerId = userProxy.career;
  local items = analysis("Zhujiao_Zhujiaozhiye", carrerId)--卡牌库

  local card = getImageByArtId(items.art1)
  self.heroHeaderCon:addChild(card);
  self.zhanLiCon = self.armature.display:getChildByName("zhanLiCon");

  local zhanLi = CartoonNum.new();
  zhanLi:initLayer();
  zhanLi:setData(12345,"common_number",40);--server
  self.zhanLiCon:addChild(zhanLi);  

  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local followTb = heroHouseProxy:getIsPlayArr();
  for i=1,3 do
    local followerArmature = self.armature:findChildArmature("cardRender"..i);

    if followTb[i] then
      local tempGridImg = CommonSkeleton:getBoneTextureDisplay(getFrameNameByGrade(followTb[i].Grade));
      followerArmature.display:setVisible(true);
      local followCardCon = followerArmature.display:getChildByName("cardCon");
      local followCarrerImg = followerArmature.display:getChildByName("carrerImg");
      local followGridImg = followerArmature.display:getChildByName("gridImg");
      local followNameBg = followerArmature.display:getChildByName("nameBg");
      local followLvImg = followerArmature.display:getChildByName("lvImg");
      local followItems = analysis("Kapai_Kapaiku", followTb[i].ConfigId)--卡牌库
      local followCard = getImageByArtId(followItems.art)
      followCardCon:addChild(followCard);

      self.tarGridImg = CommonSkeleton:getBoneTexture9Display(getFrameNameByGrade(followTb[i].Grade),false,
        155/tempGridImg:getContentSize().width,190/tempGridImg:getContentSize().height);
      updateImg(followerArmature,followGridImg,self.tarGridImg,190);

      local tarCarrer = CommonSkeleton:getBoneTextureDisplay("commonImages/common_carrer"..followItems.job);
      updateImg(followerArmature,followCarrerImg,tarCarrer,50);
      local followLvTF = generateText(followerArmature.display,followerArmature,"lvTF","1",true,ccc3(0,0,0),2);--server
      local followNameTF = generateText(followerArmature.display,followerArmature,"nameTF",followItems.name);--server
      updateStar(followerArmature,followItems.star);  
    else
      followerArmature.display:setVisible(false);
    end;
  end
  self.changeConfigBtn = generateButton(self.armature,"changeConfigBtn","common_blue_button","变阵",self.onRank,self,nil,"commonButtons/");

end

function HeroTeamMainPopup:onRank()
  self:dispatchEvent(Event.new("openSubNotice",nil,self));
end

function HeroTeamMainPopup:onUIInit()
  
end

function HeroTeamMainPopup:onRequestedData()

end

function LayerPopable:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end