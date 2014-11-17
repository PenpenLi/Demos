#ifndef MOF_NEWCONFIRMDIALOGLOADER_H
#define MOF_NEWCONFIRMDIALOGLOADER_H

class NewConfirmDialogLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~NewConfirmDialogLoader();
}
#endif