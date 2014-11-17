#ifndef MOF_CCBVALUE_H
#define MOF_CCBVALUE_H

class CCBValue{
public:
	void create(unsigned	char);
	void create(uchar);
	void getIntValue(void);
	void getByteValue(void);
	void create(char const*);
	void create(bool);
	void getBoolValue(void);
	void ~CCBValue();
	void create(float);
	void create(int);
	void getFloatValue(void);
}
#endif