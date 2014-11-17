#ifndef MOF_SHAREUILOADER_H
#define MOF_SHAREUILOADER_H

class ShareUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ShareUILoader();
}
#endif