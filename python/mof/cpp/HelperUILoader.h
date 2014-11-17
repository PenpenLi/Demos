#ifndef MOF_HELPERUILOADER_H
#define MOF_HELPERUILOADER_H

class HelperUILoader{
public:
	void ~HelperUILoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
}
#endif