Handler_9_11 = class(Command);

function Handler_9_11:execute()
	uninitializeSmallLoading();
end

Handler_9_11.new():execute();