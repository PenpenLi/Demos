#ifndef MOF_INIPARSER_H
#define MOF_INIPARSER_H

class IniParser{
public:
	void end(void);
	void parse(std::vector<unsigned	char, std::allocator<unsigned char>>);
	void parse(std::vector<uchar,std::allocator<uchar>>);
	void parse(char);
}
#endif