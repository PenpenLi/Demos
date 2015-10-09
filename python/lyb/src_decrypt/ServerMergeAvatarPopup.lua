--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

ServerMergeAvatarPopup=class(Layer);

function ServerMergeAvatarPopup:ctor()
  self.class=ServerMergeAvatarPopup;
end

function ServerMergeAvatarPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	ServerMergeAvatarPopup.superclass.dispose(self);
  
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function ServerMergeAvatarPopup:initialize(serverMergeProxy, bagProxy, datas)
  self:initLayer();
  self.skeleton=serverMergeProxy:getSkeleton();
  self.serverMergeProxy=serverMergeProxy;
  self.bagProxy=bagProxy;
  self.datas=datas;
  self.const_item_num=3;
  self.max_page=math.ceil(table.getn(datas)/self.const_item_num);
  self.item_size=makeSize(248,355);
  self.layers={};
  self.items={};
  
  --骨骼
  local armature=self.skeleton:buildArmature("avatar_select_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  self.leftButton=button;

  button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  self.rightButton=button;

  self.item_layer=GalleryViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(self.armature:getChildByName("pos"):getPosition());
  self.item_layer:setViewSize(makeSize(self.const_item_num*self.item_size.width,
                                       self.item_size.height));
  self.item_layer:setContainerSize(makeSize(self.max_page*self.const_item_num*self.item_size.width,
                                            self.item_size.height));
  self.item_layer:setMaxPage(self.max_page);
  self.item_layer:setDirection(kCCScrollViewDirectionHorizontal);
  local function refreshButton()
    self:refreshButton();
  end
  self.item_layer:addFlipPageCompleteHandler(refreshButton);
  self.armature:addChildAt(self.item_layer,1);

  local a=0;
  local item_pos;
  while self.max_page>a do
    a=1+a;
    local l=Layer.new();
    l:initLayer();
    l:setPositionX((-1+a)*self.const_item_num*self.item_size.width);
    self.item_layer:addContent(l);
    table.insert(self.layers,l);
  end

  local function sf(a, b)
    return a.ServerId<b.ServerId;
  end
  table.sort(self.datas,sf);
  for k,v in pairs(self.datas) do
    local item=ServerMergeAvatarItem.new();
    item:initialize(self.serverMergeProxy,self.bagProxy,v,self,self.onItemTap);
    if not item_pos then
      item_pos=item.armature:getChildByName("avatar_bg"):getPosition();
      item_pos.y=-item.armature:getChildByName("avatar_bg"):getContentSize().height+item_pos.y;
    end
    item:setPositionX(self.item_size.width*((-1+k)%self.const_item_num));
    self.layers[math.ceil(k/self.const_item_num)]:addChild(item);
    table.insert(self.items,item);
  end
  local k=table.getn(self.datas);
  local a=0==k%self.const_item_num and k or self.const_item_num*math.floor(1+k/self.const_item_num);
  while k<a do
    k=1+k;
    local item=self.skeleton:getBoneTextureDisplay("avatar_bg");
    item:setPositionXY(item_pos.x+self.item_size.width*((-1+k)%self.const_item_num),item_pos.y);
    self.layers[math.ceil(k/self.const_item_num)]:addChild(item);
  end
  self:refreshButton();
end

function ServerMergeAvatarPopup:onLeftButtonTap(event)
  self.item_layer:setPage(-1+self.item_layer:getCurrentPage(),true);
  self.leftButton:getDisplay().touchEnabled=false;
  self.leftButton:getDisplay().touchChildren=false;
end

function ServerMergeAvatarPopup:onRightButtonTap(event)
  self.item_layer:setPage(1+self.item_layer:getCurrentPage(),true);
  self.rightButton:getDisplay().touchEnabled=false;
  self.rightButton:getDisplay().touchChildren=false;
end

function ServerMergeAvatarPopup:onItemTap(item)
  if string.find(item.data.UserName,"服") then
    local serverMergeNamePopup=ServerMergeNamePopup.new();
    serverMergeNamePopup:initialize(self.serverMergeProxy,self.bagProxy,item.data);
    self:addChild(serverMergeNamePopup);
    self.item_layer:setMoveEnabled(false);
    self.serverMergeNamePopup=serverMergeNamePopup;
    return;
  end
  self:confirmToLogin("",item.data.PlatformId);
end

function ServerMergeAvatarPopup:refreshButton(bool)
  self.leftButton:getDisplay():setVisible(1<self.item_layer:getCurrentPage());
  self.leftButton:getDisplay().touchEnabled=true;
  self.leftButton:getDisplay().touchChildren=true;
  self.rightButton:getDisplay():setVisible(self.max_page>self.item_layer:getCurrentPage());
  self.rightButton:getDisplay().touchEnabled=true;
  self.rightButton:getDisplay().touchChildren=true;
end

function ServerMergeAvatarPopup:confirmToLogin(userName, platformId)
  GameData.platFormId4Dc=platformId and platformId or GameData.platFormID;

  local tableData = {}
  tableData["PlatformId"] = GameData.platFormId4Dc
  tableData["Key"] = GameData.userAccount
  tableData["Pwd"] = GameData.userPassword
  tableData["UserName"] = userName
  tableData["OrigainalServerId"] = GameData.ServerId -- todozhangke
  
  local dcParamStr = ""
  tableData["DCParamStr"] = dcParamStr
  log("DCParamStr="..dcParamStr)
  
  sendMessage(2,1,tableData);
  -- tableData["UDID"] = GameData.UDID
  -- tableData["ServerId"] = GameData.ServerId
  -- tableData["InstallKey"] = GameData.InstallKey
  -- tableData["MAC"] = GameData.MAC
  -- tableData["ClientType"] = GameData.ClientType
  -- tableData["ClientOSType"] = GameData.ClientOSType
  -- tableData["ClientgameVersion"] = clientgameVersion
  -- local channelID = "0"
  -- -- 只有平台2才需要去平台号其他不需要
  -- if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then
  --   channelID = CommonUtils:getChannelID()
  -- end
  -- tableData["BIChannelID"] = channelID
  -- tableData["DCParamStr"] = self:getNewString()
  -- log("GameData.InstallKey="..GameData.InstallKey)
  -- sendMessage(2,1,tableData);
end

function ServerMergeAvatarPopup:getNewString()
  local networktype = MetaInfo:getInstance():getSimNetworkType();
  local android_id = MetaInfo:getInstance():getAndroidId();
  local google_aid = MetaInfo:getInstance():getAndroidId();
  local clientpixel = MetaInfo:getInstance():getResolution();
  local serial_number = MetaInfo:getInstance():getDeviceSerialNumber();
  local newString = "&networktype=" .. networktype ..
            "&android_id=" .. android_id ..
            "&google_aid=" .. google_aid ..
            "&clientpixel=" .. clientpixel ..
            "&serial_number=" .. serial_number;
  return newString;
end

function ServerMergeAvatarPopup:refreshUserName(userName)
  if self.serverMergeNamePopup then
    self.serverMergeNamePopup:refreshUserName(userName);
  end
end