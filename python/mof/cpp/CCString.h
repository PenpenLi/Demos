#ifndef MOF_CCSTRING_H
#define MOF_CCSTRING_H

class CCString{
public:
	void createWithContentsOfFile(char const*);
	void getCString(void)const;
	void compare(char const*)const;
	void ~CCString();
	void floatValue(void)const;
	void boolValue(void)const;
	void intValue(void);
	void createWithFormat(char const*,...);
	void floatValue(void);
	void CCString(std::string const&);
	void boolValue(void);
	void length(void);
	void isEqual(cocos2d::CCObject const*);
	void createWithFormat(char const*, ...);
	void copyWithZone(cocos2d::CCZone *);
	void CCString(char const*);
	void compare(char const*);
	void getCString(void);
	void initWithFormatAndValist(char const*, void *);
	void create(std::string	const&);
	void createWithData(uchar const*,ulong);
	void length(void)const;
	void intValue(void)const;
	void createWithData(unsigned char const*, unsigned long);
	void initWithFormatAndValist(char const*,void *);
}
#endif