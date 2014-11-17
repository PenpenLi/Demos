#ifndef MOF_SHOPPINGCOMMONDIALOGUILOADER_H
#define MOF_SHOPPINGCOMMONDIALOGUILOADER_H

class ShoppingCommonDialogUILoader{
public:
	void ~ShoppingCommonDialogUILoader();
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif