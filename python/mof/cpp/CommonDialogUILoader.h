#ifndef MOF_COMMONDIALOGUILOADER_H
#define MOF_COMMONDIALOGUILOADER_H

class CommonDialogUILoader{
public:
	void ~CommonDialogUILoader();
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif