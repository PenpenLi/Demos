--=====================================================
-- 名称：     游戏打开速度工具类
-- @authors： 赵新
-- @mail：    xianxin.zhao@happyelements.com
-- @website： http://www.cnblogs.com/tinytiny/
-- @date：    2014-03-15 16:43:50
-- @descrip： 游戏初始化各个部分用时工具类
-- All Rights Reserved. 
--=====================================================
OpenSpeedUtils = {};

OpenSpeedUtils.typeTb = {};   ----{"panel" = 1111,"page" = 2222}

--	记录起始时间
--	type:	分析初始化类型。如：界面、page等等
function OpenSpeedUtils:addBeginStat(type)
	if not clientGates.consoleShow then return; end;
	local tb = OpenSpeedUtils.typeTb;
	if tb[type] then
		TdLuaUtil:trace_assert("重复使用addBeinStat: "..type);
	else
		tb[type] = getCurrentTime();
	end
end

--	记录终止时间
--	type:			分析初始化类型。如：界面、page等等
function OpenSpeedUtils:addEndStat(type)
	local tb = OpenSpeedUtils.typeTb;
	if not clientGates.consoleShow or not tb[type] then return; end;

	local endTime = getCurrentTime();
	he_log_info("----"..type.."----cost:"..(endTime - tb[type]) .. " ms");

	tb[type] = nil;
end

function addBeginTime(type)
	OpenSpeedUtils:addBeginStat(type);
end

function addEndTime(type)
	OpenSpeedUtils:addEndStat(type);
end