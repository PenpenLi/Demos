
module("ObjectSharePool",package.seeall)


map = {}

function addObject(target,name)
	-- print("ObjectSharePool add",name,tolua.isnull(target))
	if(target ~= nil and name ~= nil and not tolua.isnull(target)) then
		if(map[name] == nil) then
			map[name] = {}
		end
		-- print("ObjectSharePool addObject:",name," retain count:",target:retainCount())
		if(target:retainCount() <= 2) then
			target:retain()
		end
		
		table.insert(map[name],target)
	end
end

function getObject( name )
	if(map[name] ~= nil) then
		local len = #(map[name])
		if(len > 0) then
			local shiftObject = map[name][len]
			table.remove(map[name],len)
			-- print("ObjectSharePool getObject:",name," count:",len)
			if(not tolua.isnull(shiftObject)) then
				if(shiftObject:retainCount() >= 2) then
					shiftObject:release()
				end
				if(shiftObject.setRotation) then
					shiftObject:setRotation(0)
				end
				if(shiftObject.setScale) then
					shiftObject:setScale(1)
				end

				if(shiftObject.setVisible) then
					shiftObject:setVisible(true)
				end

				return shiftObject
			end
		end
	end	

	return nil
end

function release( ... )
	-- print("== ObjectSharePool start autorelease")
	for k,v in pairs(map or {}) do
		for k1,v1 in pairs(v or {}) do
			while(v1 and not tolua.isnull(v1) and v1:retainCount() > 0)  
			do
				v1:release()
			end
			-- print("ObjectSharePool release:",k,k1," retainCount:",v1:retainCount())
	 		-- v1:autorelease()
		end
	end
	map = {}
end