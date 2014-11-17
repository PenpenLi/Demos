#ifndef MOF_MAINUILOADER_H
#define MOF_MAINUILOADER_H

class MainUILoader{
public:
	void ~MainUILoader();
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
}
#endif