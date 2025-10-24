local M = {}

local server_name = "rpm_spec_lsp"
local cmd = "/usr/bin/rpm-spec-lsp"

function M.setup()
	if vim.fn.executable(cmd) == 0 then
		vim.notify(("rpm-spec-lsp не найден: %s"):format(cmd), vim.log.levels.WARN)
		return
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "spec",
		callback = function(args)
			vim.bo[args.buf].commentstring = "%dnl %s"
		end,
	})

	vim.lsp.config(server_name, {
		cmd = { cmd },
		filetypes = { "spec" },
		root_markers = { ".git", "SPECS" },
		single_file_support = true,
		settings = {
			rpm_spec = {
				max_line_length = 120,
			},
		},
		on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

			vim.keymap.set("n", "<leader>rp", function()
				vim.lsp.buf.execute_command({
					command = "changeProfile",
				})
			end, { buffer = bufnr, silent = true, desc = "Сменить профиль SPEC LSP" })

			if client:supports_method("textDocument/formatting") then
				local group = vim.api.nvim_create_augroup("RpmSpecFormat", { clear = false })

				vim.api.nvim_clear_autocmds({
					group = group,
					buffer = bufnr,
				})

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = group,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr, async = false })
					end,
				})
			end
		end,
		flags = {
			debounce_text_changes = 150,
		},
	})

	vim.lsp.enable(server_name)
end

return M
