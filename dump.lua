local a_name, a_env = ...
if not a_env.load_this then return end

local sv = "SVPC_SR13_AnitSpam_dump"

local function ChatFrameDump(frame)
   if frame then
   else
      if not ChatFrame1 then
         _G[sv] = "ChatFrame1 not found. It is likely that you use custom chat UI addon. Please send addon's name if you want it added to reporting tool."
         return
      end
      frame = ChatFrame1
   end

   if not frame.visibleLines then
      local frame_name = frame.GetName and frame:GetName() or ':GetName() absent'
      _G[sv] = ("No .visibleLines data on frame %q. It is likely that you use custom chat UI addon or mistyped frame name. Please send addon's name if you want it added to reporting tool."):format(frame_name)
      return
   end

   local dump = {}
   for idx = #frame.visibleLines, 1, -1 do
      local entry = frame.visibleLines[idx]
      if entry.messageInfo and entry.messageInfo.message then
         dump[idx] = entry.messageInfo.message
      end
   end
   _G[sv] = dump
end
a_env.export.ChatFrameDump = ChatFrameDump

if a_env.is_devel then
   _G.cf1dump = ChatFrameDump
end
