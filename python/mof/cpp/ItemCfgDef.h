#ifndef MOF_ITEMCFGDEF_H
#define MOF_ITEMCFGDEF_H

class ItemCfgDef{
public:
	void ReadFloat(char const*,float,bool *);
	void ReadFloat(char const*, float, bool *);
	void ReadStr(char const*,std::string,bool *);
	void ReadInt(char const*,int,bool *);
	void ReadInt(char const*, int,	bool *);
	void getFullName(void);
	void ReadStr(char const*, std::string,	bool *);
}
#endif