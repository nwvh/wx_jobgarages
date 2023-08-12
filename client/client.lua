local playerJob = nil

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

local ped = PlayerPedId()
local serviceVeh = nil
local cooldown = false

Citizen.CreateThread(function ()
    for job,data in pairs(wx.Garages) do
        Citizen.SetTimeout(6000,function () -- Wait for framework to retrieve player job and then add the blips
            if data.Blip then
                if playerJob == job then
                    local blip = AddBlipForCoord(data.Position.x, data.Position.y, data.Position.z)
                    SetBlipSprite(blip, 357)
                    SetBlipScale(blip, 0.8)
                    SetBlipColour(blip, 19)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(string.upper(job).." "..Locale["Garage"])
                    EndTextCommandSetBlipName(blip)
                end
            end
        end)
        RequestModel(data.Ped)
        while not HasModelLoaded(data.Ped) do Citizen.Wait(10) end
        local npc = CreatePed(0, data.Ped, data.Position.x, data.Position.y, data.Position.z-1, data.Position.w, true, false)
        TaskStartScenarioInPlace(npc,data.Scenario,0,true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc,true)
        SetBlockingOfNonTemporaryEvents(npc,true)

        exports.ox_target:addSphereZone({
            coords = vec3(data.Position.x, data.Position.y, data.Position.z),
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
                    label = Locale["TargetOpen"]:format(string.upper(job)),
                },
                {
                    name = 'wx_jobgarages:delete',
                    onSelect = function ()
                        if IsPedInAnyVehicle(ped,false) then
                            TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped,false),64)
                            local veh = GetVehiclePedIsIn(ped,false)
                            Citizen.SetTimeout(1500,function ()
                                Notify(Locale["NotifySuccess"],Locale["NotifyReturned"])
                                DeleteEntity(veh)
                            end)

                        else
                            Notify(Locale["NotifyError"],Locale["NotifyNotInVeh"])
                        end
                    end,
                    canInteract = function ()
                        if job == playerJob then return true end
                        return false
                    end,
                    distance = 10.0,
                    icon = 'fa-solid fa-car-side',
                    label = Locale["TargetReturn"],
                },
            }
        })
        
    end
end)
for job,data in pairs(wx.Garages) do
    local opt = {}
    for label,model in pairs(data.Vehicles) do
        if IsModelValid(model) then
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
                                serviceVeh = CreateVehicle(model, data.SpawnPosition.x, data.SpawnPosition.y, data.SpawnPosition.z, data.SpawnPosition.w, true, false)
                                Notify(Locale["NotifySuccess"],Locale["NotifyWaiting"])
                            else
                                Notify(Locale["NotifyError"],Locale["NotifyOccupied"])
                            end
                            if wx.AllExtras then
                                for i=0,20 do
                                    SetVehicleExtra(serviceVeh,i,0)
                                end
                            end
                            if wx.MaxTuning then
                                SetVehicleMod(serviceVeh,11,3,false) -- Engine
                                SetVehicleMod(serviceVeh,12,2,false) -- Brakes
                                ToggleVehicleMod(serviceVeh,18,false) -- Turbo
                                SetVehicleMod(serviceVeh,13,2,false) -- Acceleration
                                SetVehicleMod(serviceVeh,16,4,false) -- Armor
                            end
                            if data.CustomPlate ~= false then
                                if string.len(data.CustomPlate) < 8 then
                                    SetVehicleNumberPlateText(serviceVeh,data.CustomPlate..math.random(11111111,99999999))
                                else
                                    SetVehicleNumberPlateText(serviceVeh,data.CustomPlate)
                                end
                            end
                        else
                            Notify(Locale["NotifyError"],Locale["NotifyCooldown"])
                        end
                    end
            })
            lib.registerContext({
                id = 'garage_'..job,
                title = string.upper(job).." "..Locale["Garage"],
                options = opt
            })
            RequestModel(model)
            while not HasModelLoaded(model) do Citizen.Wait(10) end
        else
            print("[ERROR] The model "..model.." located in "..job.." table is invalid!")
        end
    end
end