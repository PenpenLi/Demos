require "core.utils.class"
require "core.display.DisplayNode"

BitmapTextField = class(DisplayNode);

--text_string 文字
--file_name_string 无后缀文件名
function BitmapTextField:ctor(text_string, file_name_string, width, alignment, imageOffset)
	self.class = BitmapTextField;
	self.string = text_string;
	self.file = "resource/image/ui/bmfonts_output/" .. file_name_string .. ".fnt";


	width = width or -1
	alignment = alignment or kCCTextAlignmentLeft
	imageOffset = imageOffset or CCPointMake(0,0)
	
    self.sprite = CCLabelBMFont:create(self.string, self.file, width, alignment, imageOffset);
  	self.sprite:setAnchorPoint(transLayerAnchor(0, 0));
  	self.sprite:retain();

  	self.touchEnabled = false;
    self.touchChildren = false;
end

function BitmapTextField:dispose()
	self.sprite:release();
    self.sprite = nil;
	BitmapTextField.superclass.dispose(self);
end

function BitmapTextField:getString()
    return self.string;
end

function BitmapTextField:setString(text_string)
	if text_string ~= self.string then
		self.string = text_string;
		self.sprite:setString(self.string or "");
	end
end