#ifndef MOF_ACCUMULATEAWARDLOADER_H
#define MOF_ACCUMULATEAWARDLOADER_H

class AccumulateAwardLoader{
public:
	void ~AccumulateAwardLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif