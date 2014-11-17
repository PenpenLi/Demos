#ifndef MOF_PETMATCHUILOADER_H
#define MOF_PETMATCHUILOADER_H

class PetMatchUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~PetMatchUILoader();
}
#endif