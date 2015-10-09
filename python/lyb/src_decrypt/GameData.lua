GameData={
 	gameMetaScaleRate = CommonUtils:getGameMetaScaleRate();
 	gameUIScaleRate = CommonUtils:getGameUIScaleRate();
 	-- gameWidth = 800;
 	-- gameHeight = 480;
	uiOffsetX = 0;
	uiOffsetY = 0;

	heartHitCount = 0;
	serverAdd = "";
	userAccount = "";
	userKey = "";
	userPassword = "";
	--isNotFirstLoad = nil;
	
	-- 连接类型
	connectType = 0;
	deleteBattleTextureMap = {};
	deleteAllMainSceneTextureMap = {};
    deleteSubMainSceneTextureMap = {};
	deletePreloadTextureMap = {};
	isPopQuitPanel = false;
	isConnect = false;
	isMusicOn = false;
	isShowPlayerTitle = false;
	autoRejectDuel = false;
	
	totalMemory = 0;
	availMemory = 0;

	-- 本地文件内信息
	local_account = nil;
	local_passWord = nil;
	local_serverId = nil;
	local_serverId2 = nil;		
	local_serverId3 = nil;
	local_serverId4 = nil;						
	local_sound = nil;
	local_autoButton = nil;	
	-- 本地文件内信息
	
	hasInit = false;
	bitmapFrameArr = nil;
	backFun = nil;
	backContext = nil;
	-- isPlaySoundEffect = true;
	ServerId = "";
	serverName = "";
	serverIsOpen = "0";
	userState = 0;
	userName = "";
	isConnecting = false;

	-- 发给服务器端的数据
	platFormID = 1;
	install_key = "";
	mac = "";
	udid = "";
	clienttype = "";
	clientversion = "";
	clientpixel= "";
	idfa = "";
	networktype = "";
	gameversion = "";
	channel_id = "";
	--android
	serial_number = "";
	android_id = "";
	google_aid = "";
	equipment = "";
	carrier = "";
	idfa = "";
	simulator = 1;

	-- 当前场景的编号 
	-- 1 loading
	-- 2 main
	-- 3 battle
	currentSceneIndex = 1;

	-- 服务器端传过来的平台userid
	platFormUserId = 0;

	-- 服务器端传过来的平台PlatformId
	platFormId4Dc = nil;

	osTime_m = 0;
	forceToUpdate = false;
	isCheckRoleSource = true;
	isHMenuOpen = true;
	userID="";

	clickRedDotArr = {};
	hasRedDotArr = {};

	isKickByOther = false;

	reLoginCount = 0; -- 重连次数

	limitedClickCount = 0;

	payPrice = 0;
	wifiMac = "";
	kernelTaskStartTime = 0;
	
};