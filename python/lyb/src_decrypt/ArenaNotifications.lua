
ArenaNotifications={
                          ARENA_INIT_COMMOND="Arena_Init_Command",
                          ARENA_CLOSE_COMMOND="arenaCloseCommond",
                          TO_RANK_LIST="toRankList"
                          };

ArenaNotification=class(Notification);

function ArenaNotification:ctor(type_string,data)
	self.class = ArenaNotification;
	self.type = type_string;
  self.data = data;
end