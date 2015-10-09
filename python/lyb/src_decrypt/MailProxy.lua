MailProxy=class(Proxy);

function MailProxy:ctor()
  self.class=MailProxy;
  self.skeleton=nil;
  self.data={MailArray={},IDArray={}};
end

rawset(MailProxy,"name","MailProxy");

function MailProxy:refreshData(mailArray, idArray)
	local function sortFunc(data1, data2)
		return data1.DateTime > data2.DateTime;
	end
	for k,v in pairs(mailArray) do
		self:refreshDataItem(v);
	end
	for k,v in pairs(idArray) do
		self:deleteDataItem(v.ID);
	end
	table.sort(self.data.MailArray,sortFunc);
end

function MailProxy:refreshDataDelete(idArray)
	for k,v in pairs(idArray) do
		self:deleteDataItem(v.ID);
	end
end

function MailProxy:refreshDataItem(mailData)
	for k,v in pairs(self.data.MailArray) do
		if mailData.MailId == v.MailId then
			for _k,_v in pairs(mailData) do
				v[_k]=_v;
			end
			return;
		end
	end
	table.insert(self.data.MailArray,mailData);
end

function MailProxy:deleteDataItem(id)
	for k,v in pairs(self.data.MailArray) do
		if id == v.MailId then
			table.remove(self.data.MailArray,k);
			break;
		end
	end
end

function MailProxy:getData()
	return self.data;
end

function MailProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("mail_ui");
  end
  return self.skeleton;
end

-- 点击邮件操作后数据更新
function MailProxy:mailOperation(mailId,param)

	local mailVO
	for k,v in pairs(self.data.MailArray) do
		if v.MailId == mailId then
			mailVO = self.data.MailArray[k]
			break
		end
	end

	if nil == mailVO then
		return
	end
	
	if param == 1 then --read
		mailVO.ByteState = 1
		-- if mailVO.ByteType == 1 then 
		-- 	-- self:deleteDataItem(mailId)
		-- elseif mailVO.ByteType == 2 then -- 持续性的改状态
		-- 	mailVO.ByteState = 1
		-- end
	elseif param == 2 then -- get
		self:deleteDataItem(mailId)
		-- if mailVO.ByteType == 1 then -- 一次性的直接删
		-- 	self:deleteDataItem(mailId)
		-- elseif mailVO.ByteType == 2 then 
		-- 	self:deleteDataItem(mailId)
		-- end
	end
end

-- 判断是否有邮件需要红点提示
function MailProxy:isRedDotVisible()
	local returnBoo = false
	for k,v in pairs(self.data.MailArray) do
		if v.ByteState == 0
		or 0 ~= table.getn(v.ItemIdArray) then 
			returnBoo = true
			break;
		end
	end	
	return returnBoo
end