require "core.controls.CommonLayer";
require "core.controls.ScrollSelectButton";
require "core.display.Layer";
require "core.controls.ListScrollViewLayer"
require "main.view.task.ui.render.TaskRender"

TaskPopup=class(LayerPopableDirect);

function TaskPopup:ctor()
  self.class=TaskPopup;
  self.curIndex = 1;
  self.muBiaoRenders = {};
  self.riChangRenders = {};
end

function TaskPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  TaskPopup.superclass.dispose(self);
  self.armature:dispose()
  BitmapCacher:removeUnused();
end

function TaskPopup:initialize()
  self.context=self
  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.skeleton=nil;
end
function TaskPopup:onDataInit()

  self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
  local winSize = Director:sharedDirector():getWinSize()

  local artId1 = getCurrentBgArtId();

  self.bgImage = Image.new();
  self.bgImage:loadByArtID(artId1);

  self:addChild(self.bgImage)
  local yPos = -GameData.uiOffsetY
  local winSize = Director:sharedDirector():getWinSize();
  if GameVar.mapHeight - winSize.height > 30 then
    yPos = -GameData.uiOffsetY - 30
  end
  self.bgImage:setPositionXY(-GameData.uiOffsetX, yPos);

  self.taskProxy=self:retrieveProxy(TaskProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  self.skeleton = self.taskProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  -- layerPopableData:setHasUIBackground(true)
  -- layerPopableData:setHasUIFrame(true)
  -- layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_RENWU,nil,true,1)
  layerPopableData:setArmatureInitParam(self.skeleton,"task_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
end

function TaskPopup:onPrePop()

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  armature_d.touchEnabled=true;

  local renwu_bg=armature_d:getChildByName("renwu_bg")
  self.pos=convertBone2LB(renwu_bg)
  self.height=renwu_bg:getContentSize().height
  self.width=renwu_bg:getContentSize().width

  local render1=armature_d:getChildByName("render1");
  local render2=armature_d:getChildByName("render2");
  --self.render_pos=convertBone2LB4Button(render1)
  self.render_pos=convertBone2LB(render1)
  self.render_width=render1:getContentSize().width
  self.render_height=render1:getPositionY()-render2:getPositionY()

  self.list_x = self.render_pos.x;
  self.list_y = self.render_pos.y + render1:getContentSize().height;

  armature_d:removeChild(render1);
  armature_d:removeChild(render2);

  
  local channel1=armature_d:getChildByName("channel_1");
  local channel2=armature_d:getChildByName("channel_2");
  self.channel1_pos=convertBone2LB4Button(channel1);
  self.channel2_pos=convertBone2LB4Button(channel2);
  self.channel1_text=armature:findChildArmature("channel_1"):getBone("common_channel_button").textData;
  self.channel2_text=armature:findChildArmature("channel_2"):getBone("common_channel_button").textData;
  armature_d:removeChild(channel1)
  armature_d:removeChild(channel2)

  self.muBiaoList=ListScrollViewLayer.new();
  self.muBiaoList:initLayer();
  self.muBiaoList:setPositionXY(self.list_x, self.list_y - 586);
  self.muBiaoList:setViewSize(makeSize(self.render_width, 586));
  self.muBiaoList:setItemSize(makeSize(self.render_width, self.render_height));
  self.muBiaoList:setDirection(kCCScrollViewDirectionVertical);
  self.muBiaoList:setItemAnchorPoint(ccp(0.5, 0.5))

  self:addChild(self.muBiaoList);

  self.riChangList=ListScrollViewLayer.new();
  self.riChangList:initLayer();
  self.riChangList:setPositionXY(self.list_x, self.list_y - 586);
  self.riChangList:setViewSize(makeSize(self.render_width, 586));
  self.riChangList:setItemSize(makeSize(self.render_width, self.render_height));
  self.riChangList:setDirection(kCCScrollViewDirectionVertical);
  self.riChangList:setItemAnchorPoint(ccp(0.5, 0.5))

  self:addChild(self.riChangList);

  self.muBiaoList:setVisible(false)

  -- local meiyourenwu2TextData = self.armature:getBone("meiyourenwu2").textData;
  -- self.meiyourenwu2 =  createTextFieldWithTextData(meiyourenwu2TextData, "……\n暂无任务");
  -- self.armature.display:addChild(self.meiyourenwu2);
  self.redico=armature_d:getChildByName("xiaohongdian");

  -- 无任务面板
  self.notaskui = armature_d:getChildByName("notaskui");
  self.notaskui:setVisible(false)
  
  local text1Bone=armature:findChildArmature("notaskui"):getBone("text1")
  local text2Bone=armature:findChildArmature("notaskui"):getBone("text2");
  local text3Bone=armature:findChildArmature("notaskui"):getBone("text3");
  local text4Bone=armature:findChildArmature("notaskui"):getBone("text4");  
  local text5Bone=armature:findChildArmature("notaskui"):getBone("text5");  

  self.text1 = createTextFieldWithTextData(text1Bone.textData, "今天的日常任务全部完成")
  self.text2 = createTextFieldWithTextData(text2Bone.textData, "完成任务总数")
  self.text3 = createTextFieldWithTextData(text3Bone.textData, "获得奖励总数")
  self.text4 = createTextFieldWithTextData(text4Bone.textData, "")
  self.text5 = createTextFieldWithTextData(text5Bone.textData, "")

  self.text1:setPosition(text1Bone:getDisplay():getPosition())
  self.text2:setPosition(text2Bone:getDisplay():getPosition())
  self.text3:setPosition(text3Bone:getDisplay():getPosition())
  self.text4:setPosition(text4Bone:getDisplay():getPosition())
  self.text5:setPosition(text5Bone:getDisplay():getPosition())

  -- local titleText = BitmapTextField.new("今天的日常任务全部完成","biaotituzi");
  -- titleText:setPosition(self.text1DO:getPosition())
  -- self.notaskui:addChild(titleText)
  self.notaskui:addChild(self.text1)
  self.notaskui:addChild(self.text2)
  self.notaskui:addChild(self.text3)
  self.notaskui:addChild(self.text4)
  self.notaskui:addChild(self.text5)
end

function TaskPopup:refreshNoTaskData(doneTaskCount,itemCount)
  self.notaskui:setVisible(true)
  if doneTaskCount then
    self.doneTaskCount = doneTaskCount;
    self.itemCount = itemCount;
    
    self.text4:setString(""..self.doneTaskCount)
    self.text5:setString("x"..self.itemCount)
  end
end

function TaskPopup:onUIInit()
  
  self.muBiao_button=CommonButton.new();
  self.muBiao_button:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
  self.muBiao_button:initializeBMText("标\n目","anniutuzi",_,_,makePoint(28,50));
  self.muBiao_button:setPositionXY(self.channel1_pos.x,self.channel2_pos.y);
  self.muBiao_button.touchEnabled=true
  self.muBiao_button:addEventListener(DisplayEvents.kTouchTap,self.onMuBiaoButtonTap,self);
  self.armature.display:addChild(self.muBiao_button);

  self.riChang_button=CommonButton.new();
  self.riChang_button:initialize("commonButtons/common_channel_button_normal","commonButtons/common_channel_button_down",CommonButtonTouchable.CUSTOM);
  self.riChang_button:initializeBMText("常\n日","anniutuzi",_,_,makePoint(28,50));
  self.riChang_button:setPositionXY(self.channel2_pos.x,self.channel1_pos.y);
  self.riChang_button.touchEnabled=true

  self.armature.display:addChild(self.riChang_button);
   
  self.layer=Layer.new();
  self.layer:initLayer();
  self.layer.touchEnabled=false;
  self.armature.display:addChild(self.layer);
  self.armature.display:swapChildren(self.layer,self.redico)
  self.redico:setVisible(false)


  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
    self.riChang_button:setVisible(true)

    self.riChang_button:select(true)
    self.muBiao_button:select(false)
  else
    self.riChang_button:setVisible(false)
    if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_40) then
      self.muBiao_button:setVisible(true)
      self.muBiao_button:setPosition(self.channel1_pos)
      
      self.riChang_button:select(false)
      self.muBiao_button:select(true)

      self:onMuBiaoButtonTap()
    else
      self.muBiao_button:setVisible(false)
    end    
  end

  self:setData()

end


function TaskPopup:closeUI()
  self:dispatchEvent(Event.new("TaskClose",nil,self));
end
function TaskPopup:onMuBiaoButtonTap(event)
  if event then
    MusicUtils:playEffect(7,false);
  end
  self.notaskui:setVisible(false)

  print("onMuBiaoButtonTap")
  hecDC(3, 22, 2)

  self.armature.display:swapChildren(self.muBiao_button, self.riChang_button)
  self.muBiao_button:select(true)
  self.riChang_button:select(false)
  self.riChang_button:addEventListener(DisplayEvents.kTouchTap,self.onRiChangButtonTap,self);
  self.muBiao_button:removeEventListener(DisplayEvents.kTouchTap,self.onMuBiaoButtonTap,self);
  if not self.isfirstopen then
    self:setData()
  else
    self:resetState();
  end 

  self.isfirstopen=1;
  self.riChangList:setVisible(false)

  self.muBiaoList:setVisible(true)

  self.redico:setVisible(false)
end

function TaskPopup:onRiChangButtonTap(event)
  if event then
    MusicUtils:playEffect(7,false);
  end
  print("onRiChangButtonTap")
  hecDC(3, 22, 3)

  self.armature.display:swapChildren(self.muBiao_button, self.riChang_button)

  self.muBiao_button:select(false)
  self.riChang_button:select(true)
  self.muBiao_button:addEventListener(DisplayEvents.kTouchTap,self.onMuBiaoButtonTap,self);
  self.riChang_button:removeEventListener(DisplayEvents.kTouchTap,self.onRiChangButtonTap,self);

  self.muBiaoList:setVisible(false)

  self.riChangList:setVisible(true)


  self:checkAndSendMgs()


end
function TaskPopup:onButtonGo(functionData)
  self:dispatchEvent(Event.new("ON_BUTTON_GO",functionData,self));
end
local function sortFun(v1, v2)
  if(v1.data.order < v2.data.order) then
    return true;
  elseif v1.data.order > v2.data.order then
    return false
  else
    if v1.data.id < v2.data.id then
      return true;
    elseif v1.data.id > v2.data.id then
      return false;
    else
      return false
    end
  end
end
function TaskPopup:setData()
  if(self.muBiao_button:getIsSelected()) then
    self.muBiaoList:removeAllItems();
    self.muBiaoRenders = {};
  else
    self.riChangList:removeAllItems();
  end

  self.datas = {};
  for k,v in pairs(self.taskProxy.tasks) do
      local taskPoTables=analysisByName("Mubiaorenwu_Mubiaorenwu","task",v.ID)
      for k2,v2 in pairs(taskPoTables) do
        table.insert(self.datas, {data=v2,TaskConditionArray=v.TaskConditionArray, TaskState = v.TaskState});
      end
  end
  
  self:reOrderDatas()
  
  local non=0
  self.redico:setVisible(false)
  for k,v in ipairs(self.datas) do
    print("+++++++++++++++++++++++++++++v.ID", v.data.id)
    local count
    local maxcount
    for k2,v2 in pairs(v.TaskConditionArray) do
        count = v2.Count
        maxcount=v2.MaxCount
    end

    local render=TaskRender.new();
    if v.TaskState == 3 and v.data.type==1 and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      self.redico:setVisible(true)      
    end
    if(v.data.type==1) and self.muBiao_button:getIsSelected() then
      render:initialize(self,v.data,count,maxcount, v.TaskState);
      self.muBiaoList:addItem(render)
      table.insert(self.muBiaoRenders, render)
    elseif (v.data.type==2) and self.riChang_button:getIsSelected() and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      render:initialize(self,v.data,count,maxcount, v.TaskState);
      self.riChangList:addItem(render)
      table.insert(self.riChangRenders, render)
      non=non+1;
    end
  end

  self:checkAndSendMgs()
end
function TaskPopup:testFunction()

  for k, v in pairs(self.muBiaoRenders) do
    print("kkkkkkkkkkkk", k)
    if k == 2 then
      self.muBiaoList:removeItemAt(1, false)
      self.muBiaoList:addItemAt(v, 0)

      break;
    end
  end
  local temp = self.muBiaoRenders[1];
  self.muBiaoRenders[1] = self.muBiaoRenders[2]
  self.muBiaoRenders[2] = temp;
end
function TaskPopup:checkAndSendMgs()
  if self.riChang_button:getIsSelected() then
    if self.doneTaskCount then
      self:refreshNoTaskData();
    elseif self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      local riChangCount = 0;
      for k, v in pairs(self.datas)do
        if v.data.type==2 then
          riChangCount = 1;
          break;
        end
      end
      if riChangCount==0 then
        sendMessage(8,5)
      end
    end
  end
end
function TaskPopup:refreshData(taskData, newTask)

  local tempTaskPo
  local taskPoTables=analysisByName("Mubiaorenwu_Mubiaorenwu","task",taskData.ID)
  for k2,v2 in pairs(taskPoTables) do
    tempTaskPo = v2;
  end

  if taskData.TaskState == 4 then--说明这个任务被删了
    self:deleteTaskByIndex(taskData.ID)
    self:checkAndSendMgs()
    if tempTaskPo.type == 1 then
      self:reOrderMuBiaoTask()
    else
      self:reOrderRiChangTask()
    end
  elseif taskData.TaskState == 3 then--任务状态改变引起位置改变
    if newTask then
      self:addNewTask(taskData, tempTaskPo)
    else
      for k, v in pairs(self.datas) do
        if v.data.task == taskData.ID then
          self.datas[k].TaskState = 3;
        end
      end
      self:reOrderDatas();
      local render = self:getTaskRender(tempTaskPo);
      if render then
        render:resetState(taskData.TaskState);
      else
        print("!!!!!!!!!!!!!!!!!!!!!!refresh task  not find  render", tempTaskPo.task)
      end
      if tempTaskPo.type == 1 then
        self:reOrderMuBiaoTask()
      else
        self:reOrderRiChangTask()
      end
    end
    if tempTaskPo.type==1 and self.riChang_button:getIsSelected() and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      self.redico:setVisible(true)      
    end
  else--新增任务或者同步任务条件
    if newTask then
      self:addNewTask(taskData, tempTaskPo)
    else
      local count
      local maxcount
      for k3,v3 in pairs(taskData.TaskConditionArray) do
          count = v3.Count
          maxcount=v3.MaxCount
      end
      local render = self:getTaskRender(tempTaskPo);
      if render then
        render:refreshCondition(count,maxcount);
      else
        print("!!!!!!!!!!!!!!!!!!!!!!refresh task condition not find  render taskId:".. tempTaskPo.task)
      end
    end
  end
end
function TaskPopup:addNewTask(taskData, tempTaskPo)
    local count
    local maxcount
    for k3,v3 in pairs(taskData.TaskConditionArray) do
        count = v3.Count
        maxcount=v3.MaxCount
    end
    local taskIndex = self:getTaskIndex(taskData);
    taskIndex = taskIndex;
    if taskIndex < 0 then taskIndex = 0 end;


    if(tempTaskPo.type==1) then
      print("new arrived muBiao taskId , taskIndex:",taskData.ID, taskIndex)
      local render=TaskRender.new();
      render:initialize(self,tempTaskPo,count,maxcount, taskData.TaskState);
      self.muBiaoList:addItemAt(render, taskIndex)
      table.insert(self.muBiaoRenders,taskIndex+1, render)
    elseif (tempTaskPo.type==2) and self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_28) then
      print("new arrived riChang taskId , taskIndex:",taskData.ID, taskIndex)
      local render=TaskRender.new();
      render:initialize(self,tempTaskPo,count,maxcount, taskData.TaskState);
      self.riChangList:addItemAt(render, taskIndex)
      table.insert(self.riChangRenders,taskIndex+1, render)
    end
end
function TaskPopup:reOrderMuBiaoTask()

  self.muBiaoList:removeAllItems(false)
  local tempTables = {};
  for k, v in ipairs(self.datas) do
    if v.data.type == 1 then
      local render = self:getTaskRender(v.data)
      if render then
        self.muBiaoList:addItem(render)
        table.insert(tempTables, render)
      else
        print("!!!!!!!!!!!!!!!!!!!!!!v.data.task not find  RiChang render", v.data.task)
      end
    end
  end
  local count = 0;
  for k, v in pairs(self.muBiaoList.list)do
    count = count+1
  end
  print("$$$$$$$$$$$$$$$$$$$$$$$$self.muBiaoList.list count", count)

  self.muBiaoRenders = tempTables;
  local count = 0;
  for k, v in pairs(self.muBiaoRenders)do
    count = count+1
  end
  print("$$$$$$$$$$$$$$$$$$$$$$$$self.muBiaoRenders count", count)
end
function TaskPopup:reOrderRiChangTask()

  self.riChangList:removeAllItems(false)
  local tempTables = {};
  for k, v in ipairs(self.datas) do
    if v.data.type == 2 then
      local render = self:getTaskRender(v.data)
      if render then
        self.riChangList:addItem(render)
        table.insert(tempTables, render)
      else
        print("!!!!!!!!!!!!!!!!!!!!!!v.data.task not find  RiChang render", v.data.task)
      end
    end
  end
  self.riChangRenders = tempTables;

end
function TaskPopup:reOrderDatas()
  for k,v in pairs(self.datas) do
    if(v.TaskState==3 and v.data.order > 0) then
      v.data.order=v.data.order-100
    end
  end
  table.sort(self.datas, sortFun)
end
function TaskPopup:getTaskIndex(taskData)
  local tempTaskPo 
  local taskPoTables=analysisByName("Mubiaorenwu_Mubiaorenwu","task",taskData.ID)
  for k2,v2 in pairs(taskPoTables) do
    tempTaskPo = v2;
  end

  if taskData then
    table.insert(self.datas, {data=tempTaskPo,TaskConditionArray=taskData.TaskConditionArray, TaskState = taskData.TaskState});
  end

  self:reOrderDatas()

  local returnValue = 0;
  for k, v in ipairs(self.datas) do
    if tempTaskPo.type == v.data.type then
      if v.data.task == taskData.ID then
        if returnValue < 0 then
          returnValue = 0;
        end
        print("===============returnValue", returnValue)
        return returnValue;
      end
      returnValue = returnValue + 1;
    end
  end
end

function TaskPopup:deleteTaskByIndex(taskId)
  local tempTaskPo
  local taskPoTables=analysisByName("Mubiaorenwu_Mubiaorenwu","task",taskId)
  for k2,v2 in pairs(taskPoTables) do
    tempTaskPo = v2;
  end

  if tempTaskPo.type == 1 then--目标
    for k, v in ipairs(self.muBiaoRenders)do
      if v.targetTaskPo.task == tempTaskPo.task then
        self.muBiaoList:removeItemAt(k-1)
        table.remove(self.muBiaoRenders, k)
        print("removeTaskId ", tempTaskPo.task)
        break;
      end
    end
  else
    for k, v in ipairs(self.riChangRenders)do
      if v.targetTaskPo.task == tempTaskPo.task then
        self.riChangList:removeItemAt(k-1)
        table.remove(self.riChangRenders, k)
        print("removeTaskId ", tempTaskPo.task)
        break;
      end
    end
  end
  for k, v in ipairs(self.datas) do
    if v.data.task == taskId then
      table.remove(self.datas, k);
      break;
    end
  end
end

function TaskPopup:getTaskRender(taskPo)
  if taskPo.type == 1 then--目标
    for k, v in ipairs(self.muBiaoRenders)do
      if v.targetTaskPo.task == taskPo.task then
        return v;
      end
    end
  else
    for k, v in ipairs(self.riChangRenders)do
      if v.targetTaskPo.task == taskPo.task then
        return v;
      end
    end
  end
end

function TaskPopup:resetState()
  for k,v in pairs(self.muBiaoRenders) do

    local curTask = self.taskProxy.tasks["key" .. v.targetTaskPo.task]
    if curTask and curTask.TaskState then
      v:resetState(curTask.TaskState)
    else
      error("task state is not right");
    end
  end
end


