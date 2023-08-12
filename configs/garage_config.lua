wx = {} -- Don't touch


wx.Framework = 'esx' -- [ esx / qb ]
wx.Cooldown = 5000 -- In ms, how long the player needs to wait before choosing another vehicle?
wx.AllExtras = true -- Spawn the vehicle with all available extras?
wx.MaxTuning = true -- Spawn the vehicle with max upgrades?

wx.Garages = {
    ['police'] --[[ Job Name ]] = {
        Position = vector4(-1037.0554, -857.3878, 5.0333, 55.6624), -- NPC Spawn position (X,Y,Z, Heading)
        Blip = true, -- Show blip? (only players with required job will see it)
        SpawnPosition = vector4(-1051.9429, -847.4304, 4.8676, 211.9775), -- Vehicle spawn position (X,Y,Z, Heading)
        CustomPlate = "LSPD", -- Maximum of 8 characters, if the character count is lower, it will be completed with random numbers
        Ped = `s_m_y_airworker`, -- Ped model
        Scenario = "WORLD_HUMAN_CLIPBOARD", -- Ped scenario (https://pastebin.com/6mrYTdQv)
        Vehicles = {
            -- Label      -- Spawn code
            ['Charger'] = 'code318charg',
            ['Explorer'] = 'code320exp',
            ['SUV'] = 'GU1',
        }
    },
    ['unemployed'] = {
        Position = vector4(377.5826, -1622.1602, 29.2929, 322.9598),
        Blip = true,
        SpawnPosition = vector4(373.4238, -1623.6891, 29.2920, 316.8286),
        CustomPlate = "SHERIFF",
        Ped = `s_m_y_airworker`,
        Scenario = "WORLD_HUMAN_CLIPBOARD",
        Vehicles = {
            ['Police'] = 'police',
            ['Police 2'] = 'police2',
            ['Police 3'] = 'police3',
        }
    },
    ['trooper'] = {
        Position = vector4(-454.7611, 6009.1294, 31.4901, 138.7872),
        Blip = true,
        SpawnPosition = vector4(-451.3755, 5998.2871, 31.3405, 266.8787),
        CustomPlate = "TROOPER",
        Ped = `s_m_y_airworker`,
        Scenario = "WORLD_HUMAN_CLIPBOARD",
        Vehicles = {
            ['Unmarked'] = 'fbi',
        }
    },
    ['lsfd'] = {
        Position = vector4(212.4510, -1654.5939, 29.8032, 54.8945),
        Blip = true,
        SpawnPosition = vector4(210.6388, -1645.7799, 29.8032, 319.3289),
        CustomPlate = "FIRE",
        Ped = `s_m_y_airworker`,
        Scenario = "WORLD_HUMAN_CLIPBOARD",
        Vehicles = {
            ['Fire Truck'] = 'firetruk',
        }
    },
    -- ADD HOW MANY GARAGES AND JOBS YOU WANT!
    -- ['examplejob'] = {
    --     Position = vector4(212.4510, -1654.5939, 29.8032, 54.8945),
    --     Blip = true,
    --     SpawnPosition = vector4(210.6388, -1645.7799, 29.8032, 319.3289),
    --     CustomPlate = "EXAMPLE",
    --     Ped = `example_ped`,
    --     Scenario = "EXAMPLE_SCENARIO",
    --     Vehicles = {
    --         ['examplemodel'] = 'Example Label',
    --     }
    -- },

}

Notify = function (title,message) -- You can replace this notify function if you want
    lib.notify({
        title = title,
        description = message,
        position = 'top',
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