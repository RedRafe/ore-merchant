if not OreMerchant then OreMerchant = {} end
if not OreMerchant.exchanges then OreMerchant.exchanges = {} end

-- @ exchange: {resource: string, technology: string}
local function CustomUnlockEffect(exchange)
  local rtc = exchange.resource .. "-for-coin"
  local ctr = "coin-for-" .. exchange.resource

  table.insert(data.raw.technology[exchange.technology].effects, { type  = "unlock-recipe", recipe = rtc })
  table.insert(data.raw.technology[exchange.technology].effects, { type  = "unlock-recipe", recipe = ctr })
  
  exchange.enabled = false
end

-- @ exchange: {resource: string
local function DefaultUnlockEffect(exchange)
  local effect_added = false
  -- if enabled, find tech that unlocks it
  if exchange.enabled == false then
    for _, tech in pairs(data.raw.technology) do
      if tech.effects ~= nil then
        for _, effect in pairs(tech.effects) do
          if effect.recipe == exchange.resource then
            table.insert(data.raw.technology[tech.name].effects, { type = "unlock-recipe", recipe = exchange.resource .. "-for-coin" })
            table.insert(data.raw.technology[tech.name].effects, { type = "unlock-recipe", recipe = "coin-for-" .. exchange.resource })
            effect_added = true         
          end
        end
      end
    end
  end

  -- if no tech is found, set it to enable
  if effect_added == false then
    log("Forcing enable for resource " .. exchange.resource)
    exchange.enabled = true
  end
end

-- @ exchange: {resource: string, enabled: bool}
local function SetUnlockEffect(exchange)
  if exchange.enabled == nil then return false end

  if exchange.technology then
    CustomUnlockEffect(exchange)
  else
    DefaultUnlockEffect(exchange)
  end
end

OreMerchant.SetUnlockEffect = SetUnlockEffect