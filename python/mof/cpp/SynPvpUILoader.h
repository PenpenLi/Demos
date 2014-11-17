#ifndef MOF_SYNPVPUILOADER_H
#define MOF_SYNPVPUILOADER_H

class SynPvpUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~SynPvpUILoader();
}
#endif