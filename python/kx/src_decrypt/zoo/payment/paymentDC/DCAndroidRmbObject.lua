
DCAndroidRmbObject = class()

AndroidRmbPayResult = table.const{
	kSuccess = 0,
	kNoPaymentAvailable = 1,
	kNoNet = 2,
	kDoOrderFail = 3,
	kSmsPermission = 4,
	kSdkInitFail = 5,
	kSdkFail = 6,
	kSdkCancel = 7,
	kCloseDirectly = 8,
	kCloseAfterNoNet = 9,
	kCloseAfterNoPaymentAvailable = 10,		--仅用于最终阶段加五步面板
	kCloseRepayPanel = 11,
}

function DCAndroidRmbObject:ctor()
	self.payId = nil				--
	self.result = nil
	self.errorCode = nil
	self.typeDefault = nil			--
	self.typeList1 = nil
	self.typeList2 = nil
	self.typeStatus = nil				--
	self.typeChoose = nil
	self.goodsId = nil					--
	self.goodsType = nil				--
	self.goodsNum = nil					--
	self.price = nil							
	self.times = nil				--
	self.currentStage = nil			--
	self.topLevel = nil				--
	self.province = nil				--
	self.typeDisplay = nil
	self.version = nil				--
end

function DCAndroidRmbObject:init()
	self.payId = PaymentDCUtil.getInstance():getNewPayID()
	self.typeDefault = PaymentManager:getInstance():getDefaultPayment()
	self.times = 0
	self.topLevel = UserManager.getInstance().user:getTopLevelId()
	local scene = Director.sharedDirector():getRunningScene()
	if scene and scene:is(GamePlaySceneUI) then 
		self.currentStage = scene.levelId
	else
		self.currentStage = -1
	end
	self.province = Cookie.getInstance():read(CookieKey.kLocationProvince)
	self.version = 2
	return true	
end

function DCAndroidRmbObject:getUniquePayId()
	return self.payId
end

function DCAndroidRmbObject:setTypeDisplay( typeDisplay )
	self.typeDisplay = typeDisplay
end

function DCAndroidRmbObject:setResult(result, errorCode)
	self.result = result
	self.errorCode = errorCode	
end

function DCAndroidRmbObject:getResult()
	return self.result
end

function DCAndroidRmbObject:setInitialTypeList(paymentTypeTable, singlePaymentType)
	local finalTable = {}
	if paymentTypeTable then 
		if type(paymentTypeTable) == "number" then 
			table.insert(finalTable, paymentTypeTable)
		elseif type(paymentTypeTable) == "table" then 
			finalTable = table.clone(paymentTypeTable)
		end
	end
	if singlePaymentType and not table.includes(finalTable, singlePaymentType) then 
		table.insert(finalTable, singlePaymentType)
	end
	self.typeList1 = PaymentDCUtil.getInstance():getAlterPaymentList(finalTable)
end

function DCAndroidRmbObject:setRepayTypeList(paymentTypeTable)
	local finalTable = {}
	if paymentTypeTable then 
		if type(paymentTypeTable) == "number" then 
			table.insert(finalTable, paymentTypeTable)
		elseif type(paymentTypeTable) == "table" then 
			finalTable = paymentTypeTable
		end
	end
	self.typeList2 = PaymentDCUtil.getInstance():getAlterPaymentList(finalTable)
end

function DCAndroidRmbObject:setTypeStatus(typeStatus)
	self.typeStatus = typeStatus
end

function DCAndroidRmbObject:setTypeChoose(typeChoose)
	self.typeChoose = typeChoose
end

function DCAndroidRmbObject:setGoodsId(goodsId)
	self.goodsId = goodsId
end

function DCAndroidRmbObject:setGoodsType(goodsType)
	self.goodsType = goodsType
end

function DCAndroidRmbObject:setGoodsNum(goodsNum)
	self.goodsNum = goodsNum
end

function DCAndroidRmbObject:setRmbPrice(price)
	self.price = price
end

function DCAndroidRmbObject:increaseTimes()
	self.times = self.times + 1	
end

function DCAndroidRmbObject:create()
	local dcObj = DCAndroidRmbObject.new()
	if dcObj:init() then 
		return dcObj
	else
		dcObj = nil
	end
end