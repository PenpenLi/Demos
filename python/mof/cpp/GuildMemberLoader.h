#ifndef MOF_GUILDMEMBERLOADER_H
#define MOF_GUILDMEMBERLOADER_H

class GuildMemberLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~GuildMemberLoader();
}
#endif