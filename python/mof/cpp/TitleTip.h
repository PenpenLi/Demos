#ifndef MOF_TITLETIP_H
#define MOF_TITLETIP_H

class TitleTip{
public:
	void onActionEnd(cocos2d::CCNode	*);
	void create(void);
	void TitleTip(void);
	void onMenuItemTipClicked(cocos2d::CCObject *);
	void ~TitleTip();
	void createTips(void);
	void onActionEnd(cocos2d::CCNode *);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif