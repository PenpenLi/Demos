--region NewFile_1.lua
--Author : FordFan
--Date   : 2016/4/26
--好友邀请分享弹窗

require(VIEW_PATH .. "common_share_dialog_view");
require(BASE_PATH .. "chessDialogScene");
require("gameBase/gameLayer");
require("chess/util/statisticsManager");


CommonShareDialog = class(ChessDialogScene,false);

CommonShareDialog.ANIM_TIME = 320; -- 单位毫秒
CommonShareDialog.s_dialogLayer = nil;
CommonShareDialog.DEFAULT_TEXT = "我的游戏id是" .. UserInfo.getInstance():getUid() .. "，快来和我一起对弈吧";

CommonShareDialog.s_typeEvent = 
{   
    {
        ["type"] = "flight_invite",
        ["event"] = CommonShareDialog.shareFightInvite,
    },
    {
        ["type"] = "game_share",
        ["event"] = CommonShareDialog.shareGame,
    },
    {
        ["type"] = "sys_booth",
        ["event"] = CommonShareDialog.shareSysBooth,
    },
    {
        ["type"] = "wulin_booth",
        ["event"] = CommonShareDialog.shareWuLinBooth,
    },
}

--function CommonShareDialog.getInstance()
--    if not CommonShareDialog.s_instance then
--        CommonShareDialog.s_instance = new(CommonShareDialog);
--    end
--    return CommonShareDialog.s_instance;
--end

function CommonShareDialog:ctor()
    super(self,common_share_dialog_view);
    self.m_root_view = self.m_root;
    self.is_dismissing = false;
    self:initView();
    self:setVisible(false);
end

function CommonShareDialog:dtor()
    delete(self.m_root_view);
    self.m_root_view = nil;
end

function CommonShareDialog:isShowing()
    return self:getVisible();
end

function CommonShareDialog:show()
    self.is_dismissing = false;
    self:removeViewProp();
    local w,h = self.m_dialog_view:getSize();
    
    local anim_start = self.m_dialog_view:addPropTranslate(1,kAnimNormal,CommonShareDialog.ANIM_TIME,-1,0,0,h,0);
    self:setVisible(true);
    if anim_start then
        anim_start:setEvent(self,function()
            self.m_dialog_view:removeProp(1);
        end);
    end
    self.super.show(self,false);
end

function CommonShareDialog:dismiss()
    --防止多次点击显示多次动画
    if self.is_dismissing then
        return;
    end
    self.is_dismissing = true;
    self:removeViewProp();
    local w,h = self.m_dialog_view:getSize();
    local anim_end = self.m_dialog_view:addPropTranslate(1,kAnimNormal,CommonShareDialog.ANIM_TIME,-1,0,0,0,h);
    self.m_root_view:addPropTransparency(1,kAnimNormal,CommonShareDialog.ANIM_TIME,-1,1,0);
    if anim_end then
        anim_end:setEvent(self,function()
            self:setVisible(false);
            self.m_dialog_view:removeProp(1);
            self.m_root_view:removeProp(1);
        end);
    end
    self.super.dismiss(self,false);

end

function CommonShareDialog:initView()
    -- 灰色背景
    self.m_bg_black = self.m_root_view:getChildByName("bg_black");
    self.m_bg_black:setEventTouch(self,self.dismiss);

    self.m_dialog_view = self.m_root_view:getChildByName("bg");
    self.m_dialog_view:setEventTouch(nil,function() end);

    self.m_title = self.m_dialog_view:getChildByName("title");

    self.m_share_view = self.m_dialog_view:getChildByName("share_view");
    self.m_wechat_btn = self.m_share_view:getChildByName("wechat"):getChildByName("btn");
    self.m_pyq_btn    = self.m_share_view:getChildByName("pyq"):getChildByName("btn");
    self.m_qq_btn     = self.m_share_view:getChildByName("qq"):getChildByName("btn");

    self.m_other_view = self.m_share_view:getChildByName("other");
    self.m_sms_view = self.m_share_view:getChildByName("sms");
    self.m_weibo_view = self.m_share_view:getChildByName("weibo");
    self.m_copy_url_view = self.m_share_view:getChildByName("copy_url");

    self.m_other_btn  = self.m_share_view:getChildByName("other"):getChildByName("btn");
    self.m_sms_btn    = self.m_share_view:getChildByName("sms"):getChildByName("btn");
    self.m_weibo_btn    = self.m_share_view:getChildByName("weibo"):getChildByName("btn");
    self.m_copy_url_btn = self.m_share_view:getChildByName("copy_url"):getChildByName("btn");


    self.m_wechat_btn:setOnClick(self,self.onWechatBtnClick);
    self.m_pyq_btn:setOnClick(self,self.onPyqBtnClick);
    self.m_qq_btn:setOnClick(self,self.onQQBtnClick);
    self.m_other_btn:setOnClick(self,self.onOtherBtnClick);
    self.m_sms_btn:setOnClick(self,self.onSmsBtnClick);
    self.m_weibo_btn:setOnClick(self,self.onWeiboBtnClick);
    self.m_copy_url_btn:setOnClick(self,self.onCopyUrl);

end

--移除控件属性
function CommonShareDialog:removeViewProp()

    if not self.m_dialog_view:checkAddProp(1) then
        self.m_dialog_view:removeProp(1);
    end

    if not self.m_root_view:checkAddProp(1) then
        self.m_root_view:removeProp(1);
    end
end

function CommonShareDialog:onSmsBtnClick()
    self:dismiss();
    if self.share_tab then
        self:onEventStat(StatisticsManager.SHARE_WAY_SMS);
        if kPlatform == kPlatformIOS then 
            dict_set_string(SHARE_TEXT_TO_SMS_MSG , SHARE_TEXT_TO_SMS_MSG .. kparmPostfix , self.share_tab.url);
        else
            dict_set_string(SHARE_TEXT_MSG , SHARE_TEXT_MSG .. kparmPostfix , json.encode(self.share_tab));
        end;

        call_native(SHARE_TEXT_TO_SMS_MSG);
    end
end

function CommonShareDialog:onWeiboBtnClick()
    self:dismiss();
    if self.share_tab then
        self:onEventStat(StatisticsManager.SHARE_WAY_WEIBO);
        if kPlatform == kPlatformIOS then 
            dict_set_string(SHARE_TEXT_TO_WEIBO_MSG , SHARE_TEXT_TO_SMS_MSG .. kparmPostfix , self.share_tab.url);
        else
            dict_set_string(SHARE_TEXT_MSG , SHARE_TEXT_MSG .. kparmPostfix , json.encode(self.share_tab));
        end;

        call_native(SHARE_TEXT_TO_WEIBO_MSG);
    end
end

-- 控制分享弹窗显示的按钮
function CommonShareDialog:setShareDialogStatus()
    if not self.eventType then
        self.share_tab = nil;
        self.m_other_view:setVisible(true);
        self.m_sms_view:setVisible(false);
        self.m_weibo_view:setVisible(false);
    elseif self.eventType == "flight_invite" then
        self.m_other_view:setVisible(false);
        self.m_sms_view:setVisible(true);
        self.m_weibo_view:setVisible(true);
    elseif self.eventType == "game_share" then
        self.m_other_view:setVisible(false);
        self.m_sms_view:setVisible(true);
        self.m_weibo_view:setVisible(true);
        self.m_title:setText("邀请好友");
    elseif self.eventType == "sys_booth" then
        self.m_other_view:setVisible(true);
        self.m_sms_view:setVisible(false);
        self.m_weibo_view:setVisible(false);
    elseif self.eventType == "wulin_booth" then
        self.m_other_view:setVisible(true);
        self.m_sms_view:setVisible(false);
        self.m_weibo_view:setVisible(false);
    end
end

function CommonShareDialog:onPyqBtnClick()
    self:dismiss();
    if self.share_tab then
        self:onEventStat(StatisticsManager.SHARE_WAY_PYQ);
        if kPlatform == kPlatformIOS then 
            self.share_tab.isToSession = false;
            dict_set_string(SHARE_TEXT_TO_PYQ_MSG , SHARE_TEXT_TO_PYQ_MSG .. kparmPostfix , json.encode(self.share_tab));
        else
            dict_set_string(SHARE_TEXT_MSG , SHARE_TEXT_MSG .. kparmPostfix , json.encode(self.share_tab));
        end;
        call_native(SHARE_TEXT_TO_PYQ_MSG);
    end

end

function CommonShareDialog:onWechatBtnClick()
    self:dismiss();
    if self.share_tab then
        self:onEventStat(StatisticsManager.SHARE_WAY_WECHAT);
        if kPlatform == kPlatformIOS then 
            self.share_tab.isToSession = true;
            dict_set_string(SHARE_TEXT_TO_WEICHAT_MSG , SHARE_TEXT_TO_WEICHAT_MSG .. kparmPostfix , json.encode(self.share_tab));
        else
            dict_set_string(SHARE_TEXT_MSG , SHARE_TEXT_MSG .. kparmPostfix , json.encode(self.share_tab));
        end;
        call_native(SHARE_TEXT_TO_WEICHAT_MSG);
    end
end

function CommonShareDialog:onOtherBtnClick()
    self:dismiss();
    if self.share_tab then
        share_img_msg("endgame_share");
    end
end

function CommonShareDialog:onQQBtnClick()
    self:dismiss();
    if self.share_tab then
        self:onEventStat(StatisticsManager.SHARE_WAY_QQ);
         if kPlatform == kPlatformIOS then 
            dict_set_string(SHARE_TEXT_TO_QQ_MSG , SHARE_TEXT_TO_QQ_MSG .. kparmPostfix , json.encode(self.share_tab));
        else
            dict_set_string(SHARE_TEXT_MSG , SHARE_TEXT_MSG .. kparmPostfix , json.encode(self.share_tab));
        end;       
        call_native(SHARE_TEXT_TO_QQ_MSG);
    end
end

function CommonShareDialog:onCopyUrl()
    self:dismiss();
    if self.share_tab then

    end
end

function CommonShareDialog:onEventStat(way)
    if not self.eventType then return end
    StatisticsManager.getInstance():onCountShare(self.eventType,way);
end

function CommonShareDialog:setShareDate(data,shareType)
    self.share_tab = data;
    self.eventType = shareType;
    self:setShareDialogStatus();
end