#ifndef MOF_BULKPURCHASEDIALOGUILOADER_H
#define MOF_BULKPURCHASEDIALOGUILOADER_H

class BulkPurchaseDialogUILoader{
public:
	void ~BulkPurchaseDialogUILoader();
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif