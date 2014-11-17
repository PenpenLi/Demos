#ifndef MOF_IOSPLATFORMMGR_H
#define MOF_IOSPLATFORMMGR_H

class IOSPlatformMgr{
public:
	void vxinyouRegisterSucceed(ThreadDelegateProtocol	*, std::string,	std::string);
	void ackChargeOrder(ack_register_order);
	void serverLoginCallback(int);
	void onMenuItemgoogleClicked(cocos2d::CCObject *, cocos2d::CCNode *);
	void RegisterBtnClicked(RegisterUI	*);
	void vxinyouRegisterSucceed(ThreadDelegateProtocol	*,std::string,std::string);
	void platformCenterClicked(cocos2d::CCObject *);
	void vxinyouLoginSucceed(std::string, std::string);
	void chargeBtnClicked(void);
	void levelUp(int);
	void loginUIInit(LoginUI *);
	void isUseIOSDefaultLoginUI(void);
	void enterGame(void);
	void vxinyouLoginSucceed(std::string,std::string);
	void customMenuClicked(cocos2d::CCObject *);
	void isWaitingPlatformUpdateCallBack(void);
	void gameMgrGo(void);
	void getInstance(void);
	void LoginBtnClicked(LoginUI *);
	void onMenuItemfacebookClicked(cocos2d::CCObject *);
	void loginUIOtherBtnClicked(void);
	void onMenuItemgoogleClicked(cocos2d::CCObject *,cocos2d::CCNode *);
	void systemSettingUIinit(SystemSettingUI *);
	void loginOut(void);
}
#endif