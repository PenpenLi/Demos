-- FileName: copyTreasure.lua
-- Author: liweidong
-- Date: 2014-04-00
-- Purpose: 显示天降宝物以及领取
--[[TODO List]]

module("copyTreasure", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local callResultEvent = nil --领取完成的回调函数
local treasureData=nil  --宝物数据

local treasurePosx = 1
local treasurePosy = 1

local function init(...)

end

function destroy(...)
	package.loaded["copyTreasure"] = nil
end

function moduleName()
    return "copyTreasure"
end

function initinfo(callback,data)
	callResultEvent=callback
	treasureData=data
end
function create(callback,data)
	callResultEvent=callback
	treasureData=data

	local layout=Layout:create()
	local layer = g_fnLoadUI("ui/copy_lucky_box.json")
	layer:setSize(g_winSize)
	layout:addChild(layer)


	nomalBtn = g_fnGetWidgetByName(layer, "BTN_BOX")
	treasurePosx=nomalBtn:getPositionX()
	treasurePosy=nomalBtn:getPositionY()

	nomalBtn:setTouchEnabled(false)

	CCDirector:sharedDirector():getScheduler():setTimeScale(1)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/drop_treasure/fall_box/fall_box.ExportJson")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/drop_treasure/fall_box/fall_box_txt_92.ExportJson")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/shop_recruit/zhao3.ExportJson")
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/effect/drop_treasure/fall_box_1/fall_box_1.ExportJson")
	local armature1=nil
	local armature2_1=nil
	local armature2_2=nil
	local armature3=nil
	local armature4=nil

	--创建第二步动画
	local createArm2 =function( sender, MovementEventType )
		if (MovementEventType ~= EVT_COMPLETE and MovementEventType ~= EVT_LOOP_COMPLETE) then 
			return
		end
		logger:debug("createArm2")
		armature1:removeFromParentAndCleanup(true)
		nomalBtn:setTouchEnabled(true)
		armature2_1 = UIHelper.createArmatureNode({
			filePath = "images/effect/drop_treasure/fall_box/fall_box.ExportJson",
			animationName = "fall_box",
			loop = -1
			}
		)
		nomalBtn:addNode(armature2_1,10)

		armature2_2 = UIHelper.createArmatureNode({
			filePath = "images/effect/shop_recruit/zhao3.ExportJson",
			animationName = "zhao3_2",
			loop = -1
			}
		)
		nomalBtn:addNode(armature2_2,1)
	end

	--第一步动画，掉落动画
	local createArm1 = function()
		armature1 = UIHelper.createArmatureNode({
				filePath = "images/effect/drop_treasure/fall_box/fall_box.ExportJson",
				animationName = "fall_box1",
				loop = 0,
				fnMovementCall=createArm2
				}
			)
		nomalBtn:addNode(armature1)
	end
	--创建第0步动画
	local createArm0 = function()
		armature1 = UIHelper.createArmatureNode({
				filePath = "images/effect/drop_treasure/fall_box_txt_92/fall_box_txt_92.ExportJson",
				animationName = "fall_box_txt",
				loop = 0,
				fnMovementCall=function()
					armature1:removeFromParentAndCleanup(true)
					createArm1()
				end
				,
				-- fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
				-- 	if (frameEventName == "1") then
				-- 		createArm1()
				-- 	end
				-- end,
				}
			)
		nomalBtn:addNode(armature1)
	end
	performWithDelay(nomalBtn,createArm0,0.01) --本针加载特效果资源，下一针播放，如果本针播发掉落会卡。

	--第四步动画
	local createArm4 = function( sender, MovementEventType )
		
		if (MovementEventType ~= EVT_COMPLETE and MovementEventType ~= EVT_LOOP_COMPLETE) then 
			return
		end
		logger:debug("createArm4")
		armature4 = UIHelper.createArmatureNode({
			filePath = "images/effect/drop_treasure/fall_box_1/fall_box_1.ExportJson",
			animationName = "fall_box_2",
			loop = -1
			}
		)
		nomalBtn:addNode(armature4,0)
	end
	--第三步动画
	local createArm3 = function()
		logger:debug("createArm3")
		armature3 = UIHelper.createArmatureNode({
			filePath = "images/effect/drop_treasure/fall_box_1/fall_box_1.ExportJson",
			animationName = "fall_box_1",
			loop = 0,
			fnFrameCall=function(bone, frameEventName, originFrameIndex, currentFrameIndex)
				if (frameEventName == "3") then
					--LayerManager.removeLayout()
					showTreasureDialog()
				end
			end,
			fnMovementCall=createArm4
			}
		)
		nomalBtn:addNode(armature3,20)
	end


	nomalBtn:addTouchEventListener(function(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
				createArm3()
				PreRequest.setIsCanShowAchieveTip(true)
				AudioHelper.playCommonEffect()
				nomalBtn:setTouchEnabled(false)
			end
		end
		)
	return layout
end
function showTreasureDialog()
	logger:debug("show treasure dialog=============")
	---[[修改缓存信息
	-- local tmp=treasureData.silver and UserModel.addSilverNumber(tonumber(treasureData.silver))
	--]]
	--显示奖励框，点击确认之后要回调
	local callback=function(sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			callResultEvent()
			LayerManager.removeLayout()
			LayerManager.removeLayoutByName(g_battleLayout)
		end
	end
	local layout= UIHelper.showTreasureDropItemDlg(treasureData,gi18n[1983],callback,gi18n[1984]) --
	layout:ignoreAnchorPointForPosition(false)
	layout:setAnchorPoint(ccp(0.5,0.5))
	layout:setPositionType(POSITION_ABSOLUTE)
	layout:setPosition(ccp(treasurePosx, treasurePosy))
end