--ÿ��proxy ������һ��lua�ļ���װ��ʼ����ʵ�Ǻ��˷ѵġ����Ծ������һ���ļ����档

require "main.model.ShadowProxy";

CommonDataInitialize=class(Command);

function CommonDataInitialize:ctor()
	self.class=CommonDataInitialize;
end

function CommonDataInitialize:execute()
	--ShadowProxy
  local shadowProxy=ShadowProxy.new();
  self:registerProxy(shadowProxy:getProxyName(),shadowProxy);
end