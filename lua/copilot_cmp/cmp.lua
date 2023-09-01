local source = require("copilot_cmp.source")
local capabilities = require("copilot_cmp.capabilities")

---Registered client and source mapping.
local copilot_cmp = {
  client_source_map = {},
  registered = false,
  default_capabilities = capabilities.default_capabilities,
  update_capabilities = capabilities.update_capabilities,
}

local default_opts = {
  event = { "InsertEnter", "LspAttach" },
  fix_pairs = true,
}

copilot_cmp._on_insert_enter = function(opts)
  local find_buf_client = function()
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.name == "copilot" then return client end
    end
  end

  local cmp = require("cmp")
  local copilot = find_buf_client()
  print('copilot')
  if not copilot or copilot_cmp.client_source_map[copilot.id] then return end

  local s = source.new(copilot, opts)
  if s:is_available() then
    copilot_cmp.client_source_map[copilot.id] = cmp.register_source("copilot", s)
    print('copilot registered')
  end

end

copilot_cmp.register = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  -- just in case someone decides to set event to nil for some reason
  local startEvent = opts.event or { "InsertEnter", "LspAttach" }

  print('setup')
  vim.api.nvim_create_autocmd(startEvent, {
    callback = function ()
      copilot_cmp._on_insert_enter(opts)
    end
  })
end

print('copilot_cmp')
return copilot_cmp
