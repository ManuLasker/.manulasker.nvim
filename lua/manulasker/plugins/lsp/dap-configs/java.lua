local M = {}

function M.setup()
    local dap = require("dap")

    dap.configurations.java = dap.configurations.java or {}

    vim.list_extend(dap.configurations.java, {
        {
            type      = "java",
            request   = "attach",
            name      = "Gradle - Attach debugger",
            hostName  = "localhost",
            port      = 5005,
        }
    })
end

return M
