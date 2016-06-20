
require "zoo.scenes.component.HomeScene.popoutQueue.HomeScenePopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.LoginSuccessPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.UpdateSuccessPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.UpdatePackagePopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.UpdateDynamicPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.GivebackPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.RecallPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.ActivityPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.MarkPanelPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.LadyBugPanelPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.OpenActivityPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.OpenBindingPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.OpenLevelPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.OpenCDKeyPanelPopoutAction"
require "zoo.scenes.component.HomeScene.popoutQueue.MissionPanelPopoutAction"


local MAX = 2

local OpenUrlActions = {
	-- 通过链接打开活动面板
	OpenActivityPopoutAction,
	-- 通过链接打开社区绑定url
	OpenBindingPopoutAction,
	-- 通过链接打开对应关卡
	OpenLevelPopoutAction,
	-- 通过链接打开兑换码界面
	OpenCDKeyPanelPopoutAction	
}

local ActionPrioritys = {
	-- SNS登录提示弹板
	LoginSuccessPopoutAction,
	-- 卡关、卡区流失用户召回
	RecallPopoutAction,
	-- 补偿面板
	GivebackPopoutAction,
	-- 大版本更新面板
	UpdatePackagePopoutAction,
	-- 更新奖励面板
	UpdateSuccessPopoutAction,
	-- 动态更新面板
	UpdateDynamicPopoutAction,
	-- 签到面板
	MarkPanelPopoutAction,
	-- 任务系统强弹
	MissionPanelPopoutAction,
	-- 瓢虫面板
	LadyBugPanelPopoutAction,
	-- 活动强弹
	ActivityPopoutAction,
	
}
local ActionNames = {
	[OpenActivityPopoutAction]  = "OpenActivityPopoutAction",
	[OpenBindingPopoutAction]	= "OpenBindingPopoutAction",
	[OpenLevelPopoutAction]		= "OpenLevelPopoutAction",
	[OpenCDKeyPanelPopoutAction]= "OpenCDKeyPanelPopoutAction",
	[LoginSuccessPopoutAction] 	= "LoginSuccessPopoutAction",
	[RecallPopoutAction]		= 'RecallPopoutAction',
	[GivebackPopoutAction] 		= 'GivebackPopoutAction',
	[UpdatePackagePopoutAction] = "UpdatePackagePopoutAction",
	[UpdateSuccessPopoutAction] = "UpdateSuccessPopoutAction",
	[UpdateDynamicPopoutAction] = "UpdateDynamicPopoutAction",
	[ActivityPopoutAction] 		= "ActivityPopoutAction",
	[MarkPanelPopoutAction]		= 'MarkPanelPopoutAction',
	[LadyBugPanelPopoutAction]  = 'LadyBugPanelPopoutAction',
	[MissionPanelPopoutAction]  = 'MissionPanelPopoutAction',
}

kHomeScenePopoutNode = CocosObject:create()
HomeScenePopoutQueue = {}
function HomeScenePopoutQueue:reset( condition )
	-- 
	self.actions = table.filter(self.actions or {},function(v) return v.isFixed end)
	-- 已经弹过的这次不算弹出次数
	table.each(self.actions,function( v ) 
		if v.hasPopout then v.isPlaceholder = true end 
	end)

	self.condition = condition
	self.preCondition = nil
end
HomeScenePopoutQueue:reset("enter")

-- action: 
--	Action.new():placeholder() 
--	Action.new(...)
function HomeScenePopoutQueue:insert(action)
	if not self:has(action.class) then
		table.insert(self.actions,action)
		self:popoutIfNecessary(self.condition)
	end
end

function HomeScenePopoutQueue:has( actionClass )
	return self:get(actionClass) ~= nil
end

function HomeScenePopoutQueue:remove( actionClass )
	self.actions = table.filter(self.actions,function(v) return v.class ~= actionClass end)
end

function HomeScenePopoutQueue:get( actionClass )
	return table.find(self.actions,function(v) return v.class == actionClass end)
end

-- private
function HomeScenePopoutQueue:popoutIfNecessary( popoutCondition )
	if self.hasPopout then
		return
	end

	local hasPopoutActions = table.filter(self.actions,function(v) return not v.isPlaceholder and v.hasPopout end)

	for i,actions in ipairs({OpenUrlActions, ActionPrioritys}) do
		if i == 2 and #hasPopoutActions >= MAX then
			return
		end

		for _,actionClass in ipairs(actions) do
			local action = self:get(actionClass)
			
			-- 优先级高的还没加进队列
			if not action then
				return
			end

			local isPlaceholder = action.isPlaceholder
			local hasPopout = table.find(hasPopoutActions,function(v) return v.class == actionClass end)
			local hasCondition = table.includes(action:getConditions(),popoutCondition)

			if not isPlaceholder and not hasPopout and hasCondition then
				kHomeScenePopoutNode:runAction(CCCallFunc:create(function( ... )
					print("kHomeScenePopoutNode -> popout " .. popoutCondition .. " " .. tostring(ActionNames[action.class]))
					action:popout()
				end))
				self.hasPopout = true
				action.hasPopout = true
				return
			end
		end
	end
	
end

-- private
function HomeScenePopoutQueue:next( preAction )
	self.hasPopout = false
	print(tostring(ActionNames[preAction.class]) .. " next")

	if table.last(ActionPrioritys) == preAction.class then
		return
	end

	if preAction.isPlaceholder then
		self:popoutIfNecessary(self.preCondition or self.condition)
	else
		self.preCondition = "preActionNext"
		self:popoutIfNecessary("preActionNext")
	end
end

function HomeScenePopoutQueue:printQueueLog( ... )
	print("HomeScenePopoutQueue:")
	for _,v in pairs(self.actions) do
		local log = "no name"
		if ActionNames[v.class] then
			log = ActionNames[v.class]
		end

		if v.isPlaceholder then
			log = log .. " placeholder"
		end
		print(log)
	end
end