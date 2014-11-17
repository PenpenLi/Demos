#ifndef MOF_TIXMLTEXT_H
#define MOF_TIXMLTEXT_H

class TiXmlText{
public:
	void ~TiXmlText();
	void ToText(void);
	void ToText(void)const;
	void Blank(void)const;
	void TiXmlText(char const*);
	void Print(__sFILE	*,int);
	void Clone(void);
	void Clone(void)const;
	void Parse(char const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Accept(Xml::TiXmlVisitor *)const;
	void Blank(void);
	void Accept(Xml::TiXmlVisitor *);
	void Parse(char const*, Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
}
#endif