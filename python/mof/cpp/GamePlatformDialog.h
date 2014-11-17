#ifndef MOF_GAMEPLATFORMDIALOG_H
#define MOF_GAMEPLATFORMDIALOG_H

class GamePlatformDialog{
public:
	void ~GamePlatformDialog();
	void getInstance(void);
	void cancelButtonDelegate(void);
	void setAppPause(bool);
	void showPlatformDialog(cocos2d::CCObject *));
	void confirmButtonDelegate(void);
	void GamePlatformDialog(void);
	void showPlatformDialog(cocos2d::CCObject	*));
}
#endif