#ifndef MOF_FIRSTCHARGEUILOADER_H
#define MOF_FIRSTCHARGEUILOADER_H

class FirstChargeUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~FirstChargeUILoader();
}
#endif