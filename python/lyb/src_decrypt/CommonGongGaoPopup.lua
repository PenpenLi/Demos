

CommonGongGaoPopup=class(LayerColor);

function CommonGongGaoPopup:ctor()
  self.class=CommonGongGaoPopup;
end

function CommonGongGaoPopup:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	CommonGongGaoPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CommonGongGaoPopup:initialize(text_string, context, onConfirm, confirmData, isColorLabel, allsceenMiddle)

  self:initLayer();

  local armature=CommonSkeleton:buildArmature("common_gonggao_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  local textData=armature:getBone("common_descb").textData;

  armature=armature.display;
  self:addChild(armature);
  
  --confirmButton
  local confirmButton=armature:getChildByName("common_small_blue_button");
  local confirmButton_pos=convertBone2LB(confirmButton);
  armature:removeChild(confirmButton);
  


  self.common_descb=createTextFieldWithTextData(textData,"帮主请输入帮派公告吧");
  self.common_descb:setPositionY(self.common_descb:getPositionY())

  armature:addChild(self.common_descb);
  

  local common_contentData=self.armature4dispose:getBone("common_content").textData;
  self.common_content=TextInput.new("点这儿修改公告",common_contentData.size,makeSize(common_contentData.width,common_contentData.height));
  self.common_content:setPositionXY(common_contentData.x, common_contentData.y+10)

  armature:addChild(self.common_content);

  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  confirmButton:initializeBMText("确定","anniutuzi");
  if confirm_boolean then
    confirmButton:setPositionXY(math.floor(confirmButton_pos.x/2+cancelButton_pos.x/2),math.floor(confirmButton_pos.y/2+cancelButton_pos.y/2));
  else
    confirmButton:setPosition(confirmButton_pos);
  end
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature:addChild(confirmButton);
  

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onSmallCloseButtonTap, self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);


  --armature:setPositionXY(450,300);
  local popupSize=armature:getChildByName("common_copy_panel_4"):getContentSize();

  if allsceenMiddle then
    armature:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  else
    armature:setPositionXY(math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2),math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  end
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
  self.context=context;
  self.onConfirm=onConfirm;
  self.confirmData=confirmData;
	
	-- uninitializeSmallLoading()

end

function CommonGongGaoPopup:setDescbXY(x, y)
  self.common_descb:setPositionXY(x, y)
end

function CommonGongGaoPopup:onSmallCloseButtonTap(event)
  self:removePopup();
end

function CommonGongGaoPopup:onConfirmButtonTap(event)
  if self.onConfirm then
    self.onConfirm(self.context,self.confirmData);
  end
  -- self:removePopup();

end

function CommonGongGaoPopup:removePopup()
  self.parent:removeChild(self);
end