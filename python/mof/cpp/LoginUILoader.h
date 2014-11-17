#ifndef MOF_LOGINUILOADER_H
#define MOF_LOGINUILOADER_H

class LoginUILoader{
public:
	void ~LoginUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif