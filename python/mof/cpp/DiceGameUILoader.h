#ifndef MOF_DICEGAMEUILOADER_H
#define MOF_DICEGAMEUILOADER_H

class DiceGameUILoader{
public:
	void ~DiceGameUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif