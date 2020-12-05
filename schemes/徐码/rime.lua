-- rime.lua

helper = require("ace/helper")

single_char_only = require("ace/single_char_only")

local os_tools = require("ace/os_tools")
lazy_clock = os_tools.lazy_clock_filter
preedit_lazy_clock = os_tools.preedit_lazy_clock_filter
os_env = os_tools.os_env_translator

xuma_spelling = require("ace/xuma_spelling")

xuma_postpone_fullcode = require("ace/xuma_postpone_fullcode")

xuma_52p_precand = require("ace/xuma_52p_precand")
