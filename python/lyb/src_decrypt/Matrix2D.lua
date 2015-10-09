
Matrix2D = class();
function Matrix2D:ctor(a, b, c, d, tx, ty)
	self.a = a or 1;
	self.b = b or 0;
	self.c = c or 0;
	self.d = d or 1;
	self.tx = tx or 0;
	self.ty = ty or 0;
end

function Matrix2D:toAffineTransform()
	return CCAffineTransformMake(self.a, self.b, self.c, self.d, self.tx, self.ty);
end

function Matrix2D:toString()
	return string.format("Matrix2D [%.2f,%.2f,%.2f,%.2f,%.2f,%.2f]", self.a, self.b, self.c, self.d, self.tx, self.ty);
end

--Concatenates the specified matrix properties with this matrix. All parameters are required.
function Matrix2D:prepend(a_, b_, c_, d_, tx_, ty_)
	local a = a_ or 0;
	local b = b_ or 0;
	local c = c_ or 0;
	local d = d_ or 0;
	local tx = tx_ or 0;
	local ty = ty_ or 0;

	local tx1 = self.tx;

	if a ~= 1 or b ~= 0 or c ~= 0 or d ~= 1 then
		local a1 = self.a;
		local c1 = self.c;
		self.a = a1 * a + self.b * c;
		self.b = a1 * b + self.b * d;
		self.c = c1 * a + self.d * c;
		self.d = c1 * b + self.d * d;
	end

	self.tx = tx1 * a + self.ty * c + tx;
	self.ty = tx1 * b + self.ty * d + ty;
end

--Appends the specified matrix properties with this matrix.
function Matrix2D:append(a_, b_, c_, d_, tx_, ty_)
	local a = a_ or 0;
	local b = b_ or 0;
	local c = c_ or 0;
	local d = d_ or 0;
	local tx = tx_ or 0;
	local ty = ty_ or 0;

	local a1 = self.a;
	local b1 = self.b;
	local c1 = self.c;
	local d1 = self.d;

	self.a = a * a1 + b * c1;
	self.b = a * b1 + b * d1;
	self.c = c * a1 + d * c1;
	self.d = c * b1 + d * d1;

	self.tx = tx * a1 + ty * c1 + self.tx;
	self.ty = tx * b1 + ty * d1 + self.ty;
end

function Matrix2D:concat(m)
	self:prepend(m.a, m.b, m.c, m.d, m.tx, m.ty);
end

--[[
function Matrix2D:rotate(angle)
	local i = angle or 0;
	local cos = math.cos(i);
	local sin = math.sin(i);

	local a1 = self.a;
	local c1 = self.c;
	local tx1 = self.tx;

	self.a = a1 * cos - self.b * sin;
	self.b = a1 * sin + self.b * cos;
	self.c = c1 * cos - self.d * sin;
	self.d = c1 * sin + self.d * cos;
	self.tx = tx1 * cos - self.ty * sin;
	self.ty = tx1 * sin + self.ty * cos;
end

--skewX/Y The amount to skew horizontally in degrees.
function Matrix2D:skew(skewX_, skewY_)
	local deg2rad = math.pi / 180;
	local skewX = skewX_ or 0;
	local skewY = skewY_ or 0;
	skewX = skewX * deg2rad;
	skewY = skewY * deg2rad;
	self:append(math.cos(skewY), math.sin(skewY), -math.sin(skewX), math.cos(skewX), 0,0);
end

function Matrix2D:scale(x_, y_)
	local x = x_ or 0;
	local y = y_ or 0;
	self.a = self.a * x;
	self.d = self.d * y;
	self.tx = self.tx * x;
	self.ty = self.ty * y;

end

function Matrix2D:translate(x_, y_)
	local x = x_ or 0;
	local y = y_ or 0;
	self.tx = self.tx + x;
	self.ty = self.ty + y;
end
]]

function Matrix2D:identity()
	self.a = 1;
	self.d = 1;
	self.b = 0;
	self.c = 0;
	self.tx = 0;
	self.ty = 0;
end

function Matrix2D:invert()
	local a1 = self.a;
	local b1 = self.b;
	local c1 = self.c;
	local d1 = self.d;
	local tx1 = self.tx;
	local n = a1 * d1 - b1 * c1;

	self.a = d1/n;
	self.b = -b1/n;
	self.c = -c1/n;
	self.d = a1/n;
	self.tx = (c1 * self.ty - d1 * tx1)/n;
	self.ty = -(a1 * self.ty - b1 * tx1)/n;
end

function Matrix2D:deltaTransformPoint(x, y)
	local x_ = x or 0;
	local y_ = y or 0;
	local _x = self.a * x_ + self.c * y_;
	local _y = self.b * x_ + self.d * y_;
	return _x, _y;
end

function Matrix2D:transformPoint(x, y)
	local x_ = x or 0;
	local y_ = y or 0;
	local _x = self.a * x_ + self.c * y_ + self.tx;
	local _y = self.b * x_ + self.d * y_ + self.ty;
	return _x, _y;
end

function Matrix2D:clone()
	local ret = Matrix2D.new(self.a, self.b, self.c, self.d, self.tx, self.ty);
	return ret;
end
