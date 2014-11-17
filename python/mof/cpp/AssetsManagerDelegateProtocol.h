#ifndef MOF_ASSETSMANAGERDELEGATEPROTOCOL_H
#define MOF_ASSETSMANAGERDELEGATEPROTOCOL_H

class AssetsManagerDelegateProtocol{
public:
	void onSuccess(void);
	void onProgress(int);
	void onError(cocos2d::extension::ErrorMessage *);
}
#endif