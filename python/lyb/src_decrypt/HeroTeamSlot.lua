require "core.controls.page.CommonSlot"

HeroTeamSlot=class(CommonSlot);

function HeroTeamSlot:ctor()
  self.class=HeroTeamSlot;
  self.beginX = 0;
  self.endX = 0;
end

function HeroTeamSlot:dispose()
	-- log("----------------------HeroTeamSlot:dispose()")
	self:removeChildren()
	HeroTeamSlot.superclass.dispose(self);
end

function HeroTeamSlot:initialize(context, onCardTap, type)
	self:initLayer();
	self.context = context;
	self.onCardTap = onCardTap;
	self.type = type;
	self.items = {};
	local skeleton = getSkeletonByName("hero_team_ui");
	self.skeleton = skeleton;

	local line_1 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_horizon");
	line_1:setScale(0.7);
	line_1:setPositionXY(0,135);
	self:addChild(line_1);

	local line_2 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_horizon");
	line_2:setScale(0.7);
	line_2:setPositionXY(0,310);
	self:addChild(line_2);

	local line_3 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_vertical");
	line_3:setPositionXY(140,0);
	self:addChild(line_3);

	local line_4 = CommonSkeleton:getBoneTextureDisplay("commonImages/common_line_vertical");
	line_4:setPositionXY(300,0);
	self:addChild(line_4);
end

function HeroTeamSlot:onTapBegin(event, data)
  	self.beginX = event.globalPosition.x;
end
function HeroTeamSlot:onTapEnd(event, data)
	self.endX = event.globalPosition.x;
	if math.abs(self.beginX - self.endX) < 10 then
  		self.onCardTap(self.context,data);
	end;

end

-- 设置slot的数据(子类重写该方法)
function HeroTeamSlot:setSlotData(id)
	self.id = id;
	for k,v in pairs(self.items) do
		self:removeChild(v);
	end
	self.items = {};
	for i =1,9 do
		local data;
		if 3 == self.type then
			data = self.context.datas[i+9*(-1+self.id)];
		elseif 2 == self.type then
			data = self.context.datas_yongbing[i+9*(-1+self.id)];
		else
			data = self.context.datas[i+9*(-1+self.id)];
		end
		if not data then
			break;
		end
		local num = 0
		if self.context.notificationData and self.context.notificationData.funcType == "TenCountry" then
			num = 16
		end
		local heroRoundPortrait = HeroRoundPortrait.new();
		heroRoundPortrait:initialize(data,true);
		heroRoundPortrait:setPositionXY(3+(-1+i)%3*160,350-175*math.floor((-1+i)/3)+num);
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

		end
	end
	self:setIsPlayImg();
end

function HeroTeamSlot:setIsPlayImg()

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

function HeroTeamSlot:removeArmatureListener()
	self.armature.display:removeEventListener(DisplayEvents.kTouchBegin, self.onTapBegin);
	self.armature.display:removeEventListener(DisplayEvents.kTouchEnd, self.onTapEnd);
end