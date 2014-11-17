#ifndef MOF_TREASURESCOREUILOADER_H
#define MOF_TREASURESCOREUILOADER_H

class TreasureScoreUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~TreasureScoreUILoader();
}
#endif