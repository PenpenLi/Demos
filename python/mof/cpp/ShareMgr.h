#ifndef MOF_SHAREMGR_H
#define MOF_SHAREMGR_H

class ShareMgr{
public:
	void shareCallBack(bool);
	void shareImage2WeChat(int);
	void ~ShareMgr();
	void getInstance(void);
	void showShareBtn(cocos2d::CCNode *);
	void cutScene(void);
	void ackShareAward(ack_shareaward_state);
	void weChatShareCallBack(int);
	void onMenuItemShareClicked(cocos2d::CCObject *);
}
#endif