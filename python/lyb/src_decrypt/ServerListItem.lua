
ServerListItem=class(Layer);

function ServerListItem:ctor()
  self.class=ServerListItem;
end

function ServerListItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  ServerListItem.superclass.dispose(self);
end

function ServerListItem:initialize(skeleton,serverLayer,serverVO,armature)
  self:initLayer();
  self:initializeUI(skeleton,serverLayer,serverVO,armature);
end

function ServerListItem:initializeUI(skeleton,serverLayer,serverVO,armature)
	local selectButton = CommonButton.new();
	selectButton:initialize("selectServe_server_buttton_normal","selectServe_server_buttton_down",CommonButtonTouchable.BUTTON,skeleton);
	selectButton:initializeText(serverLayer.serverButtonData,serverVO.name);
	self:addChild(selectButton);
	selectButton:addEventListener(DisplayEvents.kTouchTap,self.selectButtonHandler,self,serverVO);
	self.selectButton = selectButton;
	local stateNum;
	if serverVO.isOpen == "1" then
		stateNum = self:getServerState(serverVO.state)
	elseif serverVO.isOpen == "0" then
	  	stateNum = self:getServerState(serverVO.isOpen)
	end
	
	local stateImg = skeleton:getBoneTextureDisplay("serverList_state_"..stateNum);
	stateImg:setPositionXY(serverLayer.stateX + 30,serverLayer.stateY - 3);
	self:addChild(stateImg);
	stateImg.touchEnabled=false
	stateImg.touchChildren=false;

	if serverVO.tags == "recommend" then
	  local recommend = skeleton:getBoneTextureDisplay("recommend");
	  recommend:setPositionXY(serverLayer.recommendX,serverLayer.recommendY+30);
	  self:addChild(recommend);
	  recommend.touchEnabled=false
	  recommend.touchChildren=false;
	elseif serverVO.tags == "new" then
	  local newServer = skeleton:getBoneTextureDisplay("newServer");
	  newServer:setPositionXY(serverLayer.recommendX,serverLayer.recommendY+18);
	  self:addChild(newServer);
	  newServer.touchEnabled=false
	  newServer.touchChildren=false;
	end
end

function ServerListItem:getServerState(state)
	if state == "free" then
		return "1";
	elseif state == "busy" then
		return "3";
	elseif state == "crowd" then
		return "2";
	elseif state == "0" then
		return "4";
	end
end

function ServerListItem:selectButtonHandler(event,serverVO)
	local parent = self.parent.parent.parent.parent;
	if not parent.isMove then
		parent:allButtonNormal();
		parent:setButtonLighter(serverVO.id);
		parent.popUp:setTempServerData(serverVO)
		-- if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then
		-- 	parent:backButtonHandler()
		-- 	parent.popUp:refreshLoginServer(serverVO,true)
		-- elseif GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
		-- 	parent:backButtonHandler()
		-- 	parent.popUp:refreshLoginServer(serverVO,true)
		-- end
	end
    
    parent.popUp:returnButtonHandler()
end
