#ifndef MOF_TIXMLCOMMENT_H
#define MOF_TIXMLCOMMENT_H

class TiXmlComment{
public:
	void Print(__sFILE *,int);
	void ToComment(void)const;
	void Clone(void);
	void ToComment(void);
	void Clone(void)const;
	void Parse(char	const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Parse(char	const*,	Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
	void ~TiXmlComment();
	void Accept(Xml::TiXmlVisitor *);
	void Accept(Xml::TiXmlVisitor *)const;
}
#endif