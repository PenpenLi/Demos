#ifndef MOF_ASSETSMANAGER_H
#define MOF_ASSETSMANAGER_H

class AssetsManager{
public:
	void checkStoragePath(void);
	void downLoadCore(std::string,std::string,CURLcode &);
	void setConnectionTimeout(uint);
	void setDownloadParams(std::string, std::string, std::string, std::string);
	void AssetsManager(char	const*,char const*,char	const*);
	void setDelegate(cocos2d::extension::AssetsManagerDelegateProtocol *);
	void sendErrorMessage(cocos2d::extension::AssetsManager::ErrorType,int);
	void deleteDirectoryFiles(char const*);
	void AssetsManager(char	const*,	char const*, char const*);
	void ~AssetsManager();
	void setSearchPath(void);
	void update(void);
	void setConnectionTimeout(unsigned int);
	void setDownloadParams(std::string,std::string,std::string,std::string);
	void uncompress(void);
	void downLoadCore(std::string, std::string, CURLcode &);
	void downLoad(void);
	void checkUpdate(void);
	void sendErrorMessage(cocos2d::extension::AssetsManager::ErrorType, int);
	void createDirectory(char const*);
}
#endif