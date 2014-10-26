#include "stdafx.h"
#include "log.h"

std::string w2c(const std::wstring& ws)
{
	return std::string().assign(ws.begin(), ws.end());
}

std::string w2c(const wchar_t* pws)
{
	return w2c(std::wstring(pws));
}