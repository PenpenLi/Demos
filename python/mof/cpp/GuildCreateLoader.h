#ifndef MOF_GUILDCREATELOADER_H
#define MOF_GUILDCREATELOADER_H

class GuildCreateLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~GuildCreateLoader();
}
#endif