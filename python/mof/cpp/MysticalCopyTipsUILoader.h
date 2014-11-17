#ifndef MOF_MYSTICALCOPYTIPSUILOADER_H
#define MOF_MYSTICALCOPYTIPSUILOADER_H

class MysticalCopyTipsUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~MysticalCopyTipsUILoader();
}
#endif