require "main.view.huoDong.ui.render.VIPWelfareText"
require "main.view.huoDong.ui.render.huodongComRender"
VIPWelfare = class(TouchLayer);

function VIPWelfare:ctor(  )
	self.class = VIPWelfare;
	self.VIPWelfareText = VIPWelfareText;
	self.text = {};
end

function VIPWelfare:dispose(  )
	self:removeChildren();
	self:removeAllEventListeners();
	VIPWelfare.superclass.dispose(self);
end

function VIPWelfare:initialize( context, id )
	self.context = context;
	self.skeleton = context.skeleton;
	self.id = id;
	self.huodongProxy = context.huodongProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.userProxy = context.userProxy;


	self:initLayer();

	local armature = self.skeleton:buildArmature("Vipwelfare_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local armature_d = armature.display;
	self.armature_d =armature_d;
	self:addChild(self.armature_d);
	self:initScrollView();
	self:initText();
	self:initVIP()
end

function VIPWelfare:initVIP(  )
	local currentVIP = self.userProxy:getVipLevel();
	local vip = self.armature_d:getChildByName("vip");
	local vip_pos = convertBone2LB(vip);
	self.armature_d:removeChild(vip);
	vip = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip_normal");
	vip:setScale(0.8);
	vip:setPosition(vip_pos);
	self.armature_d:addChild(vip);

	local vipNum1 = self.armature_d:getChildByName("vipNum1");
	local vipNum1_pos = convertBone2LB(vipNum1);
	self.armature_d:removeChild(vipNum1);
	print("currentVIP = ", currentVIP)
	if currentVIP > 10 then
		local num1 = math.floor(currentVIP / 10 );
		vipNum1 = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_vip"..num1);
		print("vipNum1 = ", vipNum1,"commonNumbers/common_vip"..num1)
		vipNum1:setScale(0.8);
		vipNum1:setPosition(vipNum1_pos);
		self.armature_d:addChild(vipNum1);
	end

	num2 = math.mod(currentVIP, 10);
	local vipNum2 = self.armature_d:getChildByName("vipNum2");
	local vipNum2_pos = convertBone2LB(vipNum2);
	self.armature_d:removeChild(vipNum2);
	vipNum2 = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_vip"..num2);
	vipNum2:setScale(0.8);
	vipNum2:setPosition(vipNum2_pos);
	self.armature_d:addChild(vipNum2);

	local progressBar = self.armature:findChildArmature("progressBar");
  	self.progressBar = ProgressBar.new(progressBar, "pro_up");
end

function VIPWelfare:updateProgress(  )

	if self.userProxy.vipLevel >= self.userProxy.vipLevelMax then
		self.progressBar:setProgress(0);
		self.text[10]:setVisible(true);
		for i=1,9 do
			self.text[i]:setVisible(false);
		end
		self.armature_d:getChildByName("gold"):setVisible(false);
	else
		local CurrentVipLevel = analysis("Huiyuan_Huiyuandengji", self.userProxy.vipLevel);
		local NextVipLevel = analysis("Huiyuan_Huiyuandengji", self.userProxy.vipLevel + 1);
		print(" vip dian ", CurrentVipLevel.min, CurrentVipLevel.max, NextVipLevel.min, NextVipLevel.max)
		local ToNextLevelNeedGold;
		local IsChargeGold;
		local remainChargeGold;
		if CurrentVipLevel.min == nil then
			ToNextLevelNeedGold = NextVipLevel.min;
			IsChargeGold = self.userProxy.vip;
			remainChargeGold = NextVipLevel.min;
		else
			ToNextLevelNeedGold = NextVipLevel.min - CurrentVipLevel.min;
			IsChargeGold = self.userProxy.vip - CurrentVipLevel.min;
			remainChargeGold = CurrentVipLevel.max - self.userProxy.vip
		end
		print(" is IsChargeGold = ", IsChargeGold, ToNextLevelNeedGold, IsChargeGold / ToNextLevelNeedGold);
		self.progressBar:setProgress(IsChargeGold / ToNextLevelNeedGold);
		self.text[2]:setString(tostring(remainChargeGold));
		self.text[4]:setString("VIP"..tostring(self.userProxy.vipLevel + 1));
	end
end

function VIPWelfare:initText(  )
	for i=1,10 do
		local textData = self.armature:getBone("text"..i).textData;
		local text = createTextFieldWithTextData(textData, self.VIPWelfareText[i]);
		self:addChild(text);
		self.text[i] = text;
	end
	for i=5,10 do
		self.text[i]:setVisible(false);
	end
	
end

function VIPWelfare:initScrollView(  )
	if self.listScrollView == nil then
		self.listScrollView = ListScrollViewLayer.new();
		self.listScrollView:initLayer();
		local render = self.armature_d:getChildByName("render");
		local render_pos = convertBone2LB(render);
		local render_width = render:getGroupBounds().size.width;
		local render_height = render:getGroupBounds().size.height;
		self.armature_d:removeChild(render);
		print("render_width = ",render_width, render_height)
		self.listScrollView:setItemSize(makeSize(852, 120));
		self.listScrollView:setViewSize(makeSize(852, 475));
		self.listScrollView:setPositionX(render_pos.x);
		self.armature_d:addChild(self.listScrollView);
	end
end

function VIPWelfare:refreshData()
	print("function VIPWelfare:refreshData()");

	self:updateProgress();

	print("end self:updateProgress();")
	self.data = self.huodongProxy:getHuodongDataByID(self.id);
	if #self.data ~= 1 then

		-- 刷新数据
		if self.listScrollView ~= nil then
			self.listScrollView:removeAllItems();
		else
			return;
		end
		self.data2 = self.huodongProxy:getHuodongDataByID(self.id)
		table.sort(self.data2, function(a,b) 
				if a.BooleanValue ==  b.BooleanValue then 
					return a.MaxCount < b.MaxCount
				end
				return  a.BooleanValue < b.BooleanValue  end);
		-- print("---------------------------refreshData------");
		-- -- for k,v in pairs(self.data2) do
		-- -- 	print(k,v.Param1);
		-- -- end
		for k,v in pairs(self.data2) do
			local render = huodongComRender.new();
			render:initialize(self, v);
			self.listScrollView:addItem(render);
		end
	else
		--领取确认数据
		sharedTextAnimateReward():animateStartByString("领取成功");
		local index;
		for k,v in pairs(self.data2) do
			if v.ConditionID == self.data[1].ConditionID then
				index = k;
				v.BooleanValue = 1;
				break;
			end
		end
		self.listScrollView:removeItemAt(index - 1);
		local render = huodongComRender.new();
		render:initialize(self, self.data[1]);
		self.listScrollView:addItemAt(render, index - 1, true);

		self.context:refreshRenderDot(self.id, self.data2);
		self.context:refreshMainHuoDongReddot();

	end
end

function VIPWelfare:takeAward(conditionID)
  -- self.context.huodongProxy:takeAward(self.id, conditionID) 
end




