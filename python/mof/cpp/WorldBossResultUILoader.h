#ifndef MOF_WORLDBOSSRESULTUILOADER_H
#define MOF_WORLDBOSSRESULTUILOADER_H

class WorldBossResultUILoader{
public:
	void ~WorldBossResultUILoader();
	void createCCNode(cocos2d::CCNode	*, cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode	*,cocos2d::extension::CCBReader	*);
}
#endif