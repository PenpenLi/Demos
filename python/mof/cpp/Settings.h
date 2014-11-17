#ifndef MOF_SETTINGS_H
#define MOF_SETTINGS_H

class Settings{
public:
	void getIsPlayBackgroundMusic(void);
	void getLastServerInfo(void);
	void getClientVersion(void);
	void saveIsShowOtherRole(bool);
	void saveSettings(void);
	void saveIsPlayBackgroundMusic(bool);
	void saveLastServerInfo(Server);
	void getPassword(void);
	void saveClientVersion(std::string);
	void getAccount(void);
	void saveAccountAndPassword(std::string,	std::string);
	void getIsPlaySoundEffect(void);
	void getIsShowOtherRole(void);
	void saveAccountAndPassword(std::string,std::string);
	void saveIsPlaySoundEffect(bool);
}
#endif