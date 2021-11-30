---------------------------------------------------------------------------
--                          VANILLA SETTINGS                             --
---------------------------------------------------------------------------
data:extend({
  {
    type          = "bool-setting",
    name          = "om-fluid",
    default_value = true,
    setting_type  = "startup",
    order         = "OM-020"
  },
  {
    type          = "bool-setting",
    name          = "om-raw-resource",
    default_value = true,
    setting_type  = "startup",
    order         = "OM-010"
  },
  {
    type          = "bool-setting",
    name          = "om-raw-material",
    default_value = true,
    setting_type  = "startup",
    order         = "OM-030"
  },
  {
    type          = "bool-setting",
    name          = "om-intermediate-product",
    default_value = true,
    setting_type  = "startup",
    order         = "OM-040"
  },
  {
    type          = "bool-setting",
    name          = "om-science-pack",
    default_value = true,
    setting_type  = "startup",
    order         = "OM-050"
  }
})
---------------------------------------------------------------------------
