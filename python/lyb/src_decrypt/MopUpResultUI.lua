require "main.view.quickBattle.ui.MopUpResultRender"
MopUpResultUI=class(TouchLayer);

function MopUpResultUI:ctor()
  self.class=MopUpResultUI;
  self.uiSize = nil;
  self.BATTLE_RESULT_LIST_WIDTH = 468;
  self.BATTLE_RESULT_LIST_HEIHT = 452;
  self.BATTLE_RESULT_LIST_NUM = 2;
end

function MopUpResultUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  MopUpResultUI.superclass.dispose(self);
  self.armature:dispose()

  BitmapCacher:removeUnused();
end


function MopUpResultUI:initializeUI(skeleton, context)
  self:initLayer();

  self.mainSize=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(self.mainSize.width,self.mainSize.height);

  self.context = context;
  local armature=skeleton:buildArmature("mopUpResult_ui");
  self.skeleton = skeleton;
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self.armature = armature;
  self:addChild(armature_d)

  local armature_dSize =  armature_d:getGroupBounds().size
  print("armature_dSize.width", armature_dSize.width)
  self.armature_d_x = (self.mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (self.mainSize.height - armature_dSize.height)/2

  armature_d:setPositionXY(self.armature_d_x-GameData.uiOffsetX, self.armature_d_y-GameData.uiOffsetY)--context.armature_d_y

  local title_txtTextData = armature:getBone("title_txt").textData;
  self.title_txt =  createTextFieldWithTextData(title_txtTextData, '扫荡结果');
  self.armature_d:addChild(self.title_txt); 

  local textArm = armature:findChildArmature("fetch_button");
  local trimButtonData=textArm:getBone("common_blue_button").textData;

  --fetch_button
  local fetch_button = armature_d:getChildByName("fetch_button");
  local fetch_buttonPos = convertBone2LB4Button(fetch_button);
  armature_d:removeChild(fetch_button);
  
  fetch_button = CommonButton.new();
  fetch_button:initialize("common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  fetch_button:setPosition(fetch_buttonPos);
  fetch_button:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  armature_d:addChild(fetch_button);
  self.fetch_button = fetch_button;
  fetch_button:initializeBMText("确定","anniutuzi");


  self.battleResultList_x, self.battleResultList_y = 5, 117;
 
  self.battleResultList = ListScrollViewLayer.new();
  self.battleResultList:initLayer();
   
  self.battleResultList:setPositionXY(self.battleResultList_x, self.battleResultList_y);
  armature_d:addChild(self.battleResultList);
  
  self.battleResultList:setViewSize(makeSize(self.BATTLE_RESULT_LIST_WIDTH, self.BATTLE_RESULT_LIST_HEIHT ));
  self.battleResultList:setItemSize(makeSize(self.BATTLE_RESULT_LIST_WIDTH, self.BATTLE_RESULT_LIST_HEIHT / self.BATTLE_RESULT_LIST_NUM));

end

function MopUpResultUI:onCloseButtonTap(event) 
  -- print("self.context.count",self.context:getLeftCountByStrongPoint())
  -- if self.context:getLeftCountByStrongPoint() == 0 then
  --   self.context:closeUI()
  -- end
  self.parent:removeChild(self)

end

function MopUpResultUI:refreshData(RoundItemIdArray, StrongPointId)
    
   self.fetch_button:setGray(true)
   local curIndex = 1;
   local function timerHandleFun()
      if self.isFirstIn then
          self.timerHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerHandleFun, 1, false)
          self.isFirstIn = false;
      end
      if #RoundItemIdArray > 0 and self.battleResultList.sprite then 
          local v = RoundItemIdArray[1];
          local resultRender = MopUpResultRender.new();
          resultRender:initializeUI(self.context, v, curIndex);

          self.battleResultList:addItem(resultRender);
          self.battleResultList:scrollToItemByIndex(self.battleResultList:getItemCount())
          table.remove(RoundItemIdArray,1);
          curIndex = curIndex + 1;


          GameVar.saoDangQuanCount = 0;
          for k, v in ipairs(v.ItemIdArray) do
            if v.ItemId == 1015003 then
              GameVar.saoDangQuanCount = v.Count;
            end
          end
          if GameVar.saoDangQuanCount == 0 then
            GameVar.saoDangQuanCount = -1;
          else
            GameVar.saoDangQuanCount = GameVar.saoDangQuanCount - 1;
          end

          local resultCount = self.context.count + 1;
          local storyLineProxy = Facade.getInstance():retrieveProxy(StoryLineProxy.name);
          local key = "key_" .. StrongPointId;

          local strongPointPo = analysis("Juqing_Guanka", StrongPointId);

          local strongPointData = storyLineProxy.strongPointArray[key]
          if strongPointData then
            strongPointData.Count = resultCount;
            if strongPointPo.Gtype == 2 then
              strongPointData.TotalCount = strongPointData.TotalCount + 1;
            else
              strongPointData.TotalCount = 0
            end
          end

          local testTotalCount = storyLineProxy:getStrongPointTotalCount(StrongPointId);
          print("testTotalCount", testTotalCount)

          self.context:refreshCount(resultCount, GameVar.saoDangQuanCount)
          GameVar.saoDangQuanCount = 0;
          
      else
          if self.timerHandle then
              if self.fetch_button.sprite then
                self.fetch_button:setGray(false)
              end
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandle);
              self.timerHandle = nil;
              self.isFirstIn = true;
          end
      end
   end
   self.isFirstIn = true;
   timerHandleFun()


end
