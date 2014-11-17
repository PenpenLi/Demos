#ifndef MOF_ARENATIPUILOADER_H
#define MOF_ARENATIPUILOADER_H

class ArenaTipUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ArenaTipUILoader();
}
#endif