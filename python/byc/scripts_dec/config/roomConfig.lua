RoomConfig = class(GameCacheData,false);
RoomConfig.ROOM_TYPE_NULL                   = 0;
RoomConfig.ROOM_TYPE_NOVICE_ROOM            = 1;
RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM      = 2;
RoomConfig.ROOM_TYPE_MASTER_ROOM            = 3;
RoomConfig.ROOM_TYPE_PRIVATE_ROOM           = 4;
RoomConfig.ROOM_TYPE_FRIEND_ROOM            = 5;
RoomConfig.ROOM_TYPE_WATCH_ROOM             = 6;
RoomConfig.ROOM_TYPE_CONSOLE_ROOM           = 7;
RoomConfig.ROOM_TYPE_ENDGATE_ROOM           = 8;


RoomConfig.TYPE_NAME = {
	[RoomConfig.ROOM_TYPE_NULL]                     = "room_type_null";                     --δ֪����
	[RoomConfig.ROOM_TYPE_NOVICE_ROOM]              = "room_type_novice_room";              --���ַ���
	[RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM]        = "room_type_intermediate_room";        --�м�����
	[RoomConfig.ROOM_TYPE_MASTER_ROOM]              = "room_type_master_room";              --��ʦ����
	[RoomConfig.ROOM_TYPE_WATCH_ROOM]               = "room_type_watch_room";               --��ս����
	[RoomConfig.ROOM_TYPE_PRIVATE_ROOM]             = "room_type_private_room";             --˽�˷���
    [RoomConfig.ROOM_TYPE_FRIEND_ROOM]              = "room_type_friend_room";              --���ѷ���
	[RoomConfig.ROOM_TYPE_CONSOLE_ROOM]             = "room_type_console_room";             --��������
    [RoomConfig.ROOM_TYPE_ENDGATE_ROOM]             = "room_type_endgate_room";             --�оַ���
}

function RoomConfig.getTypeName(ctype)
    local typeName = RoomConfig.TYPE_NAME[ctype] or RoomConfig.TYPE_NAME[RoomConfig.ROOM_TYPE_NULL];
    return typeName;
end

function RoomConfig.getInstance()
    if not RoomConfig.instance then
        RoomConfig.instance = new(RoomConfig);
    end
    return RoomConfig.instance;
end

function RoomConfig.ctor(self)
    self.m_dict = new(Dict,"room_config");
    self.m_dict:load();
end

function RoomConfig.saveRoomConfig(self,roomConfig)
	if not roomConfig then
		print_string("not roomConfig");
		return
	end
    self:saveString("room_config",json.encode(roomConfig));
    self.mRoomConfig = self:explainPHPRoomConfig(roomConfig);
end

function RoomConfig.getRoomConfig(self)
    if not self.mRoomConfig then
        local jsonStr = self:getString("room_config","");
        self.mRoomConfig = self:explainPHPRoomConfig(json.decode(jsonStr));
    end
    return self.mRoomConfig;
end

function RoomConfig.getRoomTypeConfig(self,roomType)
    local roomConfig = self:getRoomConfig();
    return roomConfig[roomType];
end

function RoomConfig.explainPHPRoomConfig(self,roomConfig)
    if type(roomConfig) ~= "table" then return {} end
    local ret = {};
    for _,value in pairs(roomConfig) do 
		local room = {};
		room.id       = tonumber(value.id);
        room.level    = tonumber(value.level);
		room.name     = value.room_name;
		room.money    = tonumber(value.basechip);
		room.minmoney = tonumber(value.min_money);
		room.maxmoney = tonumber(value.max_money);
		room.rent     = tonumber(value.rent);
		room.status   =  tonumber(value.room_status);
		room.type     = tonumber(value.type);
        room.room_type = tonumber(value.room_type);
		room.time     = value.round_time/60;
        room.undomoney = tonumber(value.huiqi_cost_money);
        room.isShow   = tonumber(value.is_show or 1);
        room.give_up_time = tonumber(value.give_up_time or 0);
		ret[room.room_type] = room;
	end
    return ret;
end

--�������ɳ��ľ�ʱ����ʱ������
function RoomConfig.setFreedomRoomTimeConfig(self,freedomRoomConfig)
    if not freedomRoomConfig then
		print_string("not freedomRoomConfig");
		return
	end

	self.mFreedomRoomSumtime = freedomRoomConfig.sumtime:get_value();
	self.mFreedomRoomSteptime = freedomRoomConfig.steptime:get_value();
	self.mFreedomRoomReadtime = freedomRoomConfig.readtime:get_value();
end

function RoomConfig.getFreedomRoomSumTime(self)
	return self.mFreedomRoomSumtime or 10*60;
end

function RoomConfig.getFreedomRoomStepTime(self)
	return self.mFreedomRoomSteptime or 2*60;
end

function RoomConfig.getFreedomRoomReadTime(self)
	return self.mFreedomRoomReadtime or 60;
end