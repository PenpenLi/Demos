#ifndef MOF_NEWCONFIRMDIALOG_H
#define MOF_NEWCONFIRMDIALOG_H

class NewConfirmDialog{
public:
	void wakeLayerTouch(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void destroyCurIcon(cocos2d::CCNode *);
	void playGiftAction(void);
	void playMenuAction(void);
	void onMenuItemTouchLayer(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void updateClickLimit(void);
	void ~NewConfirmDialog();
	void Init(void);
	void onEnter(void);
	void create(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void NewConfirmDialog(void);
	void onExit(void);
	void init(void);
}
#endif