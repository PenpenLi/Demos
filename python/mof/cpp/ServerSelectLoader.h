#ifndef MOF_SERVERSELECTLOADER_H
#define MOF_SERVERSELECTLOADER_H

class ServerSelectLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ServerSelectLoader();
}
#endif