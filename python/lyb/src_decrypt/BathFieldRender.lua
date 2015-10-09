
BathFieldRender=class(Layer);

function BathFieldRender:ctor()
	self.class=BathFieldRender;
	
end

function BathFieldRender:dispose()
	self.roleDO:stopAction(self.repeatAction);
	self.repeatAction = nil;
	self.armature:dispose();
	self:removeAllEventListeners();
	self:removeChildren();
	BathFieldRender.superclass.dispose(self);
end

function BathFieldRender:initialize(skeleton,playerInfo,isPlayerSelf)
	self:initLayer();
	
	local armature=skeleton:buildArmature("render_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	local armature_d=armature.display;
	self:addChild(armature_d);
	self.armature_d = armature_d;
	
	local textData = copyTable(armature:getBone("render").textData);
	-- local pos = armature:getBone("render_1"):getDisplay():getPosition();
	armature_d:removeChild(armature:getBone("render"):getDisplay());
	
	local renderTypeStr;
	if GameConfig.PLAYER_CARRER_1 == playerInfo.Career or GameConfig.PLAYER_CARRER_3 == playerInfo.Career then
		renderTypeStr = "male_";
	else
		renderTypeStr = "female_";
	end
	
	---------据说Lua的随机数前几个比较有问题----------
	math.randomseed(tostring(os.time()):reverse():sub(1, 6));
	math.random();
	math.random();
	math.random();
	--------------------------------------------------
	
	local modelID = math.random(4);
	local roleDO = armature:getBone(renderTypeStr..modelID):getDisplay();
	for i = 1,4 do
		if armature:getBone("male_"..i):getDisplay() and roleDO ~= armature:getBone("male_"..i):getDisplay() then
			armature_d:removeChild(armature:getBone("male_"..i):getDisplay());
		end		
		if armature:getBone("female_"..i):getDisplay() and roleDO ~= armature:getBone("female_"..i):getDisplay() then
			armature_d:removeChild(armature:getBone("female_"..i):getDisplay());
		end
	end
	
	local nameText = createTextFieldWithTextData(textData,"Lv"..playerInfo.Level.." "..playerInfo.UserName,true);
	if isPlayerSelf then
		nameText:setColor(CommonUtils:ccc3FromUInt(GameConfig.MY_NAME_COLOR));
	else
		nameText:setColor(CommonUtils:ccc3FromUInt(GameConfig.OTHER_NAME_COLOR));
	end
	nameText:setPositionXY(roleDO:getGroupBounds().size.width/2 - nameText:getGroupBounds().size.width/2, nameText:getGroupBounds().size.height);	
	-- print(nameText:getPosition().x, nameText:getPosition().y)
	self.armature_d:addChild(nameText);
	local x,y = self.armature_d:getPositionX(),self.armature_d:getPositionY();
	local moveTo = CCMoveTo:create(1,ccp(x,y-5));
	local backTo = CCMoveTo:create(1,ccp(x,y));
	local ccArray = CCArray:create();
	ccArray:addObject(moveTo);
	ccArray:addObject(backTo);
	-- ccArray:addObject(CCNull);
	self.repeatAction = CCRepeatForever:create(CCSequence:create(ccArray));
	roleDO:runAction(self.repeatAction);
	self.roleDO = roleDO;
end
