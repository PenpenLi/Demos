#ifndef MOF_PETTOTEMUILOADER_H
#define MOF_PETTOTEMUILOADER_H

class PetTotemUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~PetTotemUILoader();
}
#endif