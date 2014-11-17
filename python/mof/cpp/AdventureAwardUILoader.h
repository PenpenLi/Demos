#ifndef MOF_ADVENTUREAWARDUILOADER_H
#define MOF_ADVENTUREAWARDUILOADER_H

class AdventureAwardUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~AdventureAwardUILoader();
}
#endif