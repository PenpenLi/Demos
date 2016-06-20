-- FileName: PlayerPanel.lua
-- Author: zhangqi
-- Date: 2014-03-24
-- Purpose: 玩家信息面板
-- 修改信息：2015-10-08，信息条改为附加到模块的根画布，不用再检查场景根画布，暂时注释掉所有相关代码

module("PlayerPanel", package.seeall)

-- 模块局部变量
local curfnInfoBaf = nil
local tbInfoBar = nil

function moduleName()
	return "PlayerPanel"
end

-- 初始函数，加载UI资源文件
function init( ... )
	logger:debug("PlayerPanel init ok")
end

-- 析构函数，释放纹理资源
function destroy( ... )
	logger:debug("PlayerPanel.destroy")
end

function removeCurrentPanel( ... )
	removeInfoBar() -- zhangqi, 2015-10-08, 改为调用PlayerInfoBar的全局方法
end

function resetInfobar( ... )
	curfnInfoBaf = nil
	tbInfoBar = nil
end


function createtbInfoBar( ... )
	tbInfoBar = {
		["addForMainShip"] = addForMainShip,
		["addForCopy"] = addForCopy,
		["addForExplor"] = addForExplor,
		["addForExplorNew"] = addForExplorNew,
		["addForExplorMap"] = addForExplorMap,
		["addForExplorMapNew"] = addForExplorMapNew,
		["addForPartnerStrength"] = addForPartnerStrength,
		["addForPublic"] = addForPublic,
		["addForActivity"] = addForActivity,
		["addForActivityCopy"] = addForActivityCopy,
		["addForArena"] = addForArena,
		["addForSkyPiea"] = addForSkyPiea,
		["addForGrab"] = addForGrab,
		["addForUnionShop"] = addForUnionShop,
		["addForUnionPublic"] = addForUnionPublic,
		["addForImpelDown"] = addForImpelDown,
		["addForSpecial"] = addForSpecial,
		["addForStrenMaster"] = addForStrenMaster,
	}
end


function addForMainShip( ... )
	-- 为返回功能做处理 设置当前module的infobar创建方法，引导返回的时候原界面的时候再重新执行 addby孙云鹏 2015-11-11
	curfnInfoBaf = "addForMainShip"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/MainInfoBar"
		local infoBar = MainInfoBar:new()
		infoBar:create()
	-- end

end

function addForCopy( ... )
	curfnInfoBaf = "addForCopy"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/CopyInfoBar"
		local infoBar = CopyInfoBar:new()
		infoBar:create()
	-- end

end

function addForExplor( ... )
	curfnInfoBaf = "addForExplor"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ExplorInfoBar"
		local infoBar = ExplorInfoBar:new()
		infoBar:create()
	-- end

end
function addForExplorNew( ... )
	curfnInfoBaf = "addForExplorNew"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ExplorInfoBarNew"
		local infoBar = ExplorInfoBarNew:new()
		infoBar:create()
	-- end

end
function addForExplorMap( ... )
	curfnInfoBaf = "addForExplorMap"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ExplorMapInfoBar"
		local infoBar = ExplorMapInfoBar:new()
		infoBar:create()
	-- end

end
function addForExplorMapNew( ... )
	curfnInfoBaf = "addForExplorMapNew"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ExplorMapInfoBarNew"
		local infoBar = ExplorMapInfoBarNew:new()
		infoBar:create()
	-- end

end
function addForPartnerStrength( ... )
	curfnInfoBaf = "addForPartnerStrength"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/PartnerInfoBar"
		local infoBar = PartnerInfoBar:new()
		infoBar:create()
	-- end

end
function addForPublic( ... )
	curfnInfoBaf = "addForPublic"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/PublicInfoBar"
		local infoBar = PublicInfoBar:new()
		infoBar:create()
	-- end

end

function addForActivity( ... )
	curfnInfoBaf = "addForActivity"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ActivityInfoBar"
		local infoBar = ActivityInfoBar:new()
		infoBar:create()
	-- end

end
function addForActivityCopy( ... )
	curfnInfoBaf = "addForActivityCopy"

-- 	local layRoot = LayerManager.getRootLayout()
-- 	if (layRoot) then
		require "script/module/PlayerInfo/ACopyInfoBar"
		local infoBar = ACopyInfoBar:new()
		infoBar:create()
	-- end

end

function addForArena( ... )
	curfnInfoBaf = "addForArena"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ArenaInfoBar"
		local infoBar = ArenaInfoBar:new()
		infoBar:create()
	-- end

end

function addForSkyPiea(  )
	curfnInfoBaf = "addForSkyPiea"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/SkyPieaInfoBar"
		local infoBar = SkyPieaInfoBar:new()
		infoBar:create()
	-- end
end

function addForGrab(  )
	curfnInfoBaf = "addForGrab"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/GrabInfoBar"
		local infoBar = GrabInfoBar:new()
		infoBar:create()
	-- end

end

function addForUnionShop( ... )
	curfnInfoBaf = "addForUnionShop"

	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/UnionShopInfoBar"
		local infoBar = UnionShopInfoBar:new()
		infoBar:create()
	-- end
end

function addForUnionPublic( ... )
	curfnInfoBaf = "addForUnionPublic"
	
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/UnionPublicInfoBar"
		local infoBar = UnionPublicInfoBar:new()
		infoBar:create()
	-- end
end

function addForImpelDown( ... )
	curfnInfoBaf = "addForImpelDown"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/ImpelDownInfoBar"
		local infoBar = ImpelDownInfoBar:new()
		infoBar:create()
	-- end
end

function addForSpecial( ... )
	curfnInfoBaf = "addForSpecial"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/SpecialBar"
		local infoBar = SpecialBar:new()
		infoBar:create()
	-- end
end

function addForStrenMaster( ... )
	curfnInfoBaf = "addForPartnerStrength"
	-- local layRoot = LayerManager.getRootLayout()
	-- if (layRoot) then
		require "script/module/PlayerInfo/PartnerInfoBar"
		local infoBar = PartnerInfoBar:new()
		infoBar:create()
		infoBar.layMain.lay_home_paomadeng:setSize(CCSizeMake(0, 8))
	-- end

end

function insertReturnInfo( curModule )
	createtbInfoBar()
	if (curfnInfoBaf) then
		DropUtil.insertReturnInfo(curModule,"fnInfoBar", tbInfoBar[curfnInfoBaf])
	end
	removeCurrentPanel()
end




