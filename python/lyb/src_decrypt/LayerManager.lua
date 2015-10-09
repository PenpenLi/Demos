require "core.display.Layer";
require "core.utils.Scheduler";
require "core.utils.ComponentUtils";

LayerManager = {};

LayerManager.isPopping = false;
LayerManager.layerPopables = {};
LayerManager.showCurrencys = {};
LayerManager.layer4Xingneng = {};

LayerManager.layerKeyBackables = {};

function LayerManager:clean()
	self.isInScheduler = false;
	LayerManager.isPopping = false;
	LayerManager.layerPopables = {};
	LayerManager.showCurrencys = {};
	LayerManager.layer4Xingneng = {};
end

function LayerManager:addLayerPopable(layerPopable)
	if layerPopable:is(LayerPopableDirect) then
		LayerManager:_pop(layerPopable);

	elseif layerPopable:is(LayerPopable) then
		table.insert(LayerManager.layerPopables, layerPopable);
		self:_new_pop();
	end
	if layerPopable.layerPopableData and layerPopable.layerPopableData.visibleDelegate then
		table.insert(LayerManager.layer4Xingneng, layerPopable);
		self:refreshLayerPopable4Xingneng();
	end
end
--GameData.uiOffsetX
function LayerManager:addTwoLayerPopable(layerPopable, newLayerPopable)
	LayerManager:_pop(newLayerPopable);


	local xPos1 = -(newLayerPopable.armature.display:getGroupBounds(false).size.width / 2) / CommonUtils:getGameUIScaleRate()
	local xPos2 = (layerPopable.armature.display:getGroupBounds(false).size.width / 2) / CommonUtils:getGameUIScaleRate()

    local moveTo = CCMoveBy:create(0.25, CCPointMake(xPos1, 0));
    local moveTo2 = CCMoveBy:create(0.25, CCPointMake(xPos2, 0));

	if layerPopable.hasRunAction then
	    local moveTo3 = CCMoveBy:create(0, CCPointMake(-xPos1, 0));
	    layerPopable:runAction(CCSequence:createWithTwoActions(moveTo3, moveTo))
    else
    	layerPopable:runAction(moveTo)
    end
    layerPopable.hasRunAction = true;
    newLayerPopable:runAction(moveTo2)
end

function LayerManager:removeLayerPopable(layerPopable)
	local layer = layerPopable or LayerManager.layerPopables[1];
	if layer then
		-- local size = layer:getContentSize();
		-- local win_size = Director:sharedDirector():getWinSize();
		-- local function spawnFunc()
		-- 	if layer.isDisposed then
		-- 		removeSchedule(nil,spawnFunc);
		-- 		return;
		-- 	end
		-- 	-- layer:setPositionXY((win_size.width-layer:getScaleX()*size.width)/2,
		-- 	-- 					(win_size.height-layer:getScaleY()*size.height)/2);
		-- end

		local function endFunc()
			-- removeSchedule(nil,spawnFunc);
			layer:onUIClose();
			if layer.layerPopableData and layer.layerPopableData.visibleDelegate then
				for k,v in pairs(LayerManager.layer4Xingneng) do
					if layer == v then
						table.remove(LayerManager.layer4Xingneng, k);
						break;
					end
				end
				self:refreshLayerPopable4Xingneng();
			end
		end

		-- if layer.layerPopableData and layer.layerPopableData.motion then
		-- 	local array = CCArray:create();
	 --    	array:addObject(CCEaseSineOut:create(CCScaleTo:create(0.2,0.1),0.2));
	 --    	array:addObject(CCCallFunc:create(endFunc));
	 --    	layer:runAction(CCSequence:create(array));
	 --    	addSchedule(nil,spawnFunc);
	 --    else
	    	endFunc();
	    -- end
	end
end

function LayerManager:_pop(layerPopable)
	local layer = layerPopable or LayerManager.layerPopables[1];
	if layer then
		self.isPopping = not layerPopable and true or (not layerPopable:is(LayerPopableDirect) and true);
		layer:onDataInit();
		layer:_onLayerInit();
		layer:onPrePop();
		layer:onDisplay();

		-- local size = layer:getContentSize();
		-- local win_size = Director:sharedDirector():getWinSize();
		local function spawnFunc()
			-- layer:setPositionXY((win_size.width-layer:getScaleX()*size.width)/2,
			-- 					(win_size.height-layer:getScaleY()*size.height)/2);
		end

		local function endFunc()
			removeSchedule(nil,spawnFunc);
			layer:_onPopped();
			layer:onUIInit();
			layer:_onUIInitted();
			layer.isUIPopped=true;
			layer:onRequestedData();
			layer:setScale(1);
			spawnFunc();
		end

		-- if layer.layerPopableData and layer.layerPopableData.motion then
		-- 	local array = CCArray:create();
	 --    	array:addObject(CCEaseSineOut:create(CCScaleTo:create(0.2,1),0.2));
	 --    	array:addObject(CCCallFunc:create(endFunc));
	 --    	layer:setScale(0.3);
	 --    	spawnFunc();
	 --    	layer:runAction(CCSequence:create(array));
	 --    	addSchedule(nil,spawnFunc);
		-- else
			endFunc();
		-- end
	end
end

function LayerManager:_new_pop()
	if self.isPopping then
		return;
	end
	local num=0;
	local function scheduFunc()
		num = 1 + num;
		if num == 2 then

		else
			return;
		end
		self.isInScheduler = false;
		removeSchedule(nil, scheduFunc);
		self:_pop();
	end

	if self.isInScheduler then
		return;
	end

	self.isInScheduler = true;
	addSchedule(nil, scheduFunc);
end

function LayerManager:_removeLayerPopable()
	self.isPopping = false;
	table.remove(LayerManager.layerPopables, 1);
	self:_new_pop();
end

function LayerManager:refreshLayerPopable4Xingneng()
	local idx = table.getn(self.layer4Xingneng);
	for k,v in pairs(self.layer4Xingneng) do
		v:setVisible(idx == k);
	end
end


LayerPopableData = class();

function LayerPopableData:ctor()
  self.class = LayerPopableData;
  self.parent = nil;
  self.on_pre_ui_params = nil;
  self.on_add_frame_params = nil;

  self.on_armature_init_param = nil;
  self.hasUIBackground = true;
  self.hasUIFrame = true;
  self.motion = false;
  self.visibleDelegate = true;
end
function LayerPopableData:setShowCurrency(bool)
	self.showCurrency = bool;
end
function LayerPopableData:setParent(parent)
	self.parent = parent;
end
function LayerPopableData:setPreUIData(backGroudImageID, hasnotBackLayer, isAllSceenBack, scale)
	self.on_pre_ui_params = {backGroudImageID, hasnotBackLayer, isAllSceenBack, scale};
end

function LayerPopableData:setAddFrameData()

end

function LayerPopableData:setArmatureInitParam(skeleton, ui_name)
	self.on_armature_init_param = {skeleton, ui_name};
end

function LayerPopableData:setHasUIBackground(bool)
	self.hasUIBackground = bool;
end

function LayerPopableData:setHasUIFrame(bool)
	self.hasUIFrame = bool;
end

function LayerPopableData:activateMotion()
	self.motion = true;
end

function LayerPopableData:setVisibleDelegate(bool)
	self.visibleDelegate = bool;
end


LayerProxyRetrievable = class(TouchLayer);

function LayerProxyRetrievable:retrieveProxy(proxy_name_string)
  return Facade.getInstance():retrieveProxy(proxy_name_string);
end


LayerKeyBackable = class(LayerProxyRetrievable);

function LayerKeyBackable:ctor()
	self.class = LayerKeyBackable;
	table.insert(LayerManager.layerKeyBackables, self);
end

function LayerKeyBackable:dispose()
	for k,v in pairs(LayerManager.layerKeyBackables) do
		if self == v then
			table.remove(LayerManager.layerKeyBackables, k);
			break;
		end
	end
	LayerKeyBackable.superclass.dispose(self);
end

function LayerKeyBackable:closeUI()

end


LayerPopable = class(LayerKeyBackable);

function LayerPopable:ctor()
  self.class = LayerPopable;
  self.layerPopableData = nil;

  self.isUIPopped = false;
  self.isFreshData = false;

  self.armature = nil;
end

function LayerPopable:dispose()
	self:removeAllEventListeners();
  	self:removeChildren();
  	if self.armature then
  		self.armature:dispose();
  	end
	LayerPopable.superclass.dispose(self);
	BitmapCacher:removeUnused();

	LayerManager:_removeLayerPopable();
end

--@overwrite
function LayerPopable:onDataInit()

end

function LayerPopable:_onLayerInit()
	self:initLayer();
	if self.layerPopableData
	   and self.layerPopableData.on_armature_init_param
	   and self.layerPopableData.on_armature_init_param[1]
	   and self.layerPopableData.on_armature_init_param[2]
	   then

		local params = self.layerPopableData.on_armature_init_param;
		local armature = params[1]:buildArmature(params[2]);
  		armature.animation:gotoAndPlay("f1");
  		armature:updateBonesZ();
  		armature:update();
  		self.armature = armature;
  		self:addChild(self.armature.display);

  		local closeButton =self.armature.display:getChildByName("common_copy_close_button");
  		if closeButton then
  			SingleButton:create(closeButton);
  			closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);
  		end
	end
end

--@overwrite
function LayerPopable:onPrePop()
	
end

--@overwrite ( when you need )
function LayerPopable:onDisplay()
	local parent;
	if self.layerPopableData and self.layerPopableData.parent then
		parent = self.layerPopableData.parent;
	else
		parent = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP);
	end
	if not parent:contains(self) then
		local showCurrency = nil;
		if  self.layerPopableData and self.layerPopableData.showCurrency then
			showCurrency = true;
		else
			showCurrency = false;
		end
		table.insert(LayerManager.showCurrencys, showCurrency);
		local count = #LayerManager.showCurrencys
		print("LayerManager.showCurrencys,onDisplay(),count",count)
		for k=count,1 do
			print(LayerManager.showCurrencys[k]);
		end
		setCurrencyGroupVisible(showCurrency)
		parent:addChild(self);
	end
end

function LayerPopable:_onPopped()
	if self.layerPopableData and not self.layerPopableData.hasUIBackground then
		return;
	end
	if self.layerPopableData and self.layerPopableData.on_pre_ui_params then
		local params = self.layerPopableData.on_pre_ui_params;
		AddUIBackGround(self, params[1], params[2], params[3], params[4]);
	else
		AddUIBackGround(self);
	end
end

--@overwrite
function LayerPopable:onUIInit()

end

function LayerPopable:_onUIInitted()
	if self.layerPopableData and not self.layerPopableData.hasUIFrame then
		return;
	end
	AddUIFrame(self);
end

--@overwrite
function LayerPopable:onRequestedData()

end

--@overwrite ( when you need )
function LayerPopable:onPreUIClose()

end

function LayerPopable:_closeUI()
	table.remove(LayerManager.showCurrencys);
	local count = #LayerManager.showCurrencys
	print("LayerManager.showCurrencys[k]");
	for k=count,1 do
		print(LayerManager.showCurrencys[k]);
	end


	local count = #LayerManager.showCurrencys;
	local bool
	if count == 0 then
		bool = true
	else
		bool = LayerManager.showCurrencys[count]
	end
	setCurrencyGroupVisible(bool)
end

function LayerPopable:closeUI()
	self:_closeUI()
	self:onPreUIClose();
	LayerManager:removeLayerPopable();
end

--@overwrite,这个方法在子类里面不要手动去调用
function LayerPopable:onUIClose()

end

--@overwrite ( when you need )
function LayerPopable:setLayerPopableData(layerPopableData)
	self.layerPopableData = layerPopableData;
end

function LayerPopable:getIsUIPopped()
	return self.isUIPopped;
end

function LayerPopable:getIsFreshData()
	return self.isFreshData;
end

function LayerPopable:setIsFreshData(bool)
	self.isFreshData = bool;
end


LayerPopableDirect = class(LayerPopable);

function LayerPopableDirect:ctor()
  self.class=LayerPopableDirect;
end

function LayerPopableDirect:dispose()
	self:removeAllEventListeners();
  	self:removeChildren();
  	if self.armature then
  		self.armature:dispose();
  	end
	LayerPopable.superclass.dispose(self);
	BitmapCacher:removeUnused();
end

function LayerPopableDirect:closeUI()
	self:_closeUI()
	self:onPreUIClose();
	LayerManager:removeLayerPopable(self);
end