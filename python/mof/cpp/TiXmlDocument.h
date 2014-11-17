#ifndef MOF_TIXMLDOCUMENT_H
#define MOF_TIXMLDOCUMENT_H

class TiXmlDocument{
public:
	void ToDocument(void);
	void Print(__sFILE *,int);
	void Parse(char const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void ~TiXmlDocument();
	void CopyTo(Xml::TiXmlDocument*);
	void SetError(int,char	const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Print(__sFILE *, int)const;
	void Accept(Xml::TiXmlVisitor *);
	void Clone(void)const;
	void SetError(int, char const*, Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
	void Clone(void);
	void ToDocument(void)const;
	void TiXmlDocument(void);
	void CopyTo(Xml::TiXmlDocument*)const;
	void Accept(Xml::TiXmlVisitor *)const;
	void Parse(char const*, Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
}
#endif