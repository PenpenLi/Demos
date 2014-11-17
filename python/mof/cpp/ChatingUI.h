#ifndef MOF_CHATINGUI_H
#define MOF_CHATINGUI_H

class ChatingUI{
public:
	void onChatingWorldItemClicked(cocos2d::CCObject *);
	void channelItemChoose(chatChannel);
	void onChatingGuildItemClicked(cocos2d::CCObject	*);
	void changePrivateMenuList(roleInfor);
	void setmenuListIsShow(void);
	void onMenuItemAddFriendClicked(cocos2d::CCObject *);
	void createAddFriendsImage(cocos2d::CCNode *);
	void setIsShowAddFriendButton(bool);
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void hideTipsPostion(void);
	void ChatingUI(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox	*);
	void onChatingArmygroupItemClicked(cocos2d::CCObject *);
	void channelChoose(chatChannel);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onChatingPrivatechatItemClicked(cocos2d::CCObject *);
	void onMenuItemChatingClicked(cocos2d::CCObject *);
	void onMenuItemDuelClicked(cocos2d::CCObject *);
	void ~ChatingUI();
	void onChatingSendtClicked(cocos2d::CCObject *);
	void setGuildIconIsShow(void);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void deletChatData(chatChannel);
	void onChatingGuildItemClicked(cocos2d::CCObject *);
	void hideChatingUI(void);
	void addPrivateChat(int);
	void onChatingWorldItemClicked(cocos2d::CCObject	*);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemChatingClicked(cocos2d::CCObject	*);
	void setEditShow(bool);
	void onShowPrivateItemClicked(cocos2d::CCObject *);
	void onEnter(void);
	void setPrivateIconIsShow(void);
	void chatWithNearFriend(int,std::string);
	void Init(void);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void onMenuItemSelectMsgClicked(cocos2d::CCObject *);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void showClientLocalCmd(std::string);
	void onShowPrivateItemClicked(cocos2d::CCObject	*);
	void InitInputAccount(void);
	void create(void);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox	*);
	void chatWithNearFriend(int, std::string);
	void setTipsContent(bool);
	void InitMenuItemLabel(void);
	void onChatingChannelClicked(cocos2d::CCObject *);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void bottonLablesIsShow(bool);
	void init(void);
	void onExit(void);
	void addChatData(chatChannel);
}
#endif