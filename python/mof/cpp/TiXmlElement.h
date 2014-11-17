#ifndef MOF_TIXMLELEMENT_H
#define MOF_TIXMLELEMENT_H

class TiXmlElement{
public:
	void Print(__sFILE *,int);
	void ~TiXmlElement();
	void Accept(Xml::TiXmlVisitor *)const;
	void ClearThis(void);
	void ToElement(void);
	void CopyTo(Xml::TiXmlElement*)const;
	void TiXmlElement(char const*);
	void ToElement(void)const;
	void SetAttribute(char const*, char const*);
	void CopyTo(Xml::TiXmlElement*);
	void Attribute(char const*)const;
	void SetAttribute(char const*,char const*);
	void Parse(char	const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void ReadValue(char const*,Xml::TiXmlParsingData *,Xml::TiXmlEncoding);
	void Attribute(char const*);
	void Parse(char	const*,	Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
	void QueryDoubleAttribute(char const*, double *)const;
	void Accept(Xml::TiXmlVisitor *);
	void QueryDoubleAttribute(char const*,double *);
	void QueryIntAttribute(char const*,int *);
	void Print(__sFILE *, int)const;
	void Clone(void)const;
	void QueryIntAttribute(char const*, int	*)const;
	void Clone(void);
	void ReadValue(char const*, Xml::TiXmlParsingData *, Xml::TiXmlEncoding);
}
#endif