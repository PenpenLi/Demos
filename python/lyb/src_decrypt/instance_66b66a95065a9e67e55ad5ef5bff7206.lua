
require "main.controller.command.data.dataInitialize.DataInitializeCommand1"
require "main.controller.command.data.dataInitialize.DataInitializeCommand2"
require "main.controller.command.data.dataInitialize.DataInitializeCommand3"
require "main.controller.command.data.dataInitialize.DataInitializeCommand4"
require "main.controller.command.data.dataInitialize.DataInitializeCommand5"
local instance = nil;
DataInitialize = {};
function DataInitialize.sharedDataInitialize()
	if not instance then
		instance = DataInitialize;
	end
	return instance;
end
function DataInitialize:initializeData(context, backFun)
	    self.backFun = backFun;
        
        self.commandTables = {};
        table.insert(self.commandTables, DataInitializeCommand1);
        table.insert(self.commandTables, DataInitializeCommand2);
        table.insert(self.commandTables, DataInitializeCommand3);
        table.insert(self.commandTables, DataInitializeCommand4);
        table.insert(self.commandTables, DataInitializeCommand5);

        local flag = 1;
        local i = 1;
        local function requireCommandBack()
            if flag%2 == 1 then
                  
                    if i > #self.commandTables then
	                    if self.requireCommandUpdateId then
	                        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.requireCommandUpdateId);
	                        
	                        self.commandTables = {};
	                    end
	                    return;
	                end

                    local command = self.commandTables[i];
                    command.new():execute();
                    
                    if self.backFun then
                        self.backFun(context);
                    end
                    i = i + 1;
            end
            flag = flag + 1;
        end
        self.requireCommandUpdateId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(requireCommandBack,0,false);
end