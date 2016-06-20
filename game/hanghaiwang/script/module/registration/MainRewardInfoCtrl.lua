-- FileName: MainRewardInfoCtrl.lua
-- Author: lizy
-- Date: 2014-04-00
-- Purpose: 签到获取物品
--[[TODO List]]

module("MainRewardInfoCtrl", package.seeall)

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MainRewardInfoCtrl"] = nil
end

function moduleName()
    return "MainRewardInfoCtrl"
end

function create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend)

	local b1 = (not vipLevel) or (not beishu)
	
	local b2 = (tonumber(MainRegistrationData.getSignInNum()) ~= tonumber(time) and tonumber(sppend) == 0) 
	
	
	if(b1 or b2) then
		require "script/module/registration/MainRewardInfoView"
		MainRewardInfoView.create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend,true)
	else
		local pL = tonumber(vipLevel) or 0
		local mVip = tonumber(UserModel.getVipLevel()) or 0
    	local isVipEnough =  pL <= mVip
   		logger:debug("wm----bget : " .. tostring(bget))
		if((tonumber(bget) == 1)) then
			local pLast = tonumber(DataCache.getNorSignCurInfo().last_vip) or 0
	    	-- local isGetVip = (tonumber(pLast) == tonumber(mVip)) and (tonumber(pL) <= tonumber(mVip)) and (tonumber(mVip) ~= 0)
			local isGetVip = pL <= pLast and pL <= mVip
	   		logger:debug("wm----isGetVip : " .. tostring(isGetVip))
			if(isGetVip) then
				require "script/module/registration/MainRewardInfoView"
				MainRewardInfoView.create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend,true)
			else
				if(isVipEnough) then
					require "script/module/registration/MainRewardInfoExtraView"
					MainRewardInfoExtraView.create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend)
				else
					require "db/i18n"
					local pShowText = gi18n[2637] .. pL .. gi18n[2638] .. gi18n[2639]
					local function fnGoCharge( sender ,eventType )
						if (eventType == TOUCH_EVENT_ENDED) then
						    AudioHelper.playCommonEffect()
						    --前往充值
						    logger:debug("wm----前往充值")
						    LayerManager.removeLayout()
			    			require "script/module/IAP/IAPCtrl"
							LayerManager.addLayout(IAPCtrl.create())
						end
					end
					local layDlg = UIHelper.createCommonDlg(pShowText,nil,fnGoCharge,nil)
					LayerManager.addLayout(layDlg)
				end
			end
		else
			if(isVipEnough) then
				require "script/module/registration/MainRewardInfoVipView"	
				MainRewardInfoVipView.create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend)
			else	
				require "script/module/registration/MainRewardInfoView"
				MainRewardInfoView.create(color,name,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend , false)
			end
		end
	end
end
