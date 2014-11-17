#ifndef MOF_REGISTERUILOADER_H
#define MOF_REGISTERUILOADER_H

class RegisterUILoader{
public:
	void ~RegisterUILoader();
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif