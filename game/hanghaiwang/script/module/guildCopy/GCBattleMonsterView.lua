-- FileName: GCBattleMonsterView.lua
-- Author: liweidong
-- Date: 2014-06-08
-- Purpose: 开始挑战界面
--[[TODO List]]

module("GCBattleMonsterView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
-- 模块局部变量 --
local _copyId = nil
local _baseId = nil
local _baseItemInfo = nil --据点信息
local m_i18n = gi18n

local function init(...)

end

function destroy(...)
	package.loaded["GCBattleMonsterView"] = nil
end

function moduleName()
    return "GCBattleMonsterView"
end

--国际化
function setUII18n(base)
	base.tfd_drop:setText(m_i18n[1305])
	base.tfd_power:setText(m_i18n[4311])
	base.tfd_pass_reward:setText(m_i18n[5959])--TODO
	base.BTN_ATTACK1:setTitleText(m_i18n[1308])
	UIHelper.titleShadow(base.BTN_ATTACK1)
end
--掉落预览
function fnDropPreview( ... )
	logger:debug("item reward===")
	logger:debug(_baseItemInfo["reward_item_id_simple"])
	if (_baseItemInfo["reward_item_id_simple"] ~= nil) then
		local dropIdArr = lua_string_split(_baseItemInfo["reward_item_id_simple"],",")
		for i=1,5 do
			local layDrop = _layoutMain["LAY_DROP"..i]
			if(i <= #dropIdArr) then
				local dropIds = lua_string_split(dropIdArr[i],"|")
				if (dropIds[1] ~= nil) then
					local layImage = layDrop["IMG_"..i]
					local soulItem,soulInfo = ItemUtil.createBtnByTemplateId(dropIds[1],
													function ( sender,eventType )
														if (eventType == TOUCH_EVENT_ENDED) then
															PublicInfoCtrl.createItemInfoViewByTid(tonumber(dropIds[1]))
														end
													end)
					soulItem:setTag(i)
					layImage:addChild(soulItem)
					local goodsTitle = layDrop["TFD_NAME_"..i]
					if (goodsTitle) then
						UIHelper.labelEffect(goodsTitle,soulInfo.name)
						if (soulInfo.quality ~= nil) then
							local color =  g_QulityColor[tonumber(soulInfo.quality)]
							if(color ~= nil) then
								goodsTitle:setColor(color)
							end
						end
					end
				end
			else
				layDrop:setVisible(false)
			end
		end
	else
		_layoutMain.img_bg_drop:setVisible(false)
	end
end
--初始化UI
function initUI()
	_layoutMain = g_fnLoadUI("ui/union_copy_drop.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 

	
	--头像框
	local normalTable = copy.models.normal
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(_baseItemInfo.id) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			_layoutMain.IMG_FRAME:loadTexture("images/copy/ncopy/fortpotential/"..nimgModel[1]..".png")
			_layoutMain.IMG_FRAME:setPositionType(POSITION_ABSOLUTE)
			if (tonumber(nimgModel[1])==1) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -10))
			elseif  (tonumber(nimgModel[1])==2) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -5))
			else
				_layoutMain.IMG_FRAME:setPosition(ccp(0, 1))
			end
			break
		end
	end
	--头像
	_layoutMain.IMG_HEAD:loadTexture("images/base/hero/head_icon/".._baseItemInfo.icon)

	_layoutMain.TFD_NAME:setText(_baseItemInfo.name)
	_layoutMain.TFD_POWER_NUM:setText(_baseItemInfo.cost_energy_simple)
	_layoutMain.TFD_NUM_MONEY1:setText(_baseItemInfo.coin_simple)
	_layoutMain.TFD_EXP_NUM:setText(_baseItemInfo.exp_simple*UserModel.getHeroLevel())

	fnDropPreview()
	setUII18n(_layoutMain)
	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_layoutMain.BTN_ATTACK1:addTouchEventListener(
		function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				GCBattleMonsterCtrl.onBattle(_copyId,_baseId)
			end
		end
		)

	return _layoutMain
end

function create(copyId,baseId)
	_copyId = copyId
	_baseId = baseId
	_baseItemInfo = DB_Stronghold.getDataById(_baseId)
	return initUI()
end
