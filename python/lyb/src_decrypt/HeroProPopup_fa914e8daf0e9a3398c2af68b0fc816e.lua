--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

HeroProPopup=class(LayerPopableDirect);

function HeroProPopup:ctor()
  self.class=HeroProPopup;
end

function HeroProPopup:dispose()
	HeroProPopup.superclass.dispose(self);
end

function HeroProPopup:onDataInit()
  -- local proxyRetriever=ProxyRetriever.new();
  -- self.strengthenProxy=proxyRetriever:retrieveProxy(StrengthenProxy.name);--获取数据
  self.skeleton = getSkeletonByName("hero_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroPro_ui");
  self:setLayerPopableData(layerPopableData);
end

--初始化数据
function HeroProPopup:initialize(heroId)
  
end

function HeroProPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  self:setContentSize(makeSize(1280,720));  

  self.heroProRender = self.armature:findChildArmature("heroProRender");
  -- local contentTextData = self.heroProRender:getBone("basicProTF2").textData;

  self.expTF = generateText(self,self.armature,"expTF","经验：123548225/1263543213");
  --属性初始化
  self.basicProTF = generateText(self.heroProRender.display,self.heroProRender,"basicProTF","基础属性");
  self.basicProTF1 = generateText(self.heroProRender.display,self.heroProRender,"basicProTF1","冰系伤害：1245");
  self.basicProTF2 = generateText(self.heroProRender.display,self.heroProRender,"basicProTF2","冰系伤害：1245");
  self.basicProTF3 = generateText(self.heroProRender.display,self.heroProRender,"basicProTF3","冰系伤害：1245");
  self.basicProTF4 = generateText(self.heroProRender.display,self.heroProRender,"basicProTF4","冰系伤害：1245");

  self.addProTF = generateText(self.heroProRender.display,self.heroProRender,"addProTF","附加属性");

  self.addProTF1 = generateText(self.heroProRender.display,self.heroProRender,"addProTF1","冰系伤害：1245");
  self.addProTF2 = generateText(self.heroProRender.display,self.heroProRender,"addProTF2","冰系伤害：1245");
  self.addProTF3 = generateText(self.heroProRender.display,self.heroProRender,"addProTF3","冰系伤害：1245");
  self.addProTF4 = generateText(self.heroProRender.display,self.heroProRender,"addProTF4","冰系伤害：1245");
  self.addProTF5 = generateText(self.heroProRender.display,self.heroProRender,"addProTF5","冰系伤害：1245");
  self.addProTF6 = generateText(self.heroProRender.display,self.heroProRender,"addProTF6","冰系伤害：1245");
  self.addProTF7 = generateText(self.heroProRender.display,self.heroProRender,"addProTF7","冰系伤害：1245");
  self.addProTF8 = generateText(self.heroProRender.display,self.heroProRender,"addProTF8","冰系伤害：1245");

  self.careerTF1 = generateText(self.heroProRender.display,self.heroProRender,"careerTF1","职业：影身");
  self.careerTF2 = generateText(self.heroProRender.display,self.heroProRender,"careerTF2","职业：影身");

  --装备初始化
  self.heroEquipeRender = self.armature:findChildArmature("heroEquipeRender");
  self.titleTF = generateText(self.heroEquipeRender.display,self.heroEquipeRender,"titleTF","角色装备");
  self.equipCon = self.heroEquipeRender.display:getChildByName("equipCon");

  local tfTb = {{"武器","衣服","裤子"},{"项链","鞋子","饰品"}};
  for i=1,2 do
    for j=1,3 do
      local iconContainer = IconContainer:create();
      self.equipCon:addChild(iconContainer);  
      local w = (iconContainer:getContentSize().width + 40);
      local h = (iconContainer:getContentSize().height + 40);
      iconContainer:setPositionX(w*(j - 1));
      iconContainer:setPositionY(-h*(i - 1));
      iconContainer:setBgTF(tfTb[i][j]);
    end
  end

  self.zhanLiCon = self.armature.display:getChildByName("zhanLiCon");
  -- self.pgCon = self.armature.display:getChildByName("pgCon");

  local zhanLi = CartoonNum.new();
  zhanLi:initLayer();
  zhanLi:setData(12345,"common_number",40);
  self.zhanLiCon:addChild(zhanLi);

  --heroTabBar
  self.heroTabBar = self.armature:findChildArmature("heroTabBar");
  setHeroTabBar(self.heroTabBar,1);

  --exp_progress
  local progressBar = self.armature:findChildArmature("progressBar");
  self.progressBar = ProgressBar.new(progressBar, "pro_up");
  self.progressBar:setProgress(0.6);

  self.tabBtn1 = generateButton(self.armature,"tabBtn1","common_tab_button","装备",self.click1,self);
  self.tabBtn2 = generateButton(self.armature,"tabBtn2","common_tab_button","属性",self.click2,self);
  self.tabBtn1:select(false);
  self.tabBtn2:select(true);

  self.heroProRender.display:setVisible(true);
  self.heroEquipeRender.display:setVisible(false);
end

function HeroProPopup:click1()
  self.tabBtn1:select(true);
  self.tabBtn2:select(false);
  self.heroProRender.display:setVisible(false);
  self.heroEquipeRender.display:setVisible(true);
end
function HeroProPopup:click2()
  self.tabBtn1:select(false);
  self.tabBtn2:select(true);
  self.heroProRender.display:setVisible(true);
  self.heroEquipeRender.display:setVisible(false);
end

function HeroProPopup:onUIInit()

end

function HeroProPopup:onRequestedData()

end

function LayerPopable:onPreUIClose()

end

function LayerPopable:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end