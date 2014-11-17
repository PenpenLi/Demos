#ifndef MOF_BAGUILOADER_H
#define MOF_BAGUILOADER_H

class BagUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~BagUILoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif