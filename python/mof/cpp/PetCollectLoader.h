#ifndef MOF_PETCOLLECTLOADER_H
#define MOF_PETCOLLECTLOADER_H

class PetCollectLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~PetCollectLoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif