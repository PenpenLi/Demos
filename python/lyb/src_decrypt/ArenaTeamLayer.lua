ArenaTeamLayer=class(Layer);

function ArenaTeamLayer:ctor()
    self.class=ArenaTeamLayer;
    self.armature = nil;
    self.armature_d = nil;
    self.heroNumberArray = {}
    require "main.view.arena.ui.ArenaTeamItem";
    self.zhanli = 0
    self.upTeamItemArray = {}
    self.bingYuanNumber = 0
    self.hasBackData = true
end

function ArenaTeamLayer:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    ArenaTeamLayer.superclass.dispose(self);
    self.popUp = nil
    self:removeTimeOutTimer()
    self:removeClickTimeOutTimer()
end

function ArenaTeamLayer:initializeUI(popUp)
    if self.popUp then return end;
    self.popUp = popUp; 

    self:initViewUI()
    
    self:changeAnchorPoint(GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2)
    self:openAction()

end

function ArenaTeamLayer:initListView()
    local teamp3P = self.armature_d:getChildByName("teamp3"):getPosition()
    self.viewList = ListScrollViewLayer.new();
    self.viewList:initLayer();
    self.viewList:setPosition(teamp3P)
    self.viewList:setDirection(kCCDirectionHorizontal);
    self.viewList:setViewSize(makeSize(1075,250));
    self.viewList:setItemSize(makeSize(195,250));
    self:addChild(self.viewList);
end

function ArenaTeamLayer:openAction()
    self:setScaleX(0)
    local function callBackFun()
        self:initListView()
        self:refreshTeamLayerData()
    end
    local scale = CCEaseSineOut:create(CCScaleTo:create(0.2,1,1))
    local callBack = CCCallFunc:create(callBackFun);

    local sequenceArray = CCArray:create();
    sequenceArray:addObject(scale);
    sequenceArray:addObject(CCDelayTime:create(0.1));
    sequenceArray:addObject(callBack);
    
    self:runAction(CCSequence:create(sequenceArray));
end

function ArenaTeamLayer:initViewUI()
    self.imageBg = getImageByArtId(382);
    self.imageBg:setScale(2)
    self:addChild(self.imageBg)

    self.skeleton = self.popUp:getTenContrySkeleton()
    
    local armature=self.skeleton:buildArmature("team_ui");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature;
    
    local armature_d=armature.display;
    self.armature_d = armature_d;
    self:addChild(armature_d);

    local num0 = armature_d:getChildByName("common_copy_zhanLi");
    self.num0X = num0:getPositionX() + 150
    local num0Y = num0:getPositionY();
    self.num0Y = num0Y - num0:getContentSize().height;

    self.closeButton = Button.new(self.armature:findChildArmature("common_copy_close_button"),false);
    self.closeButton:addEventListener(Events.kStart,self.onCloseButtonTap,self);
    self.armature_d:getChildByName("fightbutton"):setVisible(false)

    local text_data = self.armature:getBone("num_text").textData;
    self.numText = createTextFieldWithTextData(text_data,"征战兵源：");
    self:addChild(self.numText);

    self:addEventListener(DisplayEvents.kTouchMove,self.onTouchLayerMove,self);
    self:addEventListener(DisplayEvents.kTouchEnd,self.onTouchLayerEnd,self);
    self:addEventListener(DisplayEvents.kTouchBegin,self.onTouchLayerBegin,self);
end

function ArenaTeamLayer:onTouchLayerBegin(event)
    self.isMove = false;
    self.startPosition = event.globalPosition;
    
end
function ArenaTeamLayer:onTouchLayerMove(event)
    local position = event.globalPosition;
    local dx = self.startPosition.x-position.x;
    local dy = self.startPosition.y-position.y;
    local dis = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    if dis >80 then
        self.isMove = true;
    end
end

function ArenaTeamLayer:onTouchLayerEnd(event)
    local function timeOutFun()
        self:removeTimeOutTimer()
        self.isMove = false;
    end
    self.timeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOutFun, 0, false)
end

function ArenaTeamLayer:refreshTeamLayerData()
    self.hasBackData = true
    self:resertTeamData()
    self:addDownTeam()
    -- self:addMasterTeam()
    self:addUpTeam()
    self:addPowerNum()
    self:refreshBingyuan()
end

function ArenaTeamLayer:resertTeamData()
    self.zhanli = 0
    for key,value in pairs(self.upTeamItemArray) do
        self:removeChild(value)
    end
    self.viewList:removeAllItems(true);
    if self.teamMasterItem then
        self.armature_d:removeChild(self.teamMasterItem)
        self.teamMasterItem = nil
    end
    self.upTeamItemArray = {}
    self.bingYuanNumber = 0
end

function ArenaTeamLayer:refreshBingyuan()
    self.numText:setString("征战兵源："..self.bingYuanNumber)
end

function ArenaTeamLayer:addUpTeam()
    local generalTable = self.popUp.arenaProxy.generalIdArray
    local teamp2P = self.armature_d:getChildByName("teamp2"):getPosition()
    for key,VO in pairs(generalTable) do
        local masterVO = self.popUp.heroHouseProxy:getGeneralData(VO.generalId)
        self.zhanli = self.zhanli + math.floor(self.popUp.heroHouseProxy:getZongZhanli(VO.generalId))
        local teamItem = ArenaTeamItem.new()
        teamItem:initLayer()
        teamItem:initializeItem(self.popUp,masterVO)
        self:addXiaZhenListener(teamItem,VO.place);
        teamItem:setPositionXY(teamp2P.x + (VO.place-1)*215,teamp2P.y)
        self:addChild(teamItem)
        -- table.insert(self.upTeamItemArray,teamItem)
        self.upTeamItemArray[VO.place] = teamItem
    end
end

function ArenaTeamLayer:addMasterTeam()
    local masterVO = self.popUp.heroHouseProxy:getMainGeneral()
    -- print("ttttttttttttt1111111111ttttt"..self.zhanli)
    self.zhanli = self.zhanli + self.popUp.heroHouseProxy:getZongZhanli(masterVO.GeneralId)
    -- print("tttttttttttt222222222222222ttt"..self.zhanli)
    local teamp1P = self.armature_d:getChildByName("teamp1"):getPosition()
    self.teamMasterItem = ArenaTeamItem.new()
    self.teamMasterItem:initLayer()
    self.teamMasterItem:initializeItem(self.popUp,masterVO,"main")
    self.teamMasterItem:setPosition(teamp1P)
    self.armature_d:addChild(self.teamMasterItem)
    self.armature_d:setChildIndex(self.teamMasterItem,1000000)
    --tuizhang
    local tuizhang = self.armature_d:getChildByName("tuizhang")
    self.armature_d:setChildIndex(tuizhang,1000001)
end

function ArenaTeamLayer:addDownTeam()
    local generalArray = self.popUp.heroHouseProxy:getGeneralArray()
    for key,generalVO in pairs(generalArray) do
        if not self.popUp.arenaProxy:isInUpItem(generalVO.GeneralId) and not self.popUp.heroHouseProxy:getIsMainGeneral(generalVO.GeneralId) then
            local teamItem = ArenaTeamItem.new()
            teamItem:initLayer()
            -- print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"..generalVO.GeneralId)
            self:addShangZhenListener(teamItem,generalVO.GeneralId);
            teamItem:initializeItem(self.popUp,generalVO)
            -- print("uuuuuuuuuuuuuuuuuuuuuuuuuu")
            self.bingYuanNumber = self.bingYuanNumber + 1
            self.viewList:addItem(teamItem)
       end
    end
end

function ArenaTeamLayer:addShangZhenListener(teamItem,generalId)
    teamItem:addEventListener(DisplayEvents.kTouchTap, self.onShangZhenTap,self,generalId);
end

function ArenaTeamLayer:onShangZhenTap(event,generalId)
    if self.isMove then return end
    local place = self:getUpTeamKongPlace()
    if not place then
        sharedTextAnimateReward():animateStartByString("亲~没有上阵的位置了！");
        return 
    end
    if not self.hasBackData or self.clickTimeOut then return end
    self.hasBackData = nil
    self:initClickTimer()
    self.popUp.arenaProxy:insertPlaceGeneralIdArray(place,generalId)
    local serverArray = self.popUp.arenaProxy:getToServerArray()
    sendMessage(16,3,{GeneralIdArray = serverArray})
end

function ArenaTeamLayer:addXiaZhenListener(teamItem,place)
    teamItem.heroTeamSlot:addEventListener(DisplayEvents.kTouchTap, self.onXiaZhenTap,self,place);
end

function ArenaTeamLayer:onXiaZhenTap(event,place)
    -- print("vvvvvvvvvvvvvvv2222222222vvvvvvvvvvvv"..place)
    if not self.hasBackData or self.clickTimeOut then return end
    self.hasBackData = nil
    self:initClickTimer()
    self.popUp.arenaProxy:removePlaceGeneralIdArray(place)
    local serverArray = self.popUp.arenaProxy:getToServerArray()
    sendMessage(16,3,{GeneralIdArray = serverArray})
end


function ArenaTeamLayer:onCloseButtonTap()
    local function callBackFun()
        self.popUp:disposeTeamLayer()
    end
    local callBack = CCCallFunc:create(callBackFun);
    self:runAction(CCSequence:createWithTwoActions(CCEaseSineOut:create(CCScaleTo:create(0.2,0,1)), callBack));
end

function ArenaTeamLayer:addPowerNum()

    for k,v in pairs(self.heroNumberArray) do
      self:removeChild(v);
    end
    self.heroNumberArray = {}
    --local skeleton = self.popUp.skeleton
    local long = string.len(self.zhanli);
    for i = 1, long do
      local str = string.sub(self.zhanli, i, i);
      local num = self.skeleton:getBoneTextureDisplay("n"..str);
      num:setPositionXY(self.num0X + (i - 1)*35,self.num0Y);
      self:addChild(num);
      table.insert(self.heroNumberArray,num);
    end
end 

function ArenaTeamLayer:getUpTeamKongPlace()
    for i=1,3 do
        if not self.upTeamItemArray[i] then
            return i
        end
    end
    return nil
end

function ArenaTeamLayer:initClickTimer()
    self:removeClickTimeOutTimer()
    local function timeOutFun()
        self:removeClickTimeOutTimer()
    end
    self.clickTimeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOutFun, 0.8, false)
end

function ArenaTeamLayer:removeTimeOutTimer()
    if self.timeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
        self.timeOut = nil
    end
end

function ArenaTeamLayer:removeClickTimeOutTimer()
    if self.clickTimeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.clickTimeOut);
        self.clickTimeOut = nil
    end
end