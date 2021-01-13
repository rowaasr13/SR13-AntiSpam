local a_name, a_env = ...
if not a_env.load_this then return end

local sv = "SVPC_SR13_AnitSpam_dump"

function cf1dump(frame)
   if not frame then frame = ChatFrame1 end
   local dump = {}
   for idx = #frame.visibleLines, 1, -1 do
      local entry = frame.visibleLines[idx]
      dump[idx] = entry.messageInfo.message
   end
   _G[sv] = dump
end
