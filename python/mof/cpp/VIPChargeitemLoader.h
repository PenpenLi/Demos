#ifndef MOF_VIPCHARGEITEMLOADER_H
#define MOF_VIPCHARGEITEMLOADER_H

class VIPChargeitemLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~VIPChargeitemLoader();
}
#endif