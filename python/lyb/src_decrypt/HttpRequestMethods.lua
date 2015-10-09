-------------------------------------------------------------------------
--  Class include: URLRequest, HttpClient
-------------------------------------------------------------------------

require "core.utils.class"
require "core.utils.StringUtils"
require "core.events.EventDispatcher"

-------------------------------------------------------------------------
--  Class include: URLRequest, HttpClient
-------------------------------------------------------------------------

HttpRequestMethods = {
    kGet = "get",
    kPost = "post",
    kDownload = "kDownload",
}

--
-- URLRequest ---------------------------------------------------------
--

URLRequest = class();
function URLRequest:ctor(url, method)
	self.url = url;
    self.method = method and method or HttpRequestMethods.kGet;
    self.params = {};
    self.postBody = nil;
    self.relativePath = nil;
end

function URLRequest:addParams(key, value)
    self.params[key] = tostring(value);
end

function URLRequest:getFormatedBody()
    local output = {};
    for k, v in pairs(self.params) do
        local encoded = HttpRequestManager:UrlEncode(v, string.len(v));
        local formated = k .. "=" .. encoded;
        table.insert(output, formated);
    end
    return table.concat(output, "&");
end

function URLRequest:getFinalURL()
    local sep = string.find(self.url, "?") and "&" or "?";
    local formated = self:getFormatedBody();
    return formated == "" and self.url or (self.url .. sep .. formated);
end

--
-- HttpClient ---------------------------------------------------------
--

local httpRequestList = {};

HttpClient = class(EventDispatcher);
function HttpClient:ctor()
	self.class = HttpClient;
    self.request = nil;
    self.isLoading = false;
    self.requestID = -1;
end
function HttpClient:toString()
	return "HttpClient";
end
function HttpClient:dispose()
	self:removeSelf();
end

function onHttpClientCallback(responsePacket)
    local requestID = responsePacket.request.pParam.num;
    local deleteIndex = -1;
    local client = nil;
    for i, v in ipairs(httpRequestList) do
        if v.requestID == requestID then
            deleteIndex = i;
            client = v;
            break;            
        end
    end
    if deleteIndex ~= -1 then table.remove(httpRequestList, deleteIndex) end;
    if client then 
        client:onLoadFinished(responsePacket) 
    end;
end

function HttpClient:load(request)
	self.request = request;
	if self.request and (not self.isLoading) then
	    self.isLoading = true;
	    local url = request:getFinalURL();
	    if request.method == HttpRequestMethods.kGet then
	        self.requestID = HttpRequestManager:sharedInstance():SendGetRequest(url, 2,"onHttpClientCallback");
	    elseif request.method == HttpRequestMethods.kPost then
	        local contentLength = #request.postBody
	        self.requestID = HttpRequestManager:sharedInstance():SendPostRequest(url, request.postBody, contentLength, 2,"onHttpClientCallback"); 
	    elseif request.method == HttpRequestMethods.kDownload then
	       
	        self.requestID = MaterialManager:sharedInstance():DownloadFile(url, "E:/test" , request.relativePath, "onHttpClientCallback");
	    end
	    
        if self.requestID ~= -1 then
            table.insert(httpRequestList, self);
        end
	end
end

function HttpClient:sendToURL(url)
    HttpRequestManager:sharedInstance():SendGetRequest(url, 3, nil);
    print(url);
end

function HttpClient:onLoadFinished(responsePacket)
    local evt = nil;
    if responsePacket.succeed then
        --if responsePacket.buffLen ~= #responsePacket.responseBuf then
        --    error("LuaBuuble.cpp file must be modified atfer tolua script auto creation.")
            -- tolua_pushstring(tolua_S,(const char*)self->responseBuf);
            -- tolua_pushlstring(tolua_S,(const char*)self->responseBuf, (size_t)self->buffLen);
        -- end
        evt = Event.new(Events.kComplete, responsePacket.responseBuf, self);
    else
        evt = Event.new(Events.kError, nil, self);
    end
    evt.code = responsePacket.responseCode;
    if self:hasEventListenerByName(evt.name) then
        self:dispatchEvent(evt);
    end
end