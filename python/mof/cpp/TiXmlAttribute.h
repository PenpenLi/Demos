#ifndef MOF_TIXMLATTRIBUTE_H
#define MOF_TIXMLATTRIBUTE_H

class TiXmlAttribute{
public:
	void Print(__sFILE *,int);
	void Print(__sFILE *,	int)const;
	void Parse(char const*, Xml::TiXmlParsingData	*, Xml::TiXmlEncoding);
	void ~TiXmlAttribute();
	void Parse(char const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Print(__sFILE *,int,Xml::TiXmlString *);
}
#endif