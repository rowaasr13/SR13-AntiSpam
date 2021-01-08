local a_name, a_env = ...
if not a_env.load_this then return end

local strmatch = string.match
local strgsub  = string.gsub

local known_spammers = {}

local patterns_boost = a_env.patterns_boost
local cleanup_pattern = a_env.cleanup_pattern
local cleanup_replace = a_env.cleanup_replace

local function msg_channel_filter(self, event, msg, author, _, _, _, specialFlag, zoneChannelID)
   if not zoneChannelID then return end
   if specialFlag == "GM" or specialFlag == "DEV" then return end

   local known = known_spammers[author] or 0

   if known > 5 then
      -- print("known", msg)
      return true
   end

   msg = strgsub(msg, cleanup_pattern, cleanup_replace)
   for idx = 1, #patterns_boost do
      local pattern = patterns_boost[idx]
      if strmatch(msg, pattern) then
         -- print("spam", msg)
         known_spammers[author] = known + 1
         return true
      end
   end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", msg_channel_filter)
