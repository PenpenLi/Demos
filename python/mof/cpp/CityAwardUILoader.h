#ifndef MOF_CITYAWARDUILOADER_H
#define MOF_CITYAWARDUILOADER_H

class CityAwardUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CityAwardUILoader();
}
#endif