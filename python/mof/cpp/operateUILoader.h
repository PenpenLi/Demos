#ifndef MOF_OPERATEUILOADER_H
#define MOF_OPERATEUILOADER_H

class operateUILoader{
public:
	void ~operateUILoader();
	void createCCNode(cocos2d::CCNode	*, cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode	*,cocos2d::extension::CCBReader	*);
}
#endif