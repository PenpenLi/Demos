require "core.display.LayerPopable";
require "core.controls.CommonLayer";
BangDingPopup=class(LayerPopableDirect);

function BangDingPopup:ctor()
  self.class=BangDingPopup;
end

function BangDingPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BangDingPopup.superclass.dispose(self);
  self.armature:dispose()
end

function BangDingPopup:onDataInit()
  self.bangDingProxy = self:retrieveProxy(BangDingProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.huodongProxy = self:retrieveProxy(HuoDongProxy.name)
  self.skeleton = self.bangDingProxy:getSkeleton();

  local layerColor = LayerColorBackGround:getBackGround()
  self:addChild(layerColor);

  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(nil, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"bangding_ui")
  layerPopableData:setShowCurrency(true);
  layerPopableData:setVisibleDelegate(false)
  self:setLayerPopableData(layerPopableData)

end


function BangDingPopup:initialize()
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
end

function BangDingPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;

  self.bg=Image.new()
  self.bg:loadByArtID(435)
  self.bg:setPositionXY(50, 115)
  self.bg:setScale(0.7)
  self.armature_d:addChild(self.bg)

  self.tiShiText=TextField.new(CCLabelTTF:create("此次测试期间的充值金额将以200%比例在游戏正式上线后返还至您的账号中，请务必提供正确的手机号，以便我们将礼包码发放给您~", GameConfig.DEFAULT_FONT_NAME, 26, CCSizeMake(560,110)));
  self.tiShiText:setColor(ccc3(54,20,1))
  self.tiShiText:setPositionXY(465, 405)
  -- 根据名字的宽度定位
  self.tiShiText.touchEnabled = false;
  self.armature_d:addChild(self.tiShiText);

  local text_data = self.armature:getBone("phone1_txt").textData;
  self.tianshu_txt = createTextFieldWithTextData(text_data, "手机号");
  self.armature_d:addChild(self.tianshu_txt);
  
  local text_data = self.armature:getBone("phone2_txt").textData;
  self.tianshu_txt = createTextFieldWithTextData(text_data, "再次输入");
  self.armature_d:addChild(self.tianshu_txt);




  local inputTextData=self.armature:getBone("input_txt1").textData;
  self.textInput1=TextInput.new("请输入手机号",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput1:setPositionXY(inputTextData.x,inputTextData.y);
  self.textInput1:setColor(ccc3(0,0,0))
  self.armature_d:addChild(self.textInput1);


  local inputTextData=self.armature:getBone("input_txt2").textData;
  self.textInput2=TextInput.new("请再次输入手机号",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput2:setPositionXY(inputTextData.x,inputTextData.y);
  self.textInput2:setColor(ccc3(0,0,0))
  self.armature_d:addChild(self.textInput2);


  local redButton =armature_d:getChildByName("redButton");
  local redButton_pos=convertBone2LB4Button(redButton);
  self.armature_d:removeChild(redButton)
  
  self.button=CommonButton.new();
  self.button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.button:initializeBMText("立即绑定","anniutuzi");
  self.button:setPosition(redButton_pos);
  self.button.touchEnabled=true
  self.armature_d:addChild(self.button);
  self.button:addEventListener(DisplayEvents.kTouchTap,self.onButtonGo,self);
end

function BangDingPopup:onButtonGo()

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
    self.huodongProxy.phoneNum = self.textInput1:getInputText();
    self.huodongProxy.hasBindPhone = true;
    --将huodongproxy的 data中id = 4的booleanvalue刷成0
    self.huodongProxy:toBindPhoneNum(4, 0);
    self.huodongProxy:setDotVisible(4, 0);
    self:closeUI();
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


function BangDingPopup:refreshData(count, booleanValue)
 
end

function BangDingPopup:onUIClose( )
  self:dispatchEvent(Event.new("BangDingClose",nil,self));
end
