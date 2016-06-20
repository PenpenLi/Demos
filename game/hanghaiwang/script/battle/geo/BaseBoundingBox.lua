-- 包围盒(四叉树)
require (BATTLE_CLASS_NAME.class)
local BaseBoundingBox = class("BaseBoundingBox")
 
	------------------ properties ----------------------
	BaseBoundingBox.minX 				= nil
	BaseBoundingBox.minY				= nil
	BaseBoundingBox.maxX				= nil
	BaseBoundingBox.maxY				= nil
	-- BaseBoundingBox.target				= nil
	------------------ functions -----------------------

	function BaseBoundingBox:width( ... )
		return self.maxX - self.minX
	end


	function BaseBoundingBox:height( ... )
		return self.maxY - self.minY
	end

	function BaseBoundingBox:iniWithData(x,y,width,height)
		self.minX = x
		self.minY = y
		self.maxX = x + width
		self.maxY = y + height
	end

	function BaseBoundingBox:debug( ... )
		print("BaseBoundingBox:debug",self.minX,self.minY,self.maxX,self.maxY)
	end

	function BaseBoundingBox:isIn( x,y )
		return x >= self.minX and x < self.maxX and y >= self.minY and y < self.maxY
	end

	function BaseBoundingBox:interect( box )
		if(box ~= nil) then
			local minx = math.max(self.minX,box.minX)
			local miny = math.max(self.minY,box.minY)
			local maxx = math.min(self.maxX,box.maxX)
			local maxy = math.min(self.maxY,box.maxY)
			if(minx > maxx or miny > maxy) then
				return false
			else
				return true
			end
		end
		return false
	end
	
	function BaseBoundingBox:iniWithCCNode( ccnode )
		-- self.target = ccnode
		local box = ccnode:boundingBox()
		self.minX = box:getMinX()
		self.minY = box:getMinY()
		self.maxX = box:getMaxX()
		self.maxY = box:getMaxY()
	end
	
	function BaseBoundingBox:isEmpty( ... )
		if(
		   self.minX ~= nil and
		   self.minY ~= nil and
		   self.maxX ~= nil and
		   self.maxY ~= nil) then
 			return false
		end
		return true
	end
	function BaseBoundingBox:combine( x,y,width,height )
		local minX = x
		local minY = y
		local maxX = x + width
		local maxY = y + height
				if( 
	                self.minX == nil or
	                self.minX > minX
	              ) then

	                self.minX = minX
	            end

	            if( 
	                self.minY == nil or
	                self.minY > minY
	              ) then
	                self.minY = minY
	            end

	            if( 
	                self.maxX == nil or
	                self.maxX < maxX
	              ) then
	                self.maxX = maxX
	            end

	            if( 
	                self.maxY == nil or
	                self.maxY < maxY
	              ) then
	                self.maxY = maxY
	            end
	    -- print("after combine")
		-- self:debug()
		-- print("========== ")
	end

	function BaseBoundingBox:combineCCNodeToSelf( ccnode )
		

		local world = ccnode:convertToWorldSpace(ccnode:getPosition())
    	local size  = ccnode:getContentSize()

		if(ccnode ~= nil and (not self:isEmpty()) == true) then
			self:combine(world.x,world.y,size.width,size.height)
		else
			self:iniWithData(world.x,world.y,size.width,size.height)
			print("BaseBoundingBox:combine->self boundingBox is nil")
			self:debug()
		end
	end

 

	function BaseBoundingBox:dispose( ... )
		self.target = nil
		self.minX = nil
    	self.minY = nil
    	self.maxX = nil
    	self.maxY = nil
	end
return BaseBoundingBox