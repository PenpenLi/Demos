
-- 报活
Handler_1_6 = class(Command);

function Handler_1_6:execute()
	sendMessage(1,6);
end

Handler_1_6.new():execute();