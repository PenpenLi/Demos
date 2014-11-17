#ifndef MOF_AUTOUPDATER_H
#define MOF_AUTOUPDATER_H

class AutoUpdater{
public:
	void recieveThreadMessage(ThreadMessage *);
	void onSuccess(void);
	void startUpdate(std::vector<UpdatePackageDef, std::allocator<UpdatePackageDef>> &);
	void clearRecordedUpdateVersion(void);
	void updateEnd(void);
	void ~AutoUpdater();
	void recieveThreadMessage(ThreadMessage	*);
	void stringVersionToShortIntVersion(std::string);
	void startUpdate(std::vector<UpdatePackageDef,std::allocator<UpdatePackageDef>> &);
	void checkUpdateVersion(void);
	void setLoadingUI(LoadingLayer *);
	void onError(cocos2d::extension::ErrorMessage	*);
	void getCurAutoUpdateIntVersion(void);
	void onNoNewVersion(void);
	void downloadOnePackage(void);
	void AutoUpdater(void);
	void onProgress(int);
}
#endif