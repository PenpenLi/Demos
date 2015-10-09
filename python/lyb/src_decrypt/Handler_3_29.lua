--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_3_29 = class(Command);

function Handler_3_29:execute()
  print(".3.29..",recvTable["Zhanli"],recvTable["BooleanValue"],recvTable["AddOrSub"],recvTable["Value"]);
  if 1==recvTable["BooleanValue"] then
    local a=1==recvTable["AddOrSub"] and -recvTable["Value"] or recvTable["Value"];
    a=a+recvTable["Zhanli"];
    self:refreshZhanliEffect(a);
  end
end

function Handler_3_29:refreshZhanliEffect(zhanli)
  local scene = self:getParent4u()
  if not scene then return end
  require "main.common.effectdisplay.markEffect.MarkEffectLayer";
  local markEffectLayer=MarkEffectLayer.new();
  markEffectLayer:initialize(self:retrieveProxy(EffectProxy.name),zhanli,recvTable["Zhanli"]-zhanli);
  markEffectLayer:setScale(GameData.gameUIScaleRate)
  --markEffectLayer:setAnchorPoint(ccp(0.5,0.5))
  --local winsize = Director:sharedDirector():getWinSize()
  --markEffectLayer:setPositionXY(winsize.width / 2, winsize.height / 2)
  scene:addChild(markEffectLayer);
  --commonAddToScene(markEffectLayer)

end

function Handler_3_29:getParent4u()
  local scene = Director.sharedDirector():getRunningScene();
  local parent4u=nil;
  if scene then
    if scene.name == GameConfig.MAIN_SCENE then
      if sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS) then
        parent4u=sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS);
      end
    elseif scene.name == GameConfig.BATTLE_SCENE then
      return nil
    else
      parent4u=scene;
    end
  end
  return parent4u;
end

Handler_3_29.new():execute();