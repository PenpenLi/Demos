require "main.view.battleScene.BattleSceneMediator";


MainSceneToBattleCommand=class(Command);

function MainSceneToBattleCommand:ctor()
	self.class=ApplicationStartCommand;
end

function MainSceneToBattleCommand:execute(notification)
    if GameData.isConnect == false then return;end
    local userProxy = self:retrieveProxy(UserProxy.name)
    local beibaoman = analysis("Zhandoupeizhi_Zhanchangleixing",notification.data.battleType,"beibaoman");
    if beibaoman == 1 and not notification.data.continueBattle and not userProxy.hasAlertBagIsFull then
            local bagProxy = self:retrieveProxy(BagProxy.name)
            local itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name)
            if bagProxy:getBagIsFull(itemUseQueueProxy) then
                local commonPopup=CommonPopup.new();
                commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_113),self,self.sendBattleMessage,notification,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_113),nil,true);

                local scene = Director.sharedDirector():getRunningScene();      
                if scene.name == GameConfig.MAIN_SCENE then
                  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(commonPopup);
                elseif  scene.name == GameConfig.BATTLE_SCENE then
                  sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(commonPopup);
                end
                return;
            else
                self:sendBattleMessage(notification)
            end
    else
        userProxy.hasAlertBagIsFull = nil
        self:sendBattleMessage(notification)
    end
end

function MainSceneToBattleCommand:sendBattleMessage(notification)
        -- if notification.data.battleType ~= BattleConfig.BATTLE_TYPE_4 then
            if notification.data.battleType ~= BattleConfig.BATTLE_TYPE_11 then
              initializeSmallLoading(9999)
            else
              initializeSmallLoading()
            end
        -- end
        local battleProxy = self:retrieveProxy(BattleProxy.name);
        battleProxy.isContinueBattle = notification.data.continueBattle
        battleProxy.strongPointId = nil;
        if battleProxy.isContinueBattle then
        else
            if BattleOverMediator then
                self:removeMediator(BattleOverMediator.name)
            end
            if LotteryMediator then
                self:removeMediator(LotteryMediator.name);
            end
            self:removeMediator(BattleSceneMediator.name)--容错,断线重连可能会产生没有移除的情况
            sharedBattleLayerManager():disposeBattleLayerManager()
        end
        local table;
        if notification.data.battleType == BattleConfig.BATTLE_TYPE_1 then
               print("notification.data.StrongPointId:", notification.data.StrongPointId)
               print("notification.data.storyLineId:", notification.data.storyLineId)
               table = {StrongPointId = notification.data.StrongPointId};
               sendMessage(7,1,table);
               battleProxy.strongPointId = notification.data.StrongPointId;
               battleProxy.storyLineId = notification.data.storyLineId;

        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_2 then
                -- table = {UserId = notification.data.UserId, Ranking = notification.data.Ranking};
                -- sendMessage(16, 2, table);
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_3 then
                local towerProxy = self:retrieveProxy(TowerProxy.name)
                if notification.data.ID  and notification.data.ID ~= 0 then
                  towerProxy.id = notification.data.ID
                end
                table = {ID = towerProxy.id};
                sendMessage(17, 2, table);
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_4 then
                sendMessage(3, 24);
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_6 then
                local dataTable = notification.data.dataTable;
                 table = {TaskId = dataTable.taskId};
                sendMessage(8, 10, table);
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_7 then
              sendMessage(7, 51, {BooleanValue = 0})
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_8 then
                print(notification.data.Place)
                table = {Place = notification.data.Place};
                sendMessage(7, 54,table);
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_9 then
                table = {ID = notification.data.id};
                sendMessage(7, 52, table);
  
        elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_10 then--英雄志
               table = {StrongPointId = notification.data.StrongPointId};
               sendMessage(7,1,table);
               battleProxy.strongPointId = notification.data.StrongPointId;
               battleProxy.storyLineId = notification.data.storyLineId;
               print("notification.data.storyLineId:", notification.data.storyLineId)
        end
end



      -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_10 then
        --         sendMessage(7, 56);
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_11 then
        --         --sendMessage(7,57)
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_13 then -- 新手战斗
        --        notification.data.battleType = nil;
        --        sendMessage(3, 24);
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_12 then
               
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_4 then
        --        sendMessage(24,27);
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_20 then
        --   --城区怪物入侵
        --   sendMessage(30, 2, notification.data);
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_21 then
        --   --家族怪物入侵
        --   sendMessage(30, 2, notification.data);
        -- elseif notification.data.battleType == BattleConfig.BATTLE_TYPE_25 then
        --     local msg = {FortId = notification.data.fortId};
        --     sendMessage(33,8,msg);
