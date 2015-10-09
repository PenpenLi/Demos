require "main.config.BattleConfig"
require "core.display.Scene"


-- singleton
local instance_ = nil;
function sharedPreloadLayerManager()
    if instance_ == nil then
        instance_ = PreloadLayerManager.new();
    end
    return instance_;
end

PreloadLayerManager = class();
function PreloadLayerManager:ctor()
	self.layerArr = {};
	self.index = 0;
end
----------------
--registerLayer
----------------
function PreloadLayerManager:addLayers(scene)
  self.scene = scene;

	self:registerUIlayer(GameConfig.PRELOAD_LAYER_UI);
	self:registerUIlayer(GameConfig.PRELOAD_PARTICLE_SYSTEM_UI);
  self:registerUIlayer(GameConfig.PRELOAD_SHIFT_UI);
end

--UI直截放在secen上
function PreloadLayerManager:registerUIlayer(index)
  local itemLayer = Layer.new();
  itemLayer:initLayer();
  itemLayer.name = "bitemLayer" .. index;
  self.layerArr[index] = itemLayer;

  itemLayer:setScale(GameData.gameUIScaleRate);
  itemLayer:setPositionXY(GameData.uiOffsetX * GameData.gameUIScaleRate,
                  GameData.uiOffsetY * GameData.gameUIScaleRate)

  self.scene:addChild(itemLayer);
end
----------------
--remove
----------------
function PreloadLayerManager:removeLayer(index)
  self.layerArr[index] = nil;
end
----------------
--get layer by Id
----------------
function PreloadLayerManager:getLayer(index)
  local layer = self.layerArr[index];
  if layer == nil then
    print("err4444");
  end
  return layer;
end
----------------
-- clear all obj 
----------------
function PreloadLayerManager:clear()
	if self.layerArr then
	    for k,v in pairs(self.layerArr) do
		    v:removeChildren()
	    end
    end
end

function PreloadLayerManager:disposePreloadLayerManager()
  instance_ = nil;
  self.layerArr = {};
  if self.layer and self.layer.parent then
    self.scene:removeChild(self.layer)
  end
  self.layer = nil;
end