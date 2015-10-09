--=======================================
-- 数组对象
-- by zhenyu.li
-- (c) copyright 2009 - 2013, Happy Elements Inc.
-- All Rights Reserved. 
--=======================================
-- filename:  Array.lua
-- author:    zhenyu.li
-- created:   2013/02/28
-- descrip:   对Cocos2d-x中CCArray类封装
--=======================================

require "core.mvc.core.Object"

require "core.display.DisplayNode"

Array = class(Object);

-- 构造函数
function Array:ctor()
	self.class = Array;
	self.array = CCArray:create();
	self.array:retain();
	self.list = { };
end

-- 销毁对象
function Array:dipose()
	self.array = nil;
	self.list = nil;

	Array.superclass.dispose(self);
end

-- 查找指定对象在数组中的索引值
-- DisplayNode object — 指定对象
-- return int — 索引值
function Array:indexOfObject(object)
	if object:is(DisplayNode) then
		return self.array:indexOfObject(object.sprite);
	end
end

-- 获取数组中指定索引位置的对象
-- unsigned int index — 索引值
-- return CCObject -- 数组中的对象
function Array:objectAtIndex(index)
	return self.array:objectAtIndex(index);
end

-- 获取数组中指定索引位置的显示节点对象
-- unsigned int index — 索引值
-- return display.DisplayNode — 显示节点对象
function Array:displayNodeAtIndex(index)
	for i, v in ipairs(self.list) do
		if i == index then
			return v;
		end
	end
end

-- 数组对象长度
-- return unsigned int — 长度
function Array:count()
	return self.array:count();
end

-- 向数组中添加对象
-- DisplayNode object — 显示对象
function Array:addObject(object)
	if object:is(DisplayNode) then
		table.insert(self.list, object);
		self.array:addObject(object.sprite);
	end
end

-- 在数组指定索引处插入对象
-- DisplayNode object — 显示对象
-- unsigned int index — 索引
function Array:insertObject(object, index)
	if object:is(DisplayNode) then
		table.insert(self.list, index + 1, object);
		self.array:insertObject(object.sprite, index);
	end
end

-- 删除数组最后一个对象
-- bool bReleaseObj — 释放对象标识
function Array:removeLastObject(bReleaseObj)
	if bReleaseObj == nil then
		bReleaseObj = true;
	end

	table.remove(self.list);
	self.array.removeLastObject(bReleaseObj);
end

-- 从数组中删除指定对象
-- DisplayNode object — 显示对象
-- bool bReleaseObj — 释放对象标识
function Array:removeObject(object, bReleaseObj)
	if bReleaseObj == nil then
		bReleaseObj = true;
	end

	if object:is(DisplayNode) then
		for i, v in ipairs(self.list) do
			if v == object then
				local removedObjIndex = i;
				break;
			end
		end

		table.remove(self.list, removedObjIndex);
		self.array:removeObject(object.sprite, bReleaseObj);
	end
end

-- 删除数组中指定索引的对象
-- unsigned int index — 索引
-- bool bReleaseObj — 释放对象标识
function Array:removeObjectAtIndex(index, bReleaseObj)
	if bReleaseObj == nil then
		bReleaseObj = true;
	end

	table.remove(self.list, index);
	self.array:removeObjectAtIndex(index, bReleaseObj);
end

-- 删除数组中所有对象
function Array:removeAllObjects()
	self.list = { };
	self.array:removeAllObjects();
end

-- 反转数组排序
function Array:reverseObjects()
	self.array:reverseObjects();
end