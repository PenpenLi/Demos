#ifndef MOF_TICKETCONTAINER_H
#define MOF_TICKETCONTAINER_H

class TicketContainer{
public:
	void onGoLevelItemTouchUpInsideClicked(cocos2d::CCObject *);
	void onGoLevelItemCCControlEventTouchDownClicked(cocos2d::CCObject	*);
	void createChooseCopy(LimitActivityDef *);
	void onGoLevelItemDragInsideClicked(cocos2d::CCObject *);
	void TicketContainer(void);
	void onGoLevelItemCCControlEventTouchDownClicked(cocos2d::CCObject *);
	void create(void);
	void onEnter(void);
	void ~TicketContainer();
	void createControl(void);
	void onGoLevelItemTouchUpOutsideClicked(cocos2d::CCObject *);
	void deleteBtnEffect(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void onGoLevelItemTouchUpOutsideClicked(cocos2d::CCObject	*);
}
#endif