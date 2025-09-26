local M = {}
local wezterm = require("wezterm")

function M.table_extend(primary_table, ...)
    for _, current_table in ipairs({ ... }) do
        for _, iterm in ipairs(current_table) do
            table.insert(primary_table, iterm)
        end
    end
    return primary_table
end

function M.deep_copy(obj)
    if type(obj) ~= "table" then
        return obj
    end
    local new_table = {}
    for k, v in pairs(obj) do
        new_table[M.deep_copy(k)] = M.deep_copy(v)
    end
    return new_table
end

return M
