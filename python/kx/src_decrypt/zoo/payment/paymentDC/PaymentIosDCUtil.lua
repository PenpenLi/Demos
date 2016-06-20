
PaymentIosDCUtil = class()
local instance = nil
function PaymentIosDCUtil.getInstance()
	if not instance then
		instance = PaymentIosDCUtil.new()
		instance:init()
	end
	return instance
end

function PaymentIosDCUtil:init()

end

--唯一支付ID
function PaymentIosDCUtil:getNewIosPayID()
	local userId = UserManager:getInstance().user.uid
	if not userId then
		userId = "12345" 
	end
	local timeStamp = os.time()
	local payId = userId.."_"..timeStamp
	return payId
end

--result：支付结果 DCIosRmbObject
function PaymentIosDCUtil:sendIosRmbPayEnd(dcIosInfo)
	if not __IOS then return end
	DcUtil:UserTrack({category = "payment",
						sub_category = "end_ios",
						result = dcIosInfo.result,
						error_code = dcIosInfo.errorCode,
						pay_id = dcIosInfo.payId,
						goods_id = dcIosInfo.goodsId,
						goods_type = dcIosInfo.goodsType,
						goods_num = dcIosInfo.goodsNum,
						price = dcIosInfo.price,
						current_stage = dcIosInfo.currentStage,
						level = dcIosInfo.topLevel,
						province = dcIosInfo.province,
						version = dcIosInfo.version})
end

--result：支付结果 详见DCWindmillPayResult
function PaymentIosDCUtil:sendIosWindmillPayEnd(dcWindmillInfo)
	if not __IOS then return end
	local curHappyCoin = UserManager:getInstance().user:getCash()
	DcUtil:UserTrack({category = "payment",
						sub_category = "end_wm",
						result = dcWindmillInfo.result,
						error_code = dcWindmillInfo.errorCode,
						type_choose = dcWindmillInfo.typeChoose,
						pay_id = dcWindmillInfo.payId,
						goods_id = dcWindmillInfo.goodsId,
						goods_type = dcWindmillInfo.goodsType,
						goods_num = dcWindmillInfo.goodsNum,
						price = dcWindmillInfo.price,
						surplus = curHappyCoin,
						current_stage = dcWindmillInfo.currentStage,
						level = dcWindmillInfo.topLevel,
						version = dcWindmillInfo.version})
end