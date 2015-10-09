--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.family.ui.FamilyPopup";

FamilyMediator=class(Mediator);

function FamilyMediator:ctor()
  self.class=FamilyMediator;
	self.viewComponent=FamilyPopup.new();
end

rawset(FamilyMediator,"name","FamilyMediator");

function FamilyMediator:intialize(skeleton, familyProxy, userProxy, bagProxy, userCurrencyProxy, buddyListProxy, effectProxy, chatListProxy, challengeProxy, generalListProxy, countControlProxy, shopProxy)
  self:getViewComponent():initialize(skeleton,familyProxy,userProxy,bagProxy,userCurrencyProxy,buddyListProxy,effectProxy,chatListProxy,challengeProxy,generalListProxy,countControlProxy,shopProxy);
end

function FamilyMediator:requestNoneFamilyLayerData(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,event.data));
end

function FamilyMediator:requestFamilyMemberArray(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.REQUEST_FAMILY_MEMBER_ARRAY,event.data));
end

function FamilyMediator:requestFamilyApplyArray(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.REQUEST_FAMILY_APPLY_ARRAY,event.data));
end

function FamilyMediator:lookIntoFamilyCommand(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.LOOK_INTO_FAMILY,event.data));
end

function FamilyMediator:onFamilyFound(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_FOUND,event.data));
end

function FamilyMediator:onFamilyApply(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_APPLY,event.data));
end

function FamilyMediator:onFamilyLevelUp(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_LEVEL_UP,event.data));
end

function FamilyMediator:onFamilyDismiss(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_DISMISS,event.data));
end

function FamilyMediator:onFamilyToAgora(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_TO_AGORA,event.data));
end

function FamilyMediator:onFamilyVerify(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_VERIFY,event.data));
end

function FamilyMediator:requestFamilyLog(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.REQUEST_FAMILY_LOG,event.data));
end

function FamilyMediator:onStandSelect(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_STAND_SELECT,event.data));
end

function FamilyMediator:onInvite(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,event.data));
end

function FamilyMediator:onChangePositionID(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_CHANGE_POSITIONID,event.data));
end

function FamilyMediator:onLookIntoMember(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_LOOK_INTO_PLAYER,event.data));
end

function FamilyMediator:onFamilyKick(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_KICK,event.data));
end

--添加好友
function FamilyMediator:onAddBuddy(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_ADD_BUDDY,event.data));
end

function FamilyMediator:onPrivate(event)
  self:sendNotification(ChatNotification.new(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,event.data));
end

function FamilyMediator:onFamilyChangeNotice(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_CHANGE_NOTICE,event.data));
end

function FamilyMediator:onToTask(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_FAMILY_TASK,event.data));
end

function FamilyMediator:onActivate(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_ACTIVITY_ACTIVATE,event.data));
end

function FamilyMediator:onFamilyDonate(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_DONATE,event.data));
end

function FamilyMediator:onRecharge(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end

function FamilyMediator:onInviteFamily(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_INVITE,event.data));
end

function FamilyMediator:onToAutoGuide(event)
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function FamilyMediator:onImpeach(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_IMPEACH,event.data));
end

function FamilyMediator:onRequestFamilyBossRankData(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.REQUEST_FAMILY_BOSS_RANK_DATA,event.data));
end

function FamilyMediator:onClose(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_CLOSE));
end

function FamilyMediator:toBathField(evt)
  self:sendNotification(BathFieldNotification.new(BathFieldNotifications.TO_BATH_FIELD));
end

function FamilyMediator:getSalary(evt)
  sendMessage(27,21);
end

function FamilyMediator:toFamilyBoss(evt)
  sendMessage(27,46);
end

function FamilyMediator:refreshNoneFamilyLayerData(page, maxPage, familyInfoArray)
  self:getViewComponent():refreshNoneFamilyLayerData(page,maxPage,familyInfoArray);
end

function FamilyMediator:refreshFamilyData()
  self:getViewComponent():refreshFamilyData();
end

function FamilyMediator:refreshLookIntoFamily(data)
  self:getViewComponent():refreshLookIntoFamily(data);
end

function FamilyMediator:refreshFamilyApply(familyId, bool)
  self:getViewComponent():refreshFamilyApply(familyId,bool);
end

function FamilyMediator:refreshFamilyMemberArray(familyId, memberArray)
  self:getViewComponent():refreshFamilyMemberArray(familyId,memberArray);
end

function FamilyMediator:refreshFamilyApplyArray(applierArray)
  self:getViewComponent():refreshFamilyApplyArray(applierArray);
end

function FamilyMediator:refreshFamilyVerify(userId, booleanValue)
  self:getViewComponent():refreshFamilyVerify(userId,booleanValue);
end

function FamilyMediator:refreshFamilyLog(familyLogArray)
  self:getViewComponent():refreshFamilyLog(familyLogArray);
end

function FamilyMediator:refreshStand()
  self:getViewComponent():refreshStand();
end

function FamilyMediator:refreshChangePositionID(userId, familyPositionId)
  self:getViewComponent():refreshChangePositionID(userId,familyPositionId);
end

function FamilyMediator:refreshNewInfo()
  self:getViewComponent():refreshNewInfo();
end

function FamilyMediator:refreshNotice()
  self:getViewComponent():refreshNotice();
end

function FamilyMediator:refreshFamilyKick(userID)
  self:getViewComponent():refreshFamilyKick(userID);
end

function FamilyMediator:refreshActivitys()
  self:getViewComponent():refreshActivitys();
end

function FamilyMediator:refreshNewApply()
  self:getViewComponent():refreshNewApply();
end

function FamilyMediator:refreshFamilyContribute()
  self:getViewComponent():refreshFamilyContribute();
end

function FamilyMediator:getUserNameByMemberLayer(userId)
  return self:getViewComponent():getUserNameByMemberLayer(userId);
end

function FamilyMediator:getUserNameByApplyLayer(userId)
  return self:getViewComponent():getUserNameByApplyLayer(userId);
end

function FamilyMediator:changeTab(tabID)
  self:getViewComponent():changeTab(tabID);
end

function FamilyMediator:changeToActivity(id)
  self:getViewComponent():changeToActivity(id);
end

function FamilyMediator:duelOtherPlayer(evt)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.DUEL_OTHER_PLAYER,{UserId = evt.data.UserId, UserName = evt.data.UserName}));
end

function FamilyMediator:refreshFamilyBossRankData(skeleton, challengeProxy)
  self:getViewComponent():refreshFamilyBossRankData(skeleton,challengeProxy);
end

function FamilyMediator:refreshActivity4FamilyBoss()
  self:getViewComponent():refreshActivity4FamilyBoss();
end

function FamilyMediator:onRegister()
  self:getViewComponent():addEventListener(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,self.requestNoneFamilyLayerData,self);
  self:getViewComponent():addEventListener(FamilyNotifications.LOOK_INTO_FAMILY,self.lookIntoFamilyCommand,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_APPLY,self.onFamilyApply,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_FOUND,self.onFamilyFound,self);

  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_LEVEL_UP,self.onFamilyLevelUp,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_DISMISS,self.onFamilyDismiss,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_TO_AGORA,self.onFamilyToAgora,self);
  self:getViewComponent():addEventListener(FamilyNotifications.REQUEST_FAMILY_MEMBER_ARRAY,self.requestFamilyMemberArray,self);
  self:getViewComponent():addEventListener(FamilyNotifications.REQUEST_FAMILY_APPLY_ARRAY,self.requestFamilyApplyArray,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_VERIFY,self.onFamilyVerify,self);
  self:getViewComponent():addEventListener(FamilyNotifications.REQUEST_FAMILY_LOG,self.requestFamilyLog,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_STAND_SELECT,self.onStandSelect,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_INVITE,self.onInvite,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_CHANGE_POSITIONID,self.onChangePositionID,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_KICK,self.onFamilyKick,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_CHANGE_NOTICE,self.onFamilyChangeNotice,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_DONATE,self.onFamilyDonate,self);
  -- self:getViewComponent():addEventListener(BathFieldNotifications.TO_BATH_FIELD,self.toBathField,self);
  self:getViewComponent():addEventListener("GET_FAMILY_SALARY",self.getSalary,self);
  self:getViewComponent():addEventListener("TO_FAMILY_BOSS",self.toFamilyBoss,self);

  self:getViewComponent():addEventListener(MainSceneNotifications.TO_LOOK_INTO_PLAYER,self.onLookIntoMember,self);
  self:getViewComponent():addEventListener("chatAddBuddy",self.onAddBuddy,self);
  self:getViewComponent():addEventListener(ChatNotifications.CHAT_PRIVATE_TO_PLAYER,self.onPrivate,self);

  self:getViewComponent():addEventListener(MainSceneNotifications.MAIN_SCENE_TO_FAMILY_TASK,self.onToTask,self);

  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_ACTIVITY_ACTIVATE,self.onActivate,self);

  self:getViewComponent():addEventListener("vip_recharge",self.onRecharge,self);
  self:getViewComponent():addEventListener("invite_family",self.onInviteFamily,self);

  self:getViewComponent():addEventListener("TO_AUTO_GUIDE",self.onToAutoGuide,self);
  self:getViewComponent():addEventListener("DUEL_OTHER_PLAYER",self.duelOtherPlayer,self);

  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_IMPEACH,self.onImpeach,self);
  self:getViewComponent():addEventListener(FamilyNotifications.REQUEST_FAMILY_BOSS_RANK_DATA,self.onRequestFamilyBossRankData,self);
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_CLOSE,self.onClose,self);
end

function FamilyMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end