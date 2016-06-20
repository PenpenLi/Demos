


require (BATTLE_CLASS_NAME.class)

local BSNode = class("BSNode")
 
	------------------ properties ----------------------
	BSNode.blackBoard							= nil		-- 公用数据
	BSNode.children								= nil		-- 子节点列表
	BSNode.weight 								= 0			-- 权重
	BSNode.parent								= nil		-- 父节点
	BSNode.data									= nil		-- 原始数据
	BSNode.isroot								= false		-- 是否是根节点
	BSNode.childrenNum 							= nil 		-- 孩子数量
	BSNode.events 								= nil
	-- BSNode.disposed								= false
	------------------ functions -----------------------
	function BSNode:ctor( ... )
		ObjectTool.setProperties(self)
	end
	function BSNode:release()
		self.disposed 									= true
		-- --print("BSNode:release:",self.__cname)
		
		self:removeAllListeners()
		self:releaseChildren()

		self.blackBoard									= nil
		self.events 									= nil
		-- self.data 										= nil
		self.parent 									= nil
		self.children 									= nil
	end
	
	function BSNode:travel()
		--print(self.treeName,"->traveled",self.name)
		 local result 									= self:travelSelf()
		 if result == true then
		 	return self:travelChildren()
		 end
		 return false
	end

	function BSNode:travelSelf()
		return true
	end
	--该节点会在blackBoard中设置的属性名
	function BSNode:setBlackBoardPropertyNames()
			return {}
	end

	function BSNode:sortByWeight(list)
		  	if(list) then
			    table.sort(
			    			list, function (a,b) return tonumber(a.weight) > tonumber(b.weight) end
			        	   )
		   	end

	end

	function BSNode:init(data)
		-- --print("BSNode:init->",data.des)
		self.data										= data
		self:generateChildrenNode()
		self:generateEventTrigger()
	end

	function BSNode:generateEventTrigger( ... )
		if(self.data and self.data.eventTrigger ~= nil) then
			--print("BSNode:generateEventTrigger get event:",self.data.eventTrigger,self.__cname)
			self.events			=  string.split(self.data.eventTrigger, ",")
			for k,eventName in pairs(self.events or {}) do

					if(self.blackBoard and self.blackBoard[eventName] ~= nil) then
						eventName = self.blackBoard[eventName]
					end
					-- print("---- BAForAttackAnimationTrigger regesit",eventName,self.blackBoard[eventName],self.blackBoard:instanceName())
					--print("node ",self.name," add event:",eventName)
					EventBus.addEventListener(eventName,self.onEvenetTrigger,self)
					 
			end
		end
	end

	function BSNode:removeAllListeners()
		-- --print("@@@@@@@@@@@@@@@@@@@@@@@ BSNode:removeAllListeners")
		for k,eventName in pairs(self.events or {}) do
			EventBus.removeEventListener(eventName,self)
		end
		self.events = {}
	end

	function BSNode:onEvenetTrigger(evtName,data)
		-- print("---- BAForAttackAnimationTrigger handle",evtName)
		--print("!!!!!!!!!!!!!!!!!!!!!!!!!  on BSNodeOnEvenetTrigger:",evtName)
		self:travel()
	end

	function BSNode:generateChildrenNode()
		
		
		if self.data.children ~= nil then
			self.children  								= {}

			for key,value in pairs(self.data.children) do
				
				 local child 							= BattleNodeFactory.getNodeWithData(value,self.blackBoard,self.callBackFunc)
				 child.parent							= self
				 if(value.des == nil ) then
				 	child.des 							= self.des
				 end
				 table.insert(self.children,child)

			end
			self:sortByWeight(self.children)
			self.childrenNum 							= #self.children
		else
			self.children  								= nil
		end

	end

	function BSNode:releaseChildren( ... )
		 if self.children ~= nil then
			for key,value in pairs(self.children) do
				-- if(value.release) then
					value:release()
				-- end
			end -- for end
		end -- if end
	end



	function BSNode:toString(p)
		Logger.debug(p .. "	" .. self:printValue())

		if self.children ~= nil then
			for key,value in pairs(self.children) do
				 value:toString(p.."######")
			end -- for end
		end -- if end
	end -- function end
	function BSNode:printValue()
		return self.data.des
	end
return BSNode