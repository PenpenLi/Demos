-- FileName: DropUtil.lua
-- Author: sunyunpeng
-- Date: 2015-09-08
-- Purpose: function description of module
--[[TODO List]]

-- 模板
--local curModuleName = LayerManager.curModuleName()
--DropUtil.insertCallFn( modulename, returnCallFn )
--setSourceAndAim(curModule,curModule)	非 changModule方式 addlayout时设置的
--DropUtil.setSourceAndAim(strName,m_strCurName)   changModule方式 Layermanger   中自动添加的

require "script/module/public/MReleaseUtil"
module("DropUtil", package.seeall)

-- UI控件引用变量 --


local nPopScaleTag = 666665

-- 模块局部变量 --
local _allResuminfo = {}               -- 来源信息
local _allCallFn = {}               -- 界面刷新信息

local _allResumPopLayout = {}     	-- 来源弹出界面，addlayout方式添加的界面
local _allResumModuleChidLayout = {}     	-- moduleLayout上添加的界面，addlayout方式添加的界面
local _allResumModuleLayout = {}	-- 来源模块	   changModule方式添加的界面


local _sourceAndAimModule = {}      -- 建立一个 来源和终点的一对一映射
local _rebuildModuleFn = nil
 
-- 获取所有返回信息树
function getResuminfoTree( ... )
 	local _resuminfoTree = { }
	_resuminfoTree["allResumPopLayout"]    	        = 	_allResumPopLayout
	_resuminfoTree["allResumModuleChidLayout"]    	= 	_allResumModuleChidLayout
	_resuminfoTree["allResumModuleLayout"] 	        = 	_allResumModuleLayout
	_resuminfoTree["sourceAndAimModule"] 	        = 	_sourceAndAimModule
	_resuminfoTree["allResuminfo"] 			        = 	_allResuminfo
	_resuminfoTree["allCallFn"] 		            = 	_allCallFn
	_resuminfoTree["allCallFnArg"] 		            = 	_allCallFnArg
 	return _resuminfoTree
end


local function init(...)

end

function destroy(...)
	package.loaded["DropUtil"] = nil
end

function moduleName()

    return "DropUtil"
end

function create(...)

end

-- 检查界面是否缓存过
function checkLayoutIsRetain( curModuleName,layerObj )

	local tbRetainLayerInfo = _allResumPopLayout[curModuleName] or {}
	for i,retainLayerInfo in ipairs(tbRetainLayerInfo) do
		if ( layerObj == retainLayerInfo.popLayer:getWidgetByTag(666666)) then
			return layerObj
		end
	end


	local tbRetainLayerInfo = _allResumModuleChidLayout[curModuleName] or {}

	for i,retainLayerInfo in ipairs(tbRetainLayerInfo) do

		if ( layerObj == retainLayerInfo.popLayer) then
			return layerObj
		end
	end

	return nil
end


function checkInsertBrfore(  moduleLayoutName,insertLayout,layerType)
	if (layerType == 1) then
		if (_allResumPopLayout[moduleLayoutName]) then
			 local tbPopLayout = _allResumPopLayout[moduleLayoutName]
			 for i,_tempLayout in ipairs(tbPopLayout or {}) do
			 	if (insertLayout == _tempLayout.popLayer) then
			 		return true
			 	end
			 end
		end
		return false
	elseif (layerType == 2) then
		if (_allResumModuleChidLayout[moduleLayoutName]) then
		 local tbChildLayout = _allResumPopLayout[moduleLayoutName]
			 for i,_tempLayout in ipairs(tbChildLayout or {}) do
			 	if (insertLayout == _tempLayout.popLayer) then
			 		return true
			 	end
			 end
		end

	end
	return false
end


-- 设置重建模块方法
function setRebuildModuleFn( callfn )
	_rebuildModuleFn = callfn
end

-- 设置模块和引导模块键值对，以便返回时查找对应返回信息
function setSourceAndAim( aimName ,sourceName)
	_sourceAndAimModule[aimName] = sourceName
end

function getSourceAndAim( ... )
	return _sourceAndAimModule
end

-- 添加来源信息
-- topBar 战斗信息条 
-- tbKeep 存放需要保留的公共模块的Tag（对应 nZPmd, nZPlayer, nZMenu)
-- refreshInfo 刷新界面信息  -- returnDestination  -- callfn  -- tableIndex -- fraginfoTid -- itemInfo
function insertReturnInfo( modulename, partname,resumPartInfo )
	if (_allResuminfo[modulename]) then
		_allResuminfo[modulename][partname] = resumPartInfo
	else
		_allResuminfo[modulename] =  {}
		local resumInfo = {}
		resumInfo[partname] = resumPartInfo
		_allResuminfo[modulename] = resumInfo
	end
end

-- 插入回调函数
function insertCallFn( modulename, returnCallFn )
	if (_allCallFn[modulename]) then
		table.insert(_allCallFn[modulename],returnCallFn)
	else
		_allCallFn[modulename] =  {}
		table.insert(_allCallFn[modulename],returnCallFn)
	end

end

-- 插入回调函数所需要的参数
function insertCallFnArg( modulename, returnCallFnArgs )
	if (_allCallFnArg[modulename]) then
		table.insert(_allCallFnArg[modulename],returnCallFnArgs)
	else
		_allCallFnArg[modulename] =  {}
		table.insert(_allCallFnArg[modulename],returnCallFnArgs)
	end
end


-- 返回来源信息
function getReturnInfo( ... )
	return _resuminfo
end

-- 把弹出界面缓存起来
-- popType = 1  为NOscal 添加  0 为正常添加
function insertPopLayout( moduleLayoutName,popLayout,popType ,layerName)
	popLayout:retain()
	if (_allResumPopLayout[moduleLayoutName]  and  not checkInsertBrfore(moduleLayoutName,popLayout,1 )) then
		table.insert(_allResumPopLayout[moduleLayoutName],{ popLayer = popLayout,popType = popType})
	else
		_allResumPopLayout[moduleLayoutName] = {}
		table.insert(_allResumPopLayout[moduleLayoutName],{ popLayer = popLayout,popType = popType})
	end
end

-- 把弹出界面缓存起来
-- popType = 1  为NOscal 添加  0 为正常添加
function insertModeluChildLayout( moduleLayoutName,popLayout,popType,layerName )
	popLayout:retain()
	if (_allResumModuleChidLayout[moduleLayoutName] and not checkInsertBrfore(moduleLayoutName,popLayout,2 )) then
		table.insert(_allResumModuleChidLayout[moduleLayoutName],{ popLayer = popLayout,popType = popType})
	else
		_allResumModuleChidLayout[moduleLayoutName] = {}
		table.insert(_allResumModuleChidLayout[moduleLayoutName],{ popLayer = popLayout,popType = popType})
	end
end

-- 把模块信息缓存起来
function insertModuleLayout(  modulename, moduleLayout )

	if (not _allResumModuleLayout[modulename]) then
		local tempModule = {}
		moduleLayout:retain()
		tempModule.moduleName = modulename
		tempModule.moduleLayout = moduleLayout

		_allResumModuleLayout[modulename] = tempModule

	end
	
end

-- 根据模块名字获取缓存的界面
function getModuleLayoutbyName( modulename )
	return _allResumModuleLayout[modulename]
end

-- 获取所有缓存模块
function getAllModuleLayout( ... )
	return _allResumModuleLayout
end

-- 获取所有缓存弹出界面
function getAllPopLayout( ... )
	return _allResumPopLayout
end

-- 释放所有缓存弹出界面
function destroyPopLayout( aimName,sorceModuleName )

	if (aimName) then
		local resumPopLayout = _allResumPopLayout[sorceModuleName] or {}
		for i,v in ipairs(resumPopLayout) do
			local popLayouTb = v
			local popLayout = popLayouTb.popLayer
			popLayout:release()
			popLayout = nil
			_allResumPopLayout[sorceModuleName] = nil
			break
		end
	else 

		for k,v in pairs(_allResumPopLayout) do
			local resumPopLayout = v
			for i,v in ipairs(resumPopLayout) do
				local popLayouTb = v
				local popLayout = popLayouTb.popLayer
				-- popLayout:removeFromParentAndCleanup(true)
				popLayout:release()
				popLayout = nil
				break
			end
		end
		_allResumPopLayout = {}
	end
end



-- 释放所有缓存弹出界面
function destroyModuleChildLayout( aimName,sorceModuleName )

	if (aimName) then
		local resumPopLayout = _allResumModuleChidLayout[sorceModuleName] or {}
		for i,v in ipairs(resumPopLayout) do
			local popLayouTb = v
			local popLayout = popLayouTb.popLayer
			popLayout:release()
			popLayout = nil
			_allResumModuleChidLayout[sorceModuleName] = nil
			break
		end
	else 

		for k,v in pairs(_allResumModuleChidLayout) do
			local resumPopLayout = v
			for i,v in ipairs(resumPopLayout) do
				local popLayouTb = v
				local popLayout = popLayouTb.popLayer
				popLayout:release()
				popLayout = nil
				break
			end
		end

		_allResumModuleChidLayout = {}
	end

end

-- 删除回调函数缓存
function destroyCallFn( aimName ,sorceModuleName )
	if (aimName) then
		local tempCallTb = _allCallFn[sorceModuleName] or {}
		for i=1,#tempCallTb do
			table.remove(tempCallTb)
		end
	else
		for k,v in pairs(_allCallFn) do
			local tempCallTb = v
			for i=1,#tempCallTb do
				table.remove(tempCallTb)
			end
		end
		_allCallFn = {}
	end

end


-- 释放所有缓存模块界面
function destroyModuleLayout( aimName ,sorceModuleName)

	if (aimName) then
		for k,v in pairs(_allResumModuleLayout) do
			if (k == sorceModuleName) then
				local moduleLayout = v.moduleLayout
				moduleLayout:release()
				moduleLayout = nil
				_allResumModuleLayout[sorceModuleName] = nil  
				_sourceAndAimModule[aimName] = nil
				_allResuminfo[sorceModuleName] = nil
				_allCallFn[sorceModuleName] = nil
				_allCallFnArg[sorceModuleName] = nil
				break
			end
		end
	else
		for k,v in pairs(_allResumModuleLayout) do
			local moduleLayout = v.moduleLayout
			moduleLayout:release()
			_G[v.moduleName].destroy()
			moduleLayout = nil
		end
		_allResumModuleLayout = {}
		_sourceAndAimModule = {}
		_allResuminfo = {}
		_allCallFn = {}
		_allCallFnArg = {}
	end

end


-- 释放某个模块的缓存信息
function releaseRsumInfoByName( aimName,sorceModuleName )
	_rebuildModuleFn = nil
	destroyPopLayout(aimName,sorceModuleName)
	destroyModuleLayout(aimName,sorceModuleName)
	destroyModuleChildLayout(aimName,sorceModuleName)
	destroyCallFn(aimName,sorceModuleName)
end


-- 释放所有模块的缓存信息
function releaseAllRsumInfo(  )
	destroyPopLayout()
	destroyModuleLayout()
	destroyModuleChildLayout()
	destroyCallFn()
	logger:debug({releaseAllRsumInfo_resunInfoTree = resunInfoTree})
end

-- aimName 目标模块名字aimName, tbKeep, bClean
function returnModule(  aimName ,resunInfoTree )

	local sorceModuleName = resunInfoTree.sourceAndAimModule[aimName]
	local resumModule = resunInfoTree.allResumModuleLayout[sorceModuleName]
	local resumPopLayout = resunInfoTree.allResumPopLayout[sorceModuleName]
	local resumModuleChidLayout = resunInfoTree.allResumModuleChidLayout[sorceModuleName]
	local resumModuleInfo = resunInfoTree.allResuminfo[sorceModuleName]

	if (sorceModuleName) then
		LayerManager.changeModule(resumModule.moduleLayout,resumModule.moduleName,resumModuleInfo.tbKeep, resumModuleInfo.bClean,2)
		-- 战斗力信息条
		local fnInfobar = resumModuleInfo.fnInfoBar
		if (fnInfobar) then
			fnInfobar()
		end
		-- 添加module上的child界面
		if (resumModuleChidLayout) then
			for i=1,# resumModuleChidLayout do

				local popLayerTb = resumModuleChidLayout[i]
				local popLayer = popLayerTb.popLayer
				local popType = popLayerTb.popType
				if (popType == 1 and i == 1) then
					resumModule.moduleLayout:setVisible(false)
				end
				LayerManager.addModuleChildLayer(popLayerTb)
			end


		end
		-- 添加 弹出的直接可以添加到scence上的界面
		if (resumPopLayout) then
			for i=1,#resumPopLayout do
				local popLayerTb = resumPopLayout[i]
				local popLayer = popLayerTb.popLayer
				local popType = popLayerTb.popType
				if (popType == 1 and i == 1) then
					resumModule.moduleLayout:setVisible(false)
				end
				LayerManager.addPopLayer(popLayerTb)
			end
		end
	end
end


-- 执行回调
function doCallFn( callfnTb)
	for i=#callfnTb ,1, -1 do
		local callfn = callfnTb[i]
		callfn()
	end

end

-- 执行返回操作
function getReturn( aimName )
	local resunInfoTree = getResuminfoTree()
	local sorceModuleName = resunInfoTree.sourceAndAimModule[aimName]
	local callfnTb = resunInfoTree.allCallFn[sorceModuleName]
	logger:debug({resunInfoTree=resunInfoTree})

	if (sorceModuleName and sorceModuleName ~= {}) then
		if (sorceModuleName ~= aimName) then
			returnModule(  aimName , resunInfoTree )   -- 添加界面
			if (callfnTb and #callfnTb > 0) then
				doCallFn(callfnTb)     -- 执行回调
			end
			releaseRsumInfoByName(aimName,sorceModuleName)
		else
			if (callfnTb and #callfnTb > 0) then
				doCallFn(callfnTb)     -- 执行回调
			end
			releaseRsumInfoByName(aimName,sorceModuleName)
		end
		-- releaseAllRsumInfo()
		return true
	else
		-- 重建模块界面
		if (_rebuildModuleFn) then
			_rebuildModuleFn()
		end
		releaseAllRsumInfo()
		return false
	end

end 


