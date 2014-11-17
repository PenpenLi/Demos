#ifndef MOF_GUILDLISTLOADER_H
#define MOF_GUILDLISTLOADER_H

class GuildListLoader{
public:
	void createCCNode(cocos2d::CCNode	*, cocos2d::extension::CCBReader *);
	void ~GuildListLoader();
	void loader(void);
	void createCCNode(cocos2d::CCNode	*,cocos2d::extension::CCBReader	*);
}
#endif