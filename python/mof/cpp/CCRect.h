#ifndef MOF_CCRECT_H
#define MOF_CCRECT_H

class CCRect{
public:
	void getMinY(void);
	void getMidY(void)const;
	void getMinX(void);
	void operator=(cocos2d::CCRect const&);
	void intersectsRect(cocos2d::CCRect const&)const;
	void getMinY(void)const;
	void setRect(float);
	void getMaxX(void);
	void getMidY(void);
	void CCRect(void);
	void containsPoint(cocos2d::CCPoint const&);
	void CCRect(float,float,float,float);
	void getMidX(void)const;
	void intersectsRect(cocos2d::CCRect const&);
	void getMinX(void)const;
	void equals(cocos2d::CCRect const&);
	void equals(cocos2d::CCRect const&)const;
	void setRect(float,float,float,float);
	void CCRect(cocos2d::CCRect const&);
	void getMidX(void);
	void getMaxY(void)const;
	void containsPoint(cocos2d::CCPoint const&)const;
	void getMaxY(void);
	void getMaxX(void)const;
}
#endif