#ifndef MOF_TIXMLATTRIBUTESET_H
#define MOF_TIXMLATTRIBUTESET_H

class TiXmlAttributeSet{
public:
	void FindOrCreate(char const*);
	void Find(char const*);
	void ~TiXmlAttributeSet();
	void Add(Xml::TiXmlAttribute *);
}
#endif