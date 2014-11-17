#ifndef MOF_HTTPUTILS_H
#define MOF_HTTPUTILS_H

class HttpUtils{
public:
	void requestString(std::string);
	void asynRequestServerList(ThreadDelegateProtocol *);
	void createRequestThreadPost(std::string,std::string,ThreadMessageType,ThreadDelegateProtocol *);
	void createRequestThread(std::string, ThreadMessageType, ThreadDelegateProtocol	*);
	void checkClientVersion(void);
	void asynRequestJumpWebsite(ThreadDelegateProtocol *);
	void asynRequestEnterGameCollect(int,std::string);
	void isClientNeedToAutoUpdate(void);
	void asynRequestPlatformNotice(ThreadDelegateProtocol *);
	void createRequestThread(std::string,ThreadMessageType,ThreadDelegateProtocol *);
	void asynRequestAutoUpdatePackageList(ThreadDelegateProtocol *);
	void asynRequestServerInfo(int,int,ThreadDelegateProtocol *);
	void asynRequestDefaulServer(ThreadDelegateProtocol *);
	void requestAutoUpdateCheck(void);
	void asynRequestServerInfo(int,	int, ThreadDelegateProtocol *);
	void asynRequestEnterGameCollect(int, std::string);
	void requestClientVersionAndAutoUpdateInfo(void);
}
#endif