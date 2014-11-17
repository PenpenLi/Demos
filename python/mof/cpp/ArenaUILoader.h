#ifndef MOF_ARENAUILOADER_H
#define MOF_ARENAUILOADER_H

class ArenaUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ArenaUILoader();
}
#endif