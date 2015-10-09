--=====================================================
-- 名称：     tweenlite
-- @authors： 赵新
-- @mail：    xianxin.zhao@happyelements.com
-- @website： http://www.cnblogs.com/tinytiny/
-- @date：    2014-01-17 14:53:05
-- @descrip： 简化调用特效的复杂性		  
-- All Rights Reserved. 
--=====================================================


Tweenlite = {};

-- --播放动画 每调用一次创建一次，播放完毕就销毁
-- --默认注册点在正中心位置
-- --cartoonName    美术提供的特效名称
-- --callBack    	 回调方法
-- --params		 回调参数
-- --loop 			 循环次数  nil为一直播放
-- function Tweenlite:palyCartoon(cartoonName,loop,callBack,params)
-- 	ResourceManager:loadAniGroup(cartoonName, AnimationTypes.kEffect);
-- 	local effectAni = AnimationNode:create(cartoonName);
-- 	local function onPlayOver()
-- 		if effectAni == nil then
-- 			return;
-- 		end
-- 		effectAni:setVisible(false);
-- 		effectAni:removeFromParentAndCleanup(true);
-- 		effectAni = nil;
-- 		if callBack then callBack(params) end
-- 	end
-- 	effectAni:setAnchorPoint(ccp(0.5, 0.5));--注册点  元件的正中心
-- 	effectAni:playAction("", "", loop, onPlayOver);
-- 	return effectAni;
	
-- end



EaseType = {
	CCEaseIn = "CCEaseIn",
	CCEaseOut = "CCEaseOut",--普通移动效果
	CCEaseInOut = "CCEaseInOut",
	CCEaseExponentialIn = "CCEaseExponentialIn",
	CCEaseExponentialOut = "CCEaseExponentialOut",
	CCEaseExponentialInOut = "CCEaseExponentialInOut",
	CCEaseSineIn = "CCEaseSineIn",
	CCEaseSineOut = "CCEaseSineOut",
	CCEaseSineInOut = "CCEaseSineInOut",
	CCEaseElastic = "CCEaseElastic",
	CCEaseElasticIn = "CCEaseElasticIn",
	CCEaseElasticOut = "CCEaseElasticOut",--快速弹性效果
	CCEaseElasticInOut = "CCEaseElasticInOut",
	CCEaseBounce = "CCEaseBounce",
	CCEaseBounceIn = "CCEaseBounceIn",
	CCEaseBounceOut = "CCEaseBounceOut",--撞击地面效果
	CCEaseBounceInOut = "CCEaseBounceInOut",
	CCEaseBackIn = "CCEaseBackIn",
	CCEaseBackOut = "CCEaseBackOut",--下沉效果
	CCEaseBackInOut = "CCEaseBackInOut"
}

--移动到x y
--obj   	对象
--time  	时间 秒
--x y 		坐标
--alpha 	0-255 不透明范围
--callBack  回调   自定义参数待定
--isBy		是不是向量
--easeType	缓动类型 EaseType
--delayTime 延迟时间
--注意 缓动那块想要做成动态识别的，但是能力所及使用loadString没有实现，
--     谁能够实现就修改下吧 ^_^
function Tweenlite:to(obj,time,x,y,alpha,callBack,isBy,easeType,delayTime)
	local actions = CCArray:create();
	local seq;
	local moveTo;
	if isBy then 
		moveTo = CCMoveBy:create(time, ccp(x, y));		
	else
		moveTo = CCMoveTo:create(time, ccp(x, y));
	end
	if delayTime then
		actions:addObject(CCDelayTime:create(delayTime));
	end
	if easeType then
		if easeType == "CCEaseOut" then--普通移动效果
			actions:addObject(CCEaseOut:create(moveTo));
		elseif(easeType == "CCEaseBackOut") then--下沉效果
			actions:addObject(CCEaseBackOut:create(moveTo));
		elseif(easeType == "CCEaseBounceOut") then--撞击地面效果
			actions:addObject(CCEaseBounceOut:create(moveTo));
		elseif(easeType == "CCEaseElasticOut") then--快速弹性效果
			actions:addObject(CCEaseElasticOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialOut") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialIn") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialIn:create(moveTo));
		elseif (easeType == "CCEaseSineInOut") then
			actions:addObject(CCEaseSineInOut:create(moveTo));
		end;
	else
		actions:addObject(moveTo);
	end;
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end

	if callBack then
		if not delayTime then
			seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		else
			actions:addObject(CCCallFunc:create(callBack))
			seq = CCSequence:create(actions);
		end
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		if not delayTime then
			seq = CCSpawn:create(actions);
		else
			seq = CCSequence:create(actions);
		end
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

--上下跳动特效
--obj   	对象
--maxHieght 跳动方法
--speed  	速度
function Tweenlite:beat(obj,maxHieght,speed)
	local shcedulerId = 0;
	local step = 0;
	local _y = obj:getPositionY();
	local function repeatFunc()
		if not obj:getParent() then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(shcedulerId);
			return;
		end;
		local tempY = _y + math.abs(maxHieght * math.sin(step/100));
		step = step + speed;
		if step >= 628.3 then
			step = 0;
		end;
		obj:setPositionY(tempY);
	end;
	shcedulerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(repeatFunc,0,false);

	return shcedulerId;
end
function Tweenlite:delayCallS(time,callBack)
	local shcedulerId = 0;
	local function callBackFun()
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(shcedulerId);
		callBack();
		return;
	end
 	shcedulerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callBackFun,time,false);
 	return shcedulerId;
 end
--延迟调用
--obj   	对象
--time  	时间 秒
--callBack  回调
function Tweenlite:delayCall(obj,time,callBack)
	local move = CCDelayTime:create(time);
	local seq;
	if callBack then
		seq = CCSequence:createWithTwoActions(move, CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		if obj.display then
			obj.display:runAction(move);
		else
			obj:runAction(move);
		end
	end
end

--按照间隔循环调用
--obj   	对象
--time  	时间 秒
--func  	方法
function Tweenlite:repeatCall(obj,time,func)
	Tweenlite.startRepeat = true;
	local function tempFunc()
		if Tweenlite.startRepeat then
			Tweenlite:delayCall(obj,time,tempFunc);
			func();
		end
	end
	tempFunc();
end

--取消循环调用
function Tweenlite:cancelRepeatCall()
	Tweenlite.startRepeat = nil;
end

--跳到x y
--obj   	对象
--time  	时间 秒
--x y 		坐标
--alpha 	0-255 不透明范围
--h 		高度
--callBack  回调
--isBy		是不是向量
function Tweenlite:jump(obj,time,x,y,alpha,h,callBack,isBy)
	local actions = CCArray:create();
	local seq;
	if isBy then 
		actions:addObject(CCJumpBy:create(time, ccp(x, y),h,1));
	else
		actions:addObject(CCJumpTo:create(time, ccp(x, y),h,1));
	end
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end

	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

--贝赛尔曲线到x y
--obj   	对象
--time  	时间 秒
--x y 		坐标
--alpha 	0-255 不透明范围
--callBack  回调
--isBy		是不是向量
function Tweenlite:bezier(obj,time,x,y,alpha,callBack,isBy)
	local actions = CCArray:create();
	local seq;
	local config = ccBezierConfig()
	config.controlPoint_1 = ccp(obj:getPositionX(),obj:getPositionX());
	config.controlPoint_2 = ccp(x - 150, y + 360);
	config.endPosition = ccp(x, y);
	if isBy then 
		actions:addObject(CCBezierBy:create(time, config));
	else
		actions:addObject(CCBezierTo:create(time, config));
	end
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end

	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

--缩放
--obj   	对象
--time  	时间 秒
--num 		scale值
--alpha 	0-255 不透明范围
--callBack  回调
--isBy		是不是向量
--easeType	缓动类型 EaseType
--注意 缓动那块想要做成动态识别的，但是能力所及使用loadString没有实现，
--     谁能够实现就修改下吧 ^_^
function Tweenlite:scale(obj,time,numX,numY,alpha,callBack,isBy,easeType)
	local actions = CCArray:create();
	local seq;
	local moveTo;
	if isBy then 
		moveTo = CCScaleBy:create(time, numX,numY);
	else
		moveTo = CCScaleTo:create(time, numX,numY);
	end

	if easeType then
		if easeType == "CCEaseOut" then--普通移动效果
			actions:addObject(CCEaseOut:create(moveTo));
		elseif(easeType == "CCEaseBackOut") then--下沉效果
			actions:addObject(CCEaseBackOut:create(moveTo));
		elseif(easeType == "CCEaseBounceOut") then--撞击地面效果
			actions:addObject(CCEaseBounceOut:create(moveTo));
		elseif(easeType == "CCEaseElasticOut") then--快速弹性效果
			actions:addObject(CCEaseElasticOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialOut") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialIn") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialIn:create(moveTo));
		end;
	else
		actions:addObject(moveTo);
	end;

	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end

	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
	else
		seq = CCSpawn:create(actions);
	end
	if obj.display then
		obj.display:runAction(seq);
	else
		obj:runAction(seq);
	end
end

--转动
--obj   	对象
--time  	时间 秒
--num 		度数
--alpha 	0-255 不透明范围
--callBack  回调
--isBy		是不是向量
function Tweenlite:rotate(obj,time,num,alpha,callBack,isBy)
	Tweenlite:rotateScale(obj,time,num,alpha,nil,callBack,isBy);
end
function Tweenlite:rotateScale(obj,time,num,alpha,scale,callBack,isBy)
	local actions = CCArray:create();
	local seq;
	if isBy then 
		actions:addObject(CCRotateBy:create(time, num));
	else
		actions:addObject(CCRotateTo:create(time, num));
	end
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end
	if scale then
		actions:addObject(CCScaleTo:create(time,scale));
	end
	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

--永远转动
--obj   	对象
--time 		一周时间
--isPlay	是不是向量
function Tweenlite:rotateForever(obj,time,isPlay)
	if not isPlay then
		obj.onRotate = false;
	end
	if obj.onRotate and isPlay then return;	end;
	if not obj.onRotate and not isPlay then return;	end;

	local function rotateFun()
		if not obj.onRotate then return; end;
		obj:setRotation(0);
		Tweenlite:rotate(obj,time,360,255,rotateFun,true);
	end
	if isPlay then
		obj.onRotate = true;
		rotateFun();
	else
		obj.onRotate = false;
	end
end

--闪烁
--obj   	对象
--time  	时间 秒
--num 		次数
--callBack  回调
function Tweenlite:blink(obj,time,num,callBack)
	local move;
	move = CCBlink:create(time, num);
	local seq;
	if callBack then
		seq = CCSequence:createWithTwoActions(move, CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		if obj.display then
			obj.display:runAction(move);
		else
			obj:runAction(move);
		end
	end
end

--变色
--obj   	对象
--time  	时间 秒
--r 		red
--g 		green
--b 		blue
--alpha 	0-255 不透明范围
--callBack  回调
--isBy		是不是向量
function Tweenlite:tint(obj,time,r,g,b,alpha,callBack,isBy)
	local actions = CCArray:create();
	local seq;
	if isBy then 
		actions:addObject(CCTintBy:create(time,r,g,b));
	else
		actions:addObject(CCTintTo:create(time,r,g,b));
	end
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end

	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

--变色
--obj   	对象
--time  	时间 秒
--x 		red
--y 		green
--alpha 	0-255 不透明范围
--callBack  回调
--isBy		是不是向量
function Tweenlite:skew(obj,time,x,y,callBack,isBy)
	local actions = CCArray:create();
	local seq;
	if isBy then 
		actions:addObject(CCSkewBy:create(time,x,y));
	else
		actions:addObject(CCSkewTo:create(time,x,y));
	end

	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end

-- 卡片翻转
function Tweenlite:CardFlip(frontObj,backObj,time,callBack,dric)
	if not dric or dric ~= -1 then dric = 1 end
	Director:sharedDirector():setProjection(kCCDirectorProjection3D);
		
	if not frontObj or not backObj then return; end;
	frontObj:setVisible(true);
	backObj:setVisible(false);
	local actionf = CCOrbitCamera:create(time*0.5,1,0,0,dric*90,0,0);
	local actionsf = CCArray:create();
    actionsf:addObject(actionf);
    local function callBack1()
		frontObj:setVisible(false);
		backObj:setVisible(true);
    end
	actionsf:addObject(CCCallFunc:create(callBack1));
	frontObj:runAction(CCSequence:create(actionsf));
	local actionb = CCOrbitCamera:create(time*0.5,1,0,dric*270,dric*90,0,0);
	local actionsb = CCArray:create();
	actionsb:addObject(CCDelayTime:create(time*0.5));
    actionsb:addObject(actionb);
    local function callBack2()
    	Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
    	if callBack then
			callBack();
		end
    end
	actionsb:addObject(CCCallFunc:create(callBack2));
	backObj:runAction(CCSequence:create(actionsb));	
end
-- 卡片翻转
function Tweenlite:CardFlipHalf(frontObj,time,callBack,dric)
	if not dric or dric ~= -1 then dric = 1 end
	Director:sharedDirector():setProjection(kCCDirectorProjection3D);
		
	if not frontObj then return; end;
	frontObj:setVisible(true);
	-- backObj:setVisible(false);
	local actionf = CCOrbitCamera:create(time*0.5,1,0,0,dric*90,0,0);
	local actionsf = CCArray:create();
    actionsf:addObject(actionf);
    local function callBack1()
		frontObj:setVisible(false);
    	if callBack then
			callBack();
		end
    end
	actionsf:addObject(CCCallFunc:create(callBack1));
	frontObj:runAction(CCSequence:create(actionsf));
	-- local actionb = CCOrbitCamera:create(time*0.5,1,0,dric*270,dric*90,0,0);
	-- local actionsb = CCArray:create();
	-- actionsb:addObject(CCDelayTime:create(time*0.5));
 --    actionsb:addObject(actionb);
 --    local function callBack2()
 --    	Director:sharedDirector():setProjection(kCCDirectorProjectionDefault);
 --    	if callBack then
	-- 		callBack();
	-- 	end
 --    end
	-- actionsb:addObject(CCCallFunc:create(callBack2));
	-- backObj:runAction(CCSequence:create(actionsb));
end
--obj   		对象
--time  		旋转时间
--radius 		起始半径
--deltaRadius 	半径差
--angleZ 		起始z角
--deltaAngleZ 	旋转z角差
--angleX 		起始x角
--deltaAngleX 	旋转x角差
function Tweenlite:flipNormal(obj,time,radius,deltaRadius,angleZ,deltaAngleZ,angleX,deltaAngleX,callBack)
	local action = CCOrbitCamera:create(time,radius,deltaRadius,angleZ,deltaAngleZ,angleX,deltaAngleX);
	-- action.m_fEyeZOrig = -20;

	-- local cam = obj:getCamera();
	-- cam:setEyeXYZ(0, 0, 20);
 
    local actions = CCArray:create();
    actions:addObject(action);
	actions:addObject(CCCallFunc:create(callBack));

	obj:runAction(CCSequence:create(actions));
end;

function Tweenlite:flip(obj,time,du,callBack)
	local kInAngleZ = 270 --里面卡牌的起始Z轴角度
	local kInDeltaZ = 90  --里面卡牌旋转的Z轴角度差
	local kOutAngleZ = 0  --封面卡牌的起始Z轴角度
	local kOutDeltaZ = 40 --封面卡牌旋转的Z轴角度差


	Tweenlite:flipNormal(obj,time,1,0,0,du,0,0,callBack);
end;


function Tweenlite:removeFlip(obj,time)
	local kInAngleZ = 270 --里面卡牌的起始Z轴角度
	local kInDeltaZ = 90  --里面卡牌旋转的Z轴角度差
	local kOutAngleZ = 0  --封面卡牌的起始Z轴角度
	local kOutDeltaZ = 40 --封面卡牌旋转的Z轴角度差


	Tweenlite:flipNormal(obj,time,1,0,0,0,0,0);
end;



function Tweenlite:flip2(obj)
	-- CCPoint pos = ccp(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y);
	-- pSprite->setPosition(pos);
	-- this->addChild(pSprite);
	local pAry = CCPointArray:create(3);
	pAry:addControlPoint(ccp(0,0));
	pAry:addControlPoint(ccp(-300,30));
	pAry:addControlPoint(ccp(0,0));
	obj:runAction(CCCardinalSplineBy:create(2, pAry, 1));


end

--左右晃动
function  Tweenlite:leftRightShake(obj)
  -- local function actionFunction()
	 --  local actions1 = CCArray:create();
	 --  local actions2 = CCArray:create();
	 --  local actions3 = CCArray:create();
	 --  local actions4 = CCArray:create();
	 --  actions1:addObject(CCRotateBy:create(0.1, 10));
	 --  actions1:addObject(CCRotateBy:create(0.2, -20));
	 --  actions1:addObject(CCRotateBy:create(0.2, 20));
	 --  actions1:addObject(CCRotateBy:create(0.1, -10));

	 --  actions3:addObject(CCScaleTo:create(0.3, 1.2));
	 --  actions3:addObject(CCScaleTo:create(0.3, 1));
		
	 --  actions2:addObject(CCSequence:create(actions1))
	 --  actions2:addObject(CCSequence:create(actions3))

	 --  actions4:addObject(CCSpawn:create(actions2))

	 --  actions4:addObject(CCDelayTime:create(1))
	 --  actions4:addObject(CCCallFunc:create(actionFunction))
	 --  obj:runAction(CCSequence:create(actions4))
  -- end

  local actions1 = CCArray:create();
  local actions2 = CCArray:create();
  local actions3 = CCArray:create();
  local actions4 = CCArray:create();
  actions1:addObject(CCRotateBy:create(0.06, 10))
  actions1:addObject(CCRotateBy:create(0.12, -20))
  actions1:addObject(CCRotateBy:create(0.12, 20))
  actions1:addObject(CCRotateBy:create(0.12, -20))
  actions1:addObject(CCRotateBy:create(0.12, 20))
  actions1:addObject(CCRotateBy:create(0.06, -10))

  actions3:addObject(CCEaseInOut:create(CCScaleTo:create(0.3, 1.2)))
  actions3:addObject(CCEaseInOut:create(CCScaleTo:create(0.3, 1)))
	
  actions2:addObject(CCSequence:create(actions1))
  actions2:addObject(CCSequence:create(actions3))

  actions4:addObject(CCSpawn:create(actions2))

  actions4:addObject(CCDelayTime:create(1))
  -- actions4:addObject(CCCallFunc:create(actionFunction))
  obj:runAction(CCRepeatForever:create(CCSequence:create(actions4)))
end


function  Tweenlite:scaleMoveTo(obj,time,x,y,alpha,scale,callBack,isBy,easeType)
	local actions = CCArray:create();
	local seq;
	local moveTo;
	if isBy then 
		moveTo = CCMoveBy:create(time, ccp(x, y));		
	else
		moveTo = CCMoveTo:create(time, ccp(x, y));
	end
	if easeType then
		if easeType == "CCEaseOut" then--普通移动效果
			actions:addObject(CCEaseOut:create(moveTo));
		elseif(easeType == "CCEaseBackOut") then--下沉效果
			actions:addObject(CCEaseBackOut:create(moveTo));
		elseif(easeType == "CCEaseBounceOut") then--撞击地面效果
			actions:addObject(CCEaseBounceOut:create(moveTo));
		elseif(easeType == "CCEaseElasticOut") then--快速弹性效果
			actions:addObject(CCEaseElasticOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialOut") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialOut:create(moveTo));
		elseif(easeType == "CCEaseExponentialIn") then--其它 个人添加
		 	actions:addObject(CCEaseExponentialIn:create(moveTo));
		end;
	else
		actions:addObject(moveTo);
	end;
	if alpha then
		actions:addObject(CCFadeTo:create(time, alpha));
	end
	if scale then
		actions:addObject(CCScaleTo:create(time,scale));
	end
	
	if callBack then
		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	else
		seq = CCSpawn:create(actions);
		if obj.display then
			obj.display:runAction(seq);
		else
			obj:runAction(seq);
		end
	end
end


-- //水平翻转，1s  
-- pRole->runAction(CCFlipX3D::create(1));  

-- --X轴翻转
-- --obj   	对象
-- --time  	时间 秒
-- function Tweenlite:tint(obj,time)
-- 	local actions = CCArray:create();
-- 	local seq;
-- 	if isBy then 
-- 		actions:addObject(CCTintBy:create(time,r,g,b));
-- 	else
-- 		actions:addObject(CCTintTo:create(time,r,g,b));
-- 	end
-- 	if alpha then
-- 		actions:addObject(CCFadeTo:create(time, alpha));
-- 	end

-- 	if callBack then
-- 		seq = CCSequence:createWithTwoActions(CCSpawn:create(actions), CCCallFunc:create(callBack));
-- 		if obj.display then
-- 			obj.display:runAction(seq);
-- 		else
-- 			obj:runAction(seq);
-- 		end
-- 	else
-- 		seq = CCSpawn:create(actions);
-- 		if obj.display then
-- 			obj.display:runAction(seq);
-- 		else
-- 			obj:runAction(seq);
-- 		end
-- 	end
-- end

-- -- CCFlipX3D::actionWithDuration(t);//x轴翻转
-- -- CCFlipY3D::actionWithDuration(t);//y轴翻转


-- -- 波浪效果
-- -- obj 			波动对象
-- -- wav是 		希望总共波动多少次，次数。 
-- -- amplitude 	相当于波动的振幅，波动范围。
-- -- horizontal 	如果为YES ,那么就是垂直波动，否则垂直不波动。
-- -- vertical 	如果为YES,那么就是水平波动，否则水平不波动。
-- -- grid 		表示 波动的整个区域 ，设置一个  宽 *  高  的 框。
-- -- duration		表示，波动总体时间，单位秒。
-- -- callBack   	回调
-- function Tweenlite:wave(obj,wav,amplitude,horizontal,vertical,gridWidth,gridHeight,time,callBack)
-- 	local move;
-- 	local seq;
-- 	move = CCWaves:create(time,CCSize(gridWidth, gridHeight),wav,amplitude,horizontal,vertical);
-- 	if callBack then
-- 		seq = CCSequence:createWithTwoActions(move, CCCallFunc:create(callBack));
-- 		if obj.display then
-- 			obj.display:runAction(seq);
-- 		else
-- 			obj:runAction(seq);
-- 		end
-- 	else
-- 		if obj.display then
-- 			obj.display:runAction(move);
-- 		else
-- 			obj:runAction(move);
-- 		end
-- 	end
-- end

-- --波浪默认效果
-- function Tweenlite:waveDefault(obj,callBack)
-- 	Tweenlite:wave(obj,5, 20, true, true, 15,10, 5,callBack);
-- end

-- -- 震动效果
-- -- obj 			波动对象
-- -- time			表示，震动总体时间，单位秒。
-- -- gridWidth 	网格宽 
-- -- gridHeight 	网格高
-- -- range		范围
-- -- shakeZ       Z轴要不要震动
-- -- callBack   	回调
-- function Tweenlite:shake(obj,time,gridWidth,gridHeight,range,shakeZ,callBack)
-- 	local move;
-- 	local seq;
-- 	move = CCShaky3D:create(time,CCSize(gridWidth, gridHeight),range,shakeZ);
-- 	seq = CCSequence:createWithTwoActions(move, 
-- 		CCCallFunc:create(
-- 			function()
-- 				obj:setGrid(nil);
-- 				if callBack then
-- 					callBack();
-- 				end
-- 			end
-- 		)
-- 	);
-- 	if obj.display then
-- 		obj.display:runAction(seq);
-- 	else
-- 		obj:runAction(seq);
-- 	end
-- end

-- --震动默认效果
-- function Tweenlite:shakeDefault(obj,callBack)
-- 	Tweenlite:shake(obj,0.5, 16,12,10, false,callBack);
-- end

-- --其他特效
-- -- CCWaves3D::actionWithWaves(5, 40, ccg(20,10), t);//波浪式，5是波浪数，40是振幅
-- -- CCFlipX3D::actionWithDuration(t);//x轴翻转
-- -- CCFlipY3D::actionWithDuration(t);//y轴翻转
-- -- CCLens3D::actionWithPosition(CCPointMake(size.width/2,size.height/2), 240, ccg(15,10), t); //放大镜，参数是中心点，半径，格，时间
-- -- CCRipple3D::actionWithPosition(CCPointMake(size.width/2,size.height/2), 240, 4, 160, ccg(32,24), t);//水波 参数是中心点，半径，波浪数，振幅，格，时间
-- -- CCLiquid::actionWithWaves(4, 20, ccg(16,12), t);//流体效果，波浪数，振幅，格，时间
-- -- CCWaves::actionWithWaves(4, 20, true, true, ccg(16,12), t);//扭曲波浪，波浪数，振幅，水平sin，竖直sin，格，时间
-- -- CCTwirl::actionWithPosition(CCPointMake(size.width/2, size.height/2), 1, 2.5f, ccg(12,8), t); //扭曲，中心点，扭曲数，振幅，格，时间
-- -- CCShakyTiles3D::actionWithRange(5, true, ccg(16,12), t) ;//水波，范围，是否z轴，格，时间
-- -- CCShatteredTiles3D::actionWithRange(5, true, ccg(16,12), t);//破碎歪曲，范围，是否z轴，格，时间
-- -- CCShuffleTiles::actionWithSeed(25, ccg(16,12), t);//打散
-- -- CCFadeOutTRTiles::actionWithSize(ccg(16,12), t);//顶右淡出
-- -- CCFadeOutBLTiles::actionWithSize(ccg(16,12), t);//底左淡出
-- -- CCFadeOutUpTiles::actionWithSize(ccg(16,12), t);//向上淡出
-- -- CCFadeOutDownTiles::actionWithSize(ccg(16,12), t);//向下淡出
-- -- CCTurnOffTiles::actionWithSeed(25, ccg(48,32) , t);//方块消失
-- -- CCWavesTiles3D::actionWithWaves(4, 120, ccg(15,10), t);//方块波浪
-- -- CCJumpTiles3D::actionWithJumps(2, 30, ccg(15,10), t);//跳跃方块
-- -- CCSplitRows::actionWithRows(9, t);//切开行
-- -- CCSplitCols::actionWithCols(9, t);//切开列
-- -- CCPageTurn3D::actionWithSize(ccg(15,10), t);//翻页

-- -- CCTransitionJumpZoom 原场景缩小弹出，新场景放大弹入
-- -- CCTransitionProgressRadialCCW 逆时针切换
-- -- CCTransitionProgressRadialCW 顺时针切换
-- -- CCTransitionProgressHorizontal 水平向右切换
-- -- CCTransitionProgressVertical 垂直向下切换
-- -- CCTransitionProgressInOut 从里向外切换
-- -- CCTransitionProgressOutIn 从外向里切换
-- -- CCTransitionProgressCrossFade 原场景慢慢消失，新场景同时慢慢出现
-- -- CCTransitionPageForward翻页，下一页
-- -- CCTransitionPageBackward 翻页，前一页
-- -- CCTransitionFadeTR 方块切换 左下角
-- -- CCTransitionFadeBL 方块切换 右上角
-- -- CCTransitionFadeUp 从下向上的百叶窗
-- -- CCTransitionFadeDown 从上向下的百叶窗 
-- -- CCTransitionTurnOffTiles 方块切换，到处都是
-- -- CCTransitionSplitRows 分离的矩形横向切换
-- -- CCTransitionSplitCols 分离的矩形纵向切换
-- -- CCTransitionFade 渐变消失（变黑），渐变出现
-- -- FadeWhiteTransition 渐变消失（变白），渐变出现
-- -- FlipXLeftOver 整体横向翻转，从左往右
-- -- FlipXRightOver 整体横向翻转，从右往左
-- -- FlipYUpOver 整体纵向翻转，从上往下
-- -- FlipYDownOver 整体纵向翻转，从下往上
-- -- FlipAngularLeftOver 整体斜向翻转，从左往右
-- -- FlipAngularRightOver 整体斜向翻转，从右往左
-- -- ZoomFlipXLeftOver 整体横向翻转，从左往右，并且根据离视野远近缩放大小
-- -- ZoomFlipXRightOver整体横向翻转，从右往左，并且根据离视野远近缩放大小
-- -- ZoomFlipYUpOver整体纵向翻转，从上往下，并且根据离视野远近缩放大小
-- -- ZoomFlipYDownOver整体纵向翻转，下往上，并且根据离视野远近缩放大小
-- -- ZoomFlipAngularLeftOver 整体斜向翻转，从左往右，并且根据离视野远近缩放大小
-- -- ZoomFlipAngularRightOver 整体斜向翻转，从右往左，并且根据离视野远近缩放大小
-- -- CCTransitionShrinkGrow 原场景往后方缩小消失，新场景从后方往前放到出现
-- -- CCTransitionRotoZoom 原场景螺旋式往后方缩小消失，新场景螺旋式往前方放大出现
-- -- CCTransitionMoveInL 新场景从左向右移入
-- -- CCTransitionMoveInR 新场景从右向左移入
-- -- CCTransitionMoveInT 新场景从上向下移入
-- -- CCTransitionMoveInB 新场景从下向上移入
-- -- CCTransitionSlideInL 新旧场景同时从左向右移动
-- -- CCTransitionSlideInR新旧场景同时从右向左移动
-- -- CCTransitionSlideInT新旧场景同时从上向下移动
-- -- CCTransitionSlideInB新旧场景同时从下向上移动
-- -- CCTransitionJumpZoom 原场景缩小跳走，新场景缩小跳进


