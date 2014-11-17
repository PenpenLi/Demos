#ifndef MOF_FAMOUSHALLUILOADER_H
#define MOF_FAMOUSHALLUILOADER_H

class FamousHallUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~FamousHallUILoader();
	void loader(void);
}
#endif