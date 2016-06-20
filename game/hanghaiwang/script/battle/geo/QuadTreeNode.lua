-- 四叉树
require (BATTLE_CLASS_NAME.class)


local spaceNum 				= 4

local QuadTreeNode = class("QuadTreeNode")

 
	------------------ properties ----------------------
	QuadTreeNode.space1					= nil 	-- 第一象限
	QuadTreeNode.space2					= nil   -- 第二象限
	QuadTreeNode.space3					= nil	-- 第三象限
	QuadTreeNode.space4					= nil	-- 第四象限

	-- QuadTreeNode.spaces					= nil

 	QuadTreeNode.depth 					= nil 	-- 深度
 	QuadTreeNode.rect 					= nil	-- rectangle
 	QuadTreeNode.parentNode				= nil 	-- 父节点
	QuadTreeNode.data					= nil 
	------------------ functions -----------------------
	function QuadTreeNode:ctor( ... )
		self.data = {}
	end
	-- 点是否在区域内
	function QuadTreeNode:isPointIn( point )
		return self:isXYIn(point.x,point.y)
	end
	-- 点是否在区域内
	function QuadTreeNode:isIn( x,y )
		if(self.rect) then
			return self.rect:isIn(x,y)
		end
		return false
	end

	-- 获取点击到的所有物品
	function QuadTreeNode:getInterectObects( x,y )
		-- print("getInterectObects1")
		if(self:isIn(x,y) == true) then
			-- print("getInterectObects2")
			if(self:hasChild() == true) then

				-- print("getInterectObects3")
				local objs1 = self.space1:getInterectObects(x,y)
				if(objs1 and #objs1 > 0) then
					-- print("getInterectObects5",#objs1)
					return objs1
				end
				objs1 = self.space2:getInterectObects(x,y)
				if(objs1 and #objs1 > 0) then
					-- print("getInterectObects5",#objs1)
					return objs1
				end

				objs1 = self.space3:getInterectObects(x,y)
				if(objs1 and #objs1 > 0) then
					-- print("getInterectObects5",#objs1)
					return objs1
				end

				objs1 = self.space4:getInterectObects(x,y)
				if(objs1 and #objs1 > 0) then
					-- print("getInterectObects5",#objs1)
					return objs1
				end

			else
				local result = {}
				for k,targetData in pairs(self.data or {}) do
					 if(targetData and targetData.box) then
					 	if(targetData.box:isIn(x,y) == true) then
					 		table.insert(result,targetData)
					 	end
					 end
				end
				-- print("getInterectObects4",self.data)
				return result
			end
		end
		return nil
	end


	function QuadTreeNode:create( x,y,width,height,deep,parent)
		self.rect 		= require(BATTLE_CLASS_NAME.BaseBoundingBox).new()
		self.rect:iniWithData(x,y,width,height)
		self.parentNode = parent
		self.depth 		= deep
		if(self.depth <= 0) then
			return 
		end
		local cw = width/2
		local ch = height/2

		self.space1 = require(BATTLE_CLASS_NAME.QuadTreeNode).new()
		self.space2 = require(BATTLE_CLASS_NAME.QuadTreeNode).new()
		self.space3 = require(BATTLE_CLASS_NAME.QuadTreeNode).new()
		self.space4 = require(BATTLE_CLASS_NAME.QuadTreeNode).new()

		self.space1:create(x	,y+ch,cw,ch,self.depth - 1,self)
		self.space2:create(x+cw ,y+ch,cw,ch,self.depth - 1,self)
		self.space3:create(x	,y	 ,cw,ch,self.depth - 1,self)
		self.space4:create(x+cw ,y	 ,cw,ch,self.depth - 1,self)

	end
	function QuadTreeNode:isRoot( ... )
		return self.parentNode == nil
	end
	function QuadTreeNode:hasChild( ... )
		return self.space1~= nil and
			   self.space2~= nil and
			   self.space3~= nil and
			   self.space4~= nil 
	end
	-- 是否是叶子节点
	function QuadTreeNode:isLeaf()
		return self.depth == 0
	end

	-- 插入
	function QuadTreeNode:insert( target )
		if(self.rect and target.box) then

			if(self.rect:interect(target.box) == true) then
				-- print("==QuadTreeNode:insert interect1")
				if(self:hasChild()) then
					-- print("==QuadTreeNode:insert interect2")
					self.space1:insert(target)
					self.space2:insert(target)
					self.space3:insert(target)
					self.space4:insert(target)
				else
					-- print("==QuadTreeNode:insert success")
					table.insert(self.data,target)
				end
			end
		else
			error("QuadTreeNode:insert error")
		end
	end

	-- 删除节点
	function QuadTreeNode:remove( target )
		if(self.rect and target.box) then

			if(self.rect:interect(target.box) == true) then
				if(self:hasChild()) then
					self.space1:remove(target)
					self.space2:remove(target)
					self.space3:remove(target)
					self.space4:remove(target)
				else
					local result = nil
					for index,element in pairs(self.data or {}) do
						if(element == target) then
							result = index
							break
						end
					end
					if(result) then
						table.remove(self.data,result)
					end
				end
			end
		end
	end


return QuadTreeNode