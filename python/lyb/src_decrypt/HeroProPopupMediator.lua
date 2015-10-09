--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroPro.ui.HeroProPopup";

HeroProPopupMediator=class(Mediator);

function HeroProPopupMediator:ctor(items)
	self.class=HeroProPopupMediator;
	self.items = items;
	self.viewComponent=HeroProPopup.new(self.items);

end

rawset(HeroProPopupMediator,"name","HeroProPopupMediator");

function HeroProPopupMediator:initializeUI(items)
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
	
	--赋值
	self:getViewComponent():initialize(items);
end

function HeroProPopupMediator:onTutorToSilver(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
end

-- function HeroProPopupMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end
function HeroProPopupMediator:onTrack(event)
	   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,event.data));
end

function HeroProPopupMediator:onRegister()
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
  self:getViewComponent():addEventListener("onEquip", self.onEquip, self);
  self:getViewComponent():addEventListener("offEquip", self.offEquip, self);
  self:getViewComponent():addEventListener("tutorToSilver", self.onTutorToSilver, self);
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND, self.onTrack, self);

  -- self:getViewComponent():addEventListener(HeroHouseNotifications.HEROHOUSE_CLOSE, self.onHeroHouseClose, self);
  -- self:getViewComponent():addEventListener("showChangeEquipe", self.showChangeEquipe, self);
end

-- function HeroProPopupMediator:showChangeEquipe(event)
-- 	local id = event.data;
-- 	self:sendNotification(HeroHouseNotification.new(MainSceneNotifications.TO_HEROCHANGEEQUIPE));
-- 	print("===="..id);
-- end

function HeroProPopupMediator:setExp()
	
end

function HeroProPopupMediator:setData()
	local heroHouseProxy = self:getViewComponent():retrieveProxy(HeroHouseProxy.name);
	--GeneralId,ConfigId,UsingEquipmentArray,SkillArray,Level,Grade,IsPlay,Time
	local itemTb = heroHouseProxy.generalArray;--serverData
	for i=1,#itemTb do
		if itemTb[i].GeneralId == self:getViewComponent().selectedData.GeneralId then
			self.items = itemTb[i];
			break;
		end;
	end

	self:getViewComponent():setData(self.items);
end

function HeroProPopupMediator:onEquip(event)
	self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROEQUIPE_PUTON,event.data));
end

function HeroProPopupMediator:offEquip(event)
	self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROEQUIPE_PUTOFF,event.data));
end

function HeroProPopupMediator:onClose(event)
	-- --setButtonGroupVisible(true);
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROPRO_CLOSE));
end

function HeroProPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function HeroProPopupMediator:refreshDataBySkillLevelUp(generalID, skillID)
	self:getViewComponent():refreshDataBySkillLevelUp(generalID, skillID);
end

function HeroProPopupMediator:refreshGeneralExpAndHunli()
	self:getViewComponent():refreshGeneralExpAndHunli();
end

function HeroProPopupMediator:refreshDataByJinjie()
	self:getViewComponent():refreshDataByJinjie();
end

function HeroProPopupMediator:onHeroHouseClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROHOUSE_CLOSE));
end