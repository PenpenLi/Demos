#ifndef MOF_TIXMLDECLARATION_H
#define MOF_TIXMLDECLARATION_H

class TiXmlDeclaration{
public:
	void CopyTo(Xml::TiXmlDeclaration*);
	void Print(__sFILE *,int);
	void Parse(char const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Print(__sFILE *, int)const;
	void Clone(void);
	void ToDeclaration(void);
	void Clone(void)const;
	void Accept(Xml::TiXmlVisitor *)const;
	void ToDeclaration(void)const;
	void Accept(Xml::TiXmlVisitor *);
	void ~TiXmlDeclaration();
	void Print(__sFILE *,int,Xml::TiXmlString *);
	void Parse(char const*, Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
	void Print(__sFILE *, int, Xml::TiXmlString	*)const;
}
#endif