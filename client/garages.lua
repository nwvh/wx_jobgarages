local playerJob = nil
local spawnedNpcs = {}

if string.lower(wx.Framework) == 'esx' then
    ESX = exports["es_extended"]:getSharedObject() 
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(100)
        end
        playerJob = ESX.GetPlayerData().job.name
        end
    end)
elseif string.lower(wx.Framework) == 'qb' then
    if GetResourceState('qb-core') ~= 'started' then return end
    local PlayerData = {}
    Citizen.CreateThread(function ()
        while true do Citizen.Wait(5000)
            QBCore = exports['qb-core']:GetCoreObject()
            PlayerData = QBCore.Functions.GetPlayerData()
            while PlayerData == nil do Citizen.Wait(100) end
            playerJob = PlayerData.job
        end
    end)
else
    print("[ERROR] Invalid framework set! Please check your config")
end

local serviceVeh = nil
local cooldown = false

Citizen.CreateThread(function ()
    for job,data in pairs(wx.Garages) do
        Citizen.SetTimeout(6000,function () -- Wait for framework to retrieve player job and then add the blips
            if data.Blip then
                if playerJob == job then
                    for _,coords in pairs(data.Positions) do
                        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        SetBlipSprite(blip, 357)
                        SetBlipScale(blip, 0.8)
                        SetBlipColour(blip, 19)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(data.Label.." "..Locale["Garage"])
                        EndTextCommandSetBlipName(blip)
                    end
                end
            end
        end)
        RequestModel(data.Ped)
        while not HasModelLoaded(data.Ped) do Citizen.Wait(10) end
        for _,coords in pairs(data.Positions) do
            local npc = CreatePed(0, data.Ped, coords.x, coords.y, coords.z-1, coords.w, true, false)
            table.insert(spawnedNpcs,npc)
            TaskStartScenarioInPlace(npc,data.Scenario,0,true)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc,true)
            SetBlockingOfNonTemporaryEvents(npc,true)

            exports.ox_target:addSphereZone({
                coords = vec3(coords.x, coords.y, coords.z),
                radius = 2.0,
                options = {
                    {
                        name = 'wx_jobgarages:open',
                        onSelect = function ()
                            lib.showContext('garage_'..job)
                        end,
                        canInteract = function ()
                            if job == playerJob then return true end
                            return false
                        end,
                        distance = 2.0,
                        icon = 'fa-solid fa-car-side',
                        label = Locale["TargetOpen"]:format(data.Label, Locale["Garage"]),
                    },
                    {
                        name = 'wx_jobgarages:delete',
                        -- distance = 50.0,
                        onSelect = function ()
                            if IsPedInAnyVehicle(PlayerPedId(),false) then
                                TaskLeaveVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(),false),64)
                                local veh = GetVehiclePedIsIn(PlayerPedId(),false)
                                Citizen.SetTimeout(1500,function ()
                                    Notify(Locale["NotifySuccess"],Locale["NotifyReturned"])
                                    DeleteEntity(veh)
                                end)

                            else
                                Notify(Locale["NotifyError"],Locale["NotifyNotInVeh"])
                            end
                        end,
                        canInteract = function ()
                            if job == playerJob and IsPedInAnyVehicle(PlayerPedId(),false) then return true end
                            return false
                        end,
                        icon = 'fa-solid fa-car-side',
                        label = Locale["TargetReturn"],
                    },
                }
            })
        end
        
    end
end)
for job,data in pairs(wx.Garages) do
    local opt = {}
    for label,model in pairs(data.Vehicles) do
        if IsModelValid(model.model) then
            table.insert(opt,{
                    title = label,
                    icon = 'car-side',
                    onSelect = function ()
                        if not cooldown then
                            if not IsPositionOccupied(data.SpawnPosition.x, data.SpawnPosition.y, data.SpawnPosition.z,2.0,false,true,false,false,false,1,false) then
                                cooldown = true
                                Citizen.SetTimeout(wx.Cooldown,function ()
                                    cooldown = false
                                end)
                                serviceVeh = CreateVehicle(model.model, data.SpawnPosition.x, data.SpawnPosition.y, data.SpawnPosition.z, data.SpawnPosition.w, true, false)
                                SetVehicleLivery(serviceVeh,model.livery)
                                Notify(Locale["NotifySuccess"],Locale["NotifyWaiting"])
                            else
                                Notify(Locale["NotifyError"],Locale["NotifyOccupied"])
                            end
                        else
                            Notify(Locale["NotifyError"],Locale["NotifyAlreadyOut"])
                        end
                    end
            })
            lib.registerContext({
                id = 'garage_'..job,
                title = data.Label.." "..Locale["Garage"],
                options = opt
            })
            RequestModel(model.model)
            while not HasModelLoaded(model.model) do Citizen.Wait(10) end
        else
            print("[ERROR] The model "..model.model.." located in "..job.." table is invalid!")
        end
    end
end

AddEventHandler('onResourceStop',function (r)
    if r == GetCurrentResourceName() then
        for k, npc in pairs(spawnedNpcs) do
            DeleteEntity(npc)
        end
    end
end)