# TPZ-CORE Metabolism

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory: https://github.com/TPZ-CORE/tpz_inventory

# Installation

1. When opening the zip file, open `tpz_metabolism-main` directory folder and inside there will be another directory folder which is called as `tpz_metabolism`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_metabolism` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

# Development

### The following event is triggered when `tpz_metabolism` loaded the selected character meta data successfully.

```lua
AddEventHandler("tpz_metabolism:isLoaded", function()

end)
```

### The following event is triggered on every metabolism data update / change in real time.

```lua

-- @param hunger : returns the current hunger.
-- @param thirst : returns the current thirst.
-- @param stress : returns the current stress.
-- @param alcohol : returns the current alcohol.

AddEventHandler("tpz_metabolism:getCurrentMetabolismValues", function(hunger, thirst, stress, alcohol)

end)
```

### The following event is triggered on every temperature update / change.

```lua

-- @param temperature : returns the current temperature.
AddEventHandler("tpz_metabolism:getCurrentTemperature", function(temperature)
	ClientData.Temperature = temperature

end)
```

## Exports

```lua exports.tpz_metabolism:getThirst()```

```lua exports.tpz_metabolism:getHunger()```

```lua exports.tpz_metabolism:getStress()```

```lua exports.tpz_metabolism:getAlcohol()```

```lua exports.tpz_metabolism:getTemperature()```
