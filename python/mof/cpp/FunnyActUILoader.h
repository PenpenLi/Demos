#ifndef MOF_FUNNYACTUILOADER_H
#define MOF_FUNNYACTUILOADER_H

class FunnyActUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~FunnyActUILoader();
	void loader(void);
}
#endif