
VectorUtils = {
};

-- symmetrical vector -- 
function VectorUtils.symmetric(v1,v2)
    local modV2 = math.sqrt(v2.x^2 + v2.y^2);
    local u = { x = v2.x/modV2, y = v2.y/modV2, };
    local inner = v1.x * u.x + v1.y * u.y;
    local d = { x = inner*u.x, y = inner*u.y };
    local c = { x = 2*d.x-v1.x, y = 2*d.y-v1.y, };
    return c;
end
