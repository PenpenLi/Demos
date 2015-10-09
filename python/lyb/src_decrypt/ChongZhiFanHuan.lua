
ChongZhiFanHuan=class(TouchLayer);

function ChongZhiFanHuan:ctor()
  self.class=ChongZhiFanHuan;
end

function ChongZhiFanHuan:dispose()
  self:removeAllEventListeners();
  ChongZhiFanHuan.superclass.dispose(self);
end

function ChongZhiFanHuan:initialize(context,id)

  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("chongzhifanhuan");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);

  self.bg=Image.new()
  self.bg:loadByArtID(435)
  self.bg:setPositionXY(420,-45)
  self.bg:setScale(0.85)
  self:addChildAt(self.bg,1)

  local text_data = self.armature:getBone("first_phone").textData;
  self.tianshu_txt = createTextFieldWithTextData(text_data, "手机号");
  self.armature_d:addChild(self.tianshu_txt);
  
  local text_data = self.armature:getBone("second_phone").textData;
  self.tianshu_txt = createTextFieldWithTextData(text_data, "再次输入");
  self.armature_d:addChild(self.tianshu_txt);

  self.tiShiText=TextField.new(CCLabelTTF:create("此次测试期间的充值金额将以200%比例在游戏正式上线后返还至您的账号中，请务必提供正确的手机号，以便我们将礼包码发放给您~", GameConfig.DEFAULT_FONT_NAME, 26, CCSizeMake(615,110)));
  
  self.tiShiText:setColor(ccc3(54,20,1))
  self.tiShiText:setPositionXY(60, 410)
  -- 根据名字的宽度定位
  self.tiShiText.touchEnabled = false;
  self.armature_d:addChild(self.tiShiText);

  self.button=CommonButton.new();
  self.button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.button:initializeBMText("立即绑定","anniutuzi");
  self.button:setPositionXY(215, 60);

  self.button.touchEnabled=true
  self:addChild(self.button);
  self.button:addEventListener(DisplayEvents.kTouchTap,self.onButtonGo,self);

  local inputTextData=self.armature:getBone("input1").textData;
  self.textInput1=TextInput.new("请输入手机号",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput1:setPositionXY(inputTextData.x,inputTextData.y);

  self.textInput1:setColor(ccc3(0,0,0))

  self.armature_d:addChild(self.textInput1);

  local inputTextData=self.armature:getBone("input2").textData;
  self.textInput2=TextInput.new("请再次输入手机号",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput2:setPositionXY(inputTextData.x,inputTextData.y);

  self.textInput2:setColor(ccc3(0,0,0))

  self.armature_d:addChild(self.textInput2);

  if self.context.huodongProxy.hasBindPhone == true then
    self.textInput1:setString(self.context.huodongProxy.phoneNum);
    self.textInput2:setString(self.context.huodongProxy.phoneNum);
    self.button:refreshText("已绑定")
    self.button:setGray(true, false)
  end

end


function ChongZhiFanHuan:onButtonGo(event) 
    
    if self.textInput1:getInputText() ~= self.textInput2:getInputText() then
      sharedTextAnimateReward():animateStartByString("两次输入的手机号码必须一致哦~");
      return;
    end
    vertifyPhone(self.textInput1:getInputText());

end

function sendVertityPhoneNum( boolValue )
  print("ChongZhiFanHuan boolValue", boolValue)
  if boolValue == true then
    sendMessage(24, 8, {ParamStr1 = self.textInput1:getInputText()})
    self.context.huodongProxy.hasBindPhone = true;
  
    --将huodongproxy的 data中id = 4的booleanvalue刷成0
    self.context.huodongProxy:toBindPhoneNum(4, 0);
    self.context:refreshRedDot(4);

    if MainSceneMediator then
      local med=Facade.getInstance():retrieveMediator(MainSceneMediator.name);
      if med then
        med:refreshHuoDong();
      end
    end
  else
    sharedTextAnimateReward():animateStartByString("手机号格式不对哦~");
  end
end


