#ifndef MOF_HELPERNEWSLOADER_H
#define MOF_HELPERNEWSLOADER_H

class HelperNewsLoader{
public:
	void ~HelperNewsLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif