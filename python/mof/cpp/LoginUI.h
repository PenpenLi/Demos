#ifndef MOF_LOGINUI_H
#define MOF_LOGINUI_H

class LoginUI{
public:
	void onMenuItemgoogleClicked(cocos2d::CCObject *);
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void setServer(Server);
	void onMenuItemServerSelectionClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,	char const*, cocos2d::CCNode *);
	void onMenuItemConfirmClicked(cocos2d::CCObject *);
	void onDestroy(void);
	void recieveThreadMessage(ThreadMessage *);
	void ~LoginUI();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void loginConnect(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void setBtnEnable(bool);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void onMenuItemRegisterClicked(cocos2d::CCObject *);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void LoginUI(void);
	void deleteStringLastSpace(std::string);
	void playLoginAnimations(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onEnter(void);
	void Init(void);
	void setEditingPostion(bool);
	void enableLoginButtons(float);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void onMenuItemfacebookClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void create(void);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox	*);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string	const&);
	void init(void);
	void onExit(void);
}
#endif