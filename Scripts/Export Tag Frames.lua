-- Export all frames within tags as seperate PNG files
-- based on Export Tags script by StarJackal57: https://github.com/StarJackal57/Aseprite-Export-Tags
-- Ex: if Sprite Prefix is "Sprite", and there is a tag "Run", and there are three frames within that tag,
-- you will get three files:
--	"Sprite_Run_0.png"
--	"Sprite_Run_1.png"
--	"Sprite_Run_2.png"

-- Get current sprite
local sprite = app.activeSprite

-- Returns the Path, Filename, and Extension as 3 values
local function SplitFilename(strFilename)
	return string.match(strFilename, "(.-)([^\\]-([^\\%.]+))$")
end

-- Alert if no sprite loaded
if not sprite then
	app.alert("No sprite to export!")
end

-- Get name
local sprite_name = "output"
if sprite.filename then sprite_name = app.fs.fileTitle(sprite.filename) end

-- Start dialog
local dialog = Dialog("Export All Frames")
	:file{
		id = "dir",
		label = "Select Directory",
		title = "Sprite Prefix",
		open = false,
		save = true,
		filename = "directory"
	}
	:entry{
		id = "name",
		label = "Sprite Prefix",
		text = sprite_name,
		focus = true
	}
	:button{
		id = "ok",
		text = "&Export"
	}
	:button{
		text = "&Cancel"
	}
	:show()

-- Check dialog data
local data = dialog.data
if not data.ok then
	return
end

-- Get path, file, and extension
path, file, extension = SplitFilename(data.dir)

-- Save all frames
for i, tag in ipairs(sprite.tags) do
	for j = 0, tag.frames-1 do
		local img = Image(sprite.width, sprite.height)
		img:drawSprite(sprite, tag.fromFrame.frameNumber + j, Point(0, 0))
		img:saveAs(path .. data.name .. "" .. tag.name .. "" .. j+1 .. ".png")
	end
end

-- Refresh app
app.refresh()