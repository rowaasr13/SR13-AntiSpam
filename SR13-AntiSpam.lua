local a_name, a_env = ...
if not a_env.load_this then return end

local smatch = string.match

local known_spammers = {}

local dawn        = '[Dd]%s*[Aa]%s*[Ww]%s*[Nn]'
local icecrown    = '[Ii]%s*[Cc]%s*[Ee]%s*[Cc]%s*[Rr]%s*[Oo]%s*[Ww]%s*[Nn]'
local nova        = '[Nn]%s*[Oo]%s*[Vv]%s*[Aa]'
local oblivion    = '[Oo]%s*[Bb]%s*[Ll]%s*[Ii]%s*[Vv]%s*[Ii]%s*[Oo]%s*[Nn]'
local paradise    = '[Pp]%s*[Aa]%s*[Rr]%s*[Aa]%s*[Dd]%s*[Ii]%s*[Ss]%s*[Ee]'
local sylvanas    = '[Ss]%s*[Yy]%s*[Ll]%s*[Vv]%s*[Aa]%s*[Nn]%s*[Aa]%s*[Ss]'
local wtcb        = '[Ww]%s*[Tt]%s*[Cc]%s*[Bb]'

local armor_stack = '[Aa]%s*[Rr]%s*[Mm]%s*[Oo]%s*[Uu]?%s*[Rr]%s*[Ss]%s*[Tt]%s*[Aa]%s*[Cc]%s*[Kk]' -- optional U
local boost       = '[Bb]%s*[Oo]%s*[Oo]%s*[Ss]%s*[Tt]'
local cheap       = '[Cc]%s*[Hh]%s*[Ee]%s*[Aa]%s*[Pp]'
local curve       = '[Cc]%s*[Uu]%s*[Rr]%s*[Vv]%s*[Ee]'
local discount    = '[Dd]%s*[Ii]%s*[Ss]%s*[Cc]%s*[Oo]%s*[Uu]%s*[Nn]%s*[Tt]'
local fast        = '[Ff]%s*[Aa]%s*[Ss]%s*[Tt]'
local gold        = '[Gg]%s*[Oo]%s*[Ll]%s*[Dd]'
local intime      = '[Ii]%s*[Nn]%s*[Tt]%s*[Ii]%s*[Mm]%s*[Ee]'
local nathria     = '[Nn]%s*[Aa]%s*[Tt]%s*[Hh]%s*[Rr]%s*[Ii]%s*[AaUu]' -- also covers "nathriU" in "Denathrius"
local offer       = '[Oo]%s*[Ff]%s*[Ff]%s*[Ee]?%s*[Rr]' -- optional E
local price       = '[Pp]%s*[Rr]%s*[Ii]%s*[Cc]%s*[Ee]'
local selling     = '[Ss]%s*[Ee]%s*[Ll]%s*[Ll]%s*[Ii]%s*[Nn]%s*[Gg]'
local torghast    = '[Tt]%s*[Oo]%s*[Rr]%s*[Gg]%s*[Hh]%s*[Aa]%s*[Ss]%s*[Tt]'
local vault       = '[Vv]%s*[Aa]%s*[Uu]%s*[Ll]%s*[Tt]'
local weekly      = '[Ww]%s*[Ee]%s*[Ee]%s*[Kk]%s*[Ll]%s*[Yy]'
local whisper     = '[Ww]%s*[Hh]%s*[Ii]%s*[Ss]%s*[Pp]%s*[Ee]%s*[Rr]'
local wts         = '[Ww]%s*[Tt]%s*[Ss]'

local ach_14460   = '|Hachievement:14460'
local jou_1190    = '|Hjournal:%d+:1190:'
local m_plus      = '[Mm]%s*%+%s*%d+'
local thousands   = '%d+[Kk]'

local function concat_pattern_any(tbl)
   return table.concat(tbl, '.-')
end

local patterns_boost = {
   concat_pattern_any{boost, selling, price},
   concat_pattern_any{dawn, offer, thousands, ach_14460},
   concat_pattern_any{discount, sylvanas, m_plus, thousands},
   concat_pattern_any{gold, wts, torghast, boost},
   concat_pattern_any{icecrown, m_plus, thousands, jou_1190},
   concat_pattern_any{icecrown, selling, ach_14460, gold},
   concat_pattern_any{icecrown, selling, nathria, thousands, curve},
   concat_pattern_any{nova, intime, thousands},
   concat_pattern_any{nova, offer, armor_stack, thousands},
   concat_pattern_any{nova, offer, thousands, armor_stack},
   concat_pattern_any{nova, offer, thousands}, -- should only be applied after clearing links
   concat_pattern_any{nova, thousands, "Get", vault},
   concat_pattern_any{nova, thousands, armor_stack},
   concat_pattern_any{nova, thousands, nathria},
   concat_pattern_any{oblivion, selling, nathria},
   concat_pattern_any{oblivion, thousands, armor_stack},
   concat_pattern_any{offer, armor_stack, thousands},
   concat_pattern_any{paradise, offer, torghast, gold},
   concat_pattern_any{sylvanas, armor_stack, thousands, intime},
   concat_pattern_any{sylvanas, intime, armor_stack},
   concat_pattern_any{sylvanas, intime, thousands, jou_1190},
   concat_pattern_any{sylvanas, selling, nathria, thousands},
   concat_pattern_any{sylvanas, selling, thousands, jou_1190},
   concat_pattern_any{sylvanas, thousands, armor_stack},
   concat_pattern_any{sylvanas, thousands, intime},
   concat_pattern_any{sylvanas, thousands, jou_1190},
   concat_pattern_any{sylvanas, wts, jou_1190},
   concat_pattern_any{wtcb, wts, ach_14460, thousands},
   concat_pattern_any{wtcb, wts, thousands, gold},
   concat_pattern_any{wts, ach_14460, gold},
   concat_pattern_any{wts, armor_stack, fast, price},
   concat_pattern_any{wts, boost, intime, price},
   concat_pattern_any{wts, boost, torghast, cheap, gold},
   concat_pattern_any{wts, boost, torghast, price},
   concat_pattern_any{wts, intime, sylvanas},
   concat_pattern_any{wts, jou_1190, thousands},
   concat_pattern_any{wts, jou_1190, torghast},
   concat_pattern_any{wts, nova, jou_1190},
   concat_pattern_any{wts, price, torghast, jou_1190},
   concat_pattern_any{wts, torghast, boost},
   concat_pattern_any{wts, torghast, offer},
   concat_pattern_any{wts, weekly, vault, whisper},
}
-- _G.patterns_boost = patterns_boost

local function chat_filter(self, event, msg, author, ...)
   local known = known_spammers[author] or 0

   if known > 5 then
      -- print("known", msg)
      return true
   end

   for idx = 1, #patterns_boost do
      local pattern = patterns_boost[idx]
      if smatch(msg, pattern) then
         -- print("spam", msg)
         known_spammers[author] = known + 1
         return true
      end
   end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chat_filter)
