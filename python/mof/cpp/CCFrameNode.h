#ifndef MOF_CCFRAMENODE_H
#define MOF_CCFRAMENODE_H

class CCFrameNode{
public:
	void CCFrameNode(void);
	void create(void);
	void copyWithZone(cocos2d::CCZone *);
	void copy(CCBaseNode *);
	void reset(void);
	void ~CCFrameNode();
}
#endif