#ifndef MOF_GUILDSKILLLOADER_H
#define MOF_GUILDSKILLLOADER_H

class GuildSkillLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~GuildSkillLoader();
}
#endif