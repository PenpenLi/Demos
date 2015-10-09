--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

MacroCommand=class(Command);

function MacroCommand:ctor()
  self.class=MacroCommand;
  self.subCommands={};
end

function MacroCommand:addSubCommand(sub_command_class)
  if nil==sub_command_class then
		error("wrong invoke");
	end
	
	local rawClass = sub_command_class;
	while rawClass do
		if rawClass == Command then
			
		elseif nil==rawClass then
			error("wrong invoke");
		end
		rawClass = rawClass.super;
	end
  
  table.insert(self.subCommands,sub_command_class);
end

function MacroCommand:complete(notification)
  for k,v in pairs(self.subCommands) do
		local subCommand=v.new();
		subCommand:execute(notification);
	end
	self.subCommands={};
end