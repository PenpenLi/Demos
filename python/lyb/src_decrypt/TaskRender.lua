--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

TaskRender=class(TouchLayer);

function TaskRender:ctor()
  self.class=TaskRender;
  self.orderIndex = 0;
end

function TaskRender:dispose()
  self:removeAllEventListeners();
  TaskRender.superclass.dispose(self);
end

function TaskRender:initialize(context,targetTaskPo,count,maxcount, TaskState)
  self.context=context
  self:initLayer();
  self.targetTaskPo=targetTaskPo;
  self.skeleton = context.skeleton
  self.TaskState = TaskState;
  local armature= self.skeleton:buildArmature("taskrender");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  -- self.armature_d.touchEnabled=false
  -- self.armature_d.touchChildren=false

  self.itemTextField3=createTextFieldWithTextData(armature:getBone("word3").textData,"奖励:");--新建文本
  self.itemTextField3.touchEnabled=false;
  self.itemTextField3.touchChildren=false;
  self.armature_d:addChild(self.itemTextField3);
  self.itemTextField4=createTextFieldWithTextData(armature:getBone("condition").textData,targetTaskPo.txt);--新建文本
  self.itemTextField4.touchEnabled=false;
  self.itemTextField4.touchChildren=false;
  self.armature_d:addChild(self.itemTextField4);
  -- targetTaskPo.gift = targetTaskPo.gift .. ";3,1"
  local stringtab=StringUtils:stuff_string_split(targetTaskPo.gift);


  self.ico_pos=makePoint(168,32)
  local index = 0;
  for k,v in pairs(stringtab) do
    local itemId = tonumber(v[1])
    local itemCount = tonumber(v[2])
    local itemPo=analysis("Daoju_Daojubiao", itemId)
    local itemImage = Image.new();
    itemImage:loadByArtID(itemPo.art);
    itemImage:setScale(0.4)
    self:addChild(itemImage);
    itemImage:setPositionXY(self.ico_pos.x + index * 123, self.ico_pos.y);

    local giftNumber1TextDate=self.armature:getBone("gift_number1").textData;
    self.giftNumber1=createTextFieldWithTextData(giftNumber1TextDate,"x" .. itemCount,false)

    local xPos = self.ico_pos.x + 45 + index * 113;
    if index == 0 then
      xPos = xPos - 8;
    end
    self.giftNumber1:setPositionXY(xPos, self.ico_pos.y)
    self:addChild(self.giftNumber1)
    self.giftNumber1.touchEnabled = false

    index = index + 1;
  end

  self.img=self.armature_d:getChildByName("img");
  self.img_pos=convertBone2LB(self.img);
  self.armature_d:removeChild(self.img)
  self.img = Image.new()

  
  self.img:loadByArtID(targetTaskPo.title)
  self.img:setAnchorPoint(ccp(0.5,0.5))
  self.img:setPositionXY(self.img_pos.x+55,self.img_pos.y+ 40)
  self.armature_d:addChild(self.img);

  self.button=self.armature_d:getChildByName("botton")
  self.button_pos=convertBone2LB4Button(self.button)
  self.armature_d:removeChild(self.button)

  -- print("TaskState", TaskState)
  if(TaskState == 3) then
      self:setGetAwardState();
  else
      -- self.armature_d:addEventListener(DisplayEvents.kTouchTap,self.onClickTest,self);      
      if tonumber(targetTaskPo.functionid) == FunctionConfig.FUNCTION_ID_34 then--如果十国的话，需要提前发一下命令
        sendMessage(19,17)
      end
      self.button=CommonButton.new();
      self.button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
      self.button:initializeBMText("前往","anniutuzi");
      self.button:setPositionXY(self.button_pos.x,self.button_pos.y);
      self.button.touchEnabled=true
      self:addChild(self.button);

      self.button:addEventListener(DisplayEvents.kTouchTap,self.onButtonGo,self);

      local str;
      if "6" == targetTaskPo.condition then
        str = "("..(-1+count).."/"..(-1+maxcount)..")";
      else
        str = "("..count.."/"..maxcount..")";
      end
      self.itemTextField2=createTextFieldWithTextData(armature:getBone("word2").textData,str);--新建文本
      self.itemTextField2.touchEnabled=false;
      self.itemTextField2.touchChildren=false;
     self.armature_d:addChild(self.itemTextField2);
  end
end

function TaskRender:onClickTest(event)
  self.context:testFunction();
end

function TaskRender:onButtonGo(event)
print("fff",self.targetTaskPo.type,self.targetTaskPo.functionid)
  local param1, param2
  local renwubiaoPo = analysis("Renwu_Renwubiao", self.targetTaskPo.task)
  local stringtab=StringUtils:lua_string_split(renwubiaoPo.parameterEnd1, ",");

  if not(tonumber(self.targetTaskPo.functionid) == FunctionConfig.FUNCTION_ID_24 and self.targetTaskPo.type == 1) then--是日常
     print("param1 = tonumber(stringtab[1])")
     param1 = tonumber(stringtab[1])
  end

  if (tonumber(self.targetTaskPo.functionid) == FunctionConfig.FUNCTION_ID_24 and self.targetTaskPo.type == 1 ) then--是目标
    if analysisHas("Juqing_Juqing", tonumber(stringtab[1])) then--满星宝箱
      param1 = tonumber(stringtab[1])
      param2 = true
    end
  end

  print("param1", param1)
  local data = {functionid = self.targetTaskPo.functionid, param1 =param1, param2 =param2}
  self.context:onButtonGo(data);
  if GameVar.tutorStage == TutorConfig.STAGE_1025 then
    sendServerTutorMsg({})
    closeTutorUI();
  end
end

function TaskRender:onButtonCompleteBegin(event)
  self.beginPos=event.globalPosition
  self:setScale(0.93)
  self:addEventListener(DisplayEvents.kTouchEnd,self.onButtonComplete,self);
  self:addEventListener(DisplayEvents.kTouchMove,self.onButtonMove,self);
end

function TaskRender:onButtonMove (event)
  if (event.globalPosition.y-self.beginPos.y>20) or (event.globalPosition.y-self.beginPos.y<-20) then
    self:setScale(1)
  end
end

function TaskRender:onButtonComplete(event)
  if (event.globalPosition.y-self.beginPos.y<20) and (event.globalPosition.y-self.beginPos.y>-20) then
    -- local function callBackFun()
      if self.boneCartoon then
        self:removeChild(self.boneCartoon)
        self.boneCartoon = nil
      end

      if GameVar.tutorStage == TutorConfig.STAGE_1005 then
        openTutorUI({x=1146, y=625, width = 78, height = 75, alpha = 125});
        sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 100503, BooleanValue = 0})
      elseif GameVar.tutorStage == TutorConfig.STAGE_1010 then
        openTutorUI({x=1146, y=625, width = 78, height = 75, alpha = 125});
        sendServerTutorMsg({Stage = GameVar.tutorStage, Step = 101003, BooleanValue = 0})
      elseif GameVar.tutorStage == TutorConfig.STAGE_1025 then
        sendServerTutorMsg({})
        closeTutorUI();
      end
      sendMessage(8,3,{TaskId=self.targetTaskPo.task})
      self:setScale(1)

      MusicUtils:playEffect(502,false);
    -- end
    -- if self.boneCartoon then

    -- else
    --   self.boneCartoon = cartoonPlayer("1387",260,100,1,callBackFun,nil,nil)
    --   self:addChild(self.boneCartoon)
    -- end
  end
    -- recvTable["Vip"] = 0
    -- recvTable["Level"] = 12
    -- recvTable["Experience"] = 1 
    -- recvMessage(1003,17);

end

function TaskRender:setGetAwardState()
    self.armature_d:addEventListener(DisplayEvents.kTouchBegin,self.onButtonCompleteBegin,self);
    self.armature_d:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self);      

    self.giftImage = self.context.skeleton:getBoneTextureDisplay("gift_bg");
    self.giftImage.touchEnabled=false
    self.giftImage:setPositionXY(363, 35);
    self:addChild(self.giftImage)

    self.itemEffect = cartoonPlayer("1387",430, 80, 0,nil,nil,nil,true);
    self.itemEffect.touchEnabled = false;
    self:addChild(self.itemEffect);
end


function TaskRender:resetState(TaskState)
  if self.TaskState ~= TaskState and TaskState == 3 then
    self.button:setVisible(false)
    self.itemTextField2:setVisible(false)
    self:setGetAwardState();
  end
  self.TaskState = TaskState
end
function TaskRender:refreshCondition(count,maxcount)
  local str;
  if "6" == self.targetTaskPo.condition then
    str = "("..(-1+count).."/"..(-1+maxcount)..")";
  else
    str = "("..count.."/"..maxcount..")";
  end
  self.itemTextField2:setString(str);
end