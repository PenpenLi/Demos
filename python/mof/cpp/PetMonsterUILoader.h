#ifndef MOF_PETMONSTERUILOADER_H
#define MOF_PETMONSTERUILOADER_H

class PetMonsterUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~PetMonsterUILoader();
}
#endif