#ifndef MOF_CCCONFIGURATION_H
#define MOF_CCCONFIGURATION_H

class CCConfiguration{
public:
	void sharedConfiguration(void);
	void ~CCConfiguration();
	void purgeConfiguration(void);
	void init(void);
}
#endif