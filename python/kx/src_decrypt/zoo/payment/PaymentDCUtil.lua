PaymentDCUtil = class()

local instance = nil
function PaymentDCUtil.getInstance()
	if not instance then
		instance = PaymentDCUtil.new()
		instance:init()
	end
	return instance
end

function PaymentDCUtil:init()

end

--唯一支付ID
function PaymentDCUtil:getNewPayID()
	local userId = UserManager:getInstance().user.uid
	if not userId then
		userId = "12345" 
	end
	local timeStamp = os.time()
	local payId = userId.."_"..timeStamp
	return payId
end

--表示可选的支付列表
function PaymentDCUtil:getAlterPaymentList(paymentList)
	local finalNumber = 0
	for i,v in ipairs(paymentList) do
		local zeroNum = v - 1
		local oneFlag = 1
		if zeroNum > 0 then 
			for i=1,zeroNum do
				oneFlag = oneFlag .. "0"
			end
		end
		finalNumber = finalNumber + tonumber(oneFlag)
	end
	finalNumber = tonumber(finalNumber, 2)
	return finalNumber
end

-- pay_type：默认支付方式 ,-2（去买风车币）、-1（去联网）、0（未知） 
-- alter_list:面板可选的支付方式 
-- pay_id：该次支付的唯一编号 
-- goods_id：商品id 
-- goods_type：商品类型 
-- goods_num：商品数量 
-- pay_source:支付来源，0（用户点击触发）、1（自动弹窗） 
-- version：版本号，默认3 
-- skip：跳过确认框，1（跳过）、0（不跳过）

function PaymentDCUtil:sendPayStart(payType, alterList, payId, goodsId, goodsType, goodsNum, paySource, isSkip)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "pay",
						sub_category = "pay_start",
						pay_type = payType,
						alter_list = alterList,
						pay_id = payId,
						goods_id = goodsId,
						goods_type = goodsType,
						goods_num = goodsNum,
						pay_source = paySource,
						version = 6,
						skip = isSkip})
end

-- pay_type：默认支付方式 ,-2（去买风车币）、-1（去联网）、0（未知） 
-- alter_list:面板可选的支付方式 
-- pay_id：该次支付的唯一编号 
-- pay_source:支付来源，0（用户点击触发）、1（自动弹窗） 
-- version：版本号，默认3
function PaymentDCUtil:sendPayChoosePop(payType, alterList, payId, paySource)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "pay",
						sub_category = "pay_choose_pop",
						pay_type = payType,
						alter_list = alterList,
						pay_id = payId,
						goods_id = goodsId,
						pay_source = paySource,
						version = 6})
end

-- pay_type：默认支付方式 ,-2（去买风车币）、-1（去联网）、0（未知）  
-- alter_list:面板可选的支付方式 
-- choose_type：选择支付方式，0为关闭 
-- pay_id：该次支付的唯一编号 
-- pay_source:支付来源，0（用户点击触发）、1（自动弹窗） 
-- version：版本号，默认3
function PaymentDCUtil:sendPayChoose(payType, alterList, chooseType, payId, paySource)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "pay",
						sub_category = "pay_choose",
						pay_type = payType,
						alter_list = alterList,
						choose_type = chooseType,
						pay_id = payId,
						goods_id = goodsId,
						pay_source = paySource,
						version = 6})
end

-- pay_type：默认支付方式 ,-2（去买风车币）、-1（去联网）、0（未知）  
-- choose_type：选择支付方式 
-- pay_id：该次支付的唯一编号 
-- goods_id：商品id 
-- goods_type：商品类型 
-- goods_num：商品数量 
-- pay_source:支付来源，0（用户点击触发）、1（自动弹窗） 
-- rmb:人民币总额 
-- cash：风车币总额 
-- result：0（成功）、1（失败）、2（SDK取消）、3（二次确认弹窗取消）、4（SDK失败或取消后取消弹窗）
-- error_code：失败错误码（失败才有） 
-- version：版本号，默认3  
-- sikp：跳过确认框，0（不跳过）、1（跳过）	
function PaymentDCUtil:sendPayEnd(payType, chooseType, payId, goodsId, goodsType, goodsNum, paySource, payRmb, payCash, payResult, errorCode, isSkip)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "pay",
						sub_category = "pay_end",
						pay_type = payType,
						choose_type = chooseType,
						pay_id = payId,
						goods_id = goodsId,
						goods_type = goodsType,
						goods_num = goodsNum,
						pay_source = paySource,
						rmb = payRmb,
						cash = payCash,
						result = payResult,
						error_code = error_code,
						version = 6,
						skip = isSkip})
end
