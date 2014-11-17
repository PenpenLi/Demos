#ifndef MOF_GUILDAPPLYLOADER_H
#define MOF_GUILDAPPLYLOADER_H

class GuildApplyLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~GuildApplyLoader();
}
#endif