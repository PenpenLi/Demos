#ifndef MOF_CCEGLVIEW_H
#define MOF_CCEGLVIEW_H

class CCEGLView{
public:
	void CCEGLView(void);
	void isOpenGLReady(void);
	void end(void);
	void sharedOpenGLView(void);
	void swapBuffers(void);
	void setIMEKeyboardState(bool);
	void setContentScaleFactor(float);
	void ~CCEGLView();
}
#endif