module("EventBus", package.seeall)
listenerHandleIndex_    =  0
mediators               = {}
listeners_              = {}
commands                = {}
    function trace( data )
    	
    	--print(data)
    end

    ------------------ command ------------------
    function regestCommand(evtName , callBack )
        assert(eventName)
        assert(callBack)
        local upper = string.upper(evtName)
        if(commands[upper] == nil) then
            commands[upper] = {}
        end
        table.insert(commands[upper],callBack)
    end
    ------------------ mediator ------------------
 
 	function regestMediator( cls )
        
        if mediators == nil then
            mediators = {}
        end -- if end

       if cls.name ~= nil then
          if mediators[cls.name] == nil then
                    local classIns = cls.new()
                    --print("regestMediator:",classIns.name)

                    -- 添加监听
                    mediators[classIns.name] = classIns
                        local  eventNames   = classIns:getInterests()
                        for i,eventName in ipairs(eventNames) do
                           ----print(i,eventName)
                            addEventListener(eventName,classIns:getHandler(),classIns)
                        end -- for end
                    classIns:onRegest()
          end -- if end
       end -- if end
    end -- function end
 	
    function getMediator( name )
                

        if mediators ~= nil then

            return mediators[name]
        end

        return nil

    end -- function end
    function removeAllMediator()
        for k,v in pairs(mediators) do
             removeMediator(k)
         end  
    end
    function removeMediator( name )
        
        local ins = getMediator(name)
        if ins ~= nil then
                ins:onRemove()
                local  eventNames   = ins:getInterests()
                 -- 删除监听
                for i,eventName in ipairs(eventNames) do
                    -- --print("removeEvent---》",eventName)
                    -- removeEventListener(eventName,ins:getHandler())
                    removeEventListener(eventName,ins)
                end -- for end
            
            mediators[name] = nil
        end -- if end
    end -- function end

 	------------------ event functions -----------------------
 		

    function addEventListener(evtName, listener, target)
    	--trace(eventName)
    	-- --print("addEventListener-->",evtName)
        eventName = string.upper(evtName)
        if  listeners_ == nil then 
            listeners_ = {}
        end
        if listeners_[eventName] == nil then
            listeners_[eventName] = {}
        end

        listenerHandleIndex_ = listenerHandleIndex_ + 1
        -- local handle = string.format("HANDLE_%d", listenerHandleIndex_)
        listeners_[eventName][target] = listener
        -- return handle
    end

    function sendNotification(name,data)
        --event.name = string.upper(name)
        local eventName = string.upper(name)
       
            if listeners_[eventName] == nil then
                 if(g_debug_mode) then
                     logger:debug("we don't find:" .. eventName) 
                 end
                 return
            end
        
        --event.target = self
       -- --print("we have event:",eventName,"data:",data)
        for target, listener in pairs(listeners_[eventName]) do
            listener(target,eventName,data)
            -- local ret = listener(target,eventName,data)
            -- if ret == false then
            --     break
            -- elseif ret == "__REMOVE__" then
            --     listeners_[eventName][handle] = nil
            -- end
        end

        if( commands[eventName] ~= nil) then
            for eventName,command in pairs(table_name) do
                command(data)
            end
        end
    end

    function removeEventListener(eventName, target)
        eventName = string.upper(eventName)
        -- --print("----------------------------> will remove:",eventName,target)
        if eventName == nil or 
           target == nil or 
           listeners_[eventName] == nil or
           listeners_[eventName][target] == nil then 
            return     
        end
  
         listeners_[eventName][target] = nil
         -- --print("^^^^^^^^^^^^^^^^^^^^^^^^^^^ remove:",eventName)

        -- for target, listener in pairs(listeners_[eventName]) do
        --     if key == target or key == listener then
        --         listeners_[eventName][target] = nil
        --         --print("delete listener")
        --         break
        --     end
        -- end
    end

    function removeEventType( eventName )
        eventName = string.upper(eventName or '')
        if (eventName == nil or 
            target == nil or 
            listeners_[eventName] == nil) then
            

            for target, listener in pairs(listeners_[eventName]) do
                listeners_[eventName][target] = nil
            end


        end
    end

    function removeAllEventListenersForEvent(eventName)
        listeners_[string.upper(eventName)] = nil
    end

    function removeAllEventListeners()
        listeners_ = {}
        --  for eventName,targets in pairs(listeners_ or {}) do
        --     for k,v in pairs(targets) do
        --         targets[k] = nil
        --     end
        -- end
    end

    function release( ... )
        removeAllEventListeners()
        removeAllMediator()
        commands = {}
    end