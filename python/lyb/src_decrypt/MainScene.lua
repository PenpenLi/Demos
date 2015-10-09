require "main.config.MainConfig";
require "main.view.mainScene.MainLayerManager";
require "main.view.mainScene.ui.MainUI";
require "main.view.mainScene.ui.MapScene";

MainScene = class(Scene);

-- creat
function MainScene:ctor()
	self.class = MainScene;
  self.mainUI = MainUI.new()--主界面
  self.mapScene = MapScene.new()--地图场景
  self.name = GameConfig.MAIN_SCENE;
end

function MainScene:dispose()
    self:disposeScene();
end

-- init
function MainScene:onInit()  
    
	--sharedMainLayerManager.instance_ = MainLayerManager.new()
    sharedMainLayerManager():addLayers(self);
    
    --活动、英雄、召唤、剧情、背包既不属于MainUI也不属于MapUI，以及钱币、元宝、体能

    -- 初始化主UI
    self.mainUI:onInit()
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI):addChild(self.mainUI);
    --self.mainUI:setVisible(false);
    -- 初始化地图场景
    self.mapScene:onInit()
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_MAP):addChild(self.mapScene);
    self.mapScene:setScale(GameData.gameUIScaleRate);
    --self.mapScene:setVisible(false);

    -- local mainSize = Director:sharedDirector():getWinSize();
    -- self.mapScene:setPositionXY(mainSize.width/2, mainSize.height/2)
    -- self.mapScene:setAnchorPoint(ccp(0.5,0.5));
    -- self.mapScene:setPositionXY(GameData.uiOffsetX/2 * GameData.gameUIScaleRate,
    --               0)


    setCurrencyGroupVisible(true);


    setHButtonGroupVisible(true);

    setButtonGroupVisible(true);
   
end

function MainScene:cleanSceneAllChildren()
	  gameSceneIns = nil;
	  self.mainUI = nil;
	  self.mapScene = nil;
	  local childNumber = self:getNumOfChildren()
	  while(childNumber > 0) do
      local child = self:getChildAt(0);
      if getTextAnimateRewardInstance() == child then
         self:removeChild(child, false);
      elseif getLoadingInstance == child then
         self:removeChild(child, false);
      else
         self:removeChild(child);
      end
	    --self:removeChildAt(0);
	    childNumber = childNumber - 1;
	  end
    self:addChild(getTextAnimateRewardInstance())
    self:addChild(getLoadingInstance)
	  BitmapCacher:removeUnused();
end



