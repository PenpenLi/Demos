require "main.config.BattleConfig"
require "core.display.Scene"


-- singleton
local instance_ = nil;
function sharedFunctionLayerManager()
    if instance_ == nil then
        instance_ = FunctionLayerManager.new();
    end
    return instance_;
end

FunctionLayerManager = class();
function FunctionLayerManager:ctor()
	self.layerArr = {};
	self.index = 0;
end
----------------
--registerLayer
----------------
function FunctionLayerManager:addLayers(scene)
  self.scene = scene;

	self:registerUIlayer(GameConfig.FUNCTION_LAYER_UI);
	--self:registerUIlayer(BattleConfig.Battle_LAYER_SHIFT_SCENE);

end

--UI直截放在secen上
function FunctionLayerManager:registerUIlayer(index)
  local itemLayer = Layer.new();
  itemLayer:initLayer();
  itemLayer.name = "bitemLayer" .. index;
  self.layerArr[index] = itemLayer;

  itemLayer:setScale(GameData.gameUIScaleRate);
  local winSize = Director:sharedDirector():getWinSize();
  itemLayer:setPositionXY((winSize.width - GameConfig.STAGE_WIDTH) / 2 * GameData.gameUIScaleRate,
                  (winSize.height - GameConfig.STAGE_HEIGHT) / 2 * GameData.gameUIScaleRate)

  self.scene:addChild(itemLayer);
end
----------------
--remove
----------------
function FunctionLayerManager:removeLayer(index)
  self.layerArr[index] = nil;
end
----------------
--get layer by Id
----------------
function FunctionLayerManager:getLayer(index)
  local layer = self.layerArr[index];
  if layer == nil then
    print("err222");
  end
  return layer;
end
----------------
-- clear all obj 
----------------
function FunctionLayerManager:clear()
	if self.layerArr then
	    for k,v in pairs(self.layerArr) do
		    v:removeChildren()
	    end
    end
end

function FunctionLayerManager:disposeFunctionLayerManager()
  instance_ = nil;
  self.layerArr = {};
  if self.layer and self.layer.parent then
    self.scene:removeChild(self.layer)
  end
  self.layer = nil;
end