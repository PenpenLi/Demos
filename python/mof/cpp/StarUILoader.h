#ifndef MOF_STARUILOADER_H
#define MOF_STARUILOADER_H

class StarUILoader{
public:
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~StarUILoader();
}
#endif