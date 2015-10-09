	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
	-- Create date: 2013-5-2

	-- yanchuan.xie@happyelements.com

require "core.display.LayerPopable";
require "core.utils.LayerColorBackGround";
require "core.controls.RichTextInput";
require "core.controls.RichTextLineInput";
require "main.config.SpecialItemConstConfig";

FamilyPopup=class(LayerPopableDirect);

function FamilyPopup:ctor()
  self.class=FamilyPopup;
end

function FamilyPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  if self.panels then
    for k,v in pairs(self.panels) do
      if not v.isDisposed then
        v:dispose();
      end
    end
  end
	FamilyPopup.superclass.dispose(self);

  if self.armature then
    self.armature:dispose();
  end
  BitmapCacher:removeUnused();
end

function FamilyPopup:onDataInit()
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.buddyListProxy=self:retrieveProxy(BuddyListProxy.name);
  self.effectProxy=self:retrieveProxy(EffectProxy.name);
  self.chatListProxy=self:retrieveProxy(ChatListProxy.name);
  -- self.challengeProxy=self:retrieveProxy(ChallengeProxy.name);
  self.generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.shopProxy=self:retrieveProxy(ShopProxy.name);
  self.skeleton = self.familyProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton, "family_ui");
  self:setLayerPopableData(layerPopableData);
end

function FamilyPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  local image = Image.new();
  image:loadByArtID(875);
  -- image:setScale(2);
  self:addChildAt(image,0);
end

function FamilyPopup:onUIInit()
  self.xinxi_img =self.armature.display:getChildByName("xinxi_img");
  SingleButton:create(self.xinxi_img);
  self.xinxi_img:addEventListener(DisplayEvents.kTouchTap, self.onXinxiTap, self);

  self.chengyuan_img =self.armature.display:getChildByName("chengyuan_img");
  SingleButton:create(self.chengyuan_img);
  self.chengyuan_img:addEventListener(DisplayEvents.kTouchTap, self.onChengyuanTap, self);

  self.rizhi_img =self.armature.display:getChildByName("rizhi_img");
  SingleButton:create(self.rizhi_img);
  self.rizhi_img:addEventListener(DisplayEvents.kTouchTap, self.onRizhiTap, self);

  self.shenqing_img =self.armature.display:getChildByName("shenqing_img");
  SingleButton:create(self.shenqing_img);
  self.shenqing_img:addEventListener(DisplayEvents.kTouchTap, self.onShenqingTap, self);

  self:initialize();
end

function FamilyPopup:onRequestedData()
  
end

function FamilyPopup:onUIClose()
  if self.isLookInto then
    self.parent.onLookIntoFamilyPopup=nil;
    self.parent:removeChild(self);
    return;
  end
  self:dispatchEvent(Event.new(FamilyNotifications.FAMILY_CLOSE,nil,self));
end

function FamilyPopup:onPreUIClose()
  
end

function FamilyPopup:initialize(isLookInto, lookIntoFamilyID)
  require "main.view.family.ui.NoneFamilyLayer";
  require "main.view.family.ui.NoneFamilyItem";
  require "main.view.family.ui.FamilyFuoundLayer";

  require "main.view.family.ui.FamilyInfoLayer";
  require "main.view.family.ui.FamilyMemberLayer";
  require "main.view.family.ui.FamilyMemberItem";
  require "main.view.family.ui.FamilyLogLayer";
  require "main.view.family.ui.FamilyLogItem";
  require "main.view.family.ui.FamilyAuthorityLayer";
  require "main.view.family.ui.FamilyAuthorityItem";
  require "main.view.family.ui.FamilyActivityIcon";
  require "main.view.family.ui.FamilyApplyLayer";
  require "main.view.family.ui.FamilyApplyItem";
  require "main.view.family.ui.FamilyItemPopup";
  require "main.view.family.ui.FamilyAppointPopup";
  require "main.view.family.ui.FamilyInviteLayer";
  require "main.view.family.ui.FamilyNoticeLayer";

  self.isLookInto=isLookInto;
  self.lookIntoFamilyID=lookIntoFamilyID;

  -- local bg=LayerColorBackGround:getBackGround();
  -- self:addChild(bg);

  if self.isLookInto then
    self:initializeFamily();
    self:dispatchEvent(Event.new(FamilyNotifications.LOOK_INTO_FAMILY,{FamilyId=self.lookIntoFamilyID},self));
  elseif 0==self.userProxy:getFamilyID() then
    self:initializeNoneFamily();

    self.xinxi_img:setVisible(false);
    self.chengyuan_img:setVisible(false);
    self.rizhi_img:setVisible(false);
    self.shenqing_img:setVisible(false);
  else
    self:initializeFamily();
    self:dispatchEvent(Event.new(FamilyNotifications.LOOK_INTO_FAMILY,{FamilyId=self.userProxy:getFamilyID()},self));
  end 
end

function FamilyPopup:initializeNoneFamily()
  self.noneFamilyLayer=NoneFamilyLayer.new();
  self.noneFamilyLayer:initialize(self);
  self:addChild(self.noneFamilyLayer);
end

function FamilyPopup:refreshNoneFamilyLayerData(page, maxPage, familyInfoArray)
  if self.noneFamilyLayer then
    self.noneFamilyLayer:refreshNoneFamilyLayerData(page,maxPage,familyInfoArray);
  elseif self.onLookIntoNoneFamilyLayer then
    self.onLookIntoNoneFamilyLayer:refreshNoneFamilyLayerData(page,maxPage,familyInfoArray);
  end
end

function FamilyPopup:onXinxiTap(event)
  self:onTabButton(1);
end

function FamilyPopup:onChengyuanTap(event)
  self:onTabButton(2);
end

function FamilyPopup:onRizhiTap(event)
  self:onTabButton(3);
end

function FamilyPopup:onShenqingTap(event)
  self:onTabButton(4);
end

function FamilyPopup:getPanel(a)
  if nil==self.panels[a] then
    local panel;
    if 1==a then
      panel=FamilyInfoLayer.new();
      panel:initialize(self);
    elseif 2==a then
      panel=FamilyMemberLayer.new();
      panel:initialize(self.skeleton,self.familyProxy,self.userProxy,self);
    elseif 3==a then
      panel=FamilyLogLayer.new();
      panel:initialize(self.skeleton,self.familyProxy,self);
    elseif 4==a then
      panel=FamilyApplyLayer.new();
      panel:initialize(self.skeleton,self.familyProxy,self.userProxy,self);
    end
    self.panels[a]=panel;
  end

  return self.panels[a];
end

function FamilyPopup:initializeFamily()
  self.panels={};
  self:onXinxiTap();
end

function FamilyPopup:onTabButton(num)
  self:removePanel();

  self.panel_select=self:getPanel(num);
  self.armature.display:addChildAt(self.panel_select,2);
end

function FamilyPopup:removePanel()
  if self.panel_select then
    self.panel_select.parent:removeChild(self.panel_select,false);
    self.panel_select=nil;
  end
end

function FamilyPopup:refreshFamilyData(data)
  if self.noneFamilyLayer then
    self:removeChild(self.noneFamilyLayer);
    self.noneFamilyLayer=nil;
    self:initializeFamily();
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_175));
  end
  self:getPanel(1):refresh(data);
end








--移除
function FamilyPopup:onCloseButtonTap(event)
  
end





function FamilyPopup:refreshFamilyApply(familyId, bool)
  self.noneFamilyLayer:refreshFamilyApply(familyId,bool);
end

--onTabButtonTap
function FamilyPopup:onTabButtonTap(event)
  self:onTabButton(event.target);
end





function FamilyPopup:refreshFamilyMemberArray(familyId, memberArray)
  if familyId==self.userProxy:getFamilyID() then
    self:getPanel(2):refreshFamilyMemberArray(familyId,memberArray);
  else
    self.onLookIntoFamilyPopup:getPanel(2):refreshFamilyMemberArray(familyId,memberArray);
  end
end

function FamilyPopup:refreshFamilyApplyArray(applierArray)
  self:getPanel(4):refreshFamilyApplyArray(applierArray);
end

function FamilyPopup:refreshFamilyLog(familyLogArray)
  self:getPanel(3):refreshFamilyLog(familyLogArray);
end

function FamilyPopup:refreshFamilyVerify(userId, booleanValue)
  self:getPanel(4):refreshFamilyVerify(userId,booleanValue);
end

function FamilyPopup:refreshChangePositionID(userId, familyPositionId)
  if self.tab_buttons then
    self:refreshAuthorityByPosition();
    self:getPanel(1):refreshFamilyPosition();
    if not self.panels[2] then return; end
    self:getPanel(2):refreshChangePositionID(userId,familyPositionId);
  end
end

function FamilyPopup:refreshNewInfo()
  self:getPanel(1):refreshNewInfo();
end

function FamilyPopup:refreshNotice()
  self:getPanel(1):refreshNotice();
end

function FamilyPopup:refreshFamilyKick(userID)
  self:getPanel(2):refreshFamilyKick(userID);
end

function FamilyPopup:refreshActivitys()
  if self.noneFamilyLayer then
    return;
  end
  self:getPanel(1):refreshActivitys();
end

function FamilyPopup:onMemberItemTap(event, data)
  local familyItemPopup=FamilyItemPopup.new();
  familyItemPopup:initialize(self.skeleton,self.familyProxy,self.userProxy,self.buddyListProxy,self,data,event.globalPosition,self.onLookIntoFamilyPopup);
  self:addChild(familyItemPopup);
end

function FamilyPopup:onItemPopupTap(event, data, id)
  if 1==id then
    self:dispatchEvent(Event.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,{playerName=data.UserName,playerID=data.UserId},self));
  elseif 2==id then
    self:dispatchEvent(Event.new("chatAddBuddy",{UserId=data.UserId,UserName=data.UserName},self));
  elseif 3==id then
    self:dispatchEvent(Event.new("DUEL_OTHER_PLAYER",{UserId = data.UserId, UserName=data.UserName},self));
  elseif 4==id then
    self:dispatchEvent(Event.new(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,{UserName=data.UserName},self));
  elseif 5==id then
    local familyAppointPopup=FamilyAppointPopup.new();
    familyAppointPopup:initialize(self.skeleton,self.familyProxy,self.userProxy,self,data,event.globalPosition);
    self:addChild(familyAppointPopup);
  elseif 6==id then
    local a=CommonPopup.new();
    a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_182),self,self.onKickConfirm,data,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_182));
    self:addChild(a);
  elseif 7==id then
    self:onImpeach();
  end
end

function FamilyPopup:onKickConfirm(data)
  self:dispatchEvent(Event.new(FamilyNotifications.FAMILY_KICK,{UserId=data.UserId},self));
end

function FamilyPopup:onAppointPopupTap(data, id)
  if self:getPanel(2):getAppointableByPositionID(id) then
    self:dispatchEvent(Event.new(FamilyNotifications.FAMILY_CHANGE_POSITIONID,{UserId=data.UserId,FamilyPositionId=id},self));
  end
end

function FamilyPopup:onOtherFamilyButtonTap()
  self.onLookIntoNoneFamilyLayer=NoneFamilyLayer.new();
  self.onLookIntoNoneFamilyLayer:initialize(self.skeleton,self.familyProxy,self.userProxy,self.bagProxy,self.userCurrencyProxy,self,true);
  self:addChild(self.onLookIntoNoneFamilyLayer);
end

function FamilyPopup:refreshLookIntoFamily(data)
  uninitializeSmallLoading();
  self.onLookIntoFamilyPopup=FamilyPopup.new();
  self.onLookIntoFamilyPopup:initialize(self.skeleton,self.familyProxy,self.userProxy,self.bagProxy,self.userCurrencyProxy,self.buddyListProxy,self.effectProxy,self.chatListProxy,self.challengeProxy,self.generalListProxy,self.countControlProxy,self.shopProxy,true,data.FamilyId);
  self:addChild(self.onLookIntoFamilyPopup);
  self.onLookIntoFamilyPopup:refreshFamilyData(data);
end

function FamilyPopup:getUserNameByMemberLayer(userId)
  return self:getPanel(2):getUserNameByMemberLayer(userId);
end

function FamilyPopup:getUserNameByApplyLayer(userId)
  return self:getPanel(4):getUserNameByApplyLayer(userId);
end

function FamilyPopup:refreshAuthorityByPosition()
  self.shenqing_img:setVisible(5>self.userProxy:getFamilyPositionID());
end

function FamilyPopup:refreshNewApply()
  if self.noneFamilyLayer then
    return;
  end
  if not self.tab_effect then
    self.tab_effect=cartoonPlayer(EffectConstConfig.FAMILY_EFFECT,102,54,0);
    self.tab_effect.touchEnabled=false;
    self.tab_effect.touchChildren=false;
    self.tab_buttons[4]:addChild(self.tab_effect);
  end
  self.tab_effect:setVisible(self.tab_button_tap~=self.tab_buttons[4] and self.familyProxy:hasNewApply(self.userProxy));
end

function FamilyPopup:refreshFamilyContribute()
  if self.noneFamilyLayer then
    return;
  end
  self:getPanel(1):refreshFamilyContribute();
end

function FamilyPopup:changeTab(tabID)
  if not self.noneFamilyLayer then
    self:onTabButton(self.tab_buttons[tabID]);
  end
end

function FamilyPopup:changeToActivity(id)
  self:getPanel(1):changeToActivity(id);
end

function FamilyPopup:onImpeach()
  local hasItem=0<self.bagProxy:getItemNum(SpecialItemConstConfig.FAMILY_LEADER_IMPEACH);
  local money,price=self.shopProxy:getTypeAndPriceByItemID(SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,{1,2,3,4});
  local enough=false;
  if money then
    enough=price<=self.userCurrencyProxy:getMoneyByItemID(money);
  end
  
  local function onImpeachConfirm()
    self:dispatchEvent(Event.new(FamilyNotifications.FAMILY_IMPEACH,nil,self));
    sharedTextAnimateReward():animateStartByString("弹劾族长成功啦！你现在是族长咯！");
  end
  local function onImpeachConfirmByGold()
    if enough then
      onImpeachConfirm();
    else
      sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
      self:dispatchEvent(Event.new("vip_recharge",nil,self));
    end
  end
  if hasItem then
    local s="<content><font color='#FFFFFF'>弹劾族长需要</font>";
    s=s .. "<font color='" .. getColorByQuality(analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"color"),true) .. "'>";
    s=s .. analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"name") .. "x1</font>";
    s=s .. "<font color='#FFFFFF'>呢，弹劾以后要和小伙伴们一起玩耍哦~</font></content>";
    local a=CommonPopup.new();
    a:initialize(s,nil,onImpeachConfirm,nil,nil,nil,false,{"弹劾","取消"},true);
    self:addChild(a);
  else
    local s="<content><font color='#FFFFFF'>弹劾族长需要</font>";
    s=s .. "<font color='" .. getColorByQuality(analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"color"),true) .. "'>";
    s=s .. analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"name") .. "x1</font>";
    s=s .. "<font color='#FFFFFF'>呢，要不要花</font>";
    s=s .. "<font color='#" .. (enough and "00FF00" or "FF0000") .. "'>";
    s=s .. price .. analysis("Daoju_Daojubiao",money,"name") .. "</font>";
    s=s .. "<font color='#FFFFFF'>买一个完成弹劾呢？</font></content>";
    local a=CommonPopup.new();
    a:initialize(s,nil,onImpeachConfirmByGold,nil,nil,nil,false,{"弹劾","取消"},true);
    self:addChild(a);
  end
end

function FamilyPopup:refreshFamilyBossRankData(skeleton, challengeProxy)
  local function cbfunction()
    self:getPanel(1).item_layer:setMoveEnabled(true);
  end
  require "main.view.challenge.ui.universal_boss_battle_end.UniversalBossBattleEndRank";
  local universalBossBattleEndRank=UniversalBossBattleEndRank.new();
  universalBossBattleEndRank:initialize(skeleton,challengeProxy);
  universalBossBattleEndRank:setOnTap(self,cbfunction);
  self:addChild(universalBossBattleEndRank);
  self:getPanel(1).item_layer:setMoveEnabled(false);
end

function FamilyPopup:refreshActivity4FamilyBoss()
  if self.noneFamilyLayer then
    return;
  end
  self:getPanel(1):refreshActivity4FamilyBoss();
end