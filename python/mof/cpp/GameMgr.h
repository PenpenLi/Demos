#ifndef MOF_GAMEMGR_H
#define MOF_GAMEMGR_H

class GameMgr{
public:
	void showbrowser(std::string);
	void getRoleData(void);
	void createStarGame(void);
	void replaceScene(cocos2d::CCScene *);
	void createLogin(void);
	void createGame(void);
	void createCreation(void);
	void connectServer(void);
	void backToLoginScene(void);
	void go(cocos2d::CCDirector *);
	void endLoadingScene(LoadingType);
	void BeginLoading(std::string, LoadingType);
	void showLoadingScene(LoadingType);
	void closeSocket(void);
	void EndLoading(void);
	void LoadingProgressUp(std::string);
	void BeginLoading(std::string,LoadingType);
	void serverBreakConnect(void);
	void setDownloadPathFirst(void);
	void loadConfigFiles(ThreadDelegateProtocol *);
}
#endif