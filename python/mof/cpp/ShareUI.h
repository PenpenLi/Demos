#ifndef MOF_SHAREUI_H
#define MOF_SHAREUI_H

class ShareUI{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setDescTipShow(cocos2d::CCPoint,int);
	void onMenuItemWeChatTimeLineClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void createDescTip(void);
	void onMenuItemWeChatFriendClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ~ShareUI();
	void onEnter(void);
	void showShareAward(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void init(void);
	void onExit(void);
	void setDescTipShow(cocos2d::CCPoint, int);
}
#endif