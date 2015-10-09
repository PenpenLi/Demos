require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";


local HeadRender = class();
function HeadRender:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("headRender");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self.heroHouseProxy = parent.heroHouseProxy;
	self:initUI();
end
function HeadRender:initUI()
	self.lvup = self.armature_d:getChildByName("lvup");
	self.headTmp = self.armature_d:getChildByName("headTmp");
	self.effectTmp = self.armature_d:getChildByName("effectTmp");
	self.effectXTmp = self.armature_d:getChildByName("effectXTmp");
	self.lvTF = generateText(self.armature_d,self.armature,"lvTF","");
	self.expTF = generateText(self.armature_d,self.armature,"expTF","");
	self.jdB = self.armature_d:getChildByName("jdB");
	self.jd = self.armature_d:getChildByName("jd");
	self.bgE = self.armature_d:getChildByName("bgE");
	self.progressUtil = GrowProgressUtil.new(self.jd);
	self.lvup:setVisible(false);
	self.expTF:setPositionY(self.expTF:getPositionY()+40)
	self.armature_d:setChildIndex(self.expTF,0);
end
function HeadRender:getUI()
	return self.armature_d;
end
function HeadRender:setExP(subGen,exp)
	self.addExp = exp and exp or 0;
	self.lvTF:setString(subGen.Level);
	if self.addExp > 0 then
		self.expTF:setString("EXP +"..self.addExp);
	end
	local nexp =subGen.Experience;
	if 1 == subGen.IsMainGeneral then
		local has = analysisHas("Zhujiao_Zhujiaoshengji",subGen.Level+1);
		self.texp = nexp+1;
		if has then
			self.texp = analysis("Zhujiao_Zhujiaoshengji",subGen.Level+1,"exp");
		end
		has = analysisHas("Zhujiao_Zhujiaoshengji",subGen.Level);
		self.uexp = 1;
		if has then
			self.uexp = analysis("Zhujiao_Zhujiaoshengji",subGen.Level,"exp");
		end
	else
		local has = analysisHas("Kapai_Kapaishengjijingyan",subGen.Level+1);
		self.texp = nexp+1;
		if has then
			self.texp = analysis("Kapai_Kapaishengjijingyan",subGen.Level+1,"exp");
		end
		has = analysisHas("Kapai_Kapaishengjijingyan",subGen.Level);
		self.uexp = 1;
		if has then
			self.uexp = analysis("Kapai_Kapaishengjijingyan",subGen.Level,"exp");
		end
	end
	
	local reate;
	if nexp<self.addExp then
		reate = (self.uexp+nexp-self.addExp)/self.uexp;
	else
		reate = (nexp-self.addExp)/self.texp;
	end
	local function cycleFunc()
		self.lvup:setVisible(true);
		self.lvup:setOpacity(0);
		Tweenlite:to(self.lvup,0.5,0,100,255,function ()
			self:playEffectXX();
		end,true);
	end
	self.progressUtil:init(reate,0.02,cycleFunc)
end
function HeadRender:growExp(subGen,exp)
	if not exp or exp == 0 or not self.texp then return end
	local rateE = subGen.Experience/self.texp;
	self.progressUtil:setRate(rateE);
	Tweenlite:to(self.expTF,0.3,0,-40,255,nil,true);
end
function HeadRender:setData(data,exp)
	self:setExP(data,exp);
	local personId;
	if 1 == data.IsMainGeneral then
		personId=analysis("Zhujiao_Zhujiaozhiye",data.ConfigId,"shenti");
	else
		self.bgE:setVisible(false);
		personId=analysis("Kapai_Kapaiku",data.ConfigId,"material_id");
	end
	local tempCCSprite = CCSprite:create();
    local tempSprite = Sprite.new(tempCCSprite);
	self.clipper = ClippingNode.new(tempSprite);
	self.clipper:setAlphaThreshold(0.0);
	self.clipper:setContentSize(makeSize(160,160));
	self.headTmp:addChild(self.clipper);
	self.person = getCompositeRole(personId);
	self.person:setPositionXY(80,-40);
	self.clipper:addChild(self.person);
end
function HeadRender:playEffect()
	local boneCartoon1 = BoneCartoon.new()
    local function callBack()
        self.effectTmp:removeChild(boneCartoon1)
    end
	boneCartoon1:create("1400",1,callBack);
	--boneCartoon1:setPositionXY(0,GameConfig.STAGE_HEIGHT)
   	self.effectTmp:addChild(boneCartoon1);
end
function HeadRender:playEffectXX()
	local boneCartoon1 = BoneCartoon.new()
    local function callBack()
        self.effectXTmp:removeChild(boneCartoon1)
        Tweenlite:to(self.lvup,0.3,0,0,0,nil,true);
    end
	boneCartoon1:create("1397",1,callBack);
	boneCartoon1:setScale(2);
   	self.effectXTmp:addChild(boneCartoon1);
end
function HeadRender:dispose()
	self.progressUtil:dispose();
	self.parent = nil;
	self.skeleton = nil;
	self.armature:dispose();
end


local ItemRender = class();
function ItemRender:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("itemRender");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self:initUI();
end
function ItemRender:initUI()
	self.start1 = self.armature_d:getChildByName("start1");
	self.start2 = self.armature_d:getChildByName("start2");
	self.start3 = self.armature_d:getChildByName("start3");
	self.start4 = self.armature_d:getChildByName("start4");
	self.start5 = self.armature_d:getChildByName("start5");
	self.start1:setVisible(false);
	self.start2:setVisible(false);
	self.start3:setVisible(false);
	self.start4:setVisible(false);
	self.start5:setVisible(false);
	self.starW = self.start1:getContentSize().width;
	--self.typeTF = generateText(self.armature_d,self.armature,"typeTF","");
	self.countTF = generateText(self.armature_d,self.armature,"countTF","");
	self.nameTF = generateText(self.armature_d,self.armature,"nameTF","");
	self.edge = self.armature_d:getChildByName("edge");
	self.img = self.armature_d:getChildByName("img");
	self.effectTmp = self.armature_d:getChildByName("effectTmp");
	--self.armature_d:setScale(0.8);
end
function ItemRender:getUI()
	return self.armature_d;
end
function ItemRender:getPszFileName(itemID_int)
  local pszFileID=analysis("Daoju_Daojubiao",itemID_int,"art");
  return artData[pszFileID].source;
end
function ItemRender:setData(data)
	local daojuPO = analysis("Daoju_Daojubiao",data.ItemId);
	--self.frame_bg=CommonSkeleton:getCommonBoneTextureDisplay("commonGrids/common_grid");
	--self.frame_edg=CommonSkeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_" .. daojuPO.color);
	--self.edge:addChild(self.frame_bg);
	--self.edge:addChild(self.frame_edg);

	
	self.itemImage = BagItem.new(); 
    self.itemImage:initialize({ItemId = tonumber(data.ItemId), Count = 1,ttlC = data.Count});
    self.itemImage:setBackgroundVisible(true)
    --self.itemImage:setPositionXY(10, self.item1Pos.y);
    self.itemImage.touchEnabled=true
    self.itemImage.touchChildren=true
	self.img:addChild(self.itemImage);
	self.nameTF:setString(daojuPO.name);
	local color = CommonUtils:ccc3FromUInt(getColorByQuality(daojuPO.color));
	self.nameTF:setColor(color);
	if tonumber(data.Count)>1 then
		self.countTF:setString("X"..data.Count);
	end


	--self.image = Image.new();
	--self.image:load(self:getPszFileName(data.ItemId));
	--self.img:addChild(self.image);
	
	-- if daojuPO.functionID==4 then
	-- 	local petVO = analysis("Kapai_Kapaiku",daojuPO.parameter1);
	-- 	local ofx = (5-petVO.star)*self.starW*0.5;
	-- 	for i=1,petVO.star do
	-- 		self["start"..i]:setVisible(true);
	-- 		self["start"..i].touchEnabled=false;
 --    		self["start"..i].touchChildren=false;
	-- 		self["start"..i]:setPositionX(self["start"..i]:getPositionX()+ofx);
	-- 	end
	-- end
end
function ItemRender:playEffectXX()
	local boneCartoon1 = BoneCartoon.new()
    local function callBack()
        self.effectTmp:removeChild(boneCartoon1)
    end
	boneCartoon1:create("1397",1,callBack);
   	self.effectTmp:addChild(boneCartoon1);
end
function ItemRender:dispose()
	self.img:removeChild(self.itemImage);
	self.parent = nil;
	self.skeleton = nil;
	self.armature:dispose();
end



local SLUIMngr = class();
function SLUIMngr:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("sl_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self.userProxy = parent.userProxy;
	self.heroHouseProxy = parent.heroHouseProxy;
	self:initUI();
	self.headArr = {};
	self.itemArr = {};
end
function SLUIMngr:initUI()
	self.effectTmp = self.armature_d:getChildByName("effectTmp");
	self.gnlTmp = self.armature_d:getChildByName("gnlTmp");
	self.itemTmp = self.armature_d:getChildByName("itemTmp");
	self.line = self.armature_d:getChildByName("line1"); 
	self.xingImg_1 = self.armature_d:getChildByName("xingImg_1");
	self.xingImg_1:setVisible(false);
	self.xingImg_2 = self.armature_d:getChildByName("xingImg_2");
	self.xingImg_2:setVisible(false);
	self.xingImg_3 = self.armature_d:getChildByName("xingImg_3");
	self.xingImg_3:setVisible(false);
	self.msgTF_1 = generateText(self.armature_d,self.armature,"msgTF_1","");
	self.msgTF_1:setVisible(false);
	self.msgTF_2 = generateText(self.armature_d,self.armature,"msgTF_2","");
	self.msgTF_2:setVisible(false);
	self.msgTF_3 = generateText(self.armature_d,self.armature,"msgTF_3","");
	self.msgTF_3:setVisible(false);
	self.star_1 = self.armature_d:getChildByName("Star_1");
	self.star_1:setVisible(false);
	self.star_b_1 = self.armature_d:getChildByName("Star_b_1");
	self.star_b_1:setVisible(false);
	self.star_2 = self.armature_d:getChildByName("Star_2");
	self.star_2:setVisible(false);
	self.star_b_2 = self.armature_d:getChildByName("Star_b_2");
	self.star_b_2:setVisible(false);
	self.star_3 = self.armature_d:getChildByName("Star_3");
	self.star_3:setVisible(false);
	self.star_b_3 = self.armature_d:getChildByName("Star_b_3");
	self.star_b_3:setVisible(false);
	self.zJJYBg = self.armature_d:getChildByName("zJJYBg");
	self.zJJYBg:setVisible(false);
	self.zJJYTF = generateText(self.armature_d,self.armature,"zJJYTF","");
	self.zJJYTF:setVisible(false);
	self.zJJYLP = self.armature_d:getChildByName("lvup");
	self.zJJYLP:setScale(0.5);
	self.zJJYLP:setVisible(false);

end
function SLUIMngr:configPos(posY)
	local dPosY = posY or 100;
	--self.effectTmp:setPositionY(self.effectTmp:getPositionY()+dPosY);
	self.gnlTmp:setPositionY(self.gnlTmp:getPositionY()+dPosY);
	self.itemTmp:setPositionY(self.itemTmp:getPositionY()+dPosY);
	self.line:setPositionY(self.line:getPositionY()+dPosY);
	self.xingImg_1:setPositionY(self.xingImg_1:getPositionY()+dPosY);
	self.xingImg_2:setPositionY(self.xingImg_2:getPositionY()+dPosY);
	self.xingImg_3:setPositionY(self.xingImg_3:getPositionY()+dPosY);
	self.msgTF_1:setPositionY(self.msgTF_1:getPositionY()+dPosY);
	self.msgTF_2:setPositionY(self.msgTF_2:getPositionY()+dPosY);
	self.msgTF_3:setPositionY(self.msgTF_3:getPositionY()+dPosY);
end
function SLUIMngr:getUI()
	return self.armature_d;
end
function SLUIMngr:setExP(exp)
	self.addExp = exp and exp or 0;
end
function SLUIMngr:playSLEffect()
	local boneCartoon1 = BoneCartoon.new()
	local function callBack()
    	self.effectTmp:removeChild(boneCartoon1);
    	self.parent:onCloseUI();
	end
	local function playStarLightFun()
    	self.starLight = Sprite.new(CCSprite:create(artData[1741].source));
    	self.starLight:setAnchorPoint(ccp(0.5,0.5));
    	Tweenlite:rotateForever(self.starLight,30,true);
    	self.effectTmp:addChild(self.starLight);
    	self.starLight:setPositionXY(GameConfig.STAGE_WIDTH*0.5-40,220);
    	--self:setGeneral(self.genData);
	end
	local function callBack1_noStar()
    	self.effectTmp:removeChild(boneCartoon1);
    	self:setGeneral(self.genData);
	end
	local function callBack1()
    	self.effectTmp:removeChild(boneCartoon1);
    	local et = 0.6;
    	Tweenlite:to(self.star_1,et,0,320,255,playStarLightFun,true,EaseType.CCEaseElasticOut);
    	Tweenlite:to(self.star_2,et,0,320,255,nil,true,EaseType.CCEaseElasticOut);
    	Tweenlite:to(self.star_3,et,0,320,255,nil,true,EaseType.CCEaseElasticOut);
    	Tweenlite:to(self.star_b_1,et,0,320,255,nil,true,EaseType.CCEaseElasticOut);
    	Tweenlite:to(self.star_b_2,et,0,320,255,nil,true,EaseType.CCEaseElasticOut);
    	Tweenlite:to(self.star_b_3,et,0,320,255,nil,true,EaseType.CCEaseElasticOut);
    	self:setGeneral(self.genData);
	end
	local function setXof(dis)
		dis:setVisible(true);
		dis:setPositionX(dis:getPositionX()+1000);
		Tweenlite:to(dis,0.3,-1000,0,255,nil,true,EaseType.CCEaseExponentialIn);
	end
	local function delayCallFun1()
		setXof(self.xingImg_1);
		setXof(self.msgTF_1);
	end
	local function delayCallFun2()
		setXof(self.xingImg_2);
		setXof(self.msgTF_2);
	end
	local function delayCallFun3()
		setXof(self.xingImg_3);
		setXof(self.msgTF_3);
	end
	local function StarCall3()
		local bCtn = BoneCartoon.new();
		bCtn:create("1734",1);
		bCtn:setPositionXY(85,85)
		self.star_b_3:addChild(bCtn);
	end
	local function StarCall2()
		local bCtn = BoneCartoon.new();
		bCtn:create("1734",1);
		bCtn:setPositionXY(85,85)
		self.star_b_2:addChild(bCtn);
		if self.starLevel and self.starLevel<3 then return end
		self.star_3:setVisible(true);
		self.star_3:setScale(3);
		Tweenlite:scale(self.star_3,0.25,1,1,255,StarCall3,false,EaseType.CCEaseExponentialIn);
	end
	local function StarCall1()
		local bCtn = BoneCartoon.new();
		bCtn:create("1734",1);
		bCtn:setPositionXY(85,85)
		self.star_b_1:addChild(bCtn);
		if self.starLevel and self.starLevel<2 then return end
		self.star_2:setVisible(true);
		self.star_2:setScale(3);
		Tweenlite:scale(self.star_2,0.25,1,1,255,StarCall2,false,EaseType.CCEaseExponentialIn);
	end
	
	log("self.parent.battleProxy.battleType==="..self.parent.battleProxy.battleType)

	if self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_9 then
    	self.msgTF_1:setString("战胜了"..self.parent.battleProxy.battleOverBossName.."，他将改变态度，同意你的提案~！")
		self.msgTF_2:setString("虽然暴力是不好的，但是俗话不是说得好，挡路者内啥么。。")
		self.msgTF_3:setString("血泪史的实话告诉你，武官啊，好，厉，害，啊！")
		boneCartoon1:create("1399",1,callBack);
		Tweenlite:delayCall(self.armature_d,0.5,delayCallFun1);
		Tweenlite:delayCall(self.armature_d,0.8,delayCallFun2);
		Tweenlite:delayCall(self.armature_d,1.1,delayCallFun3);
		self:configPos();
    elseif self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_3 then
    	self.msgTF_1:setString("战胜"..self.parent.battleProxy.battleOverBossName.."，护国宝箱即将拱手奉上！")
		self.msgTF_2:setString(self.parent.battleProxy.battleOverUseTime.."秒内击溃敌军，势如破竹")
		--self.msgTF_3:setString("将"..self.parent.battleProxy.battleOverMonsterCount.."个敌人全部清剿")
		self.msgTF_3:setString("将敌人全部清剿")
		boneCartoon1:create("1399",1,callBack);
		Tweenlite:delayCall(self.armature_d,0.5,delayCallFun1);
		Tweenlite:delayCall(self.armature_d,0.8,delayCallFun2);
		Tweenlite:delayCall(self.armature_d,1.1,delayCallFun3);
		self:configPos();
    elseif self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 or self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_10 then
		self.star_b_1:setVisible(true);
		self.star_b_2:setVisible(true);
		self.star_b_3:setVisible(true);
		boneCartoon1:create("1399",1);
		self.starLevel = self.parent.battleProxy.starLevel;
		Tweenlite:delayCall(self.armature_d,1.2,callBack1);
		if self.starLevel and self.starLevel>=1 then
			self.star_1:setVisible(true);
			self.star_1:setScale(3);
			Tweenlite:scale(self.star_1,0.25,1,1,255,StarCall1,false,EaseType.CCEaseExponentialIn);
		end
	elseif self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_12 then
		boneCartoon1:create("1399",1,callBack);
		self:configPos();
    else
		boneCartoon1:create("1399",1);
		Tweenlite:delayCall(self.armature_d,1.2,callBack1_noStar);
		self:configPos();
	end
	boneCartoon1:setPositionX(GameConfig.STAGE_WIDTH*0.5)
   	self.effectTmp:addChild(boneCartoon1);
end
function SLUIMngr:playLightEffect()
	local boneCartoon1 = BoneCartoon.new()
    local function callBack()
        self.effectTmp:removeChild(boneCartoon1)
    end
	boneCartoon1:create("1398",1,callBack);
	boneCartoon1:setPositionX(-1700)
   	self.effectTmp:addChild(boneCartoon1);
end
function SLUIMngr:setGeneralData(data,dieCount)
	self.genData = data;
	self.dieCount = dieCount;
	self:playSLEffect();
end
function SLUIMngr:setGeneral(data)
	self:playLightEffect()
	self.gnlTmp:removeChildren();
	self.headArr = {};
	if self.parent.battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 then
		self.zJJYBg:setVisible(true);
		self.zJJYTF:setVisible(true);
		self.zJJYTF:setString("      主角等级："..self.userProxy:getLevel().."     经验：+"..self.addExp)
		self.zJJYLP:setVisible(self.userProxy.experience<self.addExp);
		self:configPos(-80);
	end
	local count = table.getn(data)*0.5+0.5;
	for i,v in ipairs(data) do
		local headRender = HeadRender.new(self.skeleton,self);
		local render_d = headRender:getUI();
		render_d:setPositionY(-250);
		render_d:setScale(1.4);
		render_d:setVisible(false);
		self.gnlTmp:addChild(render_d);
		table.insert( self.headArr, headRender );
		headRender:setData(v,self.addExp);
		local function delayCallFun()
			render_d:setVisible(true);
			Tweenlite:scaleMoveTo(render_d,0.25,(i-count)*200,250,255,1,function ()
				headRender:playEffect();
				headRender:growExp(v,self.addExp);
			end,true,EaseType.CCEaseExponentialIn);
		end
		Tweenlite:delayCall(render_d,(i-1)*0.2,delayCallFun);
		
	end
end
local function sortFun(a,b)
	return a.color>b.color;
end
function SLUIMngr:setItemData(data)
	local items = {};
	for k,v in pairs(data) do
		if v.ItemId == 1 then
			self:setExP(v.Count);
		else
			v.color = analysis("Daoju_Daojubiao",v.ItemId,"color");
			table.insert(items,v);
		end
	end
	table.sort( items, sortFun )
	local count = table.getn(items)*0.5+0.5;
	self.itemTmp:removeChildren();
	self.itemArr = {};
	for i,v in ipairs(items) do
		local itemRender = ItemRender.new(self.skeleton,self);
		local render_d = itemRender:getUI();
		self.itemTmp:addChild(render_d);
		render_d:setPositionX((i-count)*135);
		--render_d:setAnchorPoint(ccp(0.5,0.5));
		render_d:setVisible(false);
		itemRender:setData(v);
		itemRender.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
		table.insert( self.itemArr, itemRender );
		local function delayCallFun()
			render_d:setVisible(true);
			render_d:setScale(0.1);
			itemRender:playEffectXX();
			Tweenlite:rotateScale(render_d,0.3,360,255,1,nil,true);
		end
		Tweenlite:delayCall(render_d,i*0.3+2.5,delayCallFun);
	end
end
function SLUIMngr:onItemTip(event)
	self.parent:showItemTip(event);
end
function SLUIMngr:dispose()
	self.gnlTmp:removeChildren();
	for k,v in pairs(self.headArr) do
		v:dispose();
	end
	self.itemTmp:removeChildren();
	for k,v in pairs(self.itemArr) do
		v:dispose();
	end
	if self.starLight then
		self.starLight:stopAllActions();
		self.effectTmp:removeChild(self.starLight);
		self.starLight = nil;
	end
	self.parent = nil;
	self.skeleton = nil;
	self.armature:dispose();
end




local SBUIMngr = class();
function SBUIMngr:ctor(skeleton,parent)
	self.skeleton = skeleton;
	self.armature=self.skeleton:buildArmature("sb_ui");
	self.armature.animation:gotoAndPlay("f1");
	self.armature:updateBonesZ();
	self.armature:update();
	self.armature_d=self.armature.display;
	self.parent = parent;
	self.userProxy = parent.userProxy;
end
function SBUIMngr:initUI(funId,genId)
	self.ttlTF = generateText(self.armature_d,self.armature,"ttlTF","赶快通过以上途径提升实力吧！");
	self.ttlTF:setVisible(false);
	self.sb = self.armature_d:getChildByName("sb");
	self.sb:setOpacity(0);
	Tweenlite:to(self.sb,1,0,0,255,nil,true);
	self.btnTmp = self.armature_d:getChildByName("btnTmp");
	self.itemTmp = self.armature_d:getChildByName("itemTmp");
	-- self.yinxiongButton = Image.new();
	-- self.yinxiongButton:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_13,"icon"));

	-- self.qianghuaButton = Image.new();
	-- self.qianghuaButton:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_23,"icon"));

	-- self.langyalingButton = Image.new();
	-- self.langyalingButton:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",FunctionConfig.FUNCTION_ID_12,"icon"));
	
	-- local btnX = -200;
	-- self.btnTmp:addChild(self.yinxiongButton);
	-- self.yinxiongButton:setPositionXY(btnX,-50);
	-- btnX = btnX+self.yinxiongButton:getContentSize().width+10;
	
	-- self.btnTmp:addChild(self.qianghuaButton);
	-- self.qianghuaButton:setPositionXY(btnX,-50);
	-- btnX = btnX+self.qianghuaButton:getContentSize().width+10;
	
	-- self.btnTmp:addChild(self.langyalingButton);
	-- self.langyalingButton:setPositionXY(btnX,-50);
	-- btnX = btnX+self.langyalingButton:getContentSize().width+10;

	self.FunBtn = Image.new();
	self.FunBtn:loadByArtID(analysis("Gongnengkaiqi_Gongnengkaiqi",funId,"icon"));
	self.FunBtn:setAnchorPoint(CCPointMake(0.5, 0));
	self.btnTmp:addChild(self.FunBtn);

	-- self.yinxiongButton:setOpacity(0);
	-- Tweenlite:to(self.yinxiongButton,1,0,0,255,nil,true);
	-- self.qianghuaButton:setOpacity(0);
	-- Tweenlite:to(self.qianghuaButton,1,0,0,255,nil,true);
	-- self.langyalingButton:setOpacity(0);
	-- Tweenlite:to(self.langyalingButton,1,0,0,255,nil,true);

	self.FunBtn:setOpacity(0);
	Tweenlite:to(self.FunBtn,1,0,0,255,nil,true);
		
end
function SBUIMngr:getUI()
	return self.armature_d;
end
function SBUIMngr:setItemData(data)
	local items = {};
	for k,v in pairs(data) do
		v.color = analysis("Daoju_Daojubiao",v.ItemId,"color");
		table.insert(items,v);
	end
	table.sort( items, sortFun )
	local count = table.getn(items);
	if count<=0 then
		self.ttlTF:setVisible(true);
		return;
	end
	count = count*0.5+0.5;
	self.itemTmp:removeChildren();
	self.itemArr = {};
	for i,v in ipairs(items) do
		local itemRender = ItemRender.new(self.skeleton,self);
		local render_d = itemRender:getUI();
		self.itemTmp:addChild(render_d);
		render_d:setPositionX((i-count)*120);
		--render_d:setAnchorPoint(ccp(0.5,0.5));
		render_d:setVisible(false);
		itemRender:setData(v);
		itemRender.itemImage:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self);
		table.insert( self.itemArr, itemRender );
		local function delayCallFun()
			render_d:setVisible(true);
			render_d:setScale(0.1);
			itemRender:playEffectXX();
			Tweenlite:rotateScale(render_d,0.3,360,255,1,nil,true);
		end
		Tweenlite:delayCall(render_d,i*0.3,delayCallFun);
	end
end
function SBUIMngr:onItemTip(event)
	self.parent:showItemTip(event);
end
function SBUIMngr:dispose()
	if self.itemArr then
		self.itemTmp:removeChildren();
		for k,v in pairs(self.itemArr) do
			v:dispose();
		end
	end
	self.parent = nil;
	self.skeleton = nil;
	self.armature:dispose();
end




BattleOverUI=class(LayerPopableDirect);

function BattleOverUI:ctor()
	self.class=BattleOverUI;
	self.hasLeave = false;
	self.dieCount = 0;
end

function BattleOverUI:dispose()
	if self.sLUIMngr then
		self.sLUIMngr:dispose();
	end
	if self.sbUIMngr then
		self.sbUIMngr:dispose();
	end
	if self.layerPopableData then
		self.layerPopableData.parent = nil
	end
	BattleOverUI.superclass.dispose(self);
	self.battleProxy = nil;
end

function BattleOverUI:initialize()
	self.skeleton=nil;
end
function BattleOverUI:onDataInit()
	self.skeleton = getSkeletonByName("battleOver_ui");

	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(false);
	layerPopableData:setHasUIFrame(false);
	layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,nil,2);
	layerPopableData:setArmatureInitParam(self.skeleton,"batte_over_ui");
	layerPopableData:setParent(sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI));
	self:setLayerPopableData(layerPopableData);
	self.layerPopableData = layerPopableData;
	self.userProxy = self:retrieveProxy(UserProxy.name);
	self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name)
	local userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
    local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    local countProxy=self:retrieveProxy(CountControlProxy.name);
    local bagProxy=self:retrieveProxy(BagProxy.name);
    self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)

end


function BattleOverUI:initialize()
  -- self:initLayer();
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function BattleOverUI:onPrePop()
	self.armature_d = self.armature.display;
	self.pageTmp = self.armature_d:getChildByName("pageTmp");
	self.fhBtn = self.armature_d:getChildByName("fhBtn");
	SingleButton:create(self.fhBtn);
    self.fhBtn:addEventListener(DisplayEvents.kTouchTap, self.onCloseUI, self);

    self.zzBtn = self.armature_d:getChildByName("zzBtn");
	SingleButton:create(self.zzBtn);
    self.zzBtn:addEventListener(DisplayEvents.kTouchTap, self.goBattle, self);

    --self.xygBtn = self.armature_d:getChildByName("xygBtn");
	--SingleButton:create(self.xygBtn);
    --self.xygBtn:addEventListener(DisplayEvents.kTouchTap, self.onCloseUI, self);
    --self.xygBtn:setVisible(false);
    self.zzBtn:setVisible(false);
    self.fhBtn:setVisible(false);
	MusicUtils:stop(true);
    if self.battleData.isVictory then
		self.sLUIMngr = SLUIMngr.new(self.skeleton,self);
		self.pageTmp:addChild(self.sLUIMngr:getUI());
		self.sLUIMngr:setItemData(self.battleData.itemIdPool);
		local genArr = self:getGeneralArr();
		self.sLUIMngr:setGeneralData(genArr,self.dieCount);
		MusicUtils:playEffect(12,false);


	else
		local funId,genId = self:getShowFunID();
		self.sbUIMngr = SBUIMngr.new(self.skeleton,self);
		self.sbUIMngr:initUI(funId,genId);
		self.pageTmp:addChild(self.sbUIMngr:getUI());
		self.sbUIMngr:setItemData(self.battleData.itemIdPool);
		-- self.sbUIMngr.yinxiongButton:addEventListener(DisplayEvents.kTouchBegin,self.onClickButton,self,FunctionConfig.FUNCTION_ID_13);
  --   	self.sbUIMngr.qianghuaButton:addEventListener(DisplayEvents.kTouchBegin,self.onClickButton,self,FunctionConfig.FUNCTION_ID_14);
  --   	self.sbUIMngr.langyalingButton:addEventListener(DisplayEvents.kTouchBegin,self.onClickButton,self,FunctionConfig.FUNCTION_ID_12);
		self.sbUIMngr.FunBtn:addEventListener(DisplayEvents.kTouchBegin,self.onClickButton,self,{funId,genId});
	  	if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
			-- self.sbUIMngr.yinxiongButton:setVisible(false)
			-- self.sbUIMngr.qianghuaButton:setVisible(false)
			-- self.sbUIMngr.langyalingButton:setVisible(false)
			self.sbUIMngr.FunBtn:setVisible(false);
		end	

    	MusicUtils:playEffect(13,false);
	end
	if self.battleData.isVictory and (self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_9 or self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_3) then
		self.fhBtn:setVisible(false);
    else
    	local function delayCallFun()
			self.fhBtn:setVisible(true);
			self.fhBtn:setOpacity(0);
			Tweenlite:to(self.fhBtn,1,0,0,255,nil,true);		
		end
    	Tweenlite:delayCall(self.fhBtn,2,delayCallFun)
    end
  self:initBackGround();
end
function BattleOverUI:initBackGround()
	local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
	backHalfAlphaLayer:setOpacity(185)
	backHalfAlphaLayer:setScale(1.6)
	backHalfAlphaLayer:setPositionY(-GameData.uiOffsetY)
	self:addChildAt(backHalfAlphaLayer,0)
end
function BattleOverUI:onClickButton(event,funArr)
	if not self.openFunctionProxy:checkIsOpenFunction(funArr[1]) then
		sharedTextAnimateReward():animateStartByString("功能未开启哦~");
		return 
	end
	self.battleProxy.openFunctionId = funArr[1];
	self.battleProxy.openGeneralId = funArr[2];
	self:onCloseUI();
end
 --  BetterJinjieEquip = nil,--装备进阶
 --  Yuanfenable = nil,--缘分升级
--  16、英雄升级——跳转到英雄库中 Levelable = nil,--角色可升级
-- 14、装备强化——跳转到英雄库中 BetterEquip = nil,--装备强化
-- 15、英雄进阶——跳转到英雄库中 Gradeable = nil,--角色可进阶
-- 17、技能升级——跳转到英雄库中 Skillable = nil,--技能升级
-- 19、英雄升星——跳转到英雄库中 StarLevelable = nil,--角色可升星
-- 12、召唤——跳转到召唤中

function BattleOverUI:getShowFunID()
	local genArr = self:getGeneralArr();
	local funIdArr = {FunctionConfig.FUNCTION_ID_16,FunctionConfig.FUNCTION_ID_14,FunctionConfig.FUNCTION_ID_15,FunctionConfig.FUNCTION_ID_17,FunctionConfig.FUNCTION_ID_19,FunctionConfig.FUNCTION_ID_12}
	local idx = 6;
	local genId;
	for k,v in pairs(genArr) do
		local hdD = self.heroHouseProxy:getHongdianData(v.GeneralId);
		if hdD.Levelable then
			idx,genId = 1,v.GeneralId;
			break;
		elseif hdD.BetterEquip and idx>2 then
			idx,genId = 2,v.GeneralId;
		elseif hdD.Gradeable and idx>3 then
			idx,genId = 3,v.GeneralId;
		elseif hdD.Skillable and idx>4 then
			idx,genId = 4,v.GeneralId;
		elseif hdD.StarLevelable and idx>5 then
			idx,genId = 5,v.GeneralId;
		else
			idx,genId = 6,v.GeneralId;
		end
	end
	return funIdArr[idx],genId;
end
function BattleOverUI:getGeneralArr()
	local genArr = {};
 	for i,v in ipairs(self.battleProxy.battleOverPlayer) do
 		--table.insert(genArr,self.heroHouseProxy:getGeneralData(v)); //TODO generalId替换
 		local genVo = self.heroHouseProxy:getGeneralDataByConfigID(v);
 		if not self.battleProxy:ChackDieGen(v) then 
 			self.dieCount = self.dieCount+1;
 		end
 		if 1 == genVo.IsMainGeneral and i>1 then
 			local vo = genArr[1]
 			genArr[1] = genVo;
 			table.insert(genArr,vo);
 		else
 			table.insert(genArr,genVo);
 		end
 		
 	end
  	return genArr;
end
function BattleOverUI:onUIInit()
  --CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
  	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
		openTutorUI({x=1118, y=47, width = 117, height = 80, alpha = 125, delay = 2});--1010,68  
	end	
end
function BattleOverUI:onInitData(data,battleProxy)
	self.battleProxy = battleProxy;
	self.battleData = data;
end
function BattleOverUI:onRequestedData()

end
function BattleOverUI:battleResaultData()
	if not self.battleData.isVictory and not self.battleProxy.openFunctionId then
		-- if BattleConfig.BATTLE_TYPE_4 ~= self.battleProxy.battleType then--排除阵营战
			self.battleProxy.battleResault = self.battleData.isVictory;
		-- end
	end
end
function BattleOverUI:dispatchClose()
	self:dispatchEvent(Event.new("CLOSE_BATTLE_OVER_COMMAND",{},self));
	self:dispatchEvent(Event.new("CLOSE_BATTLE_OVER",{battleType = self.battleProxy.battleType},self));
end
function BattleOverUI:onUIClose()
	self:onCloseUI();
end
function BattleOverUI:onCloseUI()

	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
		closeTutorUI(false);
	end		

	if self.hasLeave then return end
	self.battleProxy.battleOverPlayer=nil;
	self.hasLeave = true
	self:battleResaultData()
	self:dispatchClose()

	-- 打点
    local extensionTable = {}
    extensionTable["type"] = self.battleProxy.battleType
    extensionTable["battleID"] = self.battleProxy.battleId;
    extensionTable["zhanchangID"] = self.battleProxy.battleFieldId;
    if  self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 or self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_10 then
        extensionTable["firstfight"] = GameVar.firstfight
    end
    hecDC(6, 2, nil, extensionTable)
end
function BattleOverUI:goBattle()
	if self.hasLeave then return end
	self.hasLeave = true
	local msg = {StrongPointId = self.battleProxy.battleFieldId, battleType = self.battleProxy.battleType,continueBattle = true};
	self:dispatchEvent(Event.new("CLOSE_BATTLE_OVER_COMMAND",{},self));  
	self:dispatchEvent(Event.new("Continue_Battle",msg,self));	
end
function BattleOverUI:showItemTip(event)
	if event.target.userItem.ItemId<100 then
		local name = analysis("Daoju_Daojubiao",event.target.userItem.ItemId,"name");
		name = name.." X"..event.target.userItem.ttlC;
		TipsUtil:showTips(event.target,name,nil,nil,10,sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI));
	else
		self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,parent = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI)},self))
	end
end


--battleOverBossName
--battleOverMonsterCount
--battleOverUseTime