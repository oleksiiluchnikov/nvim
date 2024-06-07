local function generate_json(config)
    config = config or {}
    local item_data = config.item_data
        or {
            { name = "New Layer", action = "apps.photoshop.fn.new_layer()" },
            { name = "Duplicate Layer", action = "apps.photoshop.fn.duplicate_layer()" },
            { name = "Delete Layer", action = "apps.photoshop.fn.delete_layer()" },
            { name = "Merge Layers", action = "apps.photoshop.fn.merge_layers()" },
            { name = "Layer Styles", action = "apps.photoshop.fn.layer_styles()" },
            { name = "Layer Mask", action = "apps.photoshop.fn.layer_mask()" },
            { name = "Group Layers", action = "apps.photoshop.fn.group_layers()" },
            { name = "Ungroup Layers", action = "apps.photoshop.fn.ungroup_layers()" },
        }
    local icon_base_url = config.icon_base_url
        or "https://cdn2.iconfinder.com/data/icons/macosxicons/512/"
    local hotkey_query = config.hotkey_query or "alt+n"

    local used_hints = {} -- Keeps track of the hints that have already been used.
    local items = {}
    for i, item in ipairs(item_data) do
        local name = item.name
        local action = item.action
        local hint = item.hint or string.sub(name, 1, 1):lower() -- Use first letter of name as hint if none specified.
        while used_hints[hint] do -- Generate new hint if already used.
            hint = hint .. "'"
        end
        used_hints[hint] = true -- Mark hint as used.
        local icon_url = item.icon or icon_base_url .. "Safari.png" -- Use default icon if none specified.
        local hs_query = "hs -c '" .. action .. "'"
        local menu_item = {
            id = i,
            name = name,
            icon = icon_url,
            hint = hint,
            action = {
                kind = "Script",
                query = hs_query,
            },
        }
        table.insert(items, menu_item)
    end

    local menu_name = config.menu_name or "Photoshop Layer Management"
    local menu_trigger = {
        kind = "hotkey",
        query = hotkey_query,
    }
    local menu = {
        name = menu_name,
        trigger = menu_trigger,
        items = items,
    }

    -- return json.encode(menu) -- Assuming you have a json module available.
    return menu
end

generate_json()
