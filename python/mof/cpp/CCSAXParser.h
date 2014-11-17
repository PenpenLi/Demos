#ifndef MOF_CCSAXPARSER_H
#define MOF_CCSAXPARSER_H

class CCSAXParser{
public:
	void parse(char const*, unsigned int);
	void endElement(void	*,uchar	const*);
	void ~CCSAXParser();
	void startElement(void *,uchar const*,uchar const**);
	void textHandler(void *,uchar const*,int);
	void textHandler(void	*,uchar	const*,int);
	void textHandler(void *, unsigned char const*, int);
	void init(char const*);
	void CCSAXParser(void);
	void parse(char const*,uint);
	void endElement(void	*, unsigned char const*);
	void setDelegator(cocos2d::CCSAXDelegator *);
	void startElement(void *, unsigned char const*, unsigned char const**);
	void endElement(void *,uchar const*);
}
#endif