if not OreMerchant then OreMerchant = {} end
if not OreMerchant.exchanges then OreMerchant.exchanges = {} end
if not OreMerchant.recipes then OreMerchant.recipes = {} end

-- @ value: Nummber
local function Ratio(value)
  local str_value = tostring(value)
  local coins = 1000
  while(str_value:sub(#str_value,#str_value) == "0" and coins > 1) do
    value = value / 10
    coins = coins / 10
    str_value = tostring(value)
  end
  return {
      amount = coins,
      coin = value
    }
end

-- @ type: String
-- return: String
local function GetCategoryFromtype(type)
  if type == "item" then return "crafting" end
  if type == "fluid" then return "crafting-with-fluid" end
  return nil
end

-- @ exchange: {resource: String, type: String}
local function GetItemOrder(exchange)
  if exchange.type == "fluid" then
    return data.raw.fluid[exchange.resource].order
  else
    if data.raw.item[exchange.resource] ~= nil then
      return data.raw.item[exchange.resource].order
    elseif data.raw.recipe[exchange.resource] ~= nil then
      return data.raw.recipe[exchange.resource].order
    else
      return data.raw.technology[exchange.resource].order
    end
  end
end

-- @ resource: String
-- return: Bool
local function IsDefaultEnabled(resource)
  if data.raw.recipe[resource] ~= nil then
    -- type Recipe exist 
    if data.raw.recipe[resource].enabled ~= nil then
      -- return its value
      return data.raw.recipe[resource].enabled
    elseif data.raw.recipe[resource].normal ~= nil then
      -- return its normald/difficult value
      return data.raw.recipe[resource].normal.enabled
    else
      -- return default value
      return true
    end
  elseif data.raw.resource[resource] ~= nil then
    -- type Resource exist
    if data.raw.resource[resource].autoplace ~= nil then
      -- is autoplaceable
      if data.raw.resource[resource].autoplace.default_enabled then
        -- return its value
        return data.raw.resource[resource].autoplace.default_enabled
      else
        -- default value
        return true
      end
    else
      -- not autoplaceable, autoplace = nil by default
      log("Error not autoplaceable resource " .. resource)
      return true
    end
  else
    -- not recipe nor resource exist???
    log("Error with recipe " .. resource)
    return true
  end
end

-- @ exchange: {resource: String, type: String}
-- return: LocalisedString
local function GetLocalisedName(exchange)
  if exchange.type == "fluid" then
    return {"fluid-name." .. exchange.resource}
  else
    return {"item-name." .. exchange.resource}
  end
end

-- @ item: String
local function GetItemIcon(name)
  local item = {
    icon = "__ore-merchant__/graphics/blank.png",
    icon_size = 64
  }

  if data.raw.item[name]  ~= nil then item = table.deepcopy(data.raw.item[name])  end
  if data.raw.fluid[name] ~= nil then item = table.deepcopy(data.raw.fluid[name]) end
  if data.raw.tool[name]  ~= nil then item = table.deepcopy(data.raw.tool[name])  end

  if item.icon ~= nil and item.icon_size ~= nil then
    return {
      icon = item.icon,
      icon_size = item.icon_size,
      icon_mipmaps = item.icon_mipmaps or 1,
      scale = item.scale or 1
    }
  end
  if item.icons ~= nil then 
    return {
      icon = item.icons[1].icon,
      icon_size = item.icons[1].icon_size,
      icon_mipmaps = item.icons[1].icon_mipmaps or 1,
      scale = item.icons[1].scale or 1
    }
  end
  if item.pictures ~= nil then 
    return  {
      icon = item.pictures[1].filename,
      icon_size = item.pictures[1].size,
      icon_mipmaps = item.pictures[1].mipmap_count,
      scale = item.pictures[1].scale or 1
    }
  end
end

-- @ exchange: {resource: String, value: Number, type: String, subgroup: String}
-- return: Prototype<Recipe>
local function ResourceToCoin(exchange)
  local itemIcon = GetItemIcon(exchange.resource)
  return {
    type = "recipe",
    name = exchange.resource .. "-for-coin",
    order = GetItemOrder(exchange),
    subgroup = "m-" .. exchange.subgroup,
    category = GetCategoryFromtype(exchange.type),
    localised_name = "Coin",
    --localised_name = {"recipe-name.res-to-coin", GetLocalisedName(exchange)},
    allow_as_intermediate = false,
    energy_required = 1.5,
    enabled = exchange.enabled,
    ingredients =
    {
      { 
        type = exchange.type,
        name = exchange.resource,
        amount = Ratio(exchange.value).amount
      },
    },
    results =
    {
      { 
        type = "item",
        name = "coin",
        amount = Ratio(exchange.value).coin
      }
    },
    icons = {
      -- coin
      {
        icon = "__base__/graphics/icons/coin.png",
        icon_size = 64,
        icon_mipmaps = 4
      },
      -- item
      {
        icon = itemIcon.icon,
        icon_size = itemIcon.icon_size,
        scale = itemIcon.scale * 0.25,
        icon_mipmaps = itemIcon.icon_mipmaps,
        shift = {-8, 8},
      },
    }
  }
end

-- @ exchange: {resource: String, value: Number, type: String, subgroup: String}
-- return: Prototype<Recipe>
local function CoinToResource(exchange)
  return {
    type = "recipe",
    name = "coin-for-" .. exchange.resource,
    order = GetItemOrder(exchange),
    subgroup = "m-coin-" .. exchange.subgroup,
    category = GetCategoryFromtype(exchange.type),
    localised_name = GetLocalisedName(exchange),
    --localised_name = {"recipe-name.coin-to-res", GetLocalisedName(exchange)},
    allow_as_intermediate = true,
    energy_required = 1.5,
    enabled = exchange.enabled,
    ingredients =
    {
      { 
        type = "item",
        name = "coin",
        amount = Ratio(exchange.value).coin
      } 
    },
    results =
    {
      { 
        type = exchange.type,
        name = exchange.resource,
        amount = Ratio(exchange.value).amount
      }
    }
  }
end

-- @ newEchange: {resource: String}
local function AddExchange(newExchange)
  if newExchange.resource ~= nil then
    for _, exchange in pairs(OreMerchant.exchanges) do
      if exchange.resource == newExchange.resource then
        return false
      end
    end
    newExchange.enabled = IsDefaultEnabled(newExchange.resource)
    table.insert(OreMerchant.exchanges, newExchange)
    return true
  else
    log("Error with exchange " .. newExchange.resource)
    return false
  end
end

-- @ newEchange: {resource: String, value: Number, type: String}
local function CreateRecipe(newExchange)
  if newExchange.resource ~= nil then
    if newExchange.type == nil then
      newExchange.type = "fluid"
    end
    if newExchange.value == nil then
      newExchange.value = 10
    end
    if newExchange.enabled == nil then
      newExchange.enabled = IsDefaultEnabled(newExchange.resource)
    end
    table.insert(OreMerchant.recipes, ResourceToCoin(newExchange))
    table.insert(OreMerchant.recipes, CoinToResource(newExchange))
  else
    log("Error with exchange " .. newExchange.resource)
    return nil
  end
end 

OreMerchant.AddExchange = AddExchange
OreMerchant.CreateRecipe = CreateRecipe