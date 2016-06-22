--region NewFile_1.lua
--Author : BearLuo
--Date   : 2015/4/23

require(BASE_PATH.."chessScene");

OwnScene = class(ChessScene);

OwnScene.s_controls = 
{
    scroll_view             = 1;
    top_cloth               = 2;
    head_icon_btn           = 3;
    user_name               = 4;
    login_type              = 5;
    info_view               = 6;
    my_sexual               = 7;
    my_region               = 8;
    bind_view               = 9;
    userinfo_view           = 10;
    my_level                = 11;
    my_name                 = 12;
    my_notice               = 13;
    my_setting              = 14;
    menu                    = 15;
    set_btn                 = 16;
    feedback_btn            = 17;
    share_btn               = 18;
    my_uid                  = 19;
    bottom_menu             = 20;
--    switch_account          = 21;

}

OwnScene.s_cmds = 
{
    updateUserInfoView      = 1;
    upLoadImage             = 2;
    updateUserHead          = 3;
}
OwnScene.ctor = function(self,viewConfig,controller)
	self.m_ctrls = OwnScene.s_controls;
    self:create();
end 

OwnScene.resume = function(self)
    ChessScene.resume(self);
    self:updateUserInfoView();
--    self:resumeAnimStart();
    require("chess/include/bottomMenu");
    BottomMenu.getInstance():onResume(self.m_bottom_menu);
    BottomMenu.getInstance():setHandler(self,BottomMenu.OWNTYPE);
end

OwnScene.isShowBangdinDialog = false;

OwnScene.pause = function(self)
	ChessScene.pause(self);
    self:removeAnimProp();
--    self:pauseAnimStart();
    BottomMenu.getInstance():onPause();
end 

OwnScene.dtor = function(self)
    delete(self.m_toggleAccountDialog);
    delete(self.m_chioce_dialog);
    delete(self.m_changeHeadDialog);
    delete(self.m_locate_city_dialog);
    delete(self.m_select_sex_dialog);
    delete(self.anim_start);
end 

OwnScene.removeAnimProp = function(self)
    self.m_top_cloth:removeProp(1);
    self.left_leaf:removeProp(1);
    self.right_leaf:removeProp(1);
    self.m_my_uid:removeProp(1);
    self.m_my_uid:removeProp(2);
    self.m_my_level:removeProp(1);
    self.m_my_level:removeProp(2);
    self.m_my_name:removeProp(1);
    self.m_my_name:removeProp(2);
    self.m_my_notice:removeProp(1);
    self.m_my_notice:removeProp(2);
    self.m_my_setting:removeProp(1);
    self.m_my_setting:removeProp(2);
    self.m_my_sexual:removeProp(1);
    self.m_my_sexual:removeProp(2);        
    self.m_my_region:removeProp(1);
    self.m_my_region:removeProp(2);

    if self.bindTabitem and #self.bindTabitem > 0 then
        for i =1, #self.bindTabitem do 
            self.bindTabitem[i]:removeProp(1);
            self.bindTabitem[i]:removeProp(2);
        end
    end
    delete(self.anim_start);
    delete(self.timerAnim);
    self.timerAnim = nil;
    delete(self.anim_end);
end

OwnScene.setAnimItemEnVisible = function(self,ret)
    self.left_leaf:setVisible(ret);
    self.right_leaf:setVisible(ret);
end

OwnScene.resumeAnimStart = function(self,lastStateObj,timer)
    --背景移动
    self:setAnimItemEnVisible(false);
    BottomMenu.getInstance():hideView(true);
    self:removeAnimProp();
    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(lastStateObj.state) then
        if not BottomMenu.getInstance():checkStateSort(States.ownModel,lastStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,-w,0,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,w,0,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(0,timer);
    end


    local duration = timer.duration;
    local waitTime = timer.waitTime
    local delay = waitTime+duration;

    delete(self.anim_start);
    self.anim_start = new(AnimInt,kAnimNormal,0,1,0,duration);
    if self.anim_start then
        self.anim_start:setEvent(self,function()
            self:setAnimItemEnVisible(true);
            delete(self.anim_start);
        end);
    end


    local lw,lh = self.left_leaf:getSize();
    self.left_leaf:addPropTranslate(1,kAnimNormal,waitTime,delay,- lw,0,-30,0);
    local rw,rh = self.right_leaf:getSize();
    --local anim = 
    self.right_leaf:addPropTranslate(1,kAnimNormal,waitTime,delay,rw,0,-30,0);
--    if anim then
--        anim:setEvent(self,function()
--            self:removeAnimProp();
--        end);
--    end
    -- 上部动画
    local tw,th = self.m_top_cloth:getSize();
    self.m_top_cloth:addPropTranslate(1, kAnimNormal, waitTime, delay, 0, 0, -th, 0);

    self.m_my_uid:addPropTransparency(2,kAnimNormal,waitTime-150,delay,0,1);
    self.m_my_uid:addPropScale(1,kAnimNormal,waitTime-150,delay,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_level:addPropTransparency(2,kAnimNormal,waitTime-150,delay+100,0,1);
    self.m_my_level:addPropScale(1,kAnimNormal,waitTime-150,delay+100,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_name:addPropTransparency(2,kAnimNormal,waitTime-150,delay+200,0,1);
    self.m_my_name:addPropScale(1,kAnimNormal,waitTime-150,delay+200,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_notice:addPropTransparency(2,kAnimNormal,waitTime-150,delay+300,0,1);
    self.m_my_notice:addPropScale(1,kAnimNormal,waitTime-150,delay+300,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_setting:addPropTransparency(2,kAnimNormal,waitTime-150,delay+400,0,1);
    self.m_my_setting:addPropScale(1,kAnimNormal,waitTime-150,delay+400,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_sexual:addPropTransparency(2,kAnimNormal,waitTime-150,delay+500,0,1);
    self.m_my_sexual:addPropScale(1,kAnimNormal,waitTime-150,delay+500,0.8,1,0.8,1,kCenterXY,98,110);

    self.m_my_region:addPropTransparency(2,kAnimNormal,waitTime-150,delay+600,0,1);
    self.m_my_region:addPropScale(1,kAnimNormal,waitTime-150,delay+600,0.8,1,0.8,1,kCenterXY,98,110);

    local startAnimIntDelay = 0
    if self.bindTabitem and #self.bindTabitem > 0 then
        startAnimIntDelay = #self.bindTabitem * 100;
        for i = 1,#self.bindTabitem do
            self.bindTabitem[i]:addPropTransparency(2,kAnimNormal,waitTime-150,(delay + 600 + i * 100) ,0,1);
            self.bindTabitem[i]:addPropScale(1,kAnimNormal,waitTime-150,(delay + 600 + i * 100),0.8,1,0.8,1,kCenterXY,98,110);
        end
    end
    --需要所有动画播完后再调用
    self.timerAnim = new(AnimInt,kAnimNormal,0,1,waitTime-120,delay + 600 + startAnimIntDelay);
    if self.timerAnim then
        self.timerAnim:setEvent(self,function()
            self:removeAnimProp();
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end
            delete(self.timerAnim);
            self.timerAnim = nil;
        end);
    end

end

OwnScene.pauseAnimStart = function(self,newStateObj,timer)
    self:removeAnimProp();
    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(newStateObj.state) then
        if BottomMenu.getInstance():checkStateSort(States.ownModel,newStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,w,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,-w,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(1,timer);
    end

    local duration = timer.duration;
    local waitTime = timer.waitTime
    local delay = waitTime+duration;
    local lw,lh = self.left_leaf:getSize();
    self.left_leaf:addPropTranslate(1,kAnimNormal,waitTime,-1,0,- lw,0,-30);
    local rw,rh = self.right_leaf:getSize();
    self.right_leaf:addPropTranslate(1,kAnimNormal,waitTime,-1,0,rw,0,-30);
    -- 上部动画
    local tw,th = self.m_top_cloth:getSize();
    local anim = self.m_top_cloth:addPropTranslate(1, kAnimNormal, waitTime, -1, 0, 0, 0, -th);
    if anim then
        anim:setEvent(self,function()
            self:setAnimItemEnVisible(false);
--            self:removeAnimProp();
        end);
    end
    delete(self.anim_end);         
    self.anim_end = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.anim_end then
        self.anim_end:setEvent(self,function()
            self:removeAnimProp();  
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end 
--            if self.bottomMove == true then
--                BottomMenu.getInstance():hideView();
--            end
            delete(self.anim_end); 
            self.anim_end = nil;        
        end);
    end
end

---------------------- func --------------------
OwnScene.create = function(self)

    self.m_root_view = self.m_root;
    self.bottomMove = false;
    self.m_scroll_view = self:findViewById(self.m_ctrls.scroll_view);
    local mw,mh = self.m_scroll_view:getSize();
    local w,h = self.m_root:getSize();
    self.m_scroll_view:setSize(mw,mh+h-System.getLayoutHeight());

    self.m_top_cloth = self:findViewById(self.m_ctrls.top_cloth);
    self.m_head_icon = new(Mask,"common/background/head_mask_bg_122.png","common/background/head_mask_bg_122.png");
    self.m_head_icon_bg = self:findViewById(self.m_ctrls.head_icon_btn);
    self.m_vip_frame = self.m_head_icon_bg:getChildByName("vip_frame");
    self.m_head_icon_bg:addChild(self.m_head_icon);
    self.m_head_icon:setAlign(kAlignCenter);
    self.m_user_name = self:findViewById(self.m_ctrls.user_name);
--    self.m_friends_rank = self:findViewById(self.m_ctrls.friends_rank);
--    self.m_fans_rank = self:findViewById(self.m_ctrls.fans_rank);
--    self.m_master_rank = self:findViewById(self.m_ctrls.master_rank);
    self.m_my_uid = self:findViewById(self.m_ctrls.my_uid);
    self.m_my_level = self:findViewById(self.m_ctrls.my_level);
    self.m_my_name = self:findViewById(self.m_ctrls.my_name);
    self.m_my_notice = self:findViewById(self.m_ctrls.my_notice);
    self.m_my_setting = self:findViewById(self.m_ctrls.my_setting);
    self.m_my_sexual = self:findViewById(self.m_ctrls.my_sexual);
    self.m_my_region = self:findViewById(self.m_ctrls.my_region);

    self.m_my_uid:setSrollOnClick();
    self.m_my_level:setSrollOnClick();
    self.m_my_name:setSrollOnClick();
    self.m_my_notice:setSrollOnClick();
    self.m_my_setting:setSrollOnClick();
    self.m_my_sexual:setSrollOnClick();
    self.m_my_region:setSrollOnClick();

    self.m_feedback_btn = self:findViewById(self.m_ctrls.feedback_btn);
    self.m_set_btn = self:findViewById(self.m_ctrls.set_btn);
    self.m_share_btn = self:findViewById(self.m_ctrls.share_btn);
	if UserInfo.getInstance():getOpenWeixinShare() == 0 then
		self.m_share_btn:setVisible(false);
	else
		self.m_share_btn:setVisible(true);
	end
    if kPlatform == kPlatformIOS then	
        if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then 
            self.m_share_btn:setVisible(true);
            self.m_feedback_btn:setVisible(true);
        else
            self.m_share_btn:setVisible(false);
            self.m_feedback_btn:setVisible(false);
        end;
    end;
    self.m_feedback_btn:setSrollOnClick();
    self.m_set_btn:setSrollOnClick();
    self.m_share_btn:setSrollOnClick();

    self.m_bottom_menu = self:findViewById(self.m_ctrls.bottom_menu);
    self.m_scroll_menu = self:findViewById(self.m_ctrls.menu);
    self.m_info_view = self:findViewById(self.m_ctrls.info_view); --性别和地区选择信息

    self.left_leaf = self.m_root_view:getChildByName("bamboo_left");
    self.right_leaf = self.m_root_view:getChildByName("bamboo_right");

    self.m_bind_view = self:findViewById(self.m_ctrls.bind_view);
    self.m_line_bg = new(Image,"common/background/line_bg.png",nil,nil,64,64,64,64);
    self.m_line_bg:setAlign(kAlignTop);
    self.m_line_bg:setSize(590,290);
    self.m_bind_view:addChild(self.m_line_bg);

--    self.m_bind_list_view = new(ListView,0,0,OwnSceneBindItem.ITEM_WIDTH,OwnSceneBindItem.ITEM_HEIGHT);
--    self.m_bind_list_view:setAlign(kAlignTop);
--    self.m_bind_list_view:setDirection(kVertical);
--    self.m_bind_view:addChild(self.m_bind_list_view);
     -- 更新绑定界面
    self:updateBindView();

end

OwnScene.s_headIconFile = UserInfo.DEFAULT_ICON;

OwnScene.updateUserHeadIcon = function(self)
    local iconType = UserInfo.getInstance():getIconType();
    if iconType == -1 then
        local file = UserInfo.getInstance():getIcon() or "";
        self.m_head_icon:setUrlImage(file);
    elseif iconType > 0 and OwnScene.s_headIconFile[iconType] then
        self.m_head_icon:setFile(OwnScene.s_headIconFile[iconType]);
    else
        self.m_head_icon:setFile(OwnScene.s_headIconFile[1]);
    end
end

OwnScene.updateUserInfoView = function(self)
    -- 昵称
    self.m_user_name:setText(UserInfo.getInstance():getName());
    -- 头像
    self:updateUserHeadIcon();
    -- 登录方式
    self.m_login_type = self:findViewById(self.m_ctrls.login_type);
    self.m_login_type:setText(UserInfo.getInstance():getAccountTypeName());
    if kPlatform == kPlatformIOS then
       -- ios 审核关闭游客显示
        if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
            self.m_login_type:setVisible(true);
        else
            self.m_login_type:setVisible(false);
        end;
    end;
    -- 游戏id
    self.m_my_uid:getChildByName("content"):setText(UserInfo.getInstance():getUid());
    self.m_my_uid:setPickable(false);
    -- 好友排行榜
--    self:getFriendsRank();
    -- 我的等级
    self.m_my_level:getChildByName("content"):setText(UserInfo.getInstance():getDanGradingName());
    -- 我的名字
    self.m_my_name:getChildByName("content"):setText(UserInfo.getInstance():getName(),0,0);
    -- 我的消息
    local num = GameCacheData.getInstance():getInt(GameCacheData.NOTICE_NUM..UserInfo.getInstance():getUid(),0);
    local notice_str = "";
    if num > 0 then
        notice_str = string.format("+%d条",num);
    end
    self.m_my_notice:getChildByName("content"):setText(notice_str);

    -- 个性装扮
--    self.m_my_setting:getChildByName("content"):setText();
    -- 我的性别
    self.m_my_sexual:getChildByName("content"):setText(UserInfo.getInstance():getSexString());
    self.m_sexType = UserInfo.getInstance():getSex() or 0;
    -- 我的地区
    self.m_my_region:getChildByName("content"):setText(UserInfo.getInstance():getCityName());

    local frameRes = UserSetInfo.getInstance():getFrameRes();
    self.m_vip_frame:setVisible(frameRes.visible);
    local fw,fh = self.m_vip_frame:getSize();
    if frameRes.frame_res then
        self.m_vip_frame:setFile(string.format(frameRes.frame_res,fw));
    end

--    self:setBtnClick();
--    local offset = self.m_scroll_view:getRegularOffsetRange();
--    print_string("--------------------------->" .. offset);
end

---- 拉取好友排行
--OwnScene.getFriendsRank = function(self)
--    self:requestCtrlCmd(OwnController.s_cmds.getFriendsRank);
--end

function OwnScene:setBtnClick()
    

end

--------------------- click ------------------
OwnScene.onBackBtnClick = function(self)
    Log.i("OwnScene.onBackBtnClick");
    self:requestCtrlCmd(OwnController.s_cmds.onBack);
end

--OwnScene.onMallBtnClick = function(self)
--    self:requestCtrlCmd(OwnController.s_cmds.goToMall);
--end

OwnScene.onSetBtnClick = function(self)
    StateMachine.getInstance():pushState(States.setModel,StateMachine.STYPE_CUSTOM_WAIT);
end

OwnScene.onFeedbackBtnClick = function(self)
    StateMachine.getInstance():pushState(States.Feedback,StateMachine.STYPE_CUSTOM_WAIT);
end

OwnScene.onShareBtnClick = function(self)
    StateMachine.getInstance():pushState(States.shareModel,StateMachine.STYPE_CUSTOM_WAIT);
    
end

OwnScene.onMyLevelBtnClick = function(self)
    StateMachine.getInstance():pushState(States.gradeModel,StateMachine.STYPE_CUSTOM_WAIT);
end

--OwnScene.onMyNameBtnClick = function(self)
----    StateMachine.getInstance():pushState(States.assetsModel,StateMachine.STYPE_CUSTOM_WAIT);
--end

OwnScene.onMyNoticeBtnClick = function(self)
    GameCacheData.getInstance():saveInt(GameCacheData.NOTICE_NUM..UserInfo.getInstance():getUid(),0);
    StateMachine.getInstance():pushState(States.noticeModel,StateMachine.STYPE_CUSTOM_WAIT);
end

OwnScene.onMyVipSetBtnClick = function(self)
--    self:requestCtrlCmd(OwnController.s_cmds.goToChessFriends);
    StateMachine.getInstance():pushState(States.vipModel,StateMachine.STYPE_CUSTOM_WAIT);
end

OwnScene.onSwitchAccountBtnClick = function(self)
    require("dialog/toggle_account_dialog");
    delete(self.m_toggleAccountDialog);
    self.m_toggleAccountDialog = nil;
    self.m_toggleAccountDialog = new(ToggleAccountDialog);
    self.m_toggleAccountDialog:setCtrl(self.m_controller);
	self.m_toggleAccountDialog:show();
end

--OwnScene.onUserinfoBtnClick = function(self)
--    StateMachine.getInstance():pushState(States.UserInfo,StateMachine.STYPE_CUSTOM_WAIT);
--end
-- 1 好友排行榜 2 粉丝排行榜 3 大师排行榜
--OwnScene.onFriendsRankBtnClick = function(self)
--    StateMachine.getInstance():pushState(States.Rank,StateMachine.STYPE_CUSTOM_WAIT,nil,1);
--end

--OwnScene.onFansRankBtnClick = function(self)
--    StateMachine.getInstance():pushState(States.Rank,StateMachine.STYPE_CUSTOM_WAIT,nil,2);
--end

--OwnScene.onMasterRankBtnClick = function(self)
--    StateMachine.getInstance():pushState(States.Rank,StateMachine.STYPE_CUSTOM_WAIT,nil,3);
--end

function OwnScene:onMyRegionBtnClick()
    if not self.m_locate_city_dialog then
        require("dialog/city_locate_pop_dialog");
        self.m_locate_city_dialog = new(CityLocatePopDialog);
        self.m_locate_city_dialog:setDismissCallBack(self,self.updateUserInfoView);
    end
    self.m_locate_city_dialog:show();
end

function OwnScene:onMySexualBtnClick()
    if not self.m_select_sex_dialog then
        require("dialog/select_sex_dialog");
        self.m_select_sex_dialog = new(SelectSexDialog);
    end
    self.m_select_sex_dialog:show();
end

function OwnScene:showChangeHeadDialog()
    if not self.m_changeHeadDialog then
        require("dialog/change_head_icon_dialog");
        self.m_changeHeadDialog = new(ChangeHeadIconDialog);
        self.m_changeHeadDialog:setConfirmClick(self,self.changeUserIcon);
    end
    self.m_changeHeadDialog:show();
end

function OwnScene:changeUserIcon(iconType,iconName)
    self.m_iconType = iconType;
    self.m_iconName = iconName;
    self:saveUserInfo(true);
end

function OwnScene:saveUserInfo(sysIcon)
    local data = {};
    data.sex = self.m_sexType;
    data.name = self.m_my_name:getChildByName("content"):getText();
    data.iconType = self.m_iconType or UserInfo.getInstance():getIconType();
    if sysIcon then
        data.icon_url = self.m_iconName or "women_head01.png";
    end;
    self:requestCtrlCmd(OwnController.s_cmds.saveUserInfo,data);
end

function OwnScene:showEditTextGlobal()
    EditTextGlobal = self;
	ime_open_edit(self.m_my_name:getChildByName("content"):getText(),
		"",
		kEditBoxInputModeSingleLine,
		kEditBoxInputFlagInitialCapsSentence,
		kKeyboardReturnTypeDone,
		-1,"global");
end

function OwnScene:contentTextChange(text)
    if not text then text = "" end
	local content = text;
    local utf8_length = string.len("我") - 1;
    if utf8_length == 0 then utf8_length = 1; end
    local index = (string.len(content) + ( utf8_length - 1 ) * ToolKit.utfstrlen(content)) / utf8_length;
	if index > 8  then
		local message = "亲，您的名字有点长哦!(英文8个字符，中文4个字符)";
		if not self.m_chioce_dialog then
			require("dialog/chioce_dialog");
            self.m_chioce_dialog = new(ChioceDialog);
		end
		self.m_chioce_dialog:setMode(ChioceDialog.MODE_OK);
		self.m_chioce_dialog:setMessage(message);
		self.m_chioce_dialog:setPositiveListener();
		self.m_chioce_dialog:show();
        self.m_my_name:getChildByName("content"):setText(UserInfo.getInstance():getName(),0,0);
        return ;
	end
    self.m_my_name:getChildByName("content"):setText(text,0,0);
    self:saveUserInfo();
end

function OwnScene:setText(str, width, height, r, g, b)
    self.m_my_name:getChildByName("content"):setText(str,0,0);
end

function OwnScene:onTextChange()
    self:contentTextChange(self.m_my_name:getChildByName("content"):getText());
end

function OwnScene:upLoadImage(iconType)
    self.m_iconType = -1;
    self:saveUserInfo();
end

    -- 更新绑定界面
function OwnScene:updateBindView()
--    self.m_bind_list_view:releaseAllViews();
--    delete(self.m_adapter);

    local bindtab = self:updateBindType();
    local num = 1;
    if bindtab and #bindtab ~= 0 then
        num = #bindtab;
    end
    self.m_line_bg:setSize(OwnSceneBindItem.ITEM_WIDTH,num * OwnSceneBindItem.ITEM_HEIGHT);
    self.bindTabitem = {};
    for i = 1,num do 
        if bindtab[i].accountType then
            self.bindTabitem[i] = new(OwnSceneBindItem,"drawable/blank.png","drawable/blank_press.png",bindtab[i]);
            self.bindTabitem[i]:setAlign(kAlignTop);
            self.bindTabitem[i]:setPos(0, (i-1) * OwnSceneBindItem.ITEM_HEIGHT);
            self.bindTabitem[i]:setSize(OwnSceneBindItem.ITEM_WIDTH,OwnSceneBindItem.ITEM_HEIGHT);
            self.bindTabitem[i]:setOnClick(self,function()
                self:onItemClick(bindtab[i].accountType);
            end);
--            self.bindTabitem[i]:setSrollOnClick();
            self.m_bind_view:addChild(self.bindTabitem[i]);
        end
    end
--    self.m_adapter = new(CacheAdapter,OwnSceneBindItem,bindtab);
--    self.m_bind_list_view:setAdapter(self.m_adapter);
--    self.m_bind_list_view:setSize(OwnSceneBindItem.ITEM_WIDTH,num * OwnSceneBindItem.ITEM_HEIGHT);
    self.m_bind_view:setSize(720,num * OwnSceneBindItem.ITEM_HEIGHT);
    local x,y = self.m_bind_view:getPos();
    self.m_scroll_menu:setPos(x,y + 30 + num * OwnSceneBindItem.ITEM_HEIGHT);
    if kPlatform == kPlatformIOS then
        if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
            self.m_scroll_menu:setPos(nil,985);
            self.m_bind_view:setVisible(true);
        else
            self.m_scroll_menu:setPos(nil,670);
            self.m_bind_view:setVisible(false);
        end;
    end;
    self.m_scroll_view:updateScrollView();

    local a = self.m_scroll_view:getFrameLength();
    local b = self.m_scroll_view:getViewLength();
    print_string("a---------------------> " .. a .. "   b---------------------->" .. b);

end

function OwnScene:updateBindType()
    local accountType = UserInfo.getInstance():getAccountType();
    local bindTab = {{accountType = 1}};
    if (accountType == 201) or (accountType == 1) or (accountType == 101) then  
        table.insert(bindTab,{accountType = 3});
        table.insert(bindTab,{accountType = 10});
    elseif accountType == 10 then
        table.insert(bindTab,{accountType = 10});
    elseif accountType == 3 then
        table.insert(bindTab,{accountType = 3});
    else
        
    end

--    for k,v in pairs(bindTab) do
--        v.handler = self;
--    end

    return bindTab;
end


function OwnScene:showBindPhoneDialog()
    delete(self.m_bind_phone_dialog);
    require(DIALOG_PATH.."bangdin_dialog");
    self.m_bind_phone_dialog = new(BangDinDialog);
    self.m_bind_phone_dialog:setHandler(self)
    self.m_bind_phone_dialog:show();
end

function OwnScene:bindWeibo()
    dict_set_string(kLoginMode,kLoginMode..kparmPostfix,0);
	call_native(kLoginWithWeibo);
    if System.getPlatform() == kPlatformWin32 then
        local post_data = {};
        post_data.bind_uuid = "win32Test";
        post_data.mid = UserInfo.getInstance():getUid();
        post_data.sid = OwnController.s_sid.xinlang;
        HttpModule.getInstance():execute(HttpModule.s_cmds.bindUid,post_data,"绑定中...");
    end
end

function OwnScene:bindWeChat()
    call_native(kLoginWeChat);
    if System.getPlatform() == kPlatformWin32 then
        local post_data = {};
        post_data.bind_uuid = "win32Test";
        post_data.mid = UserInfo.getInstance():getUid();
        post_data.sid = OwnController.s_sid.weichat;
        HttpModule.getInstance():execute(HttpModule.s_cmds.bindUid,post_data,"绑定中...");
    end
end
--[[
    重新绑定dialog
--]]
function OwnScene:removeBind(accounttype)
    require("dialog/remove_bind_dialog");
    if not self.m_remove_bind_dialog then
        self.m_remove_bind_dialog = new(RemoveBindDialog);
    end
    self.m_remove_bind_dialog:setAccountType(accounttype);
    self.m_remove_bind_dialog:setRebindCallBack(self,self.showBindPhoneDialog);
    self.m_remove_bind_dialog:show();
end

function OwnScene:onItemClick(accountType)
    if UserInfo.getInstance():findBindAccountBySid(accountType) then
        --解除绑定
        self:removeBind(accountType);
    else
        --绑定
        if accountType == 201 or accountType == 1 then
            self:showBindPhoneDialog();
        elseif accountType == 3 then
            self:bindWeChat();
        elseif accountType == 10 then
            self:bindWeibo();
        end
    end
end
---------------------- config ------------------
OwnScene.s_controlConfig = 
{

    [OwnScene.s_controls.scroll_view]              = {"scroll_view"};
    [OwnScene.s_controls.top_cloth]                = {"top_cloth"};
    [OwnScene.s_controls.head_icon_btn]            = {"top_cloth","head_icon_btn"};
    [OwnScene.s_controls.user_name]                = {"top_cloth","user_name"};
    [OwnScene.s_controls.login_type]               = {"top_cloth","login_type"};
    [OwnScene.s_controls.userinfo_view]            = {"scroll_view","userinfo_view"};
    [OwnScene.s_controls.my_uid]                   = {"scroll_view","userinfo_view","my_uid"};
    [OwnScene.s_controls.my_level]                 = {"scroll_view","userinfo_view","my_level"};
    [OwnScene.s_controls.my_name]                  = {"scroll_view","userinfo_view","my_name"};
    [OwnScene.s_controls.my_notice]                = {"scroll_view","userinfo_view","my_notice"};
    [OwnScene.s_controls.my_setting]               = {"scroll_view","userinfo_view","my_setting"};
    [OwnScene.s_controls.menu]                     = {"scroll_view","menu"};
    [OwnScene.s_controls.set_btn]                  = {"scroll_view","menu","set_btn"};
    [OwnScene.s_controls.feedback_btn]             = {"scroll_view","menu","feedback_btn"};
    [OwnScene.s_controls.share_btn]                = {"scroll_view","menu","share_btn"};
    [OwnScene.s_controls.bottom_menu]              = {"bottom_menu"};
--    [OwnScene.s_controls.switch_account]           = {"scroll_view","switch_account"};
    [OwnScene.s_controls.info_view]                = {"scroll_view","info_view"};
    [OwnScene.s_controls.my_sexual]                = {"scroll_view","info_view","my_sexual"};
    [OwnScene.s_controls.my_region]                = {"scroll_view","info_view","my_region"};
    [OwnScene.s_controls.bind_view]                = {"scroll_view","bind_view"};

}

OwnScene.s_controlFuncMap = {
    
    [OwnScene.s_controls.set_btn]                      = OwnScene.onSetBtnClick;
    [OwnScene.s_controls.feedback_btn]                 = OwnScene.onFeedbackBtnClick;
    [OwnScene.s_controls.share_btn]                    = OwnScene.onShareBtnClick;
    [OwnScene.s_controls.my_level]                     = OwnScene.onMyLevelBtnClick;
--    [OwnScene.s_controls.my_name]                      = OwnScene.onMyNameBtnClick;
    [OwnScene.s_controls.my_name]                      = OwnScene.showEditTextGlobal;
    [OwnScene.s_controls.my_notice]                    = OwnScene.onMyNoticeBtnClick;
    [OwnScene.s_controls.my_setting]                   = OwnScene.onMyVipSetBtnClick;
--    [OwnScene.s_controls.switch_account]               = OwnScene.onSwitchAccountBtnClick;
--    [OwnScene.s_controls.head_icon_btn]                = OwnScene.onUserinfoBtnClick;
    [OwnScene.s_controls.head_icon_btn]                = OwnScene.showChangeHeadDialog;
    [OwnScene.s_controls.my_region]                    = OwnScene.onMyRegionBtnClick;
    [OwnScene.s_controls.my_sexual]                    = OwnScene.onMySexualBtnClick;
};

OwnScene.s_cmdConfig =
{
    [OwnScene.s_cmds.updateUserInfoView]                = OwnScene.updateUserInfoView;
    [OwnScene.s_cmds.upLoadImage]                       = OwnScene.upLoadImage;
    [OwnScene.s_cmds.updateUserHead]                    = OwnScene.updateUserHeadIcon;
}

OwnSceneBindItem = class(Button,false);

OwnSceneBindItem.DEFAULT_ICON = 
{
    [1]  = "common/icon/phone.png", 
    [3]  = "common/icon/wechat.png", 
    [10] = "common/icon/weibo.png",
}

OwnSceneBindItem.DEFAULT_TYPE = 
{
    [1]  = "手机", 
    [3]  = "微信", 
    [10] = "微博",
}

OwnSceneBindItem.ITEM_WIDTH = 590;
OwnSceneBindItem.ITEM_HEIGHT = 80;

OwnSceneBindItem.ctor = function(self,normalFile, disableFile,data)
    super(self,normalFile, disableFile);
--    if not data then return end
--    self.m_handler = data.handler;
    self.accountType = data.accountType;
--    if not self.accountType then return end
--    self:setSize(OwnSceneBindItem.ITEM_WIDTH,OwnSceneBindItem.ITEM_HEIGHT);

    --item点击按钮
--    self.m_button = new(Button,"drawable/blank.png","drawable/blank_press.png");
--    self.m_button:setSize(590,70);
--    self.m_button:setAlign(kAlignCenter);
--    self.m_button:setOnClick(self,self.onItemClick);
--    self.m_button:setSrollOnClick();
    --图标
    local imgStr = "common/icon/phone.png";
    imgStr = OwnSceneBindItem.DEFAULT_ICON[self.accountType];
    self.m_iconType = new(Image,imgStr);
    self.m_iconType:setSize(52,52);
    self.m_iconType:setAlign(kAlignLeft);
    self.m_iconType:setPos(29,0);
    --bottom line
    self.m_bottom_line = new(Image,"common/decoration/line_2.png");
    self.m_bottom_line:setSize(590,2);
    self.m_bottom_line:setAlign(kAlignBottom);
    --绑定类型text
    local msg = "手机";
    msg = OwnSceneBindItem.DEFAULT_TYPE[self.accountType];
    self.m_bing_type = new(Text,msg,72,36,nil,nil,36,135,100,95);
    self.m_bing_type:setAlign(kAlignLeft);
    self.m_bing_type:setPos(100,2);
    --箭头图标
    self.m_arrow = new(Image,"common/icon/arrow_r.png");
    self.m_arrow:setSize(14,25);
    self.m_arrow:setAlign(kAlignRight);
    self.m_arrow:setPos(21,0);
    --绑定状态
--    self.bindStatus = false;
    local bindStatusText = "未绑定";
    local num = UserInfo.getInstance():findBindAccountBySid(self.accountType);
    if num then
--        self.bindStatus = true;
        bindStatusText = "已绑定";
    else
--        self.bindStatus = false;
        bindStatusText = "未绑定";
    end
        self.title = new(Text,bindStatusText,64,30,kAlignRight,nil,32,80,80,80);
        self.title:setAlign(kAlignRight);
        self.title:setPos(68,0);

    self:setSrollOnClick(function()
        print_string("setSrollOnClick");
    end);

    self:addChild(self.title);
    self:addChild(self.m_bing_type);
    self:addChild(self.m_bottom_line);
    self:addChild(self.m_iconType);
--    self:addChild(self.m_button);
    self:addChild(self.m_arrow);
end

OwnSceneBindItem.dtor = function(self)

end

--OwnSceneBindItem.onItemClick = function(self)
--    if self.bindStatus then
--        --解除绑定
--        self.m_handler:removeBind(self.accountType);
--    else
--        --绑定
--        if self.accountType == 201 or self.accountType == 1 then
--            self.m_handler:showBindPhoneDialog();
--        elseif self.accountType == 3 then
--            self.m_handler:bindWeChat();
--        elseif self.accountType == 10 then
--            self.m_handler:bindWeibo();
--        end
--    end
--end