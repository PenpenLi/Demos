--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "core.controls.GalleryViewLayer";
require "core.controls.RichLabelTTF";
require "core.controls.TextInput";
require "core.display.Scene";
require "core.display.Layer";
require "main.common.transform.CompositeActionAllPart";
require "main.view.serverMerge.ui.ServerMergeAvatarPopup";
require "main.view.serverMerge.ui.ServerMergeNamePopup";
require "main.view.serverMerge.ui.ServerMergeAvatarItem";
require "main.config.StaticArtsConfig";
require "main.managers.GameData";

ServerMergePopup=class(Layer);

function ServerMergePopup:ctor()
  self.class=ServerMergePopup;
end

function ServerMergePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ServerMergePopup.superclass.dispose(self);
  
  BitmapCacher:removeUnused();
end

--
function ServerMergePopup:initialize(serverMergeProxy, bagProxy, datas)
  self:initLayer();
  self.skeleton=serverMergeProxy:getSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.bagProxy=bagProxy;
  self.datas=datas;

  local winSize = Director:sharedDirector():getWinSize();
  local pos=ccp((winSize.width - GameConfig.STAGE_WIDTH)/2,(winSize.height-GameConfig.STAGE_HEIGHT)/2);  
  local uiBackImage=Image.new();
  uiBackImage:loadByArtID(StaticArtsConfig.SERVER_MERGE);
  uiBackImage:setScale(GameData.gameUIScaleRate);
  uiBackImage:setPosition(pos);
  self:addChild(uiBackImage);

  local serverMergeAvatarPopup=ServerMergeAvatarPopup.new();
  serverMergeAvatarPopup:initialize(self.serverMergeProxy,self.bagProxy,self.datas);
  serverMergeAvatarPopup:setScale(GameData.gameUIScaleRate);
  serverMergeAvatarPopup:setPosition(pos);
  self:addChild(serverMergeAvatarPopup);
  self.serverMergeAvatarPopup=serverMergeAvatarPopup;
end

function ServerMergePopup:refreshUserName(userName)
  self.serverMergeAvatarPopup:refreshUserName(userName);
end