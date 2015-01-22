
function compress(data)
    local compress = zlib.deflate()
    local deflated, compress_eof, compress_in, compress_out
    local function compress_pcall()
    	deflated, compress_eof, compress_in, compress_out = compress(data, "finish")
    end
    pcall(compress_pcall)
    --print("compress " .. compress_in .. " " .. compress_out, compress_eof)
    return deflated
end

function uncompress(data)
    local uncompress = zlib.inflate()
    local inflated, uncompress_eof, uncompress_in, uncompress_out
    local function uncompress_pcall()
    	inflated, uncompress_eof, uncompress_in, uncompress_out = uncompress(data, "finish")
    end
    pcall(uncompress_pcall)
    --print("uncompress " .. uncompress_in .. " " .. uncompress_out, uncompress_eof)
    return inflated
end
