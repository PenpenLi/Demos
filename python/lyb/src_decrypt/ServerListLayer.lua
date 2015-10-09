
require "core.controls.ListScrollViewLayer";
require "main.view.serverScene.ui.ServerListItem";
ServerListLayer=class(Layer);

function ServerListLayer:ctor()
	self.class=ServerListLayer;
	self.upLayer = nil;
	self.const_grid_column=3;
	self.const_grid_row=5.8;
	self.listLayerArray = {}
	self.listTabArray = {}
	self.allButtonArray = {}
	self.recButtonArray = {}
end

function ServerListLayer:dispose()
  	self:removeAllEventListeners();
  	self:removeChildren();
	ServerListLayer.superclass.dispose(self);
	self.armature:dispose()
	self.armature= nil;
end

function ServerListLayer:initialize(popUp)
	if self.popUp then return;end;
	self:initLayer();
	self.popUp = popUp;
	local skeleton = self.popUp.skeleton

	local armature=skeleton:buildArmature("serverList_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local armature_d=armature.display;
	self:addChild(armature_d);
	self.armature_d = armature_d;
	
	local winSize = Director:sharedDirector():getWinSize()
	local backImage = Image.new()
	backImage:loadByArtID(StaticArtsConfig.BACKGROUD_COMMON_BG)
	backImage.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
	backImage:setPositionXY(winSize.width / 2 - GameData.uiOffsetX,winSize.height / 2 - GameData.uiOffsetY)	
	self:addChildAt(backImage,0)
	backImage.touchEnabled=true;
	backImage.touchChildren=true;

	self.upLayer = Layer.new();
	self.upLayer:initLayer();
	self:addChild(self.upLayer);

	self.tab1ButtonData = armature:findChildArmature("common_tab_button_1"):getBone("selectServe_tab_button").textData;
	self.serverButtonData = armature:findChildArmature("selectServe_server_buttton"):getBone("selectServe_server_buttton").textData;

	local serverButton=armature_d:getChildByName("selectServe_server_buttton");
	armature_d:removeChild(serverButton);

	local serveBg=armature_d:getChildByName("selectServe_bg");
	armature_d:removeChild(serveBg);

	local grid=armature_d:getChildByName("selectServe_server_buttton_normal_1");
	local grid_1=armature_d:getChildByName("selectServe_server_buttton_normal_2");
	local grid_2=armature_d:getChildByName("selectServe_server_buttton_normal_3");
	local headimgBg1 = grid;
	local grid_content_size=grid:getContentSize();
	self.grid_content_size = grid_content_size;
	self.const_grid_x,self.const_grid_y=convertBone2LB(grid).x,convertBone2LB(grid).y
	self.const_grid_width,self.const_grid_height=grid_content_size.width,grid_content_size.height;
	self.const_grid_skew_x,self.const_grid_skew_y=grid_1:getPositionX()-self.const_grid_x,self.const_grid_y-convertBone2LB(grid_2).y;
	self.heightGap = (grid:getPositionY() - grid_2:getPositionY() - grid_content_size.height)*0.6;

	local text_data = armature:getBone("selectServe_state_text").textData;
	self.stateX = text_data.x - headimgBg1:getPositionX();
	local stateY = headimgBg1:getPositionY() - text_data.y;
	self.stateY = self.const_grid_height  - stateY;

	local recommend = armature_d:getChildByName("recommend");
	self.recommendX = recommend:getPositionX() - headimgBg1:getPositionX();
	local recommendY = headimgBg1:getPositionY() -  recommend:getPositionY();
	self.recommendY =   recommendY;
	armature_d:removeChild(recommend);

	text_data = armature:getBone("serverList_state_text_1").textData;
    local stateText = createTextFieldWithTextData(text_data,"流畅");
    self:addChild(stateText);

    text_data = armature:getBone("serverList_state_text_2").textData;
    stateText = createTextFieldWithTextData(text_data,"拥挤");
    self:addChild(stateText);

    text_data = armature:getBone("serverList_state_text_3").textData;
    stateText = createTextFieldWithTextData(text_data,"爆满");
    self:addChild(stateText);

    text_data = armature:getBone("serverList_state_text_4").textData;
    stateText = createTextFieldWithTextData(text_data,"维护");
    self:addChild(stateText);

	local newServer = armature_d:getChildByName("newServer");
	armature_d:removeChild(newServer);

	self.tabGap = 10
	self.tabPy = 550;
	self.tabPx = 176;

	local tab1Btn=armature_d:getChildByName("common_tab_button_1");
	local tab2Btn=armature_d:getChildByName("common_tab_button_2");
	local tab1BtnP = convertBone2LB4Button(tab1Btn);
	local tab2BtnP = convertBone2LB4Button(tab2Btn);
	self.tabGap = tab2BtnP.x - tab1BtnP.x - tab1Btn:getContentSize().width
	self.tabPy = tab1BtnP.y;
	self.tabPx = tab2BtnP.x;
	armature_d:removeChild(tab1Btn);
	armature_d:removeChild(tab2Btn);

	local tab1Btn1 = CommonButton.new();
	tab1Btn1:initialize("selectServe_tab_button_normal","selectServe_tab_button_down",CommonButtonTouchable.BUTTON,skeleton);
	tab1Btn1:setPosition(tab1BtnP);
	self:addChild(tab1Btn1);
	self.tab1Btn = tab1Btn1;
	self:tab1BtnDisableState();
	tab1Btn1:addEventListener(DisplayEvents.kTouchTap,self.tab1BtnHandler,self);

	self.upList = ListScrollViewLayer.new();
	self.upList:initLayer();
	self.upList:setPositionXY(self.const_grid_x,130);
	self.upList:setViewSize(makeSize(self.const_grid_skew_x*self.const_grid_column,self.const_grid_skew_y*self.const_grid_row));
	self.upList:setItemSize(makeSize(self.const_grid_skew_x*self.const_grid_column,grid_content_size.height + self.heightGap));
	self.upLayer:addChild(self.upList);

	armature_d:removeChild(grid);
	armature_d:removeChild(grid_1);
	armature_d:removeChild(grid_2);	
	self:refreshListData()

	self:addEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
    self:addEventListener(DisplayEvents.kTouchBegin,self.onTouchLayerBegin,self);
end

local function sortOnIndex(a, b) return a.sort > b.sort end
function ServerListLayer:refreshListData()
      local length = 0;
      local layer;
      for k,v in pairs(self.popUp.recServersArray) do
        if 0==length % 3 then
          layer=TouchLayer.new();
          layer:initLayer();
          layer:changeWidthAndHeight(self.const_grid_skew_x*self.const_grid_column,self.grid_content_size.height + self.heightGap);
          self.upList:addItem(layer);
        end
        length = 1 + length;
        local serverItem=ServerListItem.new();
        serverItem:initialize(self.popUp.skeleton,self,v,self.armature);
        serverItem:setPositionXY((length - 1)%3 * self.const_grid_skew_x*self.const_grid_column/3,0);
        layer:addChild(serverItem);
        self.allButtonArray[v.id] = serverItem;
      end
      local listTable={};length = 0;local tempTable;
      for k1,v1 in ipairs(self.popUp.allServersArray) do
      	if 0==length % 30 then
      		tempTable = {}
      		table.insert(listTable,tempTable)
      	end
      	table.insert(tempTable,v1)
      	length = 1 + length;
      end

      local listNum = 0;
      local listLayer,listView;
      for k2,v2 in pairs(listTable) do
  		listLayer,listView = self:getListLayer(listNum);
  		table.insert(self.listLayerArray,listLayer) 
  		listNum = listNum + 1;
      	length = 0;local layer;
      	table.sort(v2,sortOnIndex)
      	for k3,v3 in ipairs(v2) do
      		if 0==length % 3 then
	          layer=TouchLayer.new();
	          layer:initLayer();
	          layer:changeWidthAndHeight(self.const_grid_skew_x*self.const_grid_column,self.grid_content_size.height + self.heightGap);

	          layer.touchEnabled=false;
	          listView:addItem(layer);
	        end
	        length = 1 + length;
	        local serverItem=ServerListItem.new();
	        serverItem:initialize(self.popUp.skeleton,self,v3,self.armature);
	        serverItem:setPositionXY((length - 1)%3 * self.const_grid_skew_x*self.const_grid_column/3,0);
	        layer:addChild(serverItem);
	        self.recButtonArray[v3.id] = serverItem;
      	end

      end
      local recTable1 = self.popUp.recServersArray[1];
      self.tempServerIP = recTable1.ip;
      self.tempServerId = recTable1.id;
      self.tempServerIsOpen = recTable1.isOpen;
      self:setButtonLighter(recTable1.id)

end

function ServerListLayer:getListLayer(num)
	local tabBtn = CommonButton.new();
	tabBtn:initialize("selectServe_tab_button_normal","selectServe_tab_button_down",CommonButtonTouchable.BUTTON,self.popUp.skeleton);
	tabBtn:setPositionXY(self.tabPx+(num*self.tabGap),self.tabPy);
	self:addChild(tabBtn);
	self.tabBtn = tabBtn;
	self.tabBtn:initializeText(self.tab1ButtonData,self:getTabString(num));
	tabBtn:addEventListener(DisplayEvents.kTouchTap,self.tab2BtnHandler,self,num);
	table.insert(self.listTabArray,tabBtn)

	local listLayer = Layer.new();
	listLayer:initLayer();
	self:addChild(listLayer);
	listLayer:setVisible(false)

	local downList = ListScrollViewLayer.new();
	downList:initLayer();
	downList:setPositionXY(self.const_grid_x,130);
	downList:setViewSize(makeSize(self.const_grid_skew_x*self.const_grid_column,self.const_grid_skew_y*self.const_grid_row));
	downList:setItemSize(makeSize(self.const_grid_skew_x*self.const_grid_column,self.grid_content_size.height + self.heightGap));
	listLayer:addChild(downList);
	return listLayer,downList;
end

function ServerListLayer:getTabString(num)
	if num == 0 then
		return "1~30区"
	elseif num == 1 then
		return "31~60区"
	elseif num == 2 then
		return "61~90区"
	end
end

function ServerListLayer:allButtonNormal()
	for k,v in pairs(self.allButtonArray) do
		v.selectButton:select(false);
	end
	for k,v in pairs(self.recButtonArray) do
		v.selectButton:select(false);
	end


end

function ServerListLayer:setButtonLighter(id)
	if self.allButtonArray[id] then
		self.allButtonArray[id].selectButton:select(true);
	end
	if self.recButtonArray[id] then
		self.recButtonArray[id].selectButton:select(true);
	end
end

function ServerListLayer:tab1BtnHandler(event)
	self:tab1BtnDisableState();
	self:allListLayerVisible(false)
	self:allTabEnabled()
	self.upLayer:setVisible(true);
end

function ServerListLayer:tab2BtnHandler(event,num)
	self:allTabEnabled()
	self:tab2BtnDisableState(num);
	self:tab1BtnAbleState();
	self.upLayer:setVisible(false);
	self:allListLayerVisible(false)
	self.listLayerArray[num+1]:setVisible(true);
end

function ServerListLayer:allListLayerVisible(bool)
	for k1,v1 in pairs(self.listLayerArray) do
		v1:setVisible(bool)
	end
end

function ServerListLayer:allTabEnabled()
	for k1,v1 in pairs(self.listTabArray) do
		v1:select(false);
		v1.touchEnabled=true
		v1.touchChildren=true;
	end
end

function ServerListLayer:backButtonHandler(event)
	self.popUp:removeChild(self)
	--self.popUp:interButtonVisible(true)
end

function ServerListLayer:tab1BtnDisableState()
	  self.tab1Btn:select(true);
	  self.tab1Btn.touchEnabled=false
	  self.tab1Btn.touchChildren=false;
	  local tempStr = self.popUp:hasMyServerData() and "我的服务器" or "推荐服务器" 
	  self.tab1Btn:initializeText(self.tab1ButtonData,tempStr);
end

function ServerListLayer:tab1BtnAbleState()
	self.tab1Btn:select(false);
	self.tab1Btn.touchEnabled=true
	self.tab1Btn.touchChildren=true;
end

function ServerListLayer:tab2BtnDisableState(num)
	self.listTabArray[num+1]:select(true);
	self.listTabArray[num+1].touchEnabled=false
	self.listTabArray[num+1].touchChildren=false;
end

function ServerListLayer:tab2BtnAbleState(num)
	self.listTabArray[num+1]:select(false);
	self.listTabArray[num+1].touchEnabled=true
	self.listTabArray[num+1].touchChildren=true;
end

function ServerListLayer:onTouchLayerBegin(event)
    self.isMove = false;
    local position = event.globalPosition;
    self.startPosition = position;
end

function ServerListLayer:onTouchLayerMove(event)
    local position = event.globalPosition;
    local dx = self.startPosition.x-position.x;
    local dy = self.startPosition.y-position.y;
    local dis = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    if dis >40 then
        self.isMove = true;
    end
end
