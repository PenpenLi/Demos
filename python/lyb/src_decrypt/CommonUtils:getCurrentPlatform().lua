if CommonUtils:getCurrentPlatform() == 2 then
    
    luaJavaConvert = {}

    local _java_class = luajava.bindClass("java.lang.Class")
    local _collection_class = _java_class:forName("java.util.Collection")
    local _map_class = _java_class:forName("java.util.Map")

    -- java中的map转换为lua中的table
    function luaJavaConvert.map2Table(map)
      local result = {}
      local ite = map:entrySet():iterator()
      while ite:hasNext() do
        local kv = ite:next()
        local k = kv:getKey()
        local v = kv:getValue()
        if v ~= nil and type(v) == "userdata" then
          local v_class = v:getClass()
          if _collection_class:isAssignableFrom(v_class) then
            v = luaJavaConvert.list2Table(v)
          elseif _map_class:isAssignableFrom(v_class) then
            v = luaJavaConvert.map2Table(v)
          end
        end
        -- todo 其他情况的判断
        result[k] = v
      end
      return result
    end

    -- java中的list转换为lua中的table
    function luaJavaConvert.list2Table(list)
      local result = {}
      local ite = list:iterator()
      while ite:hasNext() do
        local v = ite:next()
        result[#result + 1] = v
      end
      -- todo 复杂list需要递归
      return result
    end

    function luaJavaConvert.bean2Table(list)
      -- todo
    end

    -- lua中数组风格的table转换为java中的list
    function luaJavaConvert.table2List(t)
      local list = luajava.newInstance("java.util.ArrayList")
      for i,v in ipairs(t) do
        list:add(v)
      end
      -- todo 复杂list需要递归
      return list
    end

    -- lua中的table转换为java中的map
    function luaJavaConvert.table2Map(t)
      local map = luajava.newInstance("java.util.HashMap")
      for k,v in pairs(t) do
        map:put(k, v)
      end
      -- todo 复杂map需要递归
      return map
    end
    
end

