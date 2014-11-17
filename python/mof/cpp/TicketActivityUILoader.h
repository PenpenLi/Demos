#ifndef MOF_TICKETACTIVITYUILOADER_H
#define MOF_TICKETACTIVITYUILOADER_H

class TicketActivityUILoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~TicketActivityUILoader();
}
#endif