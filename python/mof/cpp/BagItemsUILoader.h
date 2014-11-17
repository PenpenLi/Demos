#ifndef MOF_BAGITEMSUILOADER_H
#define MOF_BAGITEMSUILOADER_H

class BagItemsUILoader{
public:
	void ~BagItemsUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif