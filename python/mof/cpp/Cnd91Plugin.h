#ifndef MOF_CND91PLUGIN_H
#define MOF_CND91PLUGIN_H

class Cnd91Plugin{
public:
	void ShowExchangeView(int, std::string);
	void get91LoginUin(void);
	void Is91Logined(void);
	void EnterUserAsk(void);
	void Enter91Platform(void);
	void getInstance(void);
	void get91SessionId(void);
	void ShareToThirdPlatform(void);
	void ShowExchangeView(int,std::string);
	void SwitchAccount(void);
	void Login(void);
	void ~Cnd91Plugin();
}
#endif