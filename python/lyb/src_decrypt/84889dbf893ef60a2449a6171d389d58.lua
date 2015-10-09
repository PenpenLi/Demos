-- ccTypes

--common
--[[
	CCAffineTransform CCAffineTransformMake(float a, float b, float c, float d, float tx, float ty);
	CCAffineTransform CCAffineTransformMakeIdentity();
]]


--[[ Color
-- r, g, b = [0, 255]
	static ccColor3B ccc3(const GLubyte r, const GLubyte g, const GLubyte b);
	static ccColor4B ccc4(const GLubyte r, const GLubyte g, const GLubyte b, const GLubyte o);


	-- Returns a ccColor4F from a ccColor3B. Alpha will be 1.
	static ccColor4F ccc4FFromccc3B(ccColor3B c);

	-- Returns a ccColor4F from a ccColor4B.
	static ccColor4F ccc4FFromccc4B(ccColor4B c);


	static bool ccc4FEqual(ccColor4F a, ccColor4F b);
]]
function makeColorRGB(r, g, b) return ccc3(r, g, b) end;
function makeColorRGBA(r, g, b, a) return ccc3(r, g, b, a) end;

--CCPoint CCPointMake(float x, float y);
function makePoint(x, y) return CCPointMake(x, y) end;
--CCSize  CCSizeMake(float width, float height);
function makeSize(w, h) return CCSizeMake(w, h) end;
--CCRect  CCRectMake(float x, float y, float width,float height);
--CCRect : CCObject
--[[
	CCPoint origin;
    CCSize  size;
    CCRect();
    CCRect(float x, float y, float width, float height);

    float getMinX();
	float getMidX();
	float getMaxX();
	float getMinY();
	float getMidY();
	float getMaxY();
	bool equals(const CCRect & rect) const;
	bool containsPoint(const CCPoint & point) const;
	bool intersectsRect(const CCRect & rect) const;
]]
function makeRect(x, y, w, h) return CCRectMake(x,y,w,h) end;