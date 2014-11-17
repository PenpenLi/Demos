#ifndef MOF_QUEENBLESSINGUILOADER_H
#define MOF_QUEENBLESSINGUILOADER_H

class QueenBlessingUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~QueenBlessingUILoader();
	void loader(void);
}
#endif