
FunctionOpenPopup=class(LayerPopableDirect);

function FunctionOpenPopup:ctor()
  self.class=FunctionOpenPopup;
end

function FunctionOpenPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FunctionOpenPopup.superclass.dispose(self);
  self.armature:dispose()
  BitmapCacher:removeUnused();
end
function FunctionOpenPopup:initialize()
  self:initLayer();

  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));

  local layerColor = Layer.new();
  layerColor:initLayer();
  layerColor:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
  -- layerColor:setColor(ccc3(0,0,0));
  -- layerColor:setOpacity(0);

  
  self:addChild(layerColor)
  self:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY)    
end
function FunctionOpenPopup:onDataInit()
  self.openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.skeleton = self.openFunctionProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"functionOpen_ui");
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData);
end

function FunctionOpenPopup:onUIInit()
  print("function FunctionOpenPopup:onUIInit()")
  self:addChild(self.armature.display);

  self:setData();
end

function FunctionOpenPopup:setEffect(xPos, yPos)
  if not self.boneLightCartoon then
    self.boneLightCartoon = BoneCartoon.new()
    self.boneLightCartoon:create("1011",0);
    self.boneLightCartoon:setMyBlendFunc()
    self:addChildAt(self.boneLightCartoon, 1);
  end
  self.boneLightCartoon:setPositionXY(xPos, yPos)
  print("xPos, yPos", xPos, yPos)
end

function FunctionOpenPopup:initializeUI(functionId, functionData, tutorData)
  self.functionId = functionId
  self.functionData = functionData;
  self.tutorData = tutorData;
end

function FunctionOpenPopup:setData()
  local functionPo = analysis("Gongnengkaiqi_Gongnengkaiqi", self.functionId)
  local artId = functionPo.icon
  local realFunctionId = self.functionId
  if functionPo.interface ~= "" then
    local iTables = StringUtils:lua_string_split(functionPo.interface, "_")
    realFunctionId = tonumber(iTables[1]);
  end
  local function moveCallBack()
      if GameVar.tutorStage ~= 0 and GameVar.tutorStage ~= 99999 then
        local xPos, yPos, width,height
        if self.tutorData then
          xPos, yPos = self.tutorData.x, self.tutorData.y;
          if self.tutorData.width then
            width, height = self.tutorData.width, self.tutorData.height
          else
            width, height = 90,90
          end
        else
          xPos, yPos = self.functionData.x, self.functionData.y-60;
          if Utils:contain(FunctionConfig.menu_Hfunctions1,realFunctionId) then
            xPos = xPos - 60;
          end
          if self.functionData.width then
            width, height = self.functionData.width, self.functionData.height
          else
            width, height = 90,90
          end
        end
        if GameVar.tutorStage == TutorConfig.STAGE_1008 then
          openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});
        else
          openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});
        end
      else
        checkAddTutorEffect();
      end
      self.image:setVisible(false)
  end
  local function moveCallBack2()
      self:onCloseButton();
  end
  local function delayCallBackFun()
      self:removeChild(self.armature.display)
      self:removeChild(self.boneLightCartoon)
  end
  self:setEffect(640,367)
  print("self.functionData.x, self.functionData.y", self.functionData.x, self.functionData.y)

  self.image = Image.new();
  self.image:loadByArtID(artId)
  self.image:setAnchorPoint(CCPointMake(0.5,0.5));
  self.image:setPositionXY(642,397);
  self:addChild(self.image)

  local ccDelayTime = CCDelayTime:create(1)
  local delayDallBack = CCCallFunc:create(delayCallBackFun);
  local moveTo = CCMoveTo:create(0.8, ccp(self.functionData.x+GameData.uiOffsetX, self.functionData.y+GameData.uiOffsetY))
  local ccDelayTime2 = CCDelayTime:create(1)
  local callBack = CCCallFunc:create(moveCallBack);

  local callBack2 = CCCallFunc:create(moveCallBack2);
  local arr = CCArray:create();

  arr:addObject(ccDelayTime);   
  arr:addObject(delayDallBack);   
  arr:addObject(moveTo);  
  arr:addObject(callBack); 
  arr:addObject(ccDelayTime2);   
  arr:addObject(callBack2);
  self.image:runAction(CCSequence:create(arr));   
end

function FunctionOpenPopup:onCloseButton(event)--CLOSE_FUNCTION_OPEN_UI
  self:dispatchEvent(Event.new("CLOSE_FUNCTION_OPEN_UI",nil,self));
end