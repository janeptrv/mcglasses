--[[
  written by jane petrovna
  01/09/21
]]
local component = require("component")
local util = dofile("/var/janeptrv/mcglasses/src/util.lua")
local config = util.get("driver/config")

local glasses = {}
glasses.widgets = {}

local max_log_lines = tonumber(config.get_value("glasses_log_lines", "5"))
local render_resolution = tonumber(config.get_value("glasses_resolution", "500"))
local log_pos = config.get_value("glasses_log_pos", "upper_right")
local current_log = {}

local function __init()
  local all_glasses = component.list("glasses")
  local next, table = pairs(all_glasses)
  local key, _ = next(table)
  glasses.bound_glasses = component.proxy(key)

  -- set up glasses
  glasses.bound_glasses.setRenderResolution("", render_resolution, render_resolution)
  glasses.bound_glasses.setRenderPosition("relative")
  glasses.bound_glasses.removeAll()
end

local log_positions = {
  upper_right = {
    x = 90,
    y = 5
  },
  upper_left = {
    x = 5,
    y = 5
  },
  lower_right = {
    x = 90,
    y = 90
  },
  lower_left = {
    x = 5,
    y = 90
  }
}

glasses.draw = function(x, y, text, bg, fg)
  local length = string.len(text)
end


local current_log_size = 0

local function __update_log()
  local x = log_positions[log_pos].x
  local y = log_positions[log_pos].y
  if not glasses.widgets["log_box"] then
    glasses.widgets["log_box"] = glasses.bound_glasses.addBox2D()
    glasses.widgets["log_box"].addAutoTranslation(x, y)
    glasses.widgets["log_box"].setSize(30, max_log_lines)
  end
  if not glasses.widgets["log_text"] then
    glasses.widgets["log_text"] = glasses.bound_glasses.addText2D()
    glasses.widgets["log_text"].addAutoTranslation(x, y)
  end
  local final_text = ""
  for i = 1, current_log_size do
    final_text = final_text .. current_log[i] .. "\n"
  end
  glasses.widgets["log_text"].setText(final_text)
end

glasses.log = function(msg)
  local idx = current_log_size
  if idx + 1 > max_log_lines then
    for i = 1, current_log_size - 1 do
      current_log[i] = current_log[i + 1]
    end
  else
    current_log_size = current_log_size + 1
  end
    current_log[current_log_size] = msg
  __update_log()
end

__init()
return glasses
