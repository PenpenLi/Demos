#ifndef MOF_DEFAULTVALUEALLOCATOR_H
#define MOF_DEFAULTVALUEALLOCATOR_H

class DefaultValueAllocator{
public:
	void releaseMemberName(char *);
	void duplicateStringValue(char const*,uint);
	void duplicateStringValue(char const*, unsigned int);
	void makeMemberName(char const*);
	void releaseStringValue(char *);
	void ~DefaultValueAllocator();
}
#endif