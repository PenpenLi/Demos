#ifndef MOF_CHOOSECHARACTERUILOADER_H
#define MOF_CHOOSECHARACTERUILOADER_H

class ChooseCharacterUILoader{
public:
	void ~ChooseCharacterUILoader();
	void createCCNode(cocos2d::CCNode	*, cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode	*,cocos2d::extension::CCBReader	*);
}
#endif