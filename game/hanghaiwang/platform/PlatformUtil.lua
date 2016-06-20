-- Filename: PlatformUtil.lua
-- Author: chao he
-- Date: 
-- Purpose: 该文件用于处理平台相关接口
module("PlatformUtil", package.seeall)

require "script/module/main/LayerManager"

--[[desc: zhangqi, 指定文本和确认回调事件创建一个公用对话框
    strText: 提示文本，可以是nil
    richText: 富文本对象，可以是nil
    fnConfirmEvent: 确认按钮回调事件，是nil时默认关闭对话框
    nBtn: 1, 显示一个确定按钮; nil 或 2, 默认显示确定和取消按钮
    return: Layout
—]]
function showAlert( strText, richText, fnConfirmEvent, nBtn, fnCloseCallback )
	print("showAlert111strText",strText)
	require "script/module/public/UIHelper"
	LayerManager.addLayout(UIHelper.createCommonDlg( strText, richText, fnConfirmEvent, nBtn, fnCloseCallback ))

end

function closeAlert( ... )
	
end

--增加loding
function addLoadingUI()
	-- 发送网络请求显示的loading 面板
	LayerManager.addLoading()
end

--删除loding
function reduceLoadingUI(  )
	LayerManager.removeLoading()
end

--增加loginloding
function addLoginLoadingUI()
	-- 点击登录按钮后显示的loading面板, 进入主页后自动消失
	LayerManager.addLoginLoading()
end
--删除loginloding
function reduceLoginLoadingUI(  )
	LayerManager.removeLoginLoading()
end

function showInfo( info )
	
end
