#ifndef MOF_DUNGEONSUILOADER_H
#define MOF_DUNGEONSUILOADER_H

class DungeonsUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~DungeonsUILoader();
}
#endif