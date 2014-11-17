#ifndef MOF_CCMENULOADER_H
#define MOF_CCMENULOADER_H

class CCMenuLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void ~CCMenuLoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif