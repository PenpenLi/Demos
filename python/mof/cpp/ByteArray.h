#ifndef MOF_BYTEARRAY_H
#define MOF_BYTEARRAY_H

class ByteArray{
public:
	void ByteArray(char *, int);
	void read_string(void);
	void read_int(void);
	void write_string(std::string const&);
	void write_float(float);
	void write_int(int);
	void read_float(void);
	void ByteArray(char *,int);
	void ~ByteArray();
}
#endif