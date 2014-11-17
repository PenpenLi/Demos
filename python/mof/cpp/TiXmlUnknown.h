#ifndef MOF_TIXMLUNKNOWN_H
#define MOF_TIXMLUNKNOWN_H

class TiXmlUnknown{
public:
	void ~TiXmlUnknown();
	void Clone(void);
	void ToUnknown(void);
	void Print(__sFILE *,int);
	void Clone(void)const;
	void Parse(char	const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Parse(char	const*,	Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
	void Accept(Xml::TiXmlVisitor *)const;
	void Accept(Xml::TiXmlVisitor *);
	void ToUnknown(void)const;
}
#endif