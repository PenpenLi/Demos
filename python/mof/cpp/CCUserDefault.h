#ifndef MOF_CCUSERDEFAULT_H
#define MOF_CCUSERDEFAULT_H

class CCUserDefault{
public:
	void getIntegerForKey(char	const*);
	void getStringForKey(char const*,std::string const&);
	void getBoolForKey(char const*, bool);
	void ~CCUserDefault();
	void setStringForKey(char const*,std::string const&);
	void setBoolForKey(char const*, bool);
	void setBoolForKey(char const*,bool);
	void setIntegerForKey(char	const*,	int);
	void getStringForKey(char const*);
	void getBoolForKey(char const*,bool);
	void initXMLFilePath(void);
	void sharedUserDefault(void);
	void getIntegerForKey(char	const*,int);
	void purgeSharedUserDefault(void);
	void getStringForKey(char const*, std::string const&);
	void flush(void);
	void setStringForKey(char const*, std::string const&);
	void isXMLFileExist(void);
	void createXMLFile(void);
	void getIntegerForKey(char	const*,	int);
	void setIntegerForKey(char	const*,int);
}
#endif