-- FileName: ShipStrengthSuccessView.lua
-- Author: LvNanchun
-- Date: 2015-10-21
-- Purpose: function description of module
--[[TODO List]]

ShipStrengthSuccessView = class("ShipStrengthSuccessView")

-- UI variable --
local _layMain

-- module local variable --

function ShipStrengthSuccessView:moduleName()
    return "ShipStrengthSuccessView"
end

function ShipStrengthSuccessView:ctor(...)
	_layMain = g_fnLoadUI("ui/ship_str_succeed.json")
end

function ShipStrengthSuccessView:succedTextAnimation( ... )
     AudioHelper.playEffect("audio/effect/texiao_zhandoushengli.mp3")
    local imgSucceed = _layMain.img_transfer_succeed
    imgSucceed:loadTexture("")

    -- 封装创建动画的方法
    local function fnCreateAni( pName , ploop , callback)
	    local m_arAni1 = UIHelper.createArmatureNode({
	        imagePath = "images/effect/"..pName.."/"..pName.."0.png",
	        plistPath = "images/effect/"..pName.."/"..pName.."0.plist",
	        filePath = "images/effect/"..pName.."/"..pName..".ExportJson",
	        animationName = pName,
	        loop = ploop or -1,
	        fnMovementCall = callback or nil
	    })
	    return m_arAni1
	end

    -- 文字和箭头飞入的动画
    local function fnStartNumAni( sender, MovementEventType, movementID )
	    if (MovementEventType == 1) then
	        AudioHelper.playEffect("audio/effect/texiao_jinjie_shuzi.mp3")
	        -- 一下两个table一一对应，播放动画。
	        -- 向右箭头的table
	        local tbArrow = {_layMain.IMG_LEVEL_ARROW_RIGHT,
	        	_layMain.IMG_HP_ARROW_RIGHT,
	        	_layMain.IMG_PHY_ATTACK_ARROW_RIGHT,
	        	_layMain.IMG_MAGIC_ATTACK_ARROW_RIGHT,
	        	_layMain.IMG_PHY_DENFEND_ARROW_RIGHT,
	        	_layMain.IMG_MAGIC_DENFEND_ARROW_RIGHT}
	        -- 进阶后数字的table
	        local pNums = {_layMain.TFD_AFTER_LEVEL,
	        	_layMain.TFD_AFTER_HP,
	        	_layMain.TFD_AFTER_PHY_ATTACK,
	        	_layMain.TFD_AFTER_MAGIC_ATTACK,
	        	_layMain.TFD_AFTER_PHY_DENFEND,
	        	_layMain.TFD_AFTER_MAGIC_DENFEND}
	        for i=1,#tbArrow do 
	            local wArrow = tbArrow[i]
	            if(wArrow) then
	                local pArr = CCArray:create()
	                if(i ~= 1) then
	                    pArr:addObject(CCDelayTime:create(0.05*(i-1)))
	                end
	                pArr:addObject(CCCallFuncN:create(function()
	                    wArrow:addNode(fnCreateAni("jinjie_zhizhen"))
	                    if(pNums[i]) then
	                        pNums[i]:setVisible(true)
	                        local pAni = fnCreateAni("jinjie_shuzi")
	                        pAni:setPositionX(pNums[i]:getContentSize().width*0.5)
	                        pNums[i]:addNode(pAni)
	                    end
	                end))
	                if(i == #tbArrow) then
	                    pArr:addObject(CCDelayTime:create(1))
	                    pArr:addObject(CCCallFuncN:create(function()
							MainFormationTools.fnShowFightForceChangeAni(nil, function ( ... )
								_layMain:setTouchEnabled(true)

							end)
							_layMain:setTouchEnabled(true)
	                	end))
	                end
	                wArrow:runAction(CCSequence:create(pArr))
	            end
	        end
	    end
	end

--    local m_arAni1 = fnCreateAni("jinjie_chenggong" , 0 , fnStartNumAni)
	local m_arAni1 = fnCreateAni("qianghua_chenggong" , 0 , fnStartNumAni)
    if (imgSucceed:getChildByTag(103)) then
        imgSucceed:getChildByTag(103):removeFromParentAndCleanup(true)
    end
    imgSucceed:addNode(m_arAni1,1000,103)
    local m_arAni2 = fnCreateAni("jinjie_faguang" )
    if (imgSucceed:getChildByTag(104)) then
        imgSucceed:getChildByTag(104):removeFromParentAndCleanup(true)
    end
    imgSucceed:addNode(m_arAni2, 1001,104)
end

function ShipStrengthSuccessView:createSuccedAction(  )
    performWithDelay(_layMain,function()
        self:succedTextAnimation()
    end,0.5)
end

function ShipStrengthSuccessView:create( tbStrSuccess )
	_layMain.IMG_SKY:setScaleX(g_fScaleX)
	_layMain.IMG_SKY:setScaleY(g_fScaleY)

	logger:debug({tbStrSuccess = tbStrSuccess})

	local imgShip = _layMain.IMG_SHIP
	imgShip:setVisible(false)
	local tbShipPos = ccp(imgShip:getPositionX(),imgShip:getPositionY())
	local tbShipAnchor = ccp(imgShip:getAnchorPoint().x,imgShip:getAnchorPoint().y)
	-- 设置tag为512方便之后删除
	UIHelper.addShipAnimation(_layMain.LAY_MODEL, tbStrSuccess.shipAniId, tbShipPos, tbShipAnchor, nil, 512, 513)

	_layMain.TFD_BEFORE_LEVEL:setText(tostring(tbStrSuccess.preLevel))
	_layMain.TFD_AFTER_LEVEL:setText(tostring(tbStrSuccess.preLevel + 1))
	_layMain.TFD_BEFORE_HP:setText(tbStrSuccess.preAttr[1])
	_layMain.TFD_AFTER_HP:setText(tbStrSuccess.nowAttr[1])
	_layMain.TFD_BEFORE_PHY_ATTACK:setText(tbStrSuccess.preAttr[2])
	_layMain.TFD_AFTER_PHY_ATTACK:setText(tbStrSuccess.nowAttr[2])
	_layMain.TFD_BEFORE_MAGIC_ATTACK:setText(tbStrSuccess.preAttr[3])
	_layMain.TFD_AFTER_MAGIC_ATTACK:setText(tbStrSuccess.nowAttr[3])
	_layMain.TFD_BEFORE_PHY_DENFEND:setText(tbStrSuccess.preAttr[4])
	_layMain.TFD_AFTER_PHY_DENFEND:setText(tbStrSuccess.nowAttr[4])
	_layMain.TFD_BEFORE_MAGIC_DENFEND:setText(tbStrSuccess.preAttr[5])
	_layMain.TFD_AFTER_MAGIC_DENFEND:setText(tbStrSuccess.nowAttr[5])

	-- 本次强化是否有激活天赋
	if (tbStrSuccess.nowAttr.awakeInfo) then
		_layMain.TFD_TRANSFER_AWAKE:setText(tbStrSuccess.nowAttr.awakeInfo.name)
		_layMain.TFD_AWAKE_DESC:setText(tbStrSuccess.nowAttr.awakeInfo.desc)
		UIHelper.labelNewStroke(_layMain.TFD_TRANSFER_AWAKE, ccc3(0xea, 0x32, 0x00), 3)
		UIHelper.labelNewStroke(_layMain.TFD_AWAKE_DESC, ccc3(0x28, 0x00, 0x00), 2)
	else
		_layMain.TFD_TRANSFER_AWAKE:setVisible(false)
		_layMain.TFD_AWAKE_DESC:setVisible(false)
		_layMain.img_awake_ability:setVisible(false)
	end

	-- 播放特效动画
	-- 播放之前将对应控件隐藏
	_layMain.TFD_AFTER_LEVEL:setVisible(false)
	_layMain.TFD_AFTER_HP:setVisible(false)
	_layMain.TFD_AFTER_PHY_ATTACK:setVisible(false)
	_layMain.TFD_AFTER_MAGIC_ATTACK:setVisible(false)
	_layMain.TFD_AFTER_PHY_DENFEND:setVisible(false)
	_layMain.TFD_AFTER_MAGIC_DENFEND:setVisible(false)
	-- 特效动画
	self:createSuccedAction()

	_layMain:setTouchEnabled(false)
	_layMain:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			MainFormationTools.removeFlyText()
			LayerManager.removeLayout()
		end
	end)

	-- 背景运动的计时器
	local fnRemoveSchedule

	UIHelper.registExitAndEnterCall(_layMain, 
		function ()
			fnRemoveSchedule()
		end, function ()
			fnRemoveSchedule = GlobalScheduler.scheduleFunc( ShipMainCtrl.getBgUpdateFun( _layMain ), 0 )
		end)

	return _layMain
end

