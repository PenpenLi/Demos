#ifndef MOF_SKILLCONTAINER_H
#define MOF_SKILLCONTAINER_H

class SkillContainer{
public:
	void setSelectSpritePos(int);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void setArrowSpriteShow(cocos2d::CCSprite *,bool);
	void ~SkillContainer();
	void SkillContainer(void);
	void createSkillNodes(int,int,cocos2d::CCPoint);
	void getIndexBySkillid(int);
	void setSkillDesc(int);
	void create(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void setSkillNodeAttribute(int);
	void getSkillListByType(SkillList);
	void createSkillNodes(int,	int, cocos2d::CCPoint);
	void onEnter(void);
	void createControl(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void setArrowSpriteShow(cocos2d::CCSprite *, bool);
}
#endif