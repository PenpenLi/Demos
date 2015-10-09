require "core.controls.page.CommonSlot";

HeroProPageSlot=class(CommonSlot);

function HeroProPageSlot:ctor()
  self.class=HeroProPageSlot;
end

function HeroProPageSlot:dispose()
  self:removeAllEventListeners();
  HeroProPageSlot.superclass.dispose(self);
end

function HeroProPageSlot:initialize(context)
	self.context = context;
	self.skeleton = self.context.skeleton;
	self:initLayer();
end

function HeroProPageSlot:setSlotData(datas)
  TimeCUtil:getTime("setSlotData1")
  self.datas = datas;
  if self.card then
  	self:removeChild(self.card);
  	self.card = nil;
  end
  self.card = getImageByArtId(analysis("Kapai_Kapaiku", self.context.heroHouseProxy:getGeneralData(self.datas).ConfigId, "art1"));
  self:addChild(self.card);TimeCUtil:getTime("setSlotData2")
end

