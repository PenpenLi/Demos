#ifndef MOF_CCFRAMENODELIST_H
#define MOF_CCFRAMENODELIST_H

class CCFrameNodeList{
public:
	void getLength(void);
	void create(float,float);
	void getFrames(void)const;
	void getScale(void);
	void setScale(float);
	void setFrames(cocos2d::CCArray *);
	void getFrames(void);
	void setDelay(float);
	void getDelay(void)const;
	void addFrame(CCFrameNode	*);
	void getFrame(void)const;
	void setFrame(int);
	void getScale(void)const;
	void getLength(void)const;
	void getFrame(void);
	void copyWithZone(cocos2d::CCZone	*);
	void getDelay(void);
	void setLength(int);
	void ~CCFrameNodeList();
	void getFrame(int);
	void init(void);
}
#endif