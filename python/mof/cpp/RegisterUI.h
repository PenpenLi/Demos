#ifndef MOF_REGISTERUI_H
#define MOF_REGISTERUI_H

class RegisterUI{
public:
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void onMenuItemConfirmClicked(cocos2d::CCObject	*);
	void onMenuItemGoBackClicked(cocos2d::CCObject *);
	void RegisterUI(void);
	void onMenuItemConfirmClicked(cocos2d::CCObject *);
	void recieveThreadMessage(ThreadMessage *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,	std::string const&);
	void detectionInPut(float);
	void confirmPassworldDection(void);
	void setBtnEnable(bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onDestory(void);
	void playLoginAnimations(void);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void onEnter(void);
	void ~RegisterUI();
	void passwordInputDection(void);
	void onMenuItemGoBackClicked(cocos2d::CCObject	*);
	void accountInputDetection(void);
	void Init(void);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void create(void);
	void editBoxReturn(cocos2d::extension::CCEditBox	*);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void init(void);
	void onExit(void);
}
#endif