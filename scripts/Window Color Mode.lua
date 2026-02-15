-------------------------------
-- WINDOW DARK MODE IN LUA
-- CUSTOM COLORS EXTENSION
-------------------------------

-- Credits:
-- Script and code made by T-Bar: https://www.youtube.com/@tbar7460

local ffi = require("ffi")
local dwmapi = ffi.load("dwmapi")

ffi.cdef[[
    typedef void* HWND;
    typedef unsigned long DWORD;
    typedef const void *LPCVOID;
    typedef long HRESULT;

    HWND GetActiveWindow();
    HRESULT DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
    void UpdateWindow(HWND hWnd);
]]

-- Constants
local S_OK = 0x00000000
local DWMWA_COLOR_NONE = 0xFFFFFFFE
local DWMWA_COLOR_DEFAULT = 0xFFFFFFFF

local windowCornerType = { DEFAULT = 0, DONOTROUND = 1, ROUND = 2, ROUNDSMALL = 3 }

-- Convert hex RGB to BGR format
local function rgbToBGR(rgb)
    if type(rgb) == "number" then rgb = string.format("%06X", rgb) end
    if type(rgb) ~= "string" then return rgb end
    rgb = rgb:gsub("^0x", ""):gsub("^#", ""):sub(1,6)
    return rgb:sub(5,6) .. rgb:sub(3,4) .. rgb:sub(1,2)
end

-- Internal helper: returns ffi int pointer
local function intPtr(value)
    return ffi.new("int[1]", value)
end

-- Generic function to set a DWM window attribute
local function setDWMAttribute(attr, value)
    local hwnd = ffi.C.GetActiveWindow()
    local res = dwmapi.DwmSetWindowAttribute(hwnd, attr, intPtr(value), ffi.sizeof("DWORD"))
    ffi.C.UpdateWindow(hwnd)
    return res
end

-- Dark/light mode functions
local function setWindowColorMode(isDark)
    local value = isDark and 1 or 0
    local res = setDWMAttribute(19, value)
    if res ~= S_OK then setDWMAttribute(20, value) end
end

local setDarkMode = function() setWindowColorMode(true) end
local setLightMode = function() setWindowColorMode(false) end

-- Window border and title color
local function setWindowBorderColor(colorHex, setHeader, setBorder)
    setHeader = setHeader ~= false
    setBorder = setBorder ~= false
    local hex = tonumber("0x" .. rgbToBGR(colorHex or "FFFFFF"))
    if setHeader then setDWMAttribute(35, hex) end
    if setBorder then setDWMAttribute(34, hex) end
end

local function setWindowTitleColor(colorHex)
    local hex = tonumber("0x" .. rgbToBGR(colorHex or "FFFFFF"))
    setDWMAttribute(36, hex)
end

-- Window corner type
local function setWindowCornerType(corner)
    setDWMAttribute(33, corner or windowCornerType.DEFAULT)
end

-- Redraw window (for Windows 10 only)
local function redrawWindowHeader()
    local stage = getPropertyFromClass('flixel.FlxG', 'stage')
    stage.window.borderless = not stage.window.borderless
    stage.window.borderless = not stage.window.borderless
end

-- Lifecycle hooks
function onCreatePost()
    setWindowColorMode(true)
    if string.find(string.lower(getPropertyFromClass("lime.system.System", "platformLabel")), "windows 10") then
        redrawWindowHeader()
    end
end

function onDestroy()
    setWindowColorMode(false)
    if string.find(string.lower(getPropertyFromClass("lime.system.System", "platformLabel")), "windows 10") then
        redrawWindowHeader()
    end
end
