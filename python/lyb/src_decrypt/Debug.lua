Debug = {};

function Debug:assert(v,msg)
    assert(v,msg);
end

function Debug:print(param,...)
    print(param,...);
end

local prevTime = nil;
function Debug:beginTime()
    prevTime = os.clock();
end

function Debug:endTime()
    print(string.format("elapsed time: %.3f\n", os.clock() - prevTime));
end