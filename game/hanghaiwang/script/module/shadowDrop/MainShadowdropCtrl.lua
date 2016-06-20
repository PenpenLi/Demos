-- FileName: MainShadowdropCtrl.lua
-- Author: lizy
-- Date: 2014-07-30
-- Purpose: 影子掉落模块
--[[TODO List]]

module("MainShadowdropCtrl", package.seeall)
require "script/module/shadowDrop/MainShadowdropView"
require "script/network/RequestCenter"
-- UI控件引用变量 --

-- 模块局部变量 --
local shadowInfo 
local dropReturnInfo

local function init(...)

end

function destroy(...)
	package.loaded["MainShadowdropCtrl"] = nil
end

function moduleName()
    return "MainShadowdropCtrl"
end

local function createView( copyData )
	 local  layBg  =   MainShadowdropView.create(shadowInfo,copyData,dropReturnInfo)
     LayerManager.addLayout(layBg)
     return layBg
end
function create(fraginfo,returnInfo)
	dropReturnInfo = returnInfo
   shadowInfo = DB_Item_hero_fragment.getDataById(fraginfo.id)
   getCopylist(createView)
  
end

function getCopylist(  )
	--RequestCenter.ncopy_getCopyList(copyListCallBack)
	--RequestCenter.getLastNormalCopyList(copyListCallBack)
	local copyid 
	--logger:debug( dictData.ret )
	createView(DataCache.getNormalCopyData().copy_list)
end

function copyListCallBack(  cbFlag, dictData, bRet  )
	  
	-- local copyid 
	-- logger:debug( dictData.ret )
	-- createView(DataCache.getNormalCopyData().copy_list)
end