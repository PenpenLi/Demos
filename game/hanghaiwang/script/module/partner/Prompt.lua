-- FileName: PartnerPrompt.lua 
-- Author: fubei
-- Date: 14-3-28 
-- Purpose: function description of module 

module("Prompt", package.seeall)
require "script/GlobalVars"
require "script/module/public/ShowNotice"
-- vars
local m_i18n = gi18n
local m_i18nString = gi18nString

local nBuyMaxNum = 5                --每次扩充上限
local nNeedPreGold = 25             --每次扩充递增的金币数量
local nPartnerNum = 100             --武将的初始格子数
local fnCallBack --外部传入的回调方法，扩充成功后调用
local m_nExpandGold = 0 -- 扩充需要的金币数

-- 初始化和析构
function init( ... )
    m_nExpandGold = 0
end
function destroy( ... )
    init()
end

function moduleName()
    return "Prompt"
end

local function onBtnClose( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then         
        LayerManager.removeLayout()
    end
end

--获取当前扩充所需要的金币数量
local function fnGetExpandGold( ... )
    local nLimitHeroNum = UserModel.getHeroLimit()
    local nGoldNum = ((nLimitHeroNum - nPartnerNum ) / nBuyMaxNum + 1) * nNeedPreGold
    return nGoldNum
end

--修改扩充数量
local function doExpandCallback(cbFlag, dictData, bRet )
    if (bRet) then
        UserModel.addGoldNumber(-m_nExpandGold)
        UserModel.setHeroLimit(tonumber(dictData.ret))
        LayerManager.removeLayout()
        if (fnCallBack) then
            fnCallBack() 
        end
        ShowNotice.showShellInfo(m_i18nString(1010, m_nExpandGold, nBuyMaxNum))
    end
end

--确认扩充
local function onConfirm( sender, eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        if (fnGetExpandGold() > UserModel.getGoldNumber()) then
            LayerManager.removeLayout() -- 关闭扩充提示面板
            LayerManager.addLayout(UIHelper.createNoGoldAlertDlg()) -- 金币不足, 弹提示充值面板
        else
            RequestCenter.user_openHeroGrid(doExpandCallback, nil)
        end
    end
end

function create( callBack )
    init()

    fnCallBack = callBack

    m_nExpandGold = fnGetExpandGold()

    require "script/module/public/UIHelper"
    local layDlg = UIHelper.createCommonDlg(m_i18nString(1008, nBuyMaxNum, m_nExpandGold), nil, onConfirm)
    LayerManager.addLayout(layDlg)
end