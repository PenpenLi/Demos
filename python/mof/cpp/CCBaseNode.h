#ifndef MOF_CCBASENODE_H
#define MOF_CCBASENODE_H

class CCBaseNode{
public:
	void CCBaseNode(void);
	void init(float,float,float,float,float,float,float,float);
	void ~CCBaseNode();
	void copyWithZone(cocos2d::CCZone *);
	void reset(void);
	void init(float, float, float, float, float);
	void copy(CCBaseNode*);
}
#endif