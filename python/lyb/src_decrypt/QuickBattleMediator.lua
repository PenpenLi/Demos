require "main.view.quickBattle.ui.QuickBattlePopup";

QuickBattleMediator=class(Mediator);

function QuickBattleMediator:ctor()
  self.class = QuickBattleMediator;
  self.viewComponent=QuickBattlePopup.new();
end

rawset(QuickBattleMediator,"name","QuickBattleMediator");

function QuickBattleMediator:initData(data)
  self.viewComponent:initData(data);
end

function QuickBattleMediator:onRegister()
  self:getViewComponent():initialize();
  self.viewComponent:addEventListener("STRONGPOINT_CLICK", self.onStrongpointClick, self);
  self.viewComponent:addEventListener("DROP_ITEM_CLICK", self.onDropItemTap, self);
  self.viewComponent:addEventListener("REMOVE_TIP_CLICK", self.onRemoveTip, self);
  self.viewComponent:addEventListener("STRONGPOINT_CLOSE", self.onStrongPoincClose, self);
  self.viewComponent:addEventListener("OPEN_MIJI", self.onOpenMiji, self);
end
function QuickBattleMediator:onStrongpointClick(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_BATTLE, event.data));
end
function QuickBattleMediator:refreshData(RoundItemIdArray, StrongPointId)
    self.viewComponent:refreshData(RoundItemIdArray, StrongPointId);
end
function QuickBattleMediator:refreshCount(count, saoDangQuanCount)
    self.viewComponent:refreshCount(count, saoDangQuanCount)
end
function QuickBattleMediator:refreshTili()
    self.viewComponent:refreshTili();
end
function QuickBattleMediator:mopUpOver()
    self.viewComponent:mopUpOver();
end
function QuickBattleMediator:onStrongPoincClose(event)
    self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.CLOSE_QUICK_BATTLE_UI_COMMOND));
end
function QuickBattleMediator:onRemove()
  self:getViewComponent().parent:removeChild(self:getViewComponent());
end

function QuickBattleMediator:onOpenMiji(evt)
   print("onOpenMiji")
   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_ADD_TILI)); 
  --self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LITTLEHELPER,{TAB = 3,TYPE_ID = evt.data}));
end
