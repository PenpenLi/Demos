#ifndef MOF_SYSTEMSETTINGUILOADER_H
#define MOF_SYSTEMSETTINGUILOADER_H

class SystemSettingUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~SystemSettingUILoader();
	void loader(void);
}
#endif