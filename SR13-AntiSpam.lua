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

   local profile_f
   local res_f = (function() local pattren_loop_start = debugprofilestop()
   local pattren_loop_end
   for idx = 1, #patterns_boost do
      local pattern = patterns_boost[idx]
      if strfind(msg, pattern) then
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
         pattren_loop_end = debugprofilestop()
         profile_f = pattren_loop_end - pattren_loop_start
         return prev_result
      end
   end
   pattren_loop_end = debugprofilestop()
   profile_f = pattren_loop_end - pattren_loop_start
   end)()

   local profile_t
   local res_t = (function() local pattren_loop_start = debugprofilestop()
   local pattren_loop_end

   local res = is_imptree_boost(msg)
   pattren_loop_end = debugprofilestop()
   profile_t = pattren_loop_end - pattren_loop_start
   return res

   end)()

   if a_env.is_devel then
      local profile = SVPC_SR13_AnitSpam_profile
      if not profile then profile = {} SVPC_SR13_AnitSpam_profile = profile end
      profile[#profile + 1] = { res_f = res_f, profile_f = profile_f, res_t = res_t, profile_t = profile_t }
      print(
         "f:" .. (res_f and "O" or "x") .. " " .. profile_f .. "ms " ..
         "t:" .. (res_t and "O" or "x") .. " " .. profile_t .. "ms ",
         ((not not res_t) ~= (not not res_f) and msg or '')
      )
   end

   return res_f
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", msg_channel_filter)
