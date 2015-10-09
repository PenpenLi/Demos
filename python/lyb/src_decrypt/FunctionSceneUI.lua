require "main.view.functionScene.FunctionLayerManager"

FunctionSceneUI = class(Scene);
function FunctionSceneUI:ctor()
	self.class = FunctionSceneUI;
	self.name = GameConfig.FUNCTION_SCENE;
end

function FunctionSceneUI:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	FunctionSceneUI.superclass.dispose(self);
	self:disposeScene();
end

function FunctionSceneUI:onInit()
    sharedFunctionLayerManager():disposeFunctionLayerManager()
    sharedFunctionLayerManager():addLayers(self);


    --   globalPositionText = TextField.new(CCLabelTTF:create("x=0,y=0",FontConstConfig.OUR_FONT,30), true);
    --   globalPositionText:setPositionY(180)
    --   self:addChild(globalPositionText)

  	 --  globalResetButton = CommonButton.new();
 	  -- globalResetButton=CommonButton.new();
 	  -- globalResetButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
 	  -- globalResetButton:initializeText({x=28,y=-50,size=24,width=150,height=36,color=16777215,alignment=kCCTextAlignmentLeft}, "重置蝴蝶");
    -- globalResetButton:setPositionY(660)
 	  -- self:addChild(globalResetButton);
end

--传入一个mediator,并初始化这个mediator控制的view
function FunctionSceneUI:initializeUI(mediator)
	if mediator then
		sharedFunctionLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(mediator:getViewComponent());
	end
end