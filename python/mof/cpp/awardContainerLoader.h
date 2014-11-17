#ifndef MOF_AWARDCONTAINERLOADER_H
#define MOF_AWARDCONTAINERLOADER_H

class awardContainerLoader{
public:
	void ~awardContainerLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
}
#endif