--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-1-30

	yanchuan.xie@happyelements.com
]]

require "core.mvc.pattern.Mediator";

View=class(Object);

function View:ctor()
	self.class=View;
	self.mediators={};
end

function View:hasMediator(mediator_name_string)
	return nil~=self.mediators[mediator_name_string];
end

function View:onReconnect()
	for k,v in pairs(self.mediators) do
		v:onReconnect();
	end
end

function View:registerMediator(mediator_name_string, mediator)
	if nil==mediator then
		error("wrong invoke" .. mediator_name_string);
	end
	
	if mediator:is(Mediator) then
		
	else
		error("wrong invoke" .. mediator_name_string);
	end
	
	if nil==self.mediators[mediator_name_string] then
		self.mediators[mediator_name_string]=mediator;
		mediator:onRegister();
		return;
	end
	error("wrong invoke" .. mediator_name_string);
end

function View:removeMediator(mediator_name_string)
	if self:hasMediator(mediator_name_string) then
		self.mediators[mediator_name_string]:onRemove();
		self.mediators[mediator_name_string]=nil;
	end
end

function View:stop()
	for k,v in pairs(self.mediators) do
		self:removeMediator(k);
	end
end

function View:retrieveMediator(mediator_name_string)
	return self.mediators[mediator_name_string];
end