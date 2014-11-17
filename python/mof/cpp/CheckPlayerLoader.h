#ifndef MOF_CHECKPLAYERLOADER_H
#define MOF_CHECKPLAYERLOADER_H

class CheckPlayerLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CheckPlayerLoader();
}
#endif