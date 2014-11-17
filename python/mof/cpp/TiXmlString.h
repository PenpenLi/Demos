#ifndef MOF_TIXMLSTRING_H
#define MOF_TIXMLSTRING_H

class TiXmlString{
public:
	void assign(char	const*,	unsigned long);
	void init(ulong,ulong);
	void assign(char	const*,ulong);
	void find(char,ulong);
	void find(char, unsigned	long)const;
	void append(char	const*,ulong);
	void reserve(ulong);
	void init(unsigned long,	unsigned long);
	void append(char	const*,	unsigned long);
}
#endif