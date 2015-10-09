
require "core.mvc.pattern.Command";
require "core.mvc.pattern.MacroCommand";
require "core.mvc.pattern.Notification";

Controller=class(Object);

function Controller:ctor()
	self.class=Controller;
	self.commands={};
end

function Controller:hasCommand(notification_name_string, command_class)  
  local commands=self.commands[notification_name_string];
	if nil==commands then
    return false;
  else
    for k,v in pairs(commands) do
      if v==command_class then
        return true;
      end
    end
    return false;
  end
end

function Controller:registerCommand(notification_name_string, command_class)
  local rawClass = command_class;
  while rawClass do
	if rawClass == Command then
	  break;
	end
	rawClass = rawClass.super;
  end
  if nil==rawClass then
	error("wrong invoke" .. notification_name_string);
  end
	
  if self:hasCommand(notification_name_string,command_class) then
    
  else
    if self.commands[notification_name_string] then
      table.insert(self.commands[notification_name_string],command_class);
      return;
    end
    self.commands[notification_name_string]={command_class};
  end
end

function Controller:removeCommand(notification_name_string, command_class)	
	if self:hasCommand(notification_name_string,command_class) then
		for k,v in pairs(self.commands[notification_name_string]) do
			if v==command_class then
				table.remove(self.commands[notification_name_string],k);
				break;
			end
		end
	end
end

function Controller:stop()
	self.commands={};
end

function Controller:sendNotification(notification)
	if nil==notification then
		error("wrong invoke");
	end
	
	if notification:is(Notification) then
		
	else
		error("wrong invoke");
	end
	
	local commandsNotified=self.commands[notification.type];
	if nil==commandsNotified then
		return;
	end
	local commands_2={};
	for k,v in pairs(commandsNotified) do
		commands_2[k]=v;
	end
	for k,v in pairs(commands_2) do
		local command_notified=v.new();
		command_notified:execute(notification);
	end
end