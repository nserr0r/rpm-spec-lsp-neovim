local M = {}

local server_name = "rpm-spec-lsp-neovim"
local cmd = "/usr/bin/rpm-spec-lsp"

local ok_configs, configs = pcall(require, "lspconfig.configs")
if not ok_configs then
	vim.notify("lspconfig.configs недоступен", vim.log.levels.ERROR)
	return M
end

if vim.fn.executable(cmd) == 0 then
	vim.notify(string.format("rpm-spec-lsp не найден: %s", cmd), vim.log.levels.WARN)
	return M
end

if not configs[server_name] then
	configs[server_name] = {
		default_config = {
			cmd = { cmd },
			filetypes = { "spec" },
			root_dir = require("lspconfig.util").root_pattern(".git", "SPECS"),
			single_file_support = true,
			settings = { rpm_spec = { max_line_length = 120 } },
			on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rp", function()
					vim.lsp.buf.execute_command({ command = "rpm-spec.changeProfile" })
				end, { desc = "Сменить профиль SPEC LSP" })
				if client.supports_method("textDocument/formatting") then
					local group = vim.api.nvim_create_augroup("RpmSpecFormat", { clear = false })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = group,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
			flags = { debounce_text_changes = 150 },
		},
	}
end

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "spec",
		once = true,
		callback = function()
			require("lspconfig")[server_name].setup({})
		end,
	})
end

return M
