#ifndef MOF_GUILDSKILLCONTAINER_H
#define MOF_GUILDSKILLCONTAINER_H

class GuildSkillContainer{
public:
	void setSelectSpritePos(int);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject	*);
	void createGuildNodes(int, cocos2d::CCPoint);
	void GuildSkillContainer(void);
	void setArrowSpriteShow(int, bool);
	void createGuildNodes(int,cocos2d::CCPoint);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void setSkillIconStata(int);
	void ~GuildSkillContainer();
	void create(void);
	void getLvlByTemplate(int);
	void setArrowSpriteShow(int,bool);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void onEnter(void);
	void createControl(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif