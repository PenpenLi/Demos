--------------------------------------------------------------------
--  Class include: PreloadSceneUI, BattleLayerManager
--------------------------------------------------------------------

require "main.view.preloadScene.PreloadLayerManager"
require "core.display.TextField";
require "core.controls.Image";

PreloadSceneUI = class(Scene);
function PreloadSceneUI:ctor()
	self.class = PreloadSceneUI;
	self.name = GameConfig.PRELOAD_SCENE;
end

function PreloadSceneUI:dispose()
	self.loginUI = nil;
	self:removeAllEventListeners();
	PreloadSceneUI.superclass.dispose(self);
	self:disposeScene();
end

function PreloadSceneUI:onInit()
    sharedPreloadLayerManager():disposePreloadLayerManager()
    sharedPreloadLayerManager():addLayers(self);
	
	-- local _winSize = Director:sharedDirector():getWinSize()
	-- local _backImage = Image.new()
	-- _backImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_BG)
	-- _backImage.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
	-- _backImage:setPositionXY(_winSize.width / 2 - GameData.uiOffsetX,_winSize.height / 2 - GameData.uiOffsetY)
	-- sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(_backImage);

	if GameData.isMusicOn then
		MusicUtils:play(1,true)
	end

end