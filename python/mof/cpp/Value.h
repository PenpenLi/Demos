#ifndef MOF_VALUE_H
#define MOF_VALUE_H

class Value{
public:
	void asString(void)const;
	void empty(void);
	void Value(bool);
	void setComment(std::string const&, Json::CommentPlacement);
	void Value(Json::ValueType);
	void resolveReference(char const*, bool);
	void Value(uint);
	void operator[](std::string const&);
	void isObject(void)const;
	void isObject(void);
	void Value(int);
	void operator[](unsigned int);
	void setComment(std::string const&,Json::CommentPlacement);
	void asInt(void);
	void operator[](uint);
	void operator=(Json::Value const&);
	void size(void);
	void resolveReference(char const*,bool);
	void ~Value();
	void asInt(void)const;
	void setComment(char const*, Json::CommentPlacement);
	void Value(Json::Value const&);
	void Value(double);
	void empty(void)const;
	void asString(void);
	void operator[](char const*);
	void type(void)const;
	void setComment(char const*,Json::CommentPlacement);
	void size(void)const;
	void Value(unsigned int);
	void isArray(void)const;
	void type(void);
	void isArray(void);
	void Value(std::string const&);
}
#endif