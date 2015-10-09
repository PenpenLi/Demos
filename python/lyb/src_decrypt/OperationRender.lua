OperationRender=class(TouchLayer);

function OperationRender:ctor()
  self.class=OperationRender;
  self.orderIndex = 0;
end

function OperationRender:dispose()
  self:removeAllEventListeners();
  OperationRender.superclass.dispose(self);
end

function OperationRender:initialize(context,functionPo)
  self.context=context
  self:initLayer();
  self.functionPo=functionPo;
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  self.titleText=createTextFieldWithTextData(armature:getBone("titleText").textData, functionPo.name);--新建文本
  self.titleText.touchEnabled=false;
  self.titleText.touchChildren=false;
  self.armature_d:addChild(self.titleText);

  self.function_descb=createTextFieldWithTextData(armature:getBone("function_descb").textData,functionPo.explain);--新建文本
  self.function_descb.touchEnabled=false;
  self.function_descb.touchChildren=false;
  self.armature_d:addChild(self.function_descb);
  
  self.img = Image.new();
  self.img:loadByArtID(functionPo.art)
  self.img:setAnchorPoint(ccp(0.5,0.5))
  self.img:setPositionXY(65,60)
  self:addChild(self.img);

  self.button=self.armature_d:getChildByName("goButton")
  self.button_pos=convertBone2LB4Button(self.button)
  self.armature_d:removeChild(self.button)

  self.button=CommonButton.new();
  self.button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.button:initializeBMText("前往","anniutuzi");
  self.button:setPositionXY(self.button_pos.x,self.button_pos.y);
  self.button.touchEnabled=true
  self:addChild(self.button);

  self.button:addEventListener(DisplayEvents.kTouchTap,self.onButtonGo,self);

  self.redIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonImages/common_redIcon");
  self.redIcon:setPositionXY(100,35)
  self.button:addChild(self.redIcon)
  
  local isVisible = false
  if self.functionPo.id2 == FunctionConfig.FUNCTION_ID_61 then -- 阵法
    isVisible = self.context.operationProxy:isZhenfaRedIconVisible(self.context.zhenfaProxy,self.context.bagProxy,self.context.userCurrencyProxy)
  elseif self.functionPo.id2 == FunctionConfig.FUNCTION_ID_68 then -- 天相
    isVisible = self.context.operationProxy:isTianxiangRedIconVisible(self.context.userProxy, self.context.userCurrencyProxy)
  end
  
  self.redIcon:setVisible(isVisible)

end

function OperationRender:onButtonGo(event)
  
  self.redIcon:setVisible(false)

  print("self.functionPo.id2", self.functionPo.id2)
  self.context:onButtonGo(self.functionPo.id2);
  
end

