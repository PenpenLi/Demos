--region *.lua
--Date 2016/5/27
--此文件由[BabeLua]插件自动生成
-- FordFan
--endregion

StatisticsManager = class();

StatisticsManager.s_gameType = 
{
    [2] = "console_room";
    [5] = "online_room";
    [8] = "endgame_room";
}

StatisticsManager.s_levelType = 
{
    [0] = nil;
    [201] = "primary";
    [202] = "middle";
    [203] = "master";

}

--StatisticsManager.s_invitePLayChess = 
--{
--    [1] = "qq";
--    [2] = "wechat";
--    [3] = "chat";
--}


--PHP统计的参数与友盟统计的参数不一样
StatisticsManager.SHARE_WAY_QQ = "qq";
StatisticsManager.SHARE_WAY_WECHAT = "wexin";
StatisticsManager.SHARE_WAY_PYQ = "wexin";
StatisticsManager.SHARE_WAY_SMS = "sms";
StatisticsManager.SHARE_WAY_WEIBO = "weibo";
StatisticsManager.SHARE_WAY_CHAT = "chat";

function StatisticsManager.getInstance()
    if not StatisticsManager.s_instance then
		StatisticsManager.s_instance = new(StatisticsManager);
	end
	return StatisticsManager.s_instance;
end

function StatisticsManager.releaseInstance()
	delete(StatisticsManager.s_instance);
	StatisticsManager.s_instance = nil;
end

function StatisticsManager:ctor()
    
    EventDispatcher.getInstance():register(Event.Call,self,self.onNativeCallDone);
end

function StatisticsManager:dtor()
    

end

--[[
    统计到友盟
    参数: event_id 事件id 
          param 自定义后缀（子参数）
--]]
function StatisticsManager:onCountToUM(event_id, param)
    if not event_id then return end
    if not param then return end
    local event_info = event_id .. "," .. param;

    sys_set_int("win32_console_color",10);
    print_string("on_event_stat = " .. event_info);
    sys_set_int("win32_console_color",9);

    dict_set_string(ON_EVENT_STAT , ON_EVENT_STAT .. kparmPostfix , event_info);
    call_native(ON_EVENT_STAT);
end

--[[
    统计到PHP
    参数: event_id 事件id 
          param 自定义后缀（子参数）
--]] 
function StatisticsManager:onCountToPHP(event,info)
    if not event or not info then return end

    sys_set_int("win32_console_color",10);
    print_string("on_event_stat = " .. event);
    sys_set_int("win32_console_color",9);

    local post_data = {}
    post_data.param = {}
    post_data.param.mid = UserInfo.getInstance():getUid();
    post_data.param.event = event;
    post_data.param.sub_event = info;
    HttpModule.getInstance():execute(HttpModule.s_cmds.countToPHP,post_data);
end


function StatisticsManager:onCountNewUserSkip(gameType)
    local event = "user_guide";
    local param = StatisticsManager.s_gameType[gameType];
    self:onCountToPHP(event,gameType);
--    self:onCountToUM(NEW_USER_SKIP_EVENT,param);
end

function StatisticsManager:onCountQuickPlay(gotoRoom)
    local event = "quick_start";
    local roomLevel = tonumber(gotoRoom.level); 
    self:onCountToPHP(event,roomLevel);
--    local param = StatisticsManager.s_levelType[index];
--    self:onCountToUM(QUICK_START_ONLINE,param);
end

function StatisticsManager:onCountInvitePlayChess(way)
    local event = "flight_invite";
--    local param = StatisticsManager.s_invitePLayChess[index];
    self:onCountToPHP(event,way);
----    self:onCountToUM(QUICK_START_ONLINE,param);
end

function StatisticsManager:onCountInviteFriends(way)

    local event = "game_share";
--    local event = "flight_invite";
    self:onCountToPHP(event,way);
--    local param = StatisticsManager.s_invitePLayChess[index];
--    local event = "flight_invite";
--    self:onCountToPHP(event,param);
----    self:onCountToUM(QUICK_START_ONLINE,param);
end

function StatisticsManager:onCountShare(event,way)
    if not event or not way then return end
    self:onCountToPHP(event,way);
--    local param = StatisticsManager.s_invitePLayChess[index];
--    local event = "flight_invite";
--    self:onCountToPHP(event,param);
----    self:onCountToUM(QUICK_START_ONLINE,param);
end


--function StatisticsManager:onCallBackToCount(status,json_data)


--end

--function StatisticsManager.onNativeCallDone(param , ...)
--	if self.s_nativeEventFuncMap[param] then
--		self.s_nativeEventFuncMap[param](self,...);
--	end
--end

----本地事件 包括lua dispatch call事件
--StatisticsManager.s_nativeEventFuncMap = {
--    [kCountToPHP]                            = StatisticsManager.onCallBackToCount;
--};

--StatisticsManager.s_nativeEventFuncMap = CombineTables(ChessController.s_nativeEventFuncMap,
--	StatisticsManager.s_nativeEventFuncMap or {});