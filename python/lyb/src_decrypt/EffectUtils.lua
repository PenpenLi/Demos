--=====================================================
-- 名称：     为各种特效预留的类
-- @authors： 赵新
-- @mail：    xianxin.zhao@happyelements.com
-- @website： http://www.cnblogs.com/tinytiny/
-- @date：    1014-03-18 17:01:37
-- @descrip： 为各种特效预留的类
-- All Rights Reserved. 
--=====================================================
EffectUtils = {};

--  震动屏幕 
--  obj 要震动的对象
function EffectUtils:shakeScreen()
	if EffectUtils.shakeIng then return; end;
	EffectUtils.shakeIng = true;
	local size = {x = 0, y = 0};
	local left1 = CCMoveTo:create(0.04, ccp(size.x + 10, size.y));
	local right1 = CCMoveTo:create(0.04, ccp(size.x - 10, size.y));
	local top1 = CCMoveTo:create(0.04, ccp(size.x, size.y + 15));
	local rom1 = CCMoveTo:create(0.04, ccp(size.x, size.y - 15));
	local rom2 = CCMoveTo:create(0.04, ccp(size.x, size.y));
	local array = CCArray:createWithCapacity(8);
	local seq;
	array:addObject(left1);
	array:addObject(right1);
	array:addObject(top1);
	array:addObject(rom1);
	array:addObject(left1);
	array:addObject(right1);
	array:addObject(top1);
	array:addObject(rom2);
	local function callBack()
		EffectUtils.shakeIng = nil;
	end
	seq = CCSequence:createWithTwoActions(CCSequence:create(array), CCCallFunc:create(callBack));
	Director:getRunningScene():runAction(seq);
end

--  震动对象
--  obj 要震动的对象
function EffectUtils:shakeObj(obj)
	if EffectUtils.shakeIng then return; end;
	EffectUtils.shakeIng = true;
	local size = obj:getPosition();
	local left1 = CCMoveTo:create(0.04, ccp(size.x + 10, size.y));
	local right1 = CCMoveTo:create(0.04, ccp(size.x - 10, size.y));
	local top1 = CCMoveTo:create(0.04, ccp(size.x, size.y + 15));
	local rom1 = CCMoveTo:create(0.04, ccp(size.x, size.y - 15));
	local rom2 = CCMoveTo:create(0.04, ccp(size.x, size.y));
	local array = CCArray:createWithCapacity(8);
	local seq;
	array:addObject(left1);
	array:addObject(right1);
	array:addObject(left1);
	array:addObject(right1);
	array:addObject(left1);
	array:addObject(right1);
	array:addObject(right1);
	array:addObject(rom2);
	local function callBack()
		EffectUtils.shakeIng = nil;
	end
	seq = CCSequence:createWithTwoActions(CCSequence:create(array), CCCallFunc:create(callBack));
	obj:runAction(seq);
end

-- --云层飘动
-- function EffectUtils:startCloudEffect(con,con2)
-- 	local tCloudBehind1 = TextureManager:getImage("cloud.pvr.ccz");
-- 	tCloudBehind1:setAnchorPointXY(0, 1);
-- 	tCloudBehind1:setScale(0.5);
-- 	tCloudBehind1:setPositionX(0);
-- 	tCloudBehind1:setPositionY(0);
-- 	con:addChild(tCloudBehind1);

-- 	local tCloudBehind2 = TextureManager:getImage("cloud.pvr.ccz");
-- 	tCloudBehind2:setAnchorPointXY(0, 1);
-- 	tCloudBehind2:setScale(0.5);
-- 	tCloudBehind2:setPositionX(800);
-- 	tCloudBehind2:setPositionY(120);
-- 	con:addChild(tCloudBehind2);

-- 	local tCloudBehind3 = TextureManager:getImage("cloud.pvr.ccz");
-- 	tCloudBehind3:setAnchorPointXY(0, 1);
-- 	tCloudBehind3:setScale(0.5);
-- 	tCloudBehind3:setPositionX(0);
-- 	tCloudBehind3:setPositionY(240);
-- 	con:addChild(tCloudBehind3);

-- 	local tCloudBehind4 = TextureManager:getImage("cloud.pvr.ccz");
-- 	tCloudBehind4:setAnchorPointXY(0, 1);
-- 	tCloudBehind4:setScale(0.5);
-- 	tCloudBehind4:setPositionX(1000);
-- 	tCloudBehind4:setPositionY(420);
-- 	con:addChild(tCloudBehind4);

-- 	local tCloudBehind5 = TextureManager:getImage("cloud.pvr.ccz");
-- 	tCloudBehind5:setAnchorPointXY(0, 1);
-- 	tCloudBehind5:setScale(0.5);
-- 	tCloudBehind5:setPositionX(200);
-- 	tCloudBehind5:setPositionY(540);
-- 	con:addChild(tCloudBehind5);

-- 	con:setPositionY(-550);
	
-- 	if con2 then
-- 		local tCloudFront = TextureManager:getImage("cloud.pvr.ccz");
-- 		tCloudFront:setAnchorPointXY(0, 1);
-- 		tCloudFront:setScale(1.5);
-- 		con2:addChild(tCloudFront);

-- 		local tCloudFront2 = TextureManager:getImage("cloud.pvr.ccz");
-- 		tCloudFront2:setAnchorPointXY(0, 1);
-- 		tCloudFront2:setScale(1.5);
-- 		tCloudFront2:setPositionX(1000);
-- 		con2:addChild(tCloudFront2);

-- 		con2:setPositionY(-500);
-- 	end;


-- 	local function repeatFunc()
-- 		if con:getPositionX() >= kWinSize.width then
-- 			con:setPositionX(-813);
-- 		else
-- 			con:setPositionX(con:getPositionX() + 2);
-- 		end

-- 		if con2 then
-- 			if con2:getPositionX() >= kWinSize.width then
-- 				con2:setPositionX(-1513);
-- 			else
-- 				con2:setPositionX(con2:getPositionX() + 5);
-- 			end
-- 		end;
-- 	end
-- 	Tweenlite:repeatCall(con, 0.04, repeatFunc)
-- end;

-- --停止云层飘动
-- function EffectUtils:stopCloudEffect()
-- 	Tweenlite:cancelRepeatCall();
-- end

-- function EffectUtils:loopStarRun(obj, isLoop)
-- 	local isLoop = isLoop or 0;
-- 	local function starPlay()
-- 		local function starCallBack()
-- 			local starActions = CCArray:create();
-- 			starActions:addObject(CCFadeTo:create(1, 0));
-- 			starActions:addObject(CCRotateTo:create(0.5, 360));
-- 			local move = CCScaleTo:create(1, 0.1,0.1);
-- 			starActions:addObject(CCEaseSineOut:create(move));
-- 			local seq = nil;
-- 			if isLoop > 0 then
-- 				seq = CCSequence:createWithTwoActions(CCSpawn:create(starActions), CCCallFunc:create(starPlay));
-- 			else
-- 				seq = CCSpawn:create(starActions);
-- 			end
-- 			obj:runAction(seq);
-- 		end

-- 		local starActions = CCArray:create();
-- 		starActions:addObject(CCFadeTo:create(0.4, 255));
-- 		starActions:addObject(CCRotateTo:create(0.4, 180));
-- 		local move = CCScaleTo:create(0.4, 1.5,1.5);
-- 		starActions:addObject(CCEaseSineOut:create(move));
-- 		local seq = CCSequence:createWithTwoActions(CCSpawn:create(starActions), CCCallFunc:create(starCallBack));
-- 		obj:runAction(seq);
-- 	end
-- 	starPlay();
-- end

-- --获得奖励特效
-- function EffectUtils:getRewardEffect(winItemsUi,back)
-- 	-- if self.hasBag then return; end;
-- 	self.hasBag = true;
-- 	--初始化数据
-- 	local list = winItemsUi.list;
-- 	local con = list:getParent();
-- 	local tempY = kVisibleSize.height - ( - con:getPositionY() + (kVisibleSize.height - kSceneUISize.height)/2);
-- 	local render = list.tableViewRenderer;
-- 	local iconCellTb = render.items;
-- 	local uiBuilder = NewTdLayoutBuilder:getCommonBuilder();
-- 	local runningScene = Director.sharedDirector():getRunningScene();
-- 	self.itemTb = {};

-- 	local bagImg = TextureManager:getImage("icon_inventory.pvr.ccz");
-- 	runningScene:addChild(bagImg);
-- 	local tarX = kVisibleSize.width - 70;
-- 	local tarY = (kVisibleSize.height - kSceneUISize.height)/2 + 150;
-- 	bagImg:setPositionXY(tarX ,tarY);


-- 	for i = 1,#winItemsUi.items do
-- 		local num1,num3 = math.modf(i/4);
-- 		local num2 = i%4;
-- 		if num2 == 0 then num2 = 4; end;
-- 		local itemData = winItemsUi.items[i];
-- 		local iconCell = iconCellTb[num2].itemContainer.display;
-- 		local itemDisplay = assert(uiBuilder:build("CommonUIGroups/icon_container"));
-- 		local iconContainer = IconContainer:create(itemDisplay);
-- 		table.insert(self.itemTb, iconContainer)
-- 		--计算item所在全局范围坐标
-- 		-- local objSize = obj:getGroupBounds().size;
-- 		local objPos = iconCell:convertToWorldSpace(ccp(iconCell:getPositionX(),iconCell:getPositionY()));
-- 		iconContainer:setPositionXY(objPos.x, tempY);
-- 		--装备图标
-- 		local idType, picId, name, quality = ItemDataModel:getShowInfoById(itemData.id or itemData[1]);
		
-- 		iconContainer:addIcon(picId,idType == IdType.RuneId);
-- 		iconContainer:setQuality(quality);
-- 		-- Tweenlite:rotateForever(iconContainer.display,0.8,true)
-- 		--加到当前场景中
-- 		runningScene:addChild(iconContainer.display);
		
-- 		local function delayCall()
-- 			local function callBack3()
-- 				runningScene:removeChild(bagImg);
-- 				self.isPlay = false;
-- 				self.hasBag = false;
-- 				if back then
-- 					back();
-- 				end;
-- 			end;
-- 			local function callBack2()
-- 				Tweenlite:to(bagImg,0.3,0,-30,0,callBack3,true)
-- 			end;
-- 			local function callBack()
-- 				-- if not self.isPlay then
-- 					Tweenlite:easeOut(bagImg,1,0,-20,255,callBack2,true)
-- 					self.isPlay = true;
-- 				-- end;
-- 				-- Tweenlite:blink(bagImg, 0.5, 5);
-- 				runningScene:removeChild(iconContainer.display);
-- 			end;
-- 			Tweenlite:bezier(iconContainer.display,1,tarX - 15,tarY,0,callBack)
-- 			Tweenlite:scale(iconContainer.display, 1, 0.5, 0.5, 255, nil)
-- 			-- Tweenlite:to(iconContainer.icon,1,0,0,0,nil,true);
-- 			bagImg:setOpacity(0);
-- 			bagImg:setPositionY(bagImg:getPositionY() - 30);
-- 			Tweenlite:to(bagImg,0.3,0,30,255,nil,true);
-- 		end;
-- 		Tweenlite:delayCall(iconContainer.display,num1*0.2,delayCall);
-- 	end;

-- 	--playCartoon播放动画
-- end;

--  -- 通过传入的item和x，y播放飘到背包的特效 
--  -- itemId 道具id
--  -- x 道具x
--  -- y 道具y
-- function EffectUtils:getRewardToBackpack(itemId,render,start,back)
-- 	self.hasBag = true;
-- 	local con = render.display:getParent();
-- 	local tempY = kVisibleSize.height - ( - con:getPositionY() + (kVisibleSize.height - kSceneUISize.height)/2);
-- 	local uiBuilder = NewTdLayoutBuilder:getCommonBuilder();
-- 	local runningScene = Director.sharedDirector():getRunningScene();

-- 	local bagImg = TextureManager:getImage("icon_inventory.pvr.ccz");
-- 	runningScene:addChild(bagImg);

-- 	bagImg:setVisible(start);	

-- 	local tarX = kVisibleSize.width - 70;
-- 	local tarY = (kVisibleSize.height - kSceneUISize.height)/2 + 150;
-- 	bagImg:setPositionXY(tarX ,tarY);
-- 	local itemDisplay = assert(uiBuilder:build("CommonUIGroups/icon_container"));
-- 	local iconContainer = IconContainer:create(itemDisplay);
-- 	local objPos = render.display:getParent():convertToWorldSpace(ccp(render.display:getPositionX(),render.display:getPositionY()));

-- 	iconContainer:setPositionXY(objPos.x, objPos.y);
-- 	--装备图标
-- 	local idType, picId, name, quality = ItemDataModel:getShowInfoById(itemId);
-- 	iconContainer:addIcon(picId,idType == IdType.RuneId);
-- 	iconContainer:setQuality(quality);
-- 	runningScene:addChild(iconContainer.display);
-- 	local function callBack3()
-- 		runningScene:removeChild(bagImg);
-- 		self.isPlay = false;
-- 		self.hasBag = false;
-- 		if back then
-- 			back();
-- 		end;
-- 	end;
-- 	local function callBack2()
-- 		Tweenlite:to(bagImg,0.3,0,-30,0,callBack3,true)
-- 	end;
-- 	local function callBack()
-- 			Tweenlite:easeOut(bagImg,1,0,-20,255,callBack2,true)
-- 			self.isPlay = true;
-- 		runningScene:removeChild(iconContainer.display);
-- 	end;
-- 	Tweenlite:bezier(iconContainer.display,1,tarX - 15,tarY,0,callBack)
-- 	Tweenlite:scale(iconContainer.display, 1, 0.5, 0.5, 255, nil)
-- 	bagImg:setOpacity(0);
-- 	bagImg:setPositionY(bagImg:getPositionY() - 30);
-- 	Tweenlite:to(bagImg,0.3,0,30,255,nil,true);
-- end

-- --从天而降金币特效
-- function EffectUtils:playDropGold(back)
-- 	local runningScene = Director.sharedDirector():getRunningScene();
-- 	self.itemTb = {};
-- 	for i = 1,209 do
-- 		local temp1,temp2 = math.modf(i/19);
-- 		temp2 = i%19;
-- 		local goldImg = TextureManager:getImage("zhengshou_gold.pvr.ccz");		
-- 		runningScene:addChild(goldImg);
-- 		table.insert(self.itemTb, goldImg);
-- 		if i%2 == 0 then
-- 			goldImg:setPositionXY(80*(temp2 - 1) + 10 + math.random() *20 - 50,temp1 * 35 + kVisibleSize.height + 20 - math.random()*20);
-- 		else
-- 			if temp2 == 10 then
-- 				goldImg:setPositionXY(80*(temp2 - 1) + 10 + math.random() *20,temp1 * 35 + kVisibleSize.height + 40 - math.random()*40);
-- 			else
-- 				goldImg:setPositionXY(80*(temp2 - 1) + 10 + math.random() *20,temp1 * 35 + kVisibleSize.height + 20 - math.random()*20);
-- 			end;
-- 		end;
-- 		-- goldImg:setScale(math.random(8,10)*0.1);
-- 		local function callBack2()
-- 			if runningScene:contains(goldImg) then
-- 				runningScene:removeChild(goldImg);
-- 			end;
-- 		end;
-- 		local function callBack4()
-- 			Tweenlite:to(goldImg,0.2,0,0,0,callBack2,true);
-- 		end;
-- 		local function callBack()
-- 			Tweenlite:delayCall(goldImg, 1, nil);
-- 		end;
-- 		Tweenlite:bounceOut(goldImg,math.random()*1 + temp1 * 0.1,0,-kVisibleSize.height,255,callBack,true);
-- 	end;
-- 	local function callBack3()
-- 		for i = 1,#self.itemTb do
-- 			local disImg = self.itemTb[i];
-- 			local function callBackDis()
-- 				if runningScene:contains(disImg) then
-- 					runningScene:removeChild(disImg);
-- 				end;
-- 			end;
-- 			Tweenlite:to(disImg,0.2,0,0,0,callBackDis,true);
-- 		end;
-- 		if back then
-- 			back();
-- 		end;
-- 	end;
-- 	Tweenlite:delayCall(runningScene, 1.7, callBack3);
-- end

-- --数字滚动特效
-- function EffectUtils:playNumEffect(numTF,numValue,back)
-- 	local num = numValue;
-- 	local len = #numValue;
-- 	numTF:setString("");
-- 	local numTB = {};
-- 	local curTB = {};
-- 	for i = 1,len do
-- 		numTB[i] = tonumber(string.sub(num, i, -(len - (i - 1))));
-- 		curTB[i] = tonumber(string.sub(num, i, -(len - (i - 1))));
-- 	end;
	
-- 	local time = 0;
-- 	local function callBack()
-- 		time = time + 1;
-- 		if time == 11 then 
-- 			if back then back(); end;
-- 			return;
-- 		end;
-- 		local curNum = "";
-- 		Tweenlite:delayCall(numTF, 0.03, callBack)
-- 		for i = 1,len do
-- 			if curTB[i] == 9 then
-- 				curTB[i] = 0;
-- 			else
-- 				curTB[i] = curTB[i] + 1;
-- 			end;
-- 			curNum = curNum .. curTB[i];
-- 		end;
-- 		numTF:setString(""..curNum);
-- 	end;
-- 	callBack();
-- end;

-- --数字滚动特效2
-- function EffectUtils:playNumEffect2(numTF,numValue,back)
-- 	local num = numValue;
-- 	local len = #numValue;
-- 	numTF:setString("");
-- 	local numTB = {};
-- 	local curTB = {};
-- 	for i = 1,len do
-- 		numTB[i] = tonumber(string.sub(num, i, -(len - (i - 1))));
-- 		if (len - i) <= 4 then
-- 			curTB[i] = math.random(0, 9);
-- 		else
-- 			curTB[i] = 0;
-- 		end;
-- 	end;
	
-- 	local time = 4;
-- 	local function callBack()
-- 		if time < 1 or len < 4 then
-- 			numTF:setString(""..num);
-- 			if back then back(); end;
-- 			return ; 
-- 		end;
-- 		local curNum = "";
-- 		if curTB[time] >= numTB[time] then
-- 			time = time - 1;
-- 		end;
-- 		for i = 1,len do
-- 			if i >= time then
-- 				if curTB[i] == 9 then
-- 					curTB[i] = 0;
-- 				else
-- 					curTB[i] = curTB[i] + 1;
-- 				end;
-- 				curNum = curNum .. curTB[i];
-- 			end;
-- 		end;
-- 		numTF:setString(""..curNum);
-- 		Tweenlite:delayCall(numTF, 0.005, callBack)
-- 	end;
-- 	callBack();
-- end;

-- --数字滚动特效3
-- function EffectUtils:playNumEffect3(numTF,numValue,back)
-- 	local num = numValue;
-- 	local len = #numValue;
-- 	numTF:setString("");
-- 	local numTB = {};
-- 	local curTB = {};
-- 	for i = 1,len do
-- 		numTB[i] = tonumber(string.sub(num, i, -(len - (i - 1))));
-- 		curTB[i] = 0;
-- 	end;
	
-- 	local time = 1;
-- 	local function callBack()
-- 		if time > len then 
-- 			if back then back(); end;
-- 			return ; 
-- 		end;
-- 		local curNum = "";
-- 		if curTB[time] < numTB[time] then
-- 			curTB[time] = curTB[time] + 1;
-- 		else
-- 			time = time + 1;
-- 		end;
-- 		for i = 1,len do
-- 			if i <= time then
-- 				curNum = curNum .. curTB[i];
-- 			end;
-- 		end;
-- 		numTF:setString(""..curNum);
-- 		Tweenlite:delayCall(numTF, 0.01, callBack)
-- 	end;
-- 	callBack();
-- end;

-- --战力特效1
-- function EffectUtils:zhanLiEffect(zhanLiNum,changeNum,nameStr)
-- 	--cal

-- 	-- local zhanLiNum = 389122;
-- 	-- local changeNum = 35;
-- 	-- local nameStr = "n-lingjiugongzhu.pvr.ccz";

-- 	--cartoon

-- 	local runningScene = Director.sharedDirector():getRunningScene();
-- 	if self.con then
-- 		runningScene:removeChild(self.con);
-- 		self.con = nil;
-- 	end;

-- 	self.con = CocosObject:create();
-- 	self.con.touchEnabled = false;
-- 	self.con.touchChildren = false;
-- 	runningScene:addChild(self.con);
-- 	self.con:setPositionXY(kVisibleSize.width/2 + kVisibleSize.width, kVisibleSize.height/2 - 190);
-- 	local zhanLiBg = TextureManager:getImage("zhanLiBg.pvr.ccz");
-- 	self.con:addChild(zhanLiBg);

-- 	local zhanLiDesc = BitmapText:create("战力:", getFontFnt(1));
-- 	self.con:addChild(zhanLiDesc);
-- 	zhanLiDesc:setPositionXY(13 - 110,-7);

-- 	local zhanLi = BitmapText:create("", getFontFnt(1));
-- 	self.con:addChild(zhanLi);
-- 	zhanLi:setPositionXY(13 - 20,-7);

-- 	local changeStr = "";
-- 	if changeNum > 0 then
-- 		changeStr = "(+"..changeNum..")";
-- 	else
-- 		changeStr = "(-"..changeNum..")";
-- 	end;

-- 	local zhanLiChange = BitmapText:create(changeStr, getFontFnt(1),nil,kCCTextAlignmentLeft);
-- 	zhanLiChange:setAnchorPoint(ccp(0,0.5));
-- 	self.con:addChild(zhanLiChange);
-- 	zhanLiChange:setPositionXY(13 + 40,-7);
-- 	zhanLiChange:setOpacity(0);

-- 	local name = TextureManager:getImage(nameStr);
-- 	self.con:addChild(name);
-- 	name:setPositionY(35);

-- 	local function callBack5()
-- 		self.con:removeChild(zhanLiBg);
-- 		self.con:removeChild(zhanLiDesc);
-- 		self.con:removeChild(zhanLi);
-- 		self.con:removeChild(zhanLiChange);
-- 		self.con:removeChild(name);
-- 		runningScene:removeChild(self.con);
-- 	end;

-- 	local function callBack4()
-- 		-- Tweenlite:to(self.con, 0.5, 0, 300, 0, callBack3, true);
-- 		Tweenlite:to(zhanLiBg, 0.5, -800, 0, 0, callBack5, true);
-- 		Tweenlite:to(zhanLi, 0.5, -800, 0, 0, nil, true);
-- 		Tweenlite:to(zhanLiDesc, 0.5, -800, 0, 0, nil, true);
-- 		Tweenlite:to(zhanLiChange, 0.5, -800, 0, 0, nil, true);
-- 		Tweenlite:to(name, 0.5, -800, 0, 0, nil, true);
-- 	end;

-- 	local function callBack3()
-- 		Tweenlite:to(zhanLiChange, 0.5, 0, 0, 255, nil, true);
-- 		Tweenlite:delayCall(zhanLiChange, 0.5, callBack4);
-- 	end;
-- 	local function callBack2()
-- 		if #(""..zhanLiNum) < 4 then
-- 			EffectUtils:playNumEffect(zhanLi,""..zhanLiNum,callBack3);
-- 		else
-- 			EffectUtils:playNumEffect2(zhanLi,""..zhanLiNum,callBack3);
-- 		end;
-- 	end;

-- 	local function callBack1()
-- 		Tweenlite:to(self.con, 0.6 ,-70, 0, 255, nil, true);
-- 		callBack2();
-- 	end;
-- 	Tweenlite:to(self.con, 0.1, -kVisibleSize.width + 105, 0, 255, callBack1, true);
-- end;

-- --战力特效2
-- function EffectUtils:zhanLiEffect2()
-- 	--cal

-- 	-- local zhanLiNum = 389122;
-- 	-- local changeNum = 35;
-- 	-- local nameStr = "n-lingjiugongzhu.pvr.ccz";

-- 	--cartoon

-- 	local runningScene = Director.sharedDirector():getRunningScene();
-- 	if self.con then
-- 		runningScene:removeChild(self.con);
-- 		self.con = nil;
-- 	end;

-- 	self.con = CocosObject:create();
-- 	self.con.touchEnabled = false;
-- 	self.con.touchChildren = false;
-- 	runningScene:addChild(self.con);
-- 	self.con:setPositionXY(kVisibleSize.width/2 + kVisibleSize.width, kVisibleSize.height/2 - 190);
-- 	local zhanLiBg = TextureManager:getImage("zhanLiImg2.pvr.ccz");
-- 	self.con:addChild(zhanLiBg);

-- 	local function callBack5()
-- 		self.con:removeChild(zhanLiBg);
-- 		runningScene:removeChild(self.con);
-- 	end;

-- 	local function callBack4()
-- 		Tweenlite:to(zhanLiBg, 0.5, -800, 0, 0, callBack5, true);
-- 	end;

-- 	local function callBack1()
-- 		Tweenlite:to(self.con, 0.6 ,-70, 0, 255, callBack4, true);
-- 	end;
-- 	Tweenlite:to(self.con, 0.1, -kVisibleSize.width + 105, 0, 255, callBack1, true);
-- end;