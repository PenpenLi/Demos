#ifndef MOF_MAILUILOADER_H
#define MOF_MAILUILOADER_H

class MailUILoader{
public:
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void ~MailUILoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif