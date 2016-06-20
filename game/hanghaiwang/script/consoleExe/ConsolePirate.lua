-- FileName: ConsolePirate.lua
-- Author: zhangqi
-- Date: 2014-03-25
-- Purpose: 控制台

module("ConsolePirate", package.seeall)

local inputCmd
local btnCommit

-- zhangqi, 2015-12-18, 一些增加数值的控制台指令执行后即时修改前端对应信息，避免重启游戏生效
local tbLocalCmd = {["clearlocalcache"] = Util.removeCacheDir,}
--[[
silver N: 设置银币
gold N: 设置金币
vip N: 设置vip等级
level N: 设置等级
-- experience N: 设置经验
addExp N:添加经验
-- soul N:设置将魂
prestige N:设置声望值
-- prisonGold N:设置监狱币
-- rime N:设置结晶数目
-- awakeRime N:设置觉醒结晶数目

execution N：设置体力
-- setExectuion N:设置行动力
setStamina N：设置耐力
]]
local tbValueCmd = {}
tbValueCmd.silver = function ( value )
	local curSilver = UserModel.getSilverNumber()
	UserModel.addSilverNumber(tonumber(value) - curSilver)
end
tbValueCmd.gold = function ( value )
	local curGold = UserModel.getGoldNumber()
	UserModel.addGoldNumber(tonumber(value) - curGold)
end
tbValueCmd.level = function ( value )
	UserModel.setUserLevel(tonumber(value))
	updateInfoBar()
end
tbValueCmd.addExp = function ( value )
	UserModel.addExpValue(tonumber(value), "console")
end
tbValueCmd.execution = function ( value )
	local curExec = UserModel.getEnergyValue()
	UserModel.addEnergyValue(tonumber(value) - curExec)
end
tbValueCmd.setStamina = function ( value )
	local curStam = UserModel.getStaminaNumber()
	UserModel.addStaminaNumber(tonumber(value) - curStam)
end
tbValueCmd.prestige = function ( value )
	local curPrest = UserModel.getPrestigeNum()
	UserModel.addPrestigeNum(tonumber(value) - curPrest)
end

local function consoleCallback( cbFlag, dictData, bRet )
	local strText = inputCmd:getText()
	logger:debug({consoleCallback_dictData = dictData, strText = strText})

	if (inputCmd) then
		inputCmd:setText(inputCmd:getText() .. " :" .. dictData.err)
	end

	-- zhangqi, 2015-12-18, 如果是修改数值的命令，直接修改前端数值，避免大退重进
	if (bRet) then
		local a, b, strCmd, strArg = string.find(strText, "(%a+)%s+(%w+)")
		logger:debug("cmd = %s, arg = %s", strCmd, strArg)
		for cmd, func in pairs(tbValueCmd) do
			if (type(strCmd) == "string" and string.lower(cmd) == string.lower(strCmd)) then
				if (isFunc(func)) then
					func(strArg)
				end
			end
		end
	end
end

local function createEditBoxWithLayout(panel)
	if panel then
		local boxSize = CCSizeMake(400, 60)
		inputCmd = CCEditBox:create(boxSize, CCScale9Sprite:create("ui/2X2.png"))
		inputCmd:setTouchPriority(g_tbTouchPriority.editbox)
		--inputCmd:setFontSize(25);
		inputCmd:setAnchorPoint(ccp(0.5, 0.5))
		inputCmd:setFontColor(ccc3(255,0, 0));
		inputCmd:setPlaceHolder("help");
		inputCmd:setPlaceholderFontColor(ccc3(255,255,255));
		--inputCmd:setMaxLength(8);
		inputCmd:setReturnType(kKeyboardReturnTypeDone);

		local pSize = panel:getSize()
		inputCmd:setPosition(ccp((pSize.width - boxSize.width)/2 + 100, panel:getSize().height - 250))

		local function editboxEventHandler(eventType, sender)
			if eventType == "began" then
				-- triggered when an edit box gains focus after keyboard is shown
				logger:debug("began, text = " .. sender:getText())
			elseif eventType == "ended" then
				-- triggered when an edit box loses focus after keyboard is hidden.
				logger:debug("ended, text = " .. sender:getText())
			elseif eventType == "changed" then
			-- triggered when the edit box text was changed.
			--logger:debug("changed, text = " .. sender:getText())
			elseif eventType == "return" then
				-- triggered when the return button was pressed or the outside area of keyboard was touched.
				logger:debug("return, text = " .. sender:getText())
			end
		end
		inputCmd:registerScriptEditBoxHandler(editboxEventHandler)
		panel:addNode(inputCmd, 99998, 99998)
	end
end

local function createBtn(panel)
	local function btnCommitCallback( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			local strCmd = inputCmd:getText()
			if (strCmd == "") then
				inputCmd:setText("help")
				strCmd = inputCmd:getText()
			end
			
			-- zhangqi, 2015-12-18, 不需要后端请求的控制台指令
			if (table.include(table.allKeys(tbLocalCmd), string.lower(strCmd))) then
				local func = tbLocalCmd[strCmd]
				if (isFunc(func)) then
					local ret = func() or "ok"
					inputCmd:setText(strCmd .. ":ok")
				end
				return
			end

			local args = CCArray:createWithObject(CCString:create(strCmd));
			Network.rpc(consoleCallback, "console.execute", "console.execute", args, true)
		end
	end

	btnCommit = Button:create()
	btnCommit:loadTextures("ui/gold.png", "ui/silver.png", nil)
	btnCommit:setScale(2)
	btnCommit:addTouchEventListener(btnCommitCallback)
	local x, y = inputCmd:getPosition()
	btnCommit:setPosition(ccp(x, y - inputCmd:getContentSize().height))
	panel:addChild(btnCommit, 99999, 99999)
end

function create(rootLayer)
	createEditBoxWithLayout(rootLayer)
	createBtn(rootLayer)
end
