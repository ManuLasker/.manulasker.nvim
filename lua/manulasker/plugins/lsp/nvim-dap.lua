return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio", -- required by dap-ui
    },
    keys = {
        { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
        { "<leader>Dc", function() require("dap").continue() end,          desc = "DAP: Continue" },
        { "<leader>Di", function() require("dap").step_into() end,         desc = "DAP: Step into" },
        { "<leader>Do", function() require("dap").step_over() end,         desc = "DAP: Step over" },
        { "<leader>DO", function() require("dap").step_out() end,          desc = "DAP: Step out" },
        { "<leader>Dr", function() require("dap").repl.open() end,         desc = "DAP: Open REPL" },
        { "<leader>Du", function() require("dapui").toggle() end,          desc = "DAP: Toggle UI" },
        { "<leader>Dt", function() require("dap").terminate() end,         desc = "DAP: Terminate" },
    },
    config = function()
        local dap    = require("dap")
        local dapui  = require("dapui")

        -- ── DAP UI setup ─────────────────────────────────
        dapui.setup()

        -- Auto open/close UI when debugging starts/ends
        dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

        -- ── Signs ─────────────────────────────────────────
        vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint",         linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped",             linehl = "DapStopped", numhl = "" })
    end,
}
