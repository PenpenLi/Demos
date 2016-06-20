local IOSContactReaderDelegate = class()

function IOSContactReaderDelegate:readContact(callback)

	waxClass{"ReadContactCallback",NSObject,protocols={"ContactReaderCallback"}}
	function ReadContactCallback:onSuccess(result)
		print("type of result: "..tostring(type(result)))
		print("contact list: "..tostring(result))
		assert(type(result) == "string", "contact list must be a jsonstring!!!!!!!!" )

		--local resultStr = string.format("type of result: %s, contact list: %s", tostring(type(result)), tostring(result))

		--CommonTip:showTip(resultStr,"negative", nil, 10)

		local resultContacts = table.deserialize(result) or {}
		print("contactList from json: "..table.tostring(resultContacts))

		local contactMap = {}

		if result then
			for k,v in pairs(resultContacts) do
				local formatedPhone = k:gsub("-", "")
				formatedPhone = formatedPhone:gsub(" ", "")
	        	formatedPhone = formatedPhone:gsub("+86", "")
				if tonumber(formatedPhone) then
					contactMap[formatedPhone] = v
				end
			end
		end
		print("ReadContactCallback:onSuccess, result: ", table.tostring(contactMap))
		if self.callback then self.callback.onSuccess(contactMap) end
	end

	function ReadContactCallback:onFailed(result)
		assert(type(result) == "string", "contact list must be a jsonstring!!!!!!!!" )
		local errResult = table.deserialize(result) or {}
		print("ReadContactCallback:onFailed: ", errResult.errorCode)
		if self.callback then self.callback.onFailed(errResult.errorCode) end
	end
	
	function ReadContactCallback:onCancel()
		print("ReadContactCallback:onCancel")
		if self.callback then self.callback.onCancel() end
	end

	local readContactCallback = ReadContactCallback:init()
	readContactCallback.callback = callback

	ContactReader:readContact(readContactCallback)
end

local AndroidContactReaderDelegate = class()

function AndroidContactReaderDelegate:readContact(callback)
	    local javaCallback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
	        onSuccess = function(data) 
	        	local phoneNumber2NameMap = luaJavaConvert.map2Table(data)

	        	local filteredMap = {}
	        	for k,v in pairs(phoneNumber2NameMap) do
	        		print("contactList retrived2, phoneNO: "..tostring(k)..", name:"..tostring(v))
	        		local phoneNumber = k:gsub("-", "")
	        		phoneNumber = phoneNumber:gsub(" ", "")
	        		phoneNumber = phoneNumber:gsub("+86", "")
	        		if tonumber(phoneNumber) then
	        			filteredMap[phoneNumber] = v
	        		end
	        	end
	        	print("contactList filtered, : "..table.tostring(filteredMap))
	        	if callback.onSuccess then
	        		callback.onSuccess(filteredMap)
	        	end
	        end,
	        onError = function()
	        	if callback.onError then
	        		callback.onError(100)
	        	end
	        	--CommonTip:showTip("读取联系人信息失败！","negative")
	        end,
	        onCancel = function()
	        	if callback.onCancel then
	        		callback.onCancel()
	        	end
	    	end
	    })

		local contactReader = luajava.newInstance("com.happyelements.hellolua.ContactReader")
		contactReader:registerCallback(javaCallback)
		contactReader:readContact()
end

local Win32ContactReaderDelegate = class()

function Win32ContactReaderDelegate:readContact(callback)
			--fake data for win32 debug display
		local fakePhoneList = {
								"15311419018",
								"15001058075",
								"15311419016",
								"15101092222",
								"18600464043",
								"18612708905",
								"15101094555",
								"15101094529",
								"15201484763",
								"13581780194",
								"13345678901",
								"15101094528",
								"13581780184",
								"18401211967",
								"13581780144",
								"15101094523",
								"15101094522",
								"15201484765",
								"18600786044",
								"15811198371",
								"18310059425",
								"18611974951",
								"15101094521",
								"15200000000",
								"15201484764",
								"18627741955",
								"16388888888",
								"15311419017",
								}

		local contactlistInPhone = {}
		for i,v in ipairs(fakePhoneList) do
			contactlistInPhone[v] = "tao.zeng"..i
		end

		if callback.onSuccess then
			callback.onSuccess(contactlistInPhone)
		end
end

if __IOS then
	return IOSContactReaderDelegate
elseif __ANDROID then
	return AndroidContactReaderDelegate
else
	return Win32ContactReaderDelegate
end
