
DCWindmillObject = class()

DCWindmillPayResult = table.const{
	kSuccess = 0,
	kFail = 1,
	kNoWindmill = 2,
	kCloseDirectly = 3,
	kCloseAfterNoWindmill = 4,		
	kCloseAfterFail = 5,
}

function DCWindmillObject:ctor()
	self.payId = nil				--
	self.result = nil 					--
	self.errorCode = nil 				--
	self.typeChoose = nil 			--
	self.goodsId = nil					--
	self.goodsType = nil			--
	self.goodsNum = nil					--
	self.price = nil		 			--					
	self.currentStage = nil			--
	self.topLevel = nil				--
	self.version = nil				--
end

function DCWindmillObject:init()
	self.payId = PaymentDCUtil.getInstance():getNewPayID()
	self.goodsType = 1	
	self.typeChoose = Payments.WIND_MILL
	self.topLevel = UserManager.getInstance().user:getTopLevelId()
	local scene = Director.sharedDirector():getRunningScene()
	if scene and scene:is(GamePlaySceneUI) then 
		self.currentStage = scene.levelId
	else
		self.currentStage = -1
	end
	self.version = 1
	return true	
end

function DCWindmillObject:getUniquePayId()
	return self.payId
end

function DCWindmillObject:setResult(result, errorCode)
	self.result = result
	self.errorCode = errorCode	
end

function DCWindmillObject:getResult()
	return self.result
end

function DCWindmillObject:setGoodsId(goodsId)
	self.goodsId = goodsId
end

function DCWindmillObject:setGoodsType(goodsType)
	self.goodsType = goodsType
end

function DCWindmillObject:setGoodsNum(goodsNum)
	self.goodsNum = goodsNum
end

function DCWindmillObject:setWindMillPrice(price)
	self.price = price
end

function DCWindmillObject:create()
	local dcObj = DCWindmillObject.new()
	if dcObj:init() then 
		return dcObj
	else
		dcObj = nil
	end
end