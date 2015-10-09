--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

ViewObserver=class(Object);

function ViewObserver:ctor()
	self.class=ViewObserver;
	self.commands={};
end

function ViewObserver:cutDown(notification)
  local commands={};
  for k,v in pairs(self.commands) do
    commands[k]=v;
  end
  for k,v in pairs(commands) do
    local command=v.new();
    command:execute(notification);
  end
end

function ViewObserver:observe(command_class)
  local rawClass=command_class;
  while rawClass do
	if rawClass==Command then
	  break;
	end
	rawClass=rawClass.super;
  end
  if nil==rawClass then
	error("wrong invoke");
  end
  for k,v in pairs(self.commands) do
  	if v==command_class then
  		return;
  	end
  end
  table.insert(self.commands,command_class);
end

function ViewObserver:unobserve(command_class)
  for k,v in pairs(self.commands) do
  	if v==command_class then
  		table.remove(self.commands,k);
  		break;
  	end
  end
end