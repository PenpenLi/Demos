require "core.controls.page.CommonSlot"

PeibingPopupItem=class(CommonSlot);

function PeibingPopupItem:ctor()
  self.class=PeibingPopupItem;
  self.beginX = 0;
  self.endX = 0;
end

function PeibingPopupItem:dispose()
	self:removeChildren()
	PeibingPopupItem.superclass.dispose(self);
end

function PeibingPopupItem:initialize(context, onCardTap, type, id)
	self:initLayer();
	self.context = context;
	self.onCardTap = onCardTap;
	self.type = type;
	self.id = id;
	self.items = {};
end

function PeibingPopupItem:onInitialize()
	local skeleton = getSkeletonByName("hero_team_ui");
	self.skeleton = skeleton;

	local line_1 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_horizon");
	line_1:setScale(0.45);
	line_1:setPositionXY(0,180);
	self:addChild(line_1);

	local line_2 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_horizon");
	line_2:setScale(0.45);
	line_2:setPositionXY(0,345);
	self:addChild(line_2);

	local line_3 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_horizon");
	line_3:setScale(0.45);
	line_3:setPositionXY(0,15);
	self:addChild(line_3);

	local line_4 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_vertical");
	line_4:setScaleX(0.45);
	line_4:setScaleY(1.25);
	line_4:setPositionXY(130,-35);
	self:addChild(line_4);

	for i =1,6 do
		local data;
		if 3 == self.type then
			data = self.context.datas[i+6*(-1+self.id)];
		elseif 2 == self.type then
			data = self.context.datas_yongbing[i+6*(-1+self.id)];
		else
			data = self.context.datas[i+6*(-1+self.id)];
		end
		if not data then
			break;
		end

		local num = 0
		if self.context.notificationData and self.context.notificationData.funcType == "TenCountry" then
			num = 5
		end
		local heroRoundPortrait = HeroRoundPortrait.new();
		heroRoundPortrait:initialize(data,true);
		heroRoundPortrait:setPositionXY(11+(-1+i)%2*140,380-165*math.floor((-1+i)/2)+num);
		heroRoundPortrait:setScale(0.9);

		if 2 == self.type then
			heroRoundPortrait:showName4YongbingOnBangpai(self.context);
		elseif 3 == self.type then
			heroRoundPortrait:showName4Paiqian();
		end
		self:addChild(heroRoundPortrait);
		table.insert(self.items, heroRoundPortrait);

		heroRoundPortrait:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self, heroRoundPortrait.data);
		heroRoundPortrait:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self, heroRoundPortrait.data);
		if self.context.notificationData and self.context.notificationData.funcType == "TenCountry" then
			local bloodItem,deadBool = self.context.tenCountryProxy:getBloodItem(self.context.bloodData,data)
			bloodItem:setPositionXY(-20,-53)
			heroRoundPortrait.heroName:setPositionY(heroRoundPortrait.heroName:getPositionY()+7)
			heroRoundPortrait.heroNameBG:setPositionY(heroRoundPortrait.heroNameBG:getPositionY()+7)
			heroRoundPortrait:addChild(bloodItem)
			if deadBool then
				heroRoundPortrait:removeEventListener(DisplayEvents.kTouchBegin, self.onTapBegin);
				heroRoundPortrait:removeEventListener(DisplayEvents.kTouchEnd, self.onTapEnd);
			end
		end
	end
	self:setIsPlayImg();
end

function PeibingPopupItem:onTapBegin(event, data)
  	self.beginX = event.globalPosition.x;
end
function PeibingPopupItem:onTapEnd(event, data)
	self.endX = event.globalPosition.x;
	if math.abs(self.beginX - self.endX) < 10 then
  		self.onCardTap(self.context,data);
	end;

end

function PeibingPopupItem:setIsPlayImg()
	for k,v in pairs(self.items) do
		if self.context:getIsPlayByGeneralID(v.data.GeneralId) then
			if not v.play_img or v.play_img and v.play_img.isDisposed then
				v.play_img = self.skeleton:getBoneTextureDisplay("selected_img");
				v.play_img:setPositionXY(21,22);
				v:addChild(v.play_img);
			end
			v.play_img:setVisible(true);
		else
			if v.play_img and not v.play_img.isDisposed then
				v.play_img:setVisible(false);
			end
		end
	end
end

function PeibingPopupItem:removeArmatureListener()
	self.armature.display:removeEventListener(DisplayEvents.kTouchBegin, self.onTapBegin);
	self.armature.display:removeEventListener(DisplayEvents.kTouchEnd, self.onTapEnd);
end