#ifndef MOF_CHANNELSELECTLOADER_H
#define MOF_CHANNELSELECTLOADER_H

class ChannelSelectLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~ChannelSelectLoader();
}
#endif