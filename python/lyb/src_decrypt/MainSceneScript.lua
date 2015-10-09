require "main.controller.command.scriptCartoon.GameScript"
MainSceneScript = class(GameScript);

function MainSceneScript:ctor()
	self.class = MainSceneScript;
end

function MainSceneScript:cleanSelf()
	self.class = nil
end

function MainSceneScript:dispose()
    self:cleanSelf();
end

function MainSceneScript:initScript(scriptPopUp)
	self.battleProxy = Facade.getInstance():retrieveProxy(BattleProxy.name);
	self.gameScriptLayer = Layer.new()
	self.gameScriptLayer:initLayer()
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST):addChild(self.gameScriptLayer)
	self.mapLayer = Layer.new()
	self.mapLayer:initLayer()
	self.gameScriptLayer:addChild(self.mapLayer)
	self.playerLayer = Layer.new()
	self.playerLayer:initLayer()	
	self.gameScriptLayer:addChild(self.playerLayer)
	self.effectLayer = Layer.new()
	self.effectLayer:initLayer()	
	self.gameScriptLayer:addChild(self.effectLayer)
	self.isBattleScript = false
	self.scriptPopUp = scriptPopUp
	self:initTiaoGuoButtion()
	mainSceneScript = self
end

function MainSceneScript:beginScript(scriptId)
	self.isOnTiaoGuo = nil
	MainSceneScript.superclass.beginScript(self,scriptId)
	self:initTiaoGuoButtion()
	self.assistLayer = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_ASSIST)
	self.layerScale = self.assistLayer:getScale()
	self.layerPosition = self.assistLayer:getPosition()
	self.assistLayer:setScale(GameData.gameUIScaleRate);
	self.assistLayer:setPositionXY(GameData.uiOffsetX * GameData.gameUIScaleRate,GameData.uiOffsetY * GameData.gameUIScaleRate)
	local function startFun()
		if self.tiaoGuoBtn then
			self.tiaoGuoBtn:setVisible(true)
		end
	end
	Tweenlite:delayCallS(1.5,startFun);
end

function MainSceneScript:initTiaoGuoButtion()
	if self.tiaoGuoBtn then return end
	local winSize = Director:sharedDirector():getWinSize();
	self.tiaoGuoBtn=getImageByArtId(1669)
	self.tiaoGuoBtn:setPositionXY(winSize.width-GameData.uiOffsetX-70,winSize.height-(40+GameData.uiOffsetY)*GameData.gameUIScaleRate);
	self.tiaoGuoBtn.touchEnabled = true
	self.tiaoGuoBtn:setAnchorPoint(CCPointMake(0.5,0.5))
	self.tiaoGuoBtn:addEventListener(DisplayEvents.kTouchBegin,self.onTiaoGuoBegin,self);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.tiaoGuoBtn);
	self.tiaoGuoBtn:setVisible(false)
end

function MainSceneScript:onTiaoGuoBegin(event)
	self.tiaoGuoBtn:addEventListener(DisplayEvents.kTouchEnd,self.onTiaoGuoTap,self);
	self.tiaoGuoBtn:setScale(1.1)
end

function MainSceneScript:onTiaoGuoTap()
	self.tiaoGuoBtn:setScale(1)
	self:endScriptData()
	require "main.controller.command.task.ModalDialogCloseCommand";
	require "main.view.modalDialog.ModalDialogMediator";
	ModalDialogCloseCommand.new():execute()
	self.isOnTiaoGuo = true
end

function MainSceneScript:readyEndScript()
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):removeChild(self.tiaoGuoBtn);
	self.tiaoGuoBtn = nil
	MainSceneScript.superclass.readyEndScript(self)
    if self.scriptPopUp and self.scriptPopUp.readyEndScript then
	    self.scriptPopUp:readyEndScript()
	    self.scriptPopUp = nil
    end
end

function MainSceneScript:endScriptData()
	MainSceneScript.superclass.endScriptData(self)
	BitmapCacher:deleteTextureMap(GameData.deleteBattleTextureMap)
    GameData.deleteBattleTextureMap = {};
    if self.scriptPopUp and self.scriptPopUp.endScriptData then
	    self.scriptPopUp:endScriptData()
	    self.scriptPopUp = nil
    end
	self.assistLayer:setScale(self.layerScale);
	self.assistLayer:setPosition(self.layerPosition)
	mainSceneScript = nil
end