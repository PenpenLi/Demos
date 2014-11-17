#ifndef MOF_CCGLPROGRAM_H
#define MOF_CCGLPROGRAM_H

class CCGLProgram{
public:
	void initWithVertexShaderByteArray(char const*,char const*);
	void compileShader(unsigned int *, unsigned int, char const*);
	void CCGLProgram(void);
	void updateUniformLocation(int, void	*, unsigned int);
	void addAttribute(char const*, unsigned int);
	void setUniformLocationWithMatrix4fv(int,float *,uint);
	void initWithVertexShaderByteArray(char const*, char	const*);
	void setUniformLocationWith1f(int,float);
	void setUniformLocationWith1i(int,int);
	void use(void);
	void updateUniforms(void);
	void ~CCGLProgram();
	void setUniformLocationWithMatrix4fv(int, float *, unsigned int);
	void setUniformLocationWith1i(int, int);
	void setUniformLocationWith4f(float, float);
	void link(void);
	void setUniformLocationWith4f(int,float,float,float,float);
	void updateUniformLocation(int,void *,uint);
	void setUniformLocationWith1f(int, float);
	void addAttribute(char const*,uint);
	void compileShader(uint *,uint,char const*);
	void setUniformsForBuiltins(void);
}
#endif