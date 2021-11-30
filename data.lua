---------------------------------------------------------------------------
OreMerchant = {}

require("__ore-merchant__/lib/__init__")
require("__ore-merchant__/prototypes/item-groups")

local raw_resources = {
  { resource = "iron-ore",    value = 100, type = "item" , subgroup = "raw-resource"},
  { resource = "copper-ore",  value = 100, type = "item" , subgroup = "raw-resource"},
  { resource = "uranium-ore", value = 100, type = "item" , subgroup = "raw-resource"},
  { resource = "coal",        value = 100, type = "item" , subgroup = "raw-resource"},
  { resource = "stone",       value = 100, type = "item" , subgroup = "raw-resource"},
  { resource = "crude-oil",   value = 100, type = "fluid", subgroup = "fluid" },
}

local raw_materials = {
  { resource = "iron-plate",   value = 100,   type = "item", subgroup = "raw-material" },
  { resource = "copper-plate", value = 100,   type = "item", subgroup = "raw-material" },
  { resource = "steel-plate",  value = 500,   type = "item", subgroup = "raw-material" },
  { resource = "plastic-bar",  value = 360,   type = "item", subgroup = "raw-material" },
  { resource = "sulfur",       value = 460,   type = "item", subgroup = "raw-material" },
  { resource = "battery",      value = 1160,  type = "item", subgroup = "raw-material" },
  { resource = "explosives",   value = 280,   type = "item", subgroup = "raw-material" },
  { resource = "uranium-235",  value = 10000, type = "item", subgroup = "raw-material", technology = "uranium-processing" },
  { resource = "uranium-238",  value = 1000,  type = "item", subgroup = "raw-material", technology = "uranium-processing" },
}

local fluids = {
  { resource = "petroleum-gas", value = 30, type = "fluid", subgroup = "fluid", technology = "oil-processing" },
  { resource = "heavy-oil",     value = 15, type = "fluid", subgroup = "fluid", technology = "advanced-oil-processing" },
  { resource = "light-oil",     value = 15, type = "fluid", subgroup = "fluid", technology = "advanced-oil-processing" },
  { resource = "lubricant",     value = 20, type = "fluid", subgroup = "fluid", technology = "advanced-oil-processing" },
  { resource = "sulfuric-acid", value = 59, type = "fluid", subgroup = "fluid", technology = "advanced-oil-processing" },
}

local intermediate_products = {
  { resource = "copper-cable",          value = 50,    type = "item", subgroup = "intermediate-product" },
  { resource = "iron-stick",            value = 50,    type = "item", subgroup = "intermediate-product" },
  { resource = "iron-gear-wheel",       value = 200,   type = "item", subgroup = "intermediate-product" },
  { resource = "empty-barrel",          value = 500,   type = "item", subgroup = "intermediate-product" },
  { resource = "electronic-circuit",    value = 250,   type = "item", subgroup = "intermediate-product" },
  { resource = "advanced-circuit",      value = 1420,  type = "item", subgroup = "intermediate-product" },
  { resource = "processing-unit",       value = 8070,  type = "item", subgroup = "intermediate-product" },
  { resource = "engine-unit",           value = 900,   type = "item", subgroup = "intermediate-product" },
  { resource = "electric-engine-unit",  value = 1630,  type = "item", subgroup = "intermediate-product" },
  { resource = "flying-robot-frame",    value = 5200,  type = "item", subgroup = "intermediate-product" },
  { resource = "rocket-control-unit",   value = 16400, type = "item", subgroup = "intermediate-product" },
  { resource = "low-density-structure", value = 4790,  type = "item", subgroup = "intermediate-product" },
  { resource = "rocket-fuel",           value = 2250,  type = "item", subgroup = "intermediate-product" },
  { resource = "solid-fuel",            value = 200,   type = "item", subgroup = "intermediate-product", technology = "advanced-oil-processing" },
  { resource = "nuclear-fuel",          value = 3250,  type = "item", subgroup = "intermediate-product" },
  { resource = "uranium-fuel-cell",     value = 2100,  type = "item", subgroup = "intermediate-product" },
}

local science_packs = {
  { resource = "automation-science-pack", value = 300,   type = "item", subgroup = "science-pack" },
  { resource = "logistic-science-pack",   value = 700,   type = "item", subgroup = "science-pack" },
  { resource = "military-science-pack",   value = 2450,  type = "item", subgroup = "science-pack" },
  { resource = "chemical-science-pack",   value = 3250,  type = "item", subgroup = "science-pack" },
  { resource = "production-science-pack", value = 10700, type = "item", subgroup = "science-pack" },
  { resource = "utility-science-pack",    value = 11900, type = "item", subgroup = "science-pack" },
  { resource = "space-science-pack",      value = 23500, type = "item", subgroup = "science-pack", technology = "space-science-pack" },
}

-- add raw exchange to exchange list
if settings.startup["om-raw-resource"].value then
  for _, value in pairs(raw_resources) do
    OreMerchant.AddExchange(value)
  end
end

if settings.startup["om-raw-material"].value then
  for _, value in pairs(raw_materials) do
    OreMerchant.AddExchange(value)
  end
end

if settings.startup["om-fluid"].value then
  for _, value in pairs(fluids) do
    OreMerchant.AddExchange(value)
  end
end

if settings.startup["om-intermediate-product"].value then
  for _, value in pairs(intermediate_products) do
    OreMerchant.AddExchange(value)
  end
end

if settings.startup["om-science-pack"].value then
  for _, value in pairs(science_packs) do
    OreMerchant.AddExchange(value)
  end
end

-- find unlock effects
for _, value in pairs(OreMerchant.exchanges) do
  OreMerchant.SetUnlockEffect(value)
end

-- create recipes
for _, value in pairs(OreMerchant.exchanges) do
  OreMerchant.CreateRecipe(value)
end

OreMerchant.exchanges = {}

-- extend data
for _, value in pairs(OreMerchant.recipes) do
  data:extend({ value })
end

OreMerchant.recipes = {}
