QRManager = {}

function QRManager:generatorQRNode( str, size, frameNum )
	return QRLuaEncode:generatorQRNode(str, size, frameNum)
end

function QRManager:startQRScanning( callback, tip1, tip2 )
	if __ANDROID then
		self:androidStartQRScanning(callback, tip1, tip2)
	elseif __IOS then
		self:iosStartQRScanning(callback, tip1, tip2)
	elseif __WP8 then
		self:wp8StartQRScanning(callback, tip1, tip2)
	else
		print("not support!!!")
	end
end

function QRManager:getJavaManager( ... )
	if self.qr_java_manager == nil then
		self.qr_java_manager = luajava.bindClass('com.happyelements.android.qrcode.QRCodeManager')
	end

	return self.qr_java_manager
end

function QRManager:isQRScanning( ... )
	--only android, handle KeyBack click event
	if __ANDROID then
		return self:getJavaManager():getQRScanning()
	else
		return false
	end
end

function QRManager:wp8StartQRScanning( callback, tip1, tip2 )
	local callback_func = function ( code, result )
		if code == 1 then
			callback.onSuccess(result)
		elseif code == 2 then
			callback.onFail()
		elseif code == 3 then
			callback.onCancel()
		else
			callback.onFail()
		end
	end
	QRWP8Utils:getInstance():startQRScanning(callback_func, tip1, tip2)
end

function QRManager:onKeyBackClicked( ... )
	if __ANDROID then
		local QRCodeManager = self:getJavaManager()
		QRCodeManager:get():onKeyBackClicked()
		self.callback.onCancel()
	end
end

function QRManager:androidStartQRScanning( callback, tip1, tip2 )
	print("androidStartQRScanning....")
	local QRCallback = luajava.createProxy("com.happyelements.android.InvokeCallback", {
        onSuccess = function (result)
            callback.onSuccess(result)
        end,
        onError = function (code, errMsg)
           callback.onFail(code, errMsg)
        end,
        onCancel = function ()
           callback.onCancel()
        end
    });

    self.callback = callback

	local QRCodeManager = self:getJavaManager()
	QRCodeManager:startQRScanning(QRCallback, tip1, tip2)
end

function QRManager:iosStartQRScanning( callback, tip1, tip2 )
	print("iosStartQRScanning....")
	waxClass{"SimpleCallbackDelegate", "NSObject", protocols = {"SimpleCallbackDelegate"}}
	SimpleCallbackDelegate.onSuccess = function(self, tab) callback.onSuccess(tab.result) end
	SimpleCallbackDelegate.onFailed = callback.onFail
	SimpleCallbackDelegate.onCancel = callback.onCancel
	QRCodeReader:readQRCode(SimpleCallbackDelegate:init(), tip1, tip2)
end