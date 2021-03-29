local a_name, a_env = ...
if not a_env.load_this then return end

local a_basename = a_env.basename
if not _G[a_basename] then _G[a_basename] = {} end
local options = _G[a_basename]
a_env.export = options

local strgsub   = string.gsub
local strfind   = string.find
local guid_self = UnitGUID("player")
local debugprofilestop = debugprofilestop

local known_spammers = {}

local patterns_boost = a_env.patterns_boost
local cleanup_pattern = a_env.cleanup_pattern
local cleanup_replace = a_env.cleanup_replace
local is_imptree_boost = a_env.is_imptree_boost

local prev_lineID, prev_result
local function msg_channel_filter(self, event, msg, author, _, _, _, specialFlag, zoneChannelID, _, _, _, lineID, guid)
   if not zoneChannelID then return end

   -- For some reason chat system calls filter several times on each line
   -- Don't bother reprocessing it and just return same result
   if lineID == prev_lineID then return prev_result end
   prev_lineID = lineID
   prev_result = nil

   if specialFlag == "GM" or specialFlag == "DEV" then return end
   if guid == guid_self then return end

   -- All checks above are trivial, withou side-effects and return nil,
   -- everything below this line MUST update prev_result.

   local known = known_spammers[author] or 0
   if known > 5 then
      -- print("known", msg)
      prev_result = true
      return prev_result
   end

   msg = strgsub(msg, cleanup_pattern, cleanup_replace)

   local res
   do
      res = is_imptree_boost(msg)
   end

   if res then
      local highlight_spam = options.highlight_spam
      if highlight_spam then
         if highlight_spam == "author" then
            print("spam", BLUE_FONT_COLOR:GenerateHexColorMarkup() .. msg, author)
         else
            print("spam", BLUE_FONT_COLOR:GenerateHexColorMarkup() .. msg)
         end
      end
      known_spammers[author] = known + 1
      prev_result = true
      return prev_result
   end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", msg_channel_filter)
