#ifndef MOF_CCPOINT_H
#define MOF_CCPOINT_H

class CCPoint{
public:
	void CCPoint(void);
	void equals(cocos2d::CCPoint const&);
	void equals(cocos2d::CCPoint const&)const;
	void operator=(cocos2d::CCPoint const&);
	void CCPoint(cocos2d::CCPoint const&);
	void CCPoint(float,float);
}
#endif