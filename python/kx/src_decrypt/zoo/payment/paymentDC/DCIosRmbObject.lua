
DCIosRmbObject = class()

IosRmbPayResult = table.const{
	kSuccess = 0,
	kSdkFail = 1,
	kSdkCancel = 2,
	kCloseDirectly = 3,
	kCloseAfterSdkFail = 4,
}

function DCIosRmbObject:ctor()
	self.payId = nil				--
	self.result = nil
	self.errorCode = nil
	self.goodsId = nil					--
	self.goodsType = nil				--
	self.goodsNum = nil					--
	self.price = nil							
	self.times = nil				--
	self.currentStage = nil			--
	self.topLevel = nil				--
	self.province = nil				--
	self.version = nil				--
end

function DCIosRmbObject:init()
	self.payId = PaymentIosDCUtil.getInstance():getNewIosPayID()
	self.topLevel = UserManager.getInstance().user:getTopLevelId()
	local scene = Director.sharedDirector():getRunningScene()
	if scene and scene:is(GamePlaySceneUI) then 
		self.currentStage = scene.levelId
	else
		self.currentStage = -1
	end
	self.province = Cookie.getInstance():read(CookieKey.kLocationProvince)
	self.version = 1
	return true	
end

function DCIosRmbObject:getUniquePayId()
	return self.payId
end

function DCIosRmbObject:setResult(result, errorCode)
	self.result = result
	self.errorCode = errorCode	
end

function DCIosRmbObject:getResult()
	return self.result
end

function DCIosRmbObject:setGoodsId(goodsId)
	self.goodsId = goodsId
end

function DCIosRmbObject:setGoodsType(goodsType)
	self.goodsType = goodsType
end

function DCIosRmbObject:setGoodsNum(goodsNum)
	self.goodsNum = goodsNum
end

function DCIosRmbObject:setRmbPrice(price)
	self.price = price
end

function DCIosRmbObject:create()
	local dcObj = DCIosRmbObject.new()
	if dcObj:init() then 
		return dcObj
	else
		dcObj = nil
	end
end