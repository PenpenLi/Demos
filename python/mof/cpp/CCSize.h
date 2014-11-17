#ifndef MOF_CCSIZE_H
#define MOF_CCSIZE_H

class CCSize{
public:
	void CCSize(cocos2d::CCSize const&);
	void setSize(float, float);
	void equals(cocos2d::CCSize const&)const;
	void setSize(float,float);
	void CCSize(float,float);
	void CCSize(void);
	void equals(cocos2d::CCSize const&);
	void operator=(cocos2d::CCSize const&);
}
#endif