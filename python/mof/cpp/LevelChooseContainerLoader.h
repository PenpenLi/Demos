#ifndef MOF_LEVELCHOOSECONTAINERLOADER_H
#define MOF_LEVELCHOOSECONTAINERLOADER_H

class LevelChooseContainerLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~LevelChooseContainerLoader();
}
#endif