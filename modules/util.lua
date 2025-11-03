local M = {}
function M.clamp(v,a,b) return math.max(a, math.min(b, v)) end
return M