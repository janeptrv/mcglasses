--[[
  written by jane petrovna
  01/08/21
]]
local filesystem = require("filesystem")
local util

local CONFIG_LOCATION = "/etc/mcg.conf"

if os.getenv("MCG_CONFIG") ~= nil then
  CONFIG_LOCATION = os.getenv("MCG_CONFIG")
end

local config_values = {}

local config = {}

local function __get_line_value(line)
  local sep = string.find(line, "=")
  if sep ~= nil then
    return string.sub(line, 1, sep - 1), string.sub(line, sep + 1, string.len(line))
  end
  return nil, nil
end

local function __save_config_values()
  local file = io.open(CONFIG_LOCATION, "w")
  for key, value in pairs(config_values) do
    file:write(key .. "=" .. value .. "\n")
  end
  file:close()
end

local function __parse_config_values()
  if not filesystem.exists(CONFIG_LOCATION) then
    __save_config_values()
  end
  local file = io.open(CONFIG_LOCATION, "r")
  if file == nil then
    return
  end

  local line = ""
  repeat
    line = file:read("*l")
    if line ~= nil then
      local key, value = __get_line_value(line)
      config_values[key] = value
    end
  until line == nil
  file:close()
end

config.get_value = function(key, default)
  if config_values[key] then
    return config_values[key]
  else
    config_values[key] = default
    __save_config_values()
    return default
  end
end

__parse_config_values()

config.__init = function(iutil)
  util = iutil
end
return config
