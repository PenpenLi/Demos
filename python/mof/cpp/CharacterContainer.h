#ifndef MOF_CHARACTERCONTAINER_H
#define MOF_CHARACTERCONTAINER_H

class CharacterContainer{
public:
	void InitData(void);
	void showDeleteRoleTips(obj_role, cocos2d::CCNode *);
	void CharacterContainer(void);
	void showDeleteRoleTips(obj_role,cocos2d::CCNode *);
	void onItemDragInsideClicked(cocos2d::CCObject *);
	void addData(obj_role);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getCharactersSize(void);
	void onItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void getcharacterProperty(RoleTpltID);
	void onItemDragInsideClicked(cocos2d::CCObject	*);
	void setSelectRole(int);
	void registerWithTouchDispatcher(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void ~CharacterContainer();
	void deleteCharacter(void);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif