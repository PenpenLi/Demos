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
	if not paymentList or (paymentList and #paymentList <= 0) then return end

	local max = paymentList[1]

	for i,v in ipairs(paymentList) do
		if max < v then
			max = v
		end 
	end
	
	local tmp = {}
	for i,v in ipairs(paymentList) do
		tmp[v] = true
	end

	local finalNumber = 0
	for index = 1, max do
		local pay = tmp[index]
		local num = pay and math.pow(2, index - 1) or 0
		finalNumber = finalNumber + num
	end
	
	return finalNumber
end

function PaymentDCUtil:sendAndroidRmbPayStart(dcAndroidInfo)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "payment",
						sub_category = "start",
						pay_id = dcAndroidInfo.payId,
						goods_id = dcAndroidInfo.goodsId,
						goods_type = dcAndroidInfo.goodsType})
end

function PaymentDCUtil:sendAndroidWindMillPayStart(dcAndroidInfo)
	-- if not __ANDROID then return end
	-- DcUtil:UserTrack({category = "pay",
	-- 					sub_category = "start",
	-- 					pay_id = dcAndroidInfo.payId,
	-- 					goods_id = dcAndroidInfo.goodsId,
	-- 					goods_type = dcAndroidInfo.goodsType})
end

--result：支付结果 详见AndroidRmbPayResult
--error_code：SDK失败错误码 
--type_default：玩家设置（或默认）的优先支付方式 
--type_list1：玩家首次支付可选的支付方式（风车币；短代，三方） 
--type_list2：重买面板上可选的支付方式（短代，三方）   
--type_status：为什么走到这一步，显示了当前展示的这些支付方式 
--type_choose：当次支付玩家选择的支付方式（风车币；短代，三方） 
--pay_id：当次支付编号 
--goods_id：最终购买的商品id 
--goods_type：最终购买的商品类型 
--goods_num：最终购买的商品数量 
--price：消耗的人民币总额 
--times：第几次尝试购买当前物品（同一个payID）  
--current_stage：支付发生时玩家所在关卡（高级精力瓶、风车币、周赛次数等按玩家最高关算） 
--level：玩家当前最高关 
--province：玩家当前省份，国外= 空 
--type_display:支持QQ钱包的实验用户的6种展示弹窗:1="微信-支付宝"2="微信-QQ钱包"3="支付宝-QQ钱包"4="支付宝-微信"5=“QQ钱包-微信”6=“QQ钱包-支付宝”
--version：打点的版本号（1） 
function PaymentDCUtil:sendAndroidRmbPayEnd(dcAndroidInfo)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "payment",
						sub_category = "end",
						result = dcAndroidInfo.result,
						error_code = dcAndroidInfo.errorCode,
						type_default = dcAndroidInfo.typeDefault,
						type_list1 = dcAndroidInfo.typeList1,
						type_list2 = dcAndroidInfo.typeList2,
						type_status = dcAndroidInfo.typeStatus,
						type_choose = dcAndroidInfo.typeChoose,
						pay_id = dcAndroidInfo.payId,
						goods_id = dcAndroidInfo.goodsId,
						goods_type = dcAndroidInfo.goodsType,
						goods_num = dcAndroidInfo.goodsNum,
						price = dcAndroidInfo.price,
						times = dcAndroidInfo.times,
						current_stage = dcAndroidInfo.currentStage,
						level = dcAndroidInfo.topLevel,
						province = dcAndroidInfo.province,
						type_display = dcAndroidInfo.typeDisplay,
						version = dcAndroidInfo.version})
end

function PaymentDCUtil:sendAndroidPayCheckFailed(dcAndroidInfo)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "payment",
						sub_category = "check_fail",
						type_choose = dcAndroidInfo.typeChoose,
						pay_id = dcAndroidInfo.payId,
						goods_id = dcAndroidInfo.goodsId,
						goods_type = dcAndroidInfo.goodsType,
						province = dcAndroidInfo.province,
						version = dcAndroidInfo.version})
end

--result：支付结果 详见DCWindmillPayResult
function PaymentDCUtil:sendAndroidWindmillPayEnd(dcAndroidInfo)
	if not __ANDROID then return end
	local curHappyCoin = UserManager:getInstance().user:getCash()
	DcUtil:UserTrack({category = "payment",
						sub_category = "end_wm",
						result = dcAndroidInfo.result,
						error_code = dcAndroidInfo.errorCode,
						type_choose = dcAndroidInfo.typeChoose,
						pay_id = dcAndroidInfo.payId,
						goods_id = dcAndroidInfo.goodsId,
						goods_type = dcAndroidInfo.goodsType,
						goods_num = dcAndroidInfo.goodsNum,
						price = dcAndroidInfo.price,
						surplus = curHappyCoin,
						current_stage = dcAndroidInfo.currentStage,
						level = dcAndroidInfo.topLevel,
						version = dcAndroidInfo.version})
end


--from：（手动设置才打的点，系统设置为空） 
--0=从设置按钮点入，1=从支付方式告知面板点入
--former：原支付方式 
--current：新支付方式 
--operate：手动/系统切换 
--0=玩家手动切换；1=成功支付三方，系统切换为三方; 2=短代连续成功支付3次，系统切换为短代; 3=玩家当前默认不可用 系统自动切换
function PaymentDCUtil:sendDefaultPaymentChange(from, former, current, operate)
	if not __ANDROID then return end
	DcUtil:UserTrack({category = "pay",
						sub_category = "alter",
						from = from,
						former = former,
						current = current,
						operate = operate})
end