#ifndef MOF_LEVELCHOOSEDIALOGLOADER_H
#define MOF_LEVELCHOOSEDIALOGLOADER_H

class LevelChooseDialogLoader{
public:
	void createCCNode(cocos2d::CCNode	*, cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode	*,cocos2d::extension::CCBReader	*);
	void ~LevelChooseDialogLoader();
}
#endif