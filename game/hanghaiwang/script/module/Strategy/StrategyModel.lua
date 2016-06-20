-- FileName: StrategyModel.lua
-- Author: yangna
-- Date: 2016-2-4
-- Purpose: 查看攻略 
--[[TODO List]]

module("StrategyModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
-- 攻略数据格式
  --  ｛ “1” ＝ {
          -- uid = "146606",
          -- uname = "345",
          -- figure = "10031",
          -- level = "60",
          -- fight_force = "681775",
          -- extra =
          --     {
          --         "1456107592.000000"
          --     },
          -- arrBrid = 
          --     { 
          --        "24546"
          --     },
          -- guild_name = "1234",
          -- copy_id,      -- 副本有该字段，boss没有
          -- base_id,      --副本， boss都有
          -- base_lv       --副本， boss都有
  --   }
      -- "2" = {
            -- ...
         -- }
-- }

local m_StrategyData    --攻略数据

function destroy(...)
	package.loaded["StrategyModel"] = nil
end

function moduleName()
    return "StrategyModel"
end


function setStrategyData( data )
	m_StrategyData = data 
end


function getStrategyData( ... )
	return m_StrategyData
end

function create(...)

end
