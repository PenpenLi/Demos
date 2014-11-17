#ifndef MOF_CAPSULETOYUILOADER_H
#define MOF_CAPSULETOYUILOADER_H

class CapsuleToyUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CapsuleToyUILoader();
}
#endif