local _class={}

function class(super)

	local class_type = { ctor = false, super = super}    -- 'ctor' field must be here
	local vtbl = {}
	_class[class_type] = vtbl
  
    -- class_type is one proxy indeed. (return class type, but operate vtbl)
	setmetatable(class_type, {
		__newindex= function(t,k,v)

			-- Check If Already Defined !
			if rawget(vtbl, k) then
				assert(false, "Class 's Memeber \"" .. tostring(k) .. "\" Already Defined Before, This May Cause Error !")
			end
			
			vtbl[k] = v 
		end,			
		__index = function(t,k) 

			return vtbl[k] 
		end,
	})

    -- when first invoke the method belong to parent,retrun value of parent
    -- and set the value to child
	if super then
		setmetatable(vtbl, { 
			__index= function(t, k)

				local result = false

				-- First Check Interface
				for interface,v in pairs(class_type.interface) do
					if result == false then
						if interface[k] then
							result = interface[k]
						end
					end
				end

				if result then
					return result
				end

				-- Then Check Parent
				if k and _class[super] then
				    local ret = _class[super][k]
				    vtbl[k] = ret                      -- remove this if lua running on back-end server
				    return ret
				else return nil end
			end
		})
	end
    
    class_type.new = function(...)
        local obj = { class = class_type }
        setmetatable(obj, { 
			__index = _class[class_type]
		})
        
        -- deal constructor recursively
        local inherit_list = {}
		local class_ptr = class_type
		while class_ptr do
			if class_ptr.ctor then table.insert(inherit_list, class_ptr) end
			class_ptr = class_ptr.super
		end
		local inherit_length = #inherit_list
		if inherit_length > 0 then
		    for i = inherit_length, 1, -1 do inherit_list[i].ctor(obj, ...) end
		end
        
        obj.class = class_type              -- must be here, because some class constructor change class property.

		-------------------------
		--- Declare Variabel Check
		--------------------------
		function obj:declare(variableName, value, ...)
			assert(type(variableName) == "string", "function declare 's variableName paramter is nil !")
			assert(value ~= nil, "function declare 's value paramter is nil !")
			assert(#{...} == 0)

			assert(not self[variableName], "variable \"" .. variableName .. "\" Already Declared !")
			self[variableName] = value
		end

        return obj
    end
	
	class_type.is = function(self_ptr, compare_class, ...)
		assert(self_ptr)
		assert(compare_class)

		if not compare_class or not self_ptr then 
			return false 
		end

		local raw_class = self_ptr.class
		while raw_class do
			if raw_class == compare_class then return true end
			raw_class = raw_class.super
		end
		return false
	end

	-------------------------------------------
	--  Implement An Interface( Or Procotol Called In Cocos2d-x)
	--  -----------------------------------------------------
	class_type.interface = {}
	class_type.implement = function(interface, ...)
		assert(interface, "Interface Is Nil !!")
		assert(#{...} == 0)

		assert(_class[interface], "Interface Not Exist !!")

		-- Check If Already Added To Talbe class_type.interface
		if class_type.interface[interface] then
			assert(false, "Interface Already Implemented !")
		end

		class_type.interface[interface] = true
	end

	----------------------------------------------------
	--create a object with access control
	--method start with "_", will be regarded as a private function
	----------------------------------------------------
	class_type.new_ac = function()
		local delegate = {}

		local obj = class_type.new()

		local function cloneToDelegate(sourceClass)
			for k,v in pairs(sourceClass) do
				--print("++++++++++++++++++++++++++++++++",k, type(v))
				local isPrivate = string.find(k, "_") == 1
				local isInner = k == "new" or k == "new_ac"
				if type(v) == "function" and not isPrivate and not isInner and not delegate[k] then
					--print("delegated method: ", k)
					delegate[k] = function(...)
						local params = { ... } 
						params[1] = obj
						return obj[k](unpack(params))
					end
				end
			end
		end

		cloneToDelegate(_class[class_type])

		local superClass = super
		while superClass do
			cloneToDelegate(_class[superClass])
			superClass = superClass.super
		end

		return delegate
	end
	
	return class_type
end

---------------------------------------------
----- Test Detect Re Definition Of Class's Memeber
---------------------------------------
--
--print("====== Start Re Define Class's Memeber Test =====")
--debug.debug()
--
--assert(not TestClassA)
--TestClassA = class()
--
--function TestClassA:func1()
--
--end
--
--assert(not TestClassB)
--TestClassB = class(TestClassA)
--
--function TestClassB:func1()
--end
--
---- Re Define func1 In TestClassB, This Will Cause
---- Assert False
--function TestClassB:func1()
--end
--
--print("----- End Re Define Class's Memeber Test -----")
--debug.debug()



-------------------------------------
------- Test Implement An Interface
--------------------------------------
--
--print("========== Start Implement Interface Test ============")
--debug.debug()
--
----------------
---- Interface
---- ------------
--I1 = class()
--function I1:f2()
--	print("This Is Func f2, In Interface I1")
--end
--
--I2 = class()
--function I2:f2()
--	print("This Is Func f2, In Interface I2")
--end
--
--
--A = class()
--function A:f1()
--	print("This Is Func f1, In Class A")
--end
--
--
--B = class(A)
----B.implement(nil)
----fakeInterfade = {}
----B.implement(fakeInterfade)
----B.implement(I1)
----B.implement(I2)
--
--function B:f1()
--	print("This Is Func f1, In Class B")
--end
--
--b = B.new()
----b:f1()
--b:f2()
--
--print("============== End Implement Interface Test ===========")
--debug.debug()


----------------------------------------
---- Test Declare Class Instance Variabel
---- -------------------------------------
--
--print("=========== Start Declare Class Instance Variable Test ===========")
--debug.debug()
--A = class()
--
--function A:init()
--
--	self:declare("v1", "hello")
--	print(self.v1)
--
--	self:declare("v2", "world")
--	print(self.v2)
--
--	self:declare("v1", "re declare !")
--	print(self.v1)
--end
--
--a = A.new()
--a:init()
--
--print("================== End Declare Class Instance Variable Test ===========")
--debug.debug()
