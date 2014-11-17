#ifndef MOF_MACSTRINGUTILS_H
#define MOF_MACSTRINGUTILS_H

class MacStringUtils{
public:
	void ConvertToString(__CFString const*);
	void IntegerValueAtIndex(std::string &, unsigned int);
	void IntegerValueAtIndex(std::string &,uint);
}
#endif