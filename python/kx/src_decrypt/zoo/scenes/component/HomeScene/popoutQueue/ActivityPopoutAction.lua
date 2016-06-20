ActivityPopoutAction = class(HomeScenePopoutAction)

function ActivityPopoutAction:ctor( ... )

end

function ActivityPopoutAction:popout( ... )
	

	local openSource = ""
	if HomeScenePopoutQueue:has(OpenActivityPopoutAction) then
		openSource = HomeScenePopoutQueue:get(OpenActivityPopoutAction):getSource()
	end
	local index = 0
	local size = 0

	-- 
	local function onSuccess( ... )
		index = index + 1
		if index >= size then
			self:next()
		end
	end

	local function onError( ... )
		index = index + 1
		if index >= size then
			self:next()
		end
	end

	-- 
	local function onEnd( ... )

	end

	local function onGetList(list)

		list = table.filter(list or {},function(v) return v.source ~= openSource end)
		if #list == 0 then
			self:placeholder()
			self:next()
			return
		end

		size = #list

		for _,info in pairs(list) do
			local data = ActivityData.new(info)
			data:start(false,false,onSuccess,onError,onEnd)
		end
	end
	PushActivity:sharedInstance():onComeToFront(onGetList)

end

function ActivityPopoutAction:getConditions( ... )
	return {"enter","enterForground","preActionNext"}
end