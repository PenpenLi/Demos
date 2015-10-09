--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.utils.LayerColorBackGround";
require "core.utils.RefreshTime";
require "main.config.StaticArtsConfig";
require "main.config.PossessionBattleConfig";
require "main.common.effectdisplay.EffectFigure";
require "main.view.possessionBattle.ui.PossessionSignUI";
require "main.view.possessionBattle.ui.PossessionDeployUI";
require "main.view.possessionBattle.ui.PossessionDeployItem";
require "main.view.possessionBattle.ui.PossessionMemberUI";
require "main.view.possessionBattle.ui.PossessionMemberItem";
require "main.view.possessionBattle.ui.PossessionPosUI";
require "main.view.possessionBattle.ui.PossessionBattleUI";
require "main.view.possessionBattle.ui.PossessionBattleItem";
require "main.view.possessionBattle.ui.PossessionEndUI";
require "main.view.possessionBattle.ui.PossessionLastBattleUI";
require "main.view.possessionBattle.ui.PossessionLastBattleItem";
require "main.view.possessionBattle.ui.PossessionRuleUI";

PossessionBattlePopup=class(Layer);

function PossessionBattlePopup:ctor()
  self.class=PossessionBattlePopup;
end

function PossessionBattlePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionBattlePopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

--
function PossessionBattlePopup:initializeUI(skeleton, possessionBattleProxy, familyProxy, userProxy, effectProxy, battleProxy, resumeData)
  self:initLayer();
  self.skeleton=skeleton;
  self.possessionBattleProxy=possessionBattleProxy;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.effectProxy=effectProxy;
  self.battleProxy=battleProxy;
  self.resumeData=resumeData;
  
  -- AddUIBackGround(self,StaticArtsConfig.POSSESSION_BATTLE);
  
  self:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_REGISTER,{BooleanValue=1},self));
end

function PossessionBattlePopup:addSignInUI()
  self.signInUI=PossessionSignUI.new();
  self.signInUI:initializeUI(self.skeleton,self);
  self:addChild(self.signInUI);

  AddUIBackGround(self,StaticArtsConfig.POSSESSION_BATTLE);
end

function PossessionBattlePopup:addDeployUI(mapID, isViewOnly)
  self.deployUI=PossessionDeployUI.new();
  self.deployUI:initializeUI(self.skeleton,self,mapID,isViewOnly);
  self:addChild(self.deployUI);
end

function PossessionBattlePopup:addMemberUI(mapID, id, data)
  self.memberUI=PossessionMemberUI.new();
  self.memberUI:initializeUI(self.skeleton,self,mapID,id,data);
  self:addChild(self.memberUI);
end

function PossessionBattlePopup:addPosUI(mapID)
  self.posUI=PossessionPosUI.new();
  self.posUI:initializeUI(self.skeleton,self,mapID);
  self:addChild(self.posUI);
end

function PossessionBattlePopup:addBattleUI()
  self.battleUI=PossessionBattleUI.new();
  self.battleUI:initializeUI(self.skeleton,self);
  self:addChild(self.battleUI);
end

function PossessionBattlePopup:addEndUI()
  self.endUI=PossessionEndUI.new();
  self.endUI:initializeUI(self.skeleton,self);
  self:addChild(self.endUI);
end

function PossessionBattlePopup:addLastBattleUI(mapID)
  self.lastBattleUI=PossessionLastBattleUI.new();
  self.lastBattleUI:initializeUI(self.skeleton,self,mapID);
  self:addChild(self.lastBattleUI);
end

function PossessionBattlePopup:popMessage(stage)
  local a;
  if PossessionBattleConfig.ID_4==stage then
    a=PopupMessageConstConfig.ID_258;
  elseif PossessionBattleConfig.ID_5==stage then
    a=PopupMessageConstConfig.ID_259;
  elseif PossessionBattleConfig.ID_7==stage then
    a=PopupMessageConstConfig.ID_260;
  elseif PossessionBattleConfig.ID_8==stage then
    a=PopupMessageConstConfig.ID_261;
  elseif PossessionBattleConfig.ID_10==stage then
    a=PopupMessageConstConfig.ID_262;
  elseif PossessionBattleConfig.ID_11==stage then
    a=PopupMessageConstConfig.ID_263;
  end
  if a then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(a));
  end
end

function PossessionBattlePopup:removeUIs()
  if self.signInUI then
    self:removeChild(self.signInUI);
    self.signInUI=nil;
  end
  if self.deployUI then
    self:removeChild(self.deployUI);
    self.signInUI=nil;
  end
  if self.memberUI then
    self:removeChild(self.memberUI);
    self.memberUI=nil;
  end
  if self.posUI then
    self:removeChild(self.posUI);
    self.posUI=nil;
  end
  if self.battleUI then
    self:removeChild(self.battleUI);
    self.battleUI=nil;
  end
  if self.endUI then
    self:removeChild(self.endUI);
    self.endUI=nil;
  end
  if self.lastBattleUI then
    self:removeChild(self.lastBattleUI);
    self.lastBattleUI=nil;
  end
end

function PossessionBattlePopup:resume4Battle()
  if self.resumeData then
    if self.battleUI then
      self.battleUI:resume4Battle();
    elseif self.endUI then
      self.endUI:resume4Battle();
    end
  end
end

--移除
function PossessionBattlePopup:onCloseButtonTap(event)
  self:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_REGISTER,{BooleanValue=0},self));
  self:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_CLOSE,nil,self));
end

function PossessionBattlePopup:refreshStage(data)
  local stage=data.Stage;
  if PossessionBattleConfig.ID_0==stage then
    if not self.lastBattleUI then
      self:removeUIs();
      self:addLastBattleUI();
    end
    self.lastBattleUI:refreshStage(data);
  elseif PossessionBattleConfig.ID_1==stage then
    if not self.endUI then
      self:removeUIs();
      self:addEndUI();
    end
    self.endUI:refreshStage(data);
  elseif PossessionBattleConfig.ID_2==stage then
    if not self.signInUI then
      self:removeUIs();
      self:addSignInUI();
    end
    self.signInUI:refreshStage(data);
  else
    if not self.battleUI then
      self:removeUIs();
      self:addBattleUI();
    end
    self.battleUI:refreshStage(data);
  end
  self:resume4Battle();
  self:popMessage(stage);
end

function PossessionBattlePopup:refreshPosData(data)
  if self.signInUI then
    self.signInUI:refreshSetPosConfirmed(data);
  end
  if self.posUI then
    self.posUI:refreshPosData(data);
  end
end

function PossessionBattlePopup:refreshDeploy(data)
  if self.deployUI then
    self.deployUI:refreshDeploy(data);
  end
end

function PossessionBattlePopup:refreshProgress()
    if self.viewBattleUI then
        self.viewBattleUI:refreshProgress();
    end
end

function PossessionBattlePopup:refreshViewData()
    if self.viewBattleUI then
        self.viewBattleUI:refreshViewData();
    end
end

function PossessionBattlePopup:refreshDeployConfirmed(mapID)
  if self.signInUI then
    self.signInUI:refreshDeployConfirmed(mapID);
  end
end

function PossessionBattlePopup:refreshFamilyNewInfo()
  if self.signInUI then
    self.signInUI:refreshFamilyNewInfo();
  end
end

function PossessionBattlePopup:refreshSignCount(data)
  if self.signInUI then
    self.signInUI:refreshSignCount(data);
  end
end