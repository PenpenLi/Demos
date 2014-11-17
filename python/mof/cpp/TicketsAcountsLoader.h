#ifndef MOF_TICKETSACOUNTSLOADER_H
#define MOF_TICKETSACOUNTSLOADER_H

class TicketsAcountsLoader{
public:
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~TicketsAcountsLoader();
}
#endif