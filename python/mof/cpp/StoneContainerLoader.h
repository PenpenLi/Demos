#ifndef MOF_STONECONTAINERLOADER_H
#define MOF_STONECONTAINERLOADER_H

class StoneContainerLoader{
public:
	void ~StoneContainerLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
}
#endif