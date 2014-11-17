#ifndef MOF_TREASUREMANORSUILOADER_H
#define MOF_TREASUREMANORSUILOADER_H

class TreasureManorsUILoader{
public:
	void ~TreasureManorsUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
}
#endif