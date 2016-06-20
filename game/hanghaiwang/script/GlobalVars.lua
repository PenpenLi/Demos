-- Filename: GlobalVars.lua
-- Author: fang
-- Date: 2013-05-20
-- Purpose: 该文件用于: 全局变量（非模块）声明及初始化;
-- 注意事项：该文件尽量只用于全局变量声明及初始化，初始化为常量或原生语言数值获取，不能取lua模块内部的数值。
-- zhangqi, 2015-05-21, 本行代码作为测试线上更新用

FRAME_TIME = 1/60  --用于二级菜单，showFlyText等动画

-- 用cpp的随机函数重新实现math.random, 2014-12-30, zhangqi
math.random = function(m, n)
	local r = BTUtil:random()
	if m == nil and n == nil then
		return r
	end

	if n == nil then
		m = math.floor(m)
		return 1 + math.floor((m - 1) * r)
	end

	m = math.floor(m)
	n = math.floor(n)
	return m + math.floor((n - m) * r)
end

-- 是否为调试模式
g_debug_mode = BTUtil:getDebugStatus()

if (g_debug_mode) then
	g_host = "192.168.1.85"
	g_port = 7777
end

-- 是否连的线上环境, zhangqi, 2015-10-27, 
-- 2015-12-29, 默认取值：BTUtil:getBTOnlineType() == 3 表示SDK线上环境，不允许弹报错面板，否则为线下
-- 后面还会根据web端是否返回一个字段 online_state 来最终确定是否线上环境
g_web_env = {online = (BTUtil:getBTOnlineType() == 3)}

-- 得到一个了logger对象 用于输出日志信息
require "script/libs/logging/file"
require "script/libs/logging/console"
require "script/libs/logging"
logger = logging.console() -- 输出指定到控制台

-- zhangqi, 2015-03-30, 加入可以将信息发送到指定url的logger，用于收集线上的Lua报错的栈信息
require "script/libs/logging/http"
loggerHttp = logging.http("http://debug.one-piece.cc:17801/index.php?env=Exception&")
loggerHttp:setLevel(logging.ERROR)

g_no_web = false -- web服务异常情况下的调试开关，用于跳过版本检测、服务器列表等请求直接显示pid登录界面

-- 线下web服务失效时的默认配置
local tempServerList = {
	debug = false,
	group = "game110001",
	hot = 1,
	groupid = "110001",
	show = 1,
	port = 7777,
	openDateTime = 1445011200,
	openPrize = "0",
	status = 1,
	name = "1区-TEST-1服",
	host = "192.168.1.85",
	new = 0,
}

g_tbServerInfo = {} -- zhangqi,2014-09-18,保存当前进入服务器的信息
if (g_debug_mode and g_no_web) then
	g_tbServerInfo = tempServerList
end

-- 2015-03-26, 重写断网重连功能
g_reconnMax = 3 -- 自动重连的最大次数
g_reconnInter = 2 -- 自动重连间隔秒数

-- 设备可视化size
g_winSize = CCDirector:sharedDirector():getVisibleSize()
-- 设备可视起始坐标
g_origin = CCDirector:sharedDirector():getVisibleOrigin()

-- 项目美术资源原始设备size
g_designSize = {width=640.0, height=960.0}

-- X轴伸缩比
g_fScaleX = g_winSize.width/g_designSize.width
-- Y轴伸缩比
g_fScaleY = g_winSize.height/g_designSize.height

-- 界面元素伸缩比
g_fElementScaleRatio = 1.0
-- 界面背景伸缩比
g_fBgScaleRatio = 1.0

-- 通用图片路径
g_pathCommonImage = "images/common/"

-- 胖娃体
g_sFontPangWa = "DFPYuanW9-GB.ttf" -- 方正胖娃体 替换为 新字体
-- 胖娃体
g_sFontCuYuan = "FZCuYuan-M03S.ttf" -- 方正粗圆
-- 通用字体名称
g_sFontName = g_sFontCuYuan -- zhangqi, 2015-06-25, 华康圆体废弃删除改为方正粗圆

-- 系统平台类型，目前有ios, android
g_system_type = BTUtil:getPlatform()

g_tbFontSize = {title = 24, normal = 18, desc = 18} -- zhangqi, 20140428, 默认字体大小

-- TableViewCell动画进入时长
g_cellAnimateDuration = 0.08

-- 提示的显示时长
g_tipAnimateDuration = 2.0

-- 判定左右手势滑动的 x轴有效横移像素点
g_limitedPixels = 10

-- 判定左右手势滑动的 斜率临界值
g_limitedK = 0.5

-- 最大上阵将领个数
g_limitedHerosOnFormation = 6

-- 耐力最大值
g_staminaNum = 100

-- 最大体力上限
g_maxEnergyNum = 150

-- 体力恢复一点时间 added by zhz
g_energyTime = 6*60

-- 2015-04-09, 耐力恢复一点时间 改成30分钟恢复一点
g_stainTime = 30*60

-- 副本难度级别当前分简单，普通，困难 3级。 zhangqi, 20140416
g_HardLevel = 3

-- 网络状态值记录
g_network_disconnected=1                    -- 网络状态：断开
g_network_connecting=2                      -- 网络状态：连接中
g_network_connected=3                       -- 网络状态：已连接


-------------------------------------功能节点枚举值-------------------------------------
-- add by lichenyang 2013.08.29
-- modified by huxiaozhou 2014-06-05
ksSwitchFormation        = 1         --阵容
ksSwitchGeneralTransform = 2         --武将进阶
ksSwitchShop             = 3         --商店
ksSwitchEliteCopy        = 4         --精英副本
ksSwitchActivity         = 5         --活动
ksSwitchGreatSoldier     = 6         --名将
ksSwitchContest          = 7         --比武
ksSwitchArena            = 8         --竞技场
ksSwitchActivityCopy     = 9         --活动副本
ksSwitchPet              = 10        --宠物
ksSwitchResource         = 11        --资源矿
ksSwitchStar             = 12        --占星
ksSwitchSignIn           = 13        --签到
ksSwitchLevelGift        = 14        --等级礼包
ksSwitchSmithy           = 15        --铁匠铺
ksSwitchWeaponForge      = 16        --装备强化
ksSwitchGeneralForge     = 17        --武将强化
-- ksSwitchGeneralTransform = 2 --18        --武将进阶 废弃了 不用 请不要修改
ksSwitchTreasureForge    = 19        --宝物强化
ksSwitchRobTreasure      = 20        --夺宝系统
ksSwitchResolve          = 21        --炼化炉
ksSwitchDestiny          = 22        --天命系统
ksSwitchGuild            = 23        --联盟系统
ksSwitchEquipFixed       = 24        --装备洗练
ksSwitchTreasureFixed    = 25        --宝物精炼
ksSwitchTower            = 26        -- 爬塔
ksSwitchWorldBoss        = 27        -- 世界boss
ksSwitchBattleSoul       = 28        -- 战魂
ksSwitchDress            = 29        -- 主角时装
ksSwitchExplore			 = 30        -- 探索
ksSwitchTreasure         = 31		 -- 宝物
ksSwitchEveryDayTask     = 32        -- 每日任务
ksSwitchHeroBreak		 = 33        -- 伙伴突破
ksSwitchReborn           = 34        -- 分解室重生
ksSwitchLitFmt			 = 35 		 -- 阵容小伙伴
ksSwitchBuyBox			 = 36 		 -- 购买酒馆道具，购买贝里
ksSwitchMysteryShop		 = 37 		 -- 神秘招募
ksSwitchImpelDown	 	 = 38 		 -- 深海监狱
ksSwitchMainShip		 = 39		 -- 主船系统
ksSwitchAwake		     = 40 		 -- 伙伴觉醒
ksSwitchGameBook		 = 41		 -- 游戏宝典
ksSwitchSpeShop          = 42        -- 宝物商店
ksSwitchBuyTreasBox      = 43        -- 开启饰品宝箱
ksSwitchGuildCopy	     = 44        -- 公会副本
ksSwitchHellCopy	     = 45        -- 炼狱副本
ksSwitchCannonAndBall	 = 46        -- 船炮系统



-----------------------引导类型-----------------------
ksGuideFormation        =  1    --引导阵容
ksGuideGeneralTransform =  2    --引导武将进阶
ksGuideFiveLevelGift    =  3    --5级等级礼包
ksGuideCopyBox          =  4    --引导副本箱子
-------
ksGuideReborn			=  5    -- 重生引导
ksGuideSignIn           =  6    --引导签到
ksGuideForthFormation   =  7    --引导第4个上阵栏位开启
ksGuideEliteCopy        =  8    --引导精英副本开启
ksGuideCopy2Box			=  9    --引导第二个副本宝箱
ksGuideArena            =  10   --引导竞技场
ksGuideAstrology        =  13   --引导占星系统
ksGuideRobTreasure      =  15   --夺宝引导系统
ksGuideSmithy           =  16   --装备强化引导系统    modified
ksGuideResolve          =  18   -- 分解室 神秘商店引导
ksGuideDestiny          =  19   --天命系统新手引导
ksGuideExplore			=  20   -- 探索系统新手引导
ksGuideTreasure         =  21   -- 宝物新手引导 不懂加个这个引导有啥效果 【因为夺宝之后会有宝物上阵引导】
ksGuideLitFmt			=  22   -- 阵容引导小伙伴
ksGuideAcopy			=  23   -- 活动副本引导
ksGuideSkypiea			=  24   -- 爬塔引导
ksGuideMainShip         =  25   -- 主船系统引导
ksGuideResource         =  26   -- 资源矿引导
ksGuideImpelDown        =  27   -- 深海监狱引导
ksGuideBoss             =  28   -- 海王类引导
ksGuideAwake            =  29   -- 觉醒引导
ksGuideClose            =  99999  --当前关闭引导


g_tGuideState = {}
g_tGuideState.g_closeGuide			= false  --设置成true 后就关闭引导

g_tConsolStat = {show = true} -- 是否显示控制台按钮，设置成true就显示
---------------------宝物类型--------------------------
kTreasureHorseType      = 1     --1：名马
kTreasureBookType       = 2     --2：名书
kTreasureWeaponType     = 3     --3：名兵(暂无，预留)
kTreasureGemType        = 4     --4：珍宝(暂无，预留)



---------------------平台id-----------------------------
kPlatform_91_ios       = 1001       --91    ios
kPlatform_91_android   = 1002       --91    android
kPlatform_pp           = 1003       --pp    ios
kPlatform_360          = 1004       --360   android
kPlatform_uc           = 1005       --uc    android
kPlatform_dk           = 1006       --百度多酷
kPlatform_xiaomi       = 1007       --小米
kPlatform_dangle       = 1008       --当乐
kPlatform_wandoujia    = 1009       --豌豆荚
kPlatform_anzhi        = 1010       --安智市场
kPlatform_37wan        = 1011       --37wan
kPlatform_jifeng       = 1012       --机锋
kPlatform_tbt          = 1013       --同步推 ios
kPlatform_AppStore     = 1014       --AppSotre
kPlatform_iTools       = 1015       --itools
kPlatform_dangleios    = 1016       --当乐ios
kPlatform_pingguoyuan  = 1017       --苹果园
kPlatform_pp2          = 1018       --pp2
kPlatform_kuaiyong     = 1019
kPlatform_debug        = 9000       --线下测试

---------------------  动画事件  ----------------------------
EVT_START                = 0          -- 开始
EVT_COMPLETE             = 1          -- 结束
EVT_LOOP_COMPLETE        = 2          -- 循环结束

---------------------  副本类型  ----------------------------
COPY_TYPE_NORMAL		= 1 -- 一般副本
COPY_TYPE_ECOPY			= 2 -- 精英副本
COPY_TYPE_EVENT			= 3 -- 活动副本
COPY_TYPE_EVENT_BELLT	= 4 -- 贝里活动副本
COPY_TYPE_AWAKE			= 5 -- 觉醒副本


---------------------  数据  ----------------------------
CCP_ZERO			    = ccp(0,0)
CCP_HALF			    = ccp(0.5,0.5)


--************************ CardPirate **************************
g_UserDefault = CCUserDefault:sharedUserDefault()
g_ProjName = "fknpirate" -- 游戏名称，用于更新包目录结构的root目录名称
g_ResRoot = "Resources" -- 更新包的二级目录名称
g_ResPath = CCFileUtils:sharedFileUtils():getWritablePath()
g_ExtUpdateHistory = string.format("%s%s/%s/UpdateHistory", g_ResPath, g_ProjName, g_ResRoot) -- 外部的历史更新列表
g_attribManager = AttribEffectManager:new()

g_HttpConnTimeout = 15 -- http 请求超时，单位秒
g_HttpRateRef = 10 -- http 下载速率，单位 KB/秒，用来计算资源更新下载时的超时
g_HttpReadTimeout = 60 -- http 下载最小超时，单位秒

-- 为了满足设计高度1136的副本大地图在iPhone5上的不缩放需求，设置特殊的缩放比例
g_CopyBgRate1136 = g_winSize.height/1136

g_UpgradeStamina = 10 -- zhangqi, 2015-05-16, 每次升级赠送的耐力 

-- 按钮红点提示的全局状态变量
g_redPoint = {
	conch = {visible = false, num = 0}, -- 空岛贝背包按钮
	partner = {visible = false, num = 0}, -- 伙伴背包按钮
	equip = {visible = false, num = 0}, -- 装备背包按钮
	bag = {visible = false, num = 0, lastVisible = false}, -- 道具背包按钮
	diviStar = {visible = false,num = 0}, --占星
	newMail = {visible = false,num = 0}, --邮件
	newMineMail = {visible = false,FirstTabShowRed = false,SecondTabShowRed = false,num = 0}, --资源矿邮件
	chat = {visible = false, num = 0}, -- 聊天
	treasure = {visible = false, num = 0}, -- zhangqi, 2015-09-15, 宝物背包按钮
	special = {visible = false,num=0},
	recovery = {visible = false,num = 0}, --zhangjunwu 2015-10-13 回收系统主界面红点
	awake = {visible = false, num = 0},   -- lvnanchun 2015-11-18 觉醒背包红点
	newGuildMemApply = {visible = false,num = 0}  --yangna 2015.12.21  工会成员有新的申请
}

g_redPoint.partner.setvisible=function(val)
	require "script/model/user/UserModel"
	CCUserDefault:sharedUserDefault():setIntegerForKey("g_redPoint_partner_visible"..UserModel.getUserUid(), val)
	CCUserDefault:sharedUserDefault():flush()
end
g_redPoint.partner.getvisible=function()
	require "script/model/user/UserModel"
	return CCUserDefault:sharedUserDefault():getIntegerForKey("g_redPoint_partner_visible"..UserModel.getUserUid())
end



-- zhangjunwu 2014-11-5 伙伴背包，装备背包，道具背包，宝物背包 刷新列表的 全局状态变量
g_bagRefresh = {
	parnterRefresh 			= false, --伙伴背包
	partnerFragRefresh 		= false, -- 伙伴碎片背包
	equipRefresh 			= false, -- 装备背包
	equipFragRefresh		= false, -- 装备背包
	itemRefresh  			= false, --道具背包
	treasRefresh 			= false, -- 宝物背包
	conchRefresh			= false, -- 空岛贝背包
	awakeRefresh			= false, -- 觉醒背包
}

g_tbTouchPriority = { -- 统一的触摸优先级管理
	richTextBtn = -11 , --富文本的文本按钮优先级
	battleLayer = -100, -- 战斗场景层
	battleMenu = -105, -- 战斗场景按钮层
	popDlg = -110, -- 弹出框，需要通过优先级来屏蔽下方的CCTableView列表上的其他按钮
	editbox = -115, -- 输入框
	explore=-120 ,--一键探索屏蔽层
	guide = -125, -- 新手引导层
	switch = -126, -- 功能开启面板
	talk = -127, -- 对话层
	network = -128, -- 网络错误弹出框，优先级最高
	touchEffect = -129, -- 全局的触屏特效层
	ShieldLayout = -10000, --屏蔽旧界面往新界面传递触摸层。
}

g_battleLayout = "battleLayout" -- 战斗场景专用的layout名称，用于LayerManager的管理，zhangqi
g_HolderLayout = "holderLayout"  --据点专用layout

--zhangjunwu 吧聊天中的cell的类型提取出来，防止引用无用的模块
ChatCellType = {
	normal = 1,
	copyReport = 2,
	playerReport = 3,  --普通战报
	battleReport = 4 ,--新添加战报类型，用于攻略战报 by yangna 2016.2.5
}

--zhangjunwu 
ResolveTabType = {
	E_Parnter = 1,
	E_Shadow = 2,
	E_Reborn = 3,
	E_Equip = 4,
	E_Treas = 5,
	E_SPTreas = 6,
	E_SuperShip = 7,
}
--zhangjunwu 2016-2-17
g_ApplyMax  = 5 --可申请公会的上限


-- 默认的字体信息
g_FontInfo = {
	name = "FZCuYuan-M03S.ttf", -- zhangqi, 2015-06-25, 华康圆体废弃删除改为方正粗圆
	size = 22,
	color = ccc3(0xff, 0xff, 0xff),
	stroke = (g_system_type == kBT_PLATFORM_ANDROID) and 3 or 2, --zhangqi,20140605, iOS系统描边2px，安卓系统3px
	strokeColor = ccc3(0x00, 0x00, 0x00),
}

g_FontPangWa = "DFPYuanW9-GB.ttf" -- 方正胖娃体 替换为 新字体

g_FontCuYuan = "FZCuYuan-M03S.ttf" -- 方正粗圆简体

g_FontEn = g_FontCuYuan -- zhangqi, 2015-06-25, 华康圆体废弃删除改为方正粗圆

-- 中间有空格的属性名称
local m_i18n = gi18n
g_AttrNameSpaces = {hp = m_i18n[1032], phy_att = m_i18n[1658], magic_att = m_i18n[1659], phy_def = m_i18n[1660], magic_def = m_i18n[1661], }
-- 中间没有空格的属性名称
g_AttrName = {hp = m_i18n[1047], phy_att = m_i18n[1048], magic_att = m_i18n[1049], phy_def = m_i18n[1050], magic_def = m_i18n[1051], }

--中间没有空格并且没有':'
g_AttrNameWithoutSign = {hp = m_i18n[1068], phy_att = m_i18n[1069], magic_att = m_i18n[1070], phy_def = m_i18n[1071], magic_def = m_i18n[1072], }

-- 映射关系
g_LockAttrNameConfig = { ["1"] = "hp", ["2"] = "phy_att" ,["3"] = "magic_att", ["4"] = "phy_def",["5"] = "magic_def", 
						["11"] = "percentHP", ["12"] = "percentPhyAtt", ["13"] = "percentMagAtt", ["14"] = "percentPhyDef", ["15"] = "percentMagDef", }


-- 品质等级颜色: 灰色：#efefef 白色：#ffffff 绿色：#01f45a 蓝色：#1fe8f9 紫色：#fb48ff 橙色：
-- 常用较暗的配色
g_QulityColor = {ccc3(0x4b,0x4b,0x4b),
	ccc3(0x4b,0x4b,0x4b),
	ccc3(0x00,0x62,0x0c),
	ccc3(0x00,0x3d,0xc7),
	ccc3(0xa1,0x15,0xb6),
	ccc3(0xf4,0x62,0x00), -- 橙色品质以前为#fe4a00，修改为 #f46200	
	ccc3(0xdf,0x00,0x00), -- 红色品质以前为#b30606，修改为 #df0000
}
-- 较亮的配色，个别地方使用
g_QulityColor2 = {ccc3(0xdb,0xdb,0xdb),
	ccc3(0xdb,0xdb,0xdb),
	ccc3(0x4d,0xec,0x15),
	ccc3(0x1f,0xd7,0xff),
	ccc3(0xee,0x46,0xec),
	ccc3(0xff,0x96,0x00),
	ccc3(0xff,0x30,0x1b),      -- 新添加红色
}

-- zhangqi, 2015-06-30, 伙伴，宝物，装备信息模块中用到的品级配色方案
g_QulityColor3 = {ccc3(0xdf,0xdf,0xdf),
	ccc3(0xdf,0xdf,0xdf),
	ccc3(0xc9,0xff,0xbc),
	ccc3(0xa1,0xf1,0xff),
	ccc3(0xff,0xce,0xf9),
	ccc3(0xf7,0xd2,0x8e),
	ccc3(0xff,0xc0,0xc0),	  -- 新添加红色
}

-- 属性显示的名称和数值字体样式
g_AttrFont = {title = {size = 22, name = g_FontCuYuan, color = ccc3(0x7f, 0x5f, 0x20)},
				value = {size = 22, name = g_FontCuYuan, color = ccc3(0x57, 0x1e, 0x01)}
			 }

g_btnTitleGray = ccc3(0xf0, 0xf0, 0xf0) -- 按钮标题置灰的颜色，2015-04-30

-- 品质决定 宝物显示样子    灰白绿蓝紫橙
g_QulityTextIndex = {1739,
	1740,
	1741,
	1742,
	1743,
	1744,
}

-- 品质名称图片(灰白绿蓝紫橙)
g_QulityImageIndex = {
	"images/common/hero_star/star_1.png",
	"images/common/hero_star/star_2.png",
	"images/common/hero_star/star_3.png",
	"images/common/hero_star/star_4.png",
	"images/common/hero_star/star_5.png",
	"images/common/hero_star/star_6.png",
	"images/common/hero_star/star_7.png",

}

-- 各种列表(各种物品背包和选择上阵列表)用到的cell的类型
g_tbCellType = {
	partner = 1, -- 伙伴
	shadow = 2, -- 伙伴碎片
	item = 3, -- 道具
	treasure = 4, -- 宝物
	equip = 5, -- 装备
	fragment = 6, -- 装备碎片
	fight = 7, -- 战魂
	pet = 8, -- 宠物
}

-- 背包列表标签按钮标题文字默认颜色和选中颜色
-- zhangqi, 2014-08-20, 策划说美术要求按钮文字颜色都改为白色
g_TabTitleColor = {normal = ccc3(255,255,255), selected = ccc3(255,255,255)} --selected = ccc3(0x60, 0xf5, 0xdd)}


-- zhangqi, 2015-06-19, 进入装备强化界面的前一模块标识
g_equipStrengthFrom = {}
g_equipStrengthFrom.CreateType = {
	createTypeFormation = 1, -- 从阵容过来 
	createTypeEquipList = 2,  -- 从装备列表来
	createTypeEquipFragList = 3, -- 从装备碎片列表来
	createTypeSellEquip = 4, -- 从出售装备
	createTypeSellEquipFrag = 5, -- 出售装备碎片
	createTypeOtherFormation = 6, -- 查看别人装备
	createTypeBtnBar = 7, -- 从按钮面板进入
}

-- zhangqi, 2015-06-23, 进入宝物信息界面的前一模块标识
g_treaInfoFrom = {
	layFromBagType = 1, 	--从背包来的
	layFromForType = 2,		--从阵容来的
	layFromRobType = 4,		--从夺宝来的
	layFromOtherType = 3,	--其他
	layFromOtherFormationType = 5 ,	--从别人阵容上来
	layFromRefine = 6 ,
	layFromChooseType = 7 -- 从阵容的更换装备列表中来
}



-- zhangqi, 20140324
--[[desc: 加载指定的json文件
    jsonFile: json 文件名
    bSetSize: 是否自动设置全屏尺寸，加载非UI画布（比如只是放了多种列表cell的画布）时可能需要指定为true
    return: 如果加载正确返回 Widget 对象  
—]]
g_fnLoadUI = function ( jsonFile, bSetSize )
	local widget = GUIReader:shareReader():widgetFromJsonFile(jsonFile)
	assert(widget, "load UI Error: " .. jsonFile)
	if (not bSetSize) then
		widget:setSize(g_winSize) -- 2014-05-08, 所有画布默认设置全屏大小
	end
	GUIReader:purge() -- 加载完释放Reader
	return widget
end

--[[desc: 根据名称查找子控件
    objRootPanel: 父级层容器对象
    strName: 子控件名称
    strUIType: 实际的控件类型，例如 "Label", "Button", 如果不指定则按控件名称前缀获取类型
    return: 查到的话返回子控件对象
—]]
-- 各种控件的名称前缀和控件类型名对应表
local tbWidgetType = {
	["WID"] = "Widget", --UI中不使用 设置UI快速访问使用  liweidong
	["TABLEVIEWLAYOUT"] = "TableViewLayout", --UI中不使用 设置UI快速访问使用 这个类型老是把其他类型覆盖 liweidong
	["BTN"] = "Button", -- 按钮（Button）
	["IMG"] = "ImageView", -- 图片（ImageView）
	["CBX"] = "CheckBox", -- 复选框（CheckBox）
	["LABN"] = "LabelAtlas", -- 数字标签
	["FNT"] = "LabelBMFont", -- 自定义字体
	["LOAD"] = "LoadingBar", -- 加载进度条
	["SCB"] = "Slider", -- 滚动条
	["TFD"] = "Label", -- 文本框（多行）
	["INP"] = "Input", -- 输入框
	["LAY"] = "Layout", -- 层容器
	["SCV"] = "ScrollView", -- 滑动层（ScrollView）
	["LSV"] = "ListView", -- 列表容器（ListView）
	["PGV"] = "PageView", -- 翻页容器（PageView）
}
g_fnGetWidgetByName = function ( objRootPanel, strName, strUIType )
	local wt = string.upper(string.strsplit(strName, "_")[1]) -- 取出控件名称中的类型, 转成大写
	local widget = tolua.cast(UIHelper:seekWidgetByName(objRootPanel, strName), strUIType or tbWidgetType[wt])
	-- logger:debug("g_fnGetWidgetByName: %s, type: %s", strName, (strUIType or tbWidgetType[wt]))
	-- return assert(widget, "can not found " .. strName .. " type: " .. (strUIType or tbWidgetType[wt]))
	return widget
end
--liweidong 设置UI快速访问
function setWidgetQuickAccess()
	local function getWidget(table,key)
		local node=g_fnGetWidgetByName(table, key)
		table[key]=node --缓存
		return node
	end
	for _,val in pairs(tbWidgetType) do
		local widget=Widget:create()
		tolua.cast(widget, val)
		local originalMetaTable=getmetatable(widget)
		local originalIndex=originalMetaTable.__index
		local function newIndexFun(table, key)
			if (type(originalIndex)=="function") then
				return originalIndex(table,key) or getWidget(table,key)
			elseif (type(originalIndex)=="table") then
				return originalIndex[key] or getWidget(table,key)
			else
				return getWidget(table,key)
			end
		end
		originalMetaTable.__index = newIndexFun
	end
end
setWidgetQuickAccess()

function g_fnCastWidget( widget )
	if not widget:getName() then
		return
	end
	local wt = string.upper(string.strsplit(widget:getName(), "_")[1])
	local widget = tolua.cast(widget, tbWidgetType[wt])
end


--[[desc: 返回一个绝对的(x,y)坐标相对于指定Widget size的百分比
    widParent: 坐标相对的Widget
    newX: 绝对的X坐标
    newY: 绝对的Y坐标
    return: 一个CCPoint对象  
—]]
function g_GetPercentPosition( widParent, newX, newY )
	local size = widParent:getContentSize()
	return ccp(newX/size.width, newY/size.height)
end

function g_GetUpgradeRewardGold( ... )
	return 10
end

function g_GetUpgradeRewardStamina( ... )
	return 10 -- 2015-05-09
end

-- 从extern.lua移过来
--每间隔多少秒执行一次callback liweidong
--特别注意CCDelayTime是一个动作，和schedule定时不同，一帧内可能执行多次callback。即使游戏卡也能保证多少秒执行一次。
function schedule(node, callback, delay)
	local delay = CCDelayTime:create(delay)
	local callfunc = CCCallFunc:create(callback)
	local sequence = CCSequence:createWithTwoActions(delay, callfunc)
	local action = CCRepeatForever:create(sequence)
	node:runAction(action)
	return action
end

function performWithDelay(node, callback, delay)
	local delay = CCDelayTime:create(delay)
	local callfunc = CCCallFunc:create(callback)
	local sequence = CCSequence:createWithTwoActions(delay, callfunc)
	node:runAction(sequence)
	return sequence
end

--每一帧执行 =====begin
local frameCallBack = {}
function everyFrameEvent( )
    for _,val in ipairs(frameCallBack) do
    	if (val.fun) then
	        val.fun()
	    end
    end
end
local function registFrameFun(node,funtion)
    table.insert(frameCallBack,{obj=node,fun=funtion})
end
function revmoeFrameFun( fun )
    for _,val in ipairs(frameCallBack) do
        if (val.fun==fun) then
            table.remove(frameCallBack,_)
            break
        end
    end
end
function revmoeFrameNode( obj )
    for i=#frameCallBack,1,-1 do
    	if (frameCallBack[i].obj==obj) then
            table.remove(frameCallBack,i)
        end
    end
end
--所有帧事件执行完成之后调用的
function afterAllFrameFun(fun)
	local scene = CCDirector:sharedDirector():getRunningScene()
	local action
	action = schedule(scene,function()
			if (#frameCallBack<=0) then
				fun()
				scene:getActionManager():removeAction(action)
			end
		end,0.01)
end
--每隔多少帧执行一次 liweidong 【禁止使用】
function scheduleFrame(node, callback, delay)
	if (node and tonumber(node:getScriptHandler())==0) then
		UIHelper.registExitAndEnterCall(node)
	end

    local frames=0
    local onCall = nil 
    onCall = function()
        frames = frames+1
        if (frames%delay==0) then
            callback(frames)
        end
    end
    registFrameFun(node,onCall)
    return onCall
end
--延迟多少帧执行 liweidong
function performWithDelayFrame(node, callback, delay)
	if (tonumber(delay)<=0) then
		callback()
		return
	end
	if (node and (not node.m_status_scriptHandler)) then
		UIHelper.registExitAndEnterCall(node)
	end
    local frames=-1
    local onCall = nil 
    onCall = function()
        frames = frames+1
        if (frames>=delay) then
            callback(frames)
            revmoeFrameFun(onCall)
        end
    end
    registFrameFun(node,onCall)
    return onCall
end

--liweidong记录常住内存的object对象
foreverObjectArr = CCArray:create()
foreverObjectArr:retain()
--liweidong删除常住内存的object对象
function deleteForeverObjects()
	logger:debug("release c++ object num:" .. foreverObjectArr:count())
	foreverObjectArr:release()
	DropUtil.releaseAllRsumInfo()
end
