#ifndef MOF_PETARENACONTAINER_H
#define MOF_PETARENACONTAINER_H

class PetArenaContainer{
public:
	void createItemsNode(cocos2d::CCNode *,	PetPvpItem *, int);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject	*);
	void onDescAwardTouchDownClicked(cocos2d::CCObject *);
	void createContent(void);
	void PetArenaContainer(void);
	void ~PetArenaContainer();
	void onEnter(void);
	void createControl(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void createItemsNode(cocos2d::CCNode *,PetPvpItem *,int);
	void create(void);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif