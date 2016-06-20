-- FileName: Online_Debug.lua
-- Author: zhangqi
-- Date: 2015-12-17
-- Purpose: 定义线下环境连线上配置信息，以便线上问题的调试
--[[TODO List]]

--[[desc:zhangqi, 2015-12-17, 线下环境连线上配置信息
    g_DEBUG_env.offline: 默认false, 设置为true表示开启线下连线上配置
    g_DEBUG_env.player: 默认false, 设置为true表示开启模拟玩家登陆模式
    g_DEBUG_env.ios: 默认true, 表示iOS系统，会引用相关其他配置，包括：online_pid, os, pl
    g_DEBUG_env.online_pid: 线上角色对应的Pid的hash值，需要后端查角色名返回数字Pid（如25418）
    						然后再去 http://192.168.1.55:8001/game/replay?pid=25418查看hash值
    g_DEBUG_env.pl: 渠道名称, 可以从平台获取
    g_DEBUG_env.gn: 本游戏名简写，常量
    g_DEBUG_env.getUrlParam: 覆盖 Platform 的同名方法
    g_DEBUG_env.getHost: 覆盖 config_debug.lua 的同名方法
    g_DEBUG_env.pkgUrl: 创建连线上时更新下载路径，更新模块中需要用
—]]
g_DEBUG_env = {offline = false, gn = "cp", ios = false, player = false}

if (g_DEBUG_env.offline) then
	if (g_DEBUG_env.ios) then
		g_DEBUG_env.online_pid = "88ee46b1352c4efb" -- ios app1
		g_DEBUG_env.os = "ios"
		g_DEBUG_env.pl = "apptest"
	else
		g_DEBUG_env.online_pid = "2901ce2466e5d9ce" -- "王小富" -- android zsyphone
		g_DEBUG_env.os = "android"
		g_DEBUG_env.pl = "zsyphone"
	end

	g_DEBUG_env.getUrlParam = function ( ... )
		local urlParam = string.format("&pl=%s&gn=%s&os=%s", g_DEBUG_env.pl, g_DEBUG_env.gn, g_DEBUG_env.os)
        print("urlParam", urlParam)
        return urlParam
	end
	require "platform/Platform"
	Platform.getUrlParam = g_DEBUG_env.getUrlParam

	g_DEBUG_env.getHost = function ( ... )
		return "http://hhwmapi.chaohaowan.com/"
	end
	require "platform/config/config_debug"
	config.getHost = g_DEBUG_env.getHost

    g_DEBUG_env.pkgUrl = function ( DownloadUrl, pkg )
    	return string.format("%s/%s/%s/%s.zip", DownloadUrl, pkg.updateType, pkg.path, pkg.file)
    end
end
