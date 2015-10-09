Handler_24_3 = class(Command);

function Handler_24_3:execute()
	require "main.common.LocalNoticeUtil";
	local NoticeBarArray = recvTable["NoticeBarArray"];
	for k,v in pairs(NoticeBarArray) do
		registerLocalNotification(v["ID"],1,v["Content"],v["Time"],false);
	end
end

Handler_24_3.new():execute();