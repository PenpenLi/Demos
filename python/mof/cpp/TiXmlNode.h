#ifndef MOF_TIXMLNODE_H
#define MOF_TIXMLNODE_H

class TiXmlNode{
public:
	void FirstChildElement(void)const;
	void NextSiblingElement(char const*);
	void NextSiblingElement(void);
	void NextSiblingElement(void)const;
	void ToElement(void);
	void ToText(void);
	void NextSiblingElement(char const*)const;
	void ~TiXmlNode();
	void TiXmlNode(Xml::TiXmlNode::NodeType);
	void FirstChildElement(char const*)const;
	void ToElement(void)const;
	void ToDeclaration(void)const;
	void LinkEndChild(Xml::TiXmlNode*);
	void Identify(char	const*,	Xml::TiXmlEncoding);
	void ToDeclaration(void);
	void ToDocument(void);
	void FirstChildElement(void);
	void ToText(void)const;
	void ToComment(void)const;
	void ToDocument(void)const;
	void ToComment(void);
	void Identify(char	const*,Xml::TiXmlEncoding);
	void GetDocument(void);
	void ToUnknown(void);
	void ToUnknown(void)const;
	void FirstChildElement(char const*);
	void GetDocument(void)const;
}
#endif