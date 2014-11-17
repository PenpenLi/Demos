#ifndef MOF_CZSTRING_H
#define MOF_CZSTRING_H

class CZString{
public:
	void CZString(Json::Value::CZString	const&);
	void operator<(Json::Value::CZString const&);
	void operator<(Json::Value::CZString const&)const;
	void ~CZString();
}
#endif