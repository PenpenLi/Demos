#ifndef MOF_CCDICTIONARY_H
#define MOF_CCDICTIONARY_H

class CCDictionary{
public:
	void removeObjectForKey(int);
	void setObject(cocos2d::CCObject *,std::string const&);
	void setObject(cocos2d::CCObject *,int);
	void setObject(cocos2d::CCObject *,	std::string const&);
	void CCDictionary(void);
	void removeObjectForElememt(cocos2d::CCDictElement *);
	void valueForKey(std::string const&);
	void removeObjectsForKeys(cocos2d::CCArray *);
	void setObjectUnSafe(cocos2d::CCObject *, int);
	void createWithDictionary(cocos2d::CCDictionary*);
	void setObject(cocos2d::CCObject *,	int);
	void createWithContentsOfFile(char const*);
	void objectForKey(int);
	void setObjectUnSafe(cocos2d::CCObject *,std::string const&);
	void count(void);
	void copyWithZone(cocos2d::CCZone *);
	void objectForKey(std::string const&);
	void setObjectUnSafe(cocos2d::CCObject *, std::string const&);
	void removeObjectForKey(std::string	const&);
	void allKeys(void);
	void create(void);
	void ~CCDictionary();
	void setObjectUnSafe(cocos2d::CCObject *,int);
	void removeAllObjects(void);
	void createWithContentsOfFileThreadSafe(char const*);
}
#endif