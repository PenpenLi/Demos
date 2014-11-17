#ifndef MOF_VIPUILOADER_H
#define MOF_VIPUILOADER_H

class VipUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~VipUILoader();
}
#endif