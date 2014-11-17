#ifndef MOF_LOGINAWARDUILOADER_H
#define MOF_LOGINAWARDUILOADER_H

class LoginAwardUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~LoginAwardUILoader();
	void loader(void);
}
#endif