#ifndef MOF_CCTWEENNODE_H
#define MOF_CCTWEENNODE_H

class CCTweenNode{
public:
	void ~CCTweenNode();
	void betweenValue(CCFrameNode	*,CCFrameNode *);
	void CCTweenNode(void);
	void tweenTo(float);
	void remove(void);
	void betweenValue(CCFrameNode	*, CCFrameNode *);
}
#endif