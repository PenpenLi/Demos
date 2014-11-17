#ifndef MOF_GUILDUICONTAINER_H
#define MOF_GUILDUICONTAINER_H

class GuildUIContainer{
public:
	void createActivityNode(cocos2d::CCNode *,ActivityCfgDef	*,bool);
	void GuildUIContainer(void);
	void onTouchUpInsideClicked(cocos2d::CCObject *);
	void onTouchDownClicked(cocos2d::CCObject	*);
	void onDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onTouchUpOutsideClicked(cocos2d::CCObject *);
	void createContent(void);
	void createActivityNode(cocos2d::CCNode *, ActivityCfgDef *, bool);
	void onTouchDownClicked(cocos2d::CCObject *);
	void onEnter(void);
	void createControl(void);
	void createEffect(cocos2d::CCNode *);
	void ~GuildUIContainer();
	void init(void);
	void onExit(void);
}
#endif