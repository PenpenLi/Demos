#ifndef MOF_CHARACTERCONTAINERLOADER_H
#define MOF_CHARACTERCONTAINERLOADER_H

class CharacterContainerLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CharacterContainerLoader();
}
#endif