#ifndef MOF_TIXMLBASE_H
#define MOF_TIXMLBASE_H

class TiXmlBase{
public:
	void EncodeString(Xml::TiXmlString	const&,Xml::TiXmlString*);
	void ReadText(char	const*,	Xml::TiXmlString *, bool, char const*, bool, Xml::TiXmlEncoding);
	void ReadText(char	const*,Xml::TiXmlString	*,bool,char const*,bool,Xml::TiXmlEncoding);
	void ConvertUTF32ToUTF8(unsigned long, char *, int	*);
	void GetEntity(char const*, char *, int *,	Xml::TiXmlEncoding);
	void StringEqual(char const*, char	const*,	bool, Xml::TiXmlEncoding);
	void ReadName(char	const*,Xml::TiXmlString	*,Xml::TiXmlEncoding);
	void StringEqual(char const*,char const*,bool,Xml::TiXmlEncoding);
	void ConvertUTF32ToUTF8(unsigned long, char *, int	*)::FIRST_BYTE_MARK;
	void GetEntity(char const*,char *,int *,Xml::TiXmlEncoding);
	void SkipWhiteSpace(char const*, Xml::TiXmlEncoding);
	void ReadName(char	const*,	Xml::TiXmlString *, Xml::TiXmlEncoding);
	void SkipWhiteSpace(char const*,Xml::TiXmlEncoding);
	void ConvertUTF32ToUTF8(ulong,char	*,int *);
}
#endif