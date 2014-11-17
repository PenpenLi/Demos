#ifndef MOF_CCBSEQUENCEPROPERTY_H
#define MOF_CCBSEQUENCEPROPERTY_H

class CCBSequenceProperty{
public:
	void getType(void);
	void CCBSequenceProperty(void);
	void setType(int);
	void ~CCBSequenceProperty();
	void setName(char	const*);
	void getKeyframes(void);
	void init(void);
	void getName(void);
}
#endif