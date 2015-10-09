require "main.config.MainConfig"

-- singleton
local instance_ = nil;
function sharedMainLayerManager()
    if instance_ == nil then
        instance_ = MainLayerManager.new();
        --instance_:init();
    end
    return instance_ ;
end

MainLayerManager = class();
function MainLayerManager:ctor()
	self.layerArr = {};
	self.index = 0;
	self.layer = Layer.new();
	self.layer:initLayer();
	self.layer.name = "MainLayerManager";
end
----------------
--registerLayer
----------------
function MainLayerManager:addLayers(scene)
	--self:registerLayer(MainConfig.MAIN_LAYER_SKYBOX);
	--self:registerLayer(MainConfig.MAIN_LAYER_MAP_BG);
	self:registerLayer(MainConfig.MAIN_LAYER_MAP);
	self:registerLayer(MainConfig.MAIN_LAYER_STORYLINE_MAP);
	--self:registerLayer(MainConfig.MAIN_LAYER_PLAYERS);
	--self:registerLayer(MainConfig.MAIN_LAYER_MAP_FORWARD);
	self:registerLayer(MainConfig.MAIN_LAYER_PARTICLE_SYSTEM);
	self:registerLayer(MainConfig.MAIN_LAYER_UI);
	self:registerLayer(MainConfig.MAIN_LAYER_BOTTOM_POPUP);
	self:registerLayer(MainConfig.MAIN_LAYER_POPUP);
	self:registerLayer(MainConfig.MAIN_LAYER_CURRENCY);
	self:registerLayer(MainConfig.MAIN_LAYER_ASSIST);
	self:registerLayer(MainConfig.MAIN_LAYER_EFFECTS);

	scene:addChild(self.layer);
end
----------------
-- register layer by id
----------------
function MainLayerManager:registerLayer(index)
	local itemLayer = Layer.new();--(self.layerArr[index] and self.layerArr[index]) or Layer.new();
	itemLayer:initLayer();
	itemLayer.name = "itemLayer" .. index;
	self.layerArr[index] = itemLayer;

	if index == MainConfig.MAIN_LAYER_MAP then
		--itemLayer:setScale(GameData.gameMetaScaleRate);
	else
		itemLayer:setScale(GameData.gameUIScaleRate);
		if index ~= MainConfig.MAIN_LAYER_EFFECTS then
			itemLayer:setPositionXY(GameData.uiOffsetX * GameData.gameUIScaleRate,GameData.uiOffsetY * GameData.gameUIScaleRate)	
		end
	end

	self.layer:addChild(itemLayer);

end
----------------
--remove
----------------
function MainLayerManager:removeLayer(index)
	self.layerArr[index] = nil;
end
----------------
--get layer by Id
----------------
function MainLayerManager:getLayer(index)
	local layer = self.layerArr[index];
	if layer == nil then
		print("err3333");
	end
	return layer;
end
----------------
-- clear all obj 
----------------
function MainLayerManager:clear()
	-- for k,v in pairs(self.layerArr) do
				-- self.layerArr[index] = nil;
	-- end
	instance_ = nil;
	self.layerArr = {};

end

function MainLayerManager:disposeMainLayerManager()
	instance_ = nil;
	self.layerArr = {};
	if self.layer and self.layer.parent then
		self.layer.parent:removeChild(self.layer)
	end
	self.layer = nil;
end
