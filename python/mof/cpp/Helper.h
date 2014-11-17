#ifndef MOF_HELPER_H
#define MOF_HELPER_H

class Helper{
public:
	void Helper(void);
	void sendMessage(cocos2d::extension::AssetsManager::_Message *);
	void handleUpdateSucceed(cocos2d::extension::AssetsManager::_Message *);
	void ~Helper();
	void update(float);
}
#endif