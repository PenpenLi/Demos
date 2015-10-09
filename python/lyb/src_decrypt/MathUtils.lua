--=====================================================
-- 计算
-- by jiaxin.zhang
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  RandomUtil.lua
-- author:    jiaxin.zhang
-- e-mail:    jiaxin.zhang@happyelements.com
-- created:   2013/09/16
-- descrip:   计算处理
--=====================================================

MathUtils = {};

MathUtils.count = 0;
function MathUtils:setSeed(seed)
	self.count = 0;
	JavaRandomUtil:sharedUtil():setSeed(seed);
end

function MathUtils:setBattleField(battleField)
	self.battleField = battleField
end

function MathUtils:disPose()
	self.battleField = nil
end

-- 取随机数
-- 填一个只取从1到startValue之间
-- 填2个取两个之间
function MathUtils:random(startValue, endValue)
	self.count = self.count  + 1;
	local _start = 0;
	local _end = 0;

	if endValue then
		_start = startValue;
		_end = endValue;
	else
		_start = 1;
		_end = startValue;
	end

	assert(_start <= _end,"_start is bigger than _end");
	if _start == _end then 
		return _start;
	end
	local interval = _end - _start;
	--log("============================interval=========================="..interval)
	local randomValue = JavaRandomUtil:sharedUtil():nextInt(interval);
	-- log("MathUtil:random: count: " .. self.count .. " value: " .. randomValue);
	BattleUtils:writelog("random index=" .. self.count.. " value=" .. randomValue);
	self.battleField:addRandomValue(_start + randomValue)
	return _start + randomValue;
end

-- 检查是否发生
function MathUtils:checkHappen(value)
	local randomValue = self:random(0, BattleConstants.HUNDRED_THOUSAND);
	return randomValue <= value,randomValue;
end