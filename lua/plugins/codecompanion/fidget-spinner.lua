local M = {
	completed = "󰗡 Completed",
	error = " Error",
	cancelled = "󰜺 Cancelled",
}

local function format_adapter(adapter)
	local parts = {}
	table.insert(parts, adapter.formatted_name)
	if adapter.model and adapter.model ~= "" then
		table.insert(parts, "(" .. adapter.model .. ")")
	end
	return table.concat(parts, " ")
end

function M.setup()
	local ok, progress = pcall(require, "fidget.progress")
	if not ok then
		return
	end

	M.handles = {}

	local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

	vim.api.nvim_create_autocmd("User", {
		pattern = "CodeCompanionRequestStarted",
		group = group,
		callback = function(args)
			local handle = progress.handle.create({
				title = "",
				message = "  Sending...",
				lsp_client = {
					name = format_adapter(args.data.adapter),
				},
			})
			M.handles[args.data.id] = handle
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "CodeCompanionRequestFinished",
		group = group,
		callback = function(args)
			local handle = M.handles[args.data.id]
			M.handles[args.data.id] = nil
			if handle then
				if args.data.status == "success" then
					handle.message = M.completed
				elseif args.data.status == "error" then
					handle.message = M.error
				else
					handle.message = M.cancelled
				end
				handle:finish()
			end
		end,
	})
end

return M
