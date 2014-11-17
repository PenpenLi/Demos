#ifndef MOF_SWEEPUILOADER_H
#define MOF_SWEEPUILOADER_H

class SweepUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~SweepUILoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif