#ifndef MOF_PETARENAUILOADER_H
#define MOF_PETARENAUILOADER_H

class PetArenaUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~PetArenaUILoader();
	void loader(void);
}
#endif