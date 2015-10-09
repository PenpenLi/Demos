
LiBaoDuiHuan=class(TouchLayer);

function LiBaoDuiHuan:ctor()
  self.class=LiBaoDuiHuan;
end

function LiBaoDuiHuan:dispose()
  self:removeAllEventListeners();
  LiBaoDuiHuan.superclass.dispose(self);
end

function LiBaoDuiHuan:initialize(context,id)
  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("libaoduihuan_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  self.bg=Image.new()
  self.bg:loadByArtID(435)
  self.bg:setPositionXY(470,-45)
  self.bg:setScale(0.84)
  self:addChildAt(self.bg,1)
  self.button=self.armature_d:getChildByName("botton")
  self.button_pos=convertBone2LB4Button(self.button)
  self.armature_d:removeChild(self.button)
  self.button=CommonButton.new();
  self.button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.button:initializeBMText("兑换","anniutuzi");
  self.button:setPositionXY(self.button_pos.x,self.button_pos.y);
  self.button.touchEnabled=true
  self:addChild(self.button);
  self.button:addEventListener(DisplayEvents.kTouchTap,self.onButtonGo,self);

  local inputTextData=self.armature:getBone("input").textData;
  self.textInput=TextInput.new("请输入兑换码",inputTextData.size,makeSize(inputTextData.width,inputTextData.height));
  self.textInput:setPositionXY(inputTextData.x,inputTextData.y);

  self.textInput:setColor(ccc3(0,0,0))

  self:addChild(self.textInput);
end
function LiBaoDuiHuan:refreshData( ... )
  
end
function LiBaoDuiHuan:onButtonGo(event) 
    sendMessage(24,32,{CDKey=self.textInput:getString()})
end