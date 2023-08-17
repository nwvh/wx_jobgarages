wx = {} -- Don't touch


wx.Framework = 'esx' -- [ esx / qb ]
wx.Cooldown = 5000 -- In ms, how long the player needs to wait before choosing another vehicle?
wx.HeliCooldown = 120*60000 -- Cooldown but for helis (Default 2 minutes)
wx.AllExtras = true -- Spawn the vehicle with all available extras? (Doesn't apply to helicopters)
wx.MaxTuning = true -- Spawn the vehicle with max upgrades? (Doesn't apply to helicopters)

wx.Garages = {
    ['police'] --[[ Job Name ]] = {
        Label = "Los Santos Police Department", -- Optional blip name and target + context menu label
        Positions = {
            vector4(-1037.0554, -857.3878, 5.0333, 55.6624),
            vector4(-1037.0554, -856.3878, 5.0333, 55.6624),
            vector4(-1037.0554, -855.3878, 5.0333, 55.6624),
            vector4(-1037.0554, -854.3878, 5.0333, 55.6624),
        }, -- NPC Spawn position (X,Y,Z, Heading)
        Blip = true, -- Show blip? (only players with required job will see it)
        SpawnPosition = vector4(-1051.9429, -847.4304, 4.8676, 211.9775), -- Vehicle spawn position (X,Y,Z, Heading)
        CustomPlate = "LSPD", -- Maximum of 8 characters, if the character count is lower, it will be completed with random numbers
        Ped = `s_m_y_airworker`, -- Ped model
        Scenario = "WORLD_HUMAN_CLIPBOARD", -- Ped scenario (https://pastebin.com/6mrYTdQv)
        Vehicles = {
            -- Label      -- Spawn code
            ['Charger'] = { model = 'code318charg', livery = 1},
            ['Explorer'] = { model = 'code320exp', livery = 0},
            ['SUV'] = { model = 'GU1', livery = 0},
        }
    },
    ['trooper'] = {
        Label = "San Andreas State Troopers",
        Positions = {
            vector4(-454.7611, 6009.1294, 31.4901, 138.7872),
        },
        Blip = true,
        SpawnPosition = vector4(-451.3755, 5998.2871, 31.3405, 266.8787),
        CustomPlate = "TROOPER",
        Ped = `s_m_y_airworker`,
        Scenario = "WORLD_HUMAN_CLIPBOARD",
        Vehicles = {
            ['Unmarked'] = { model = 'fbi', livery = 0},
        }
    },
    ['lsfd'] = {
        Label = "Los Santos Fire Department",
        Positions = {
            vector4(212.4510, -1654.5939, 29.8032, 54.8945),
        },
        Blip = true,
        SpawnPosition = vector4(210.6388, -1645.7799, 29.8032, 319.3289),
        CustomPlate = "FIRE",
        Ped = `s_m_y_airworker`,
        Scenario = "WORLD_HUMAN_CLIPBOARD",
        Vehicles = {
            ['Fire Truck'] = { model = 'fbi', livery = 0},
        }
    },
    -- ADD HOW MANY GARAGES AND JOBS YOU WANT!
    -- ['examplejob'] = {
    --     Positions = {
    --     vector4(212.4510, -1654.5939, 29.8032, 54.8945),
    -- },
    --     Blip = true,
    --     SpawnPosition = vector4(210.6388, -1645.7799, 29.8032, 319.3289),
    --     CustomPlate = "EXAMPLE",
    --     Ped = `example_ped`,
    --     Scenario = "EXAMPLE_SCENARIO",
    --     Vehicles = {
    --         ['examplemodel'] = { model = 'examplemodel', livery = 0},
    --     }
    -- },

}

wx.Helipads = {
    ['police'] --[[ Job Name ]] = {
        Label = "Los Santos Police Department", -- Optional blip name and target + context menu label
        Positions = {
            vector4(-1107.5497, -832.3687, 37.6754, 221.9360),
        }, -- NPC Spawn position (X,Y,Z, Heading)
        Blip = true, -- Show blip? (only players with required job will see it)
        SpawnPosition = vector4(-1095.6434, -835.1830, 37.6754, 306.7749), -- Vehicle spawn position (X,Y,Z, Heading)
        Ped = `s_m_y_airworker`, -- Ped model
        Scenario = "WORLD_HUMAN_CLIPBOARD", -- Ped scenario (https://pastebin.com/6mrYTdQv)
        Vehicles = {
            -- Label      -- Spawn code
            ['Police Maverick'] = { model = 'polmav', livery = 2},
        }
    },

}

Notify = function (title,message) -- You can replace this notify function if you want
    lib.notify({
        title = title,
        description = message,
        Positions = 'top',
        style = {
            backgroundColor = '#1E1E2E',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'car-side',
    })
end