#ifndef MOF_GUILDUILOADER_H
#define MOF_GUILDUILOADER_H

class GuildUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~GuildUILoader();
	void loader(void);
}
#endif