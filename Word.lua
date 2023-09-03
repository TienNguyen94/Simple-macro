
Created = "15/07/2023"

---Auto----

local ar_key = nil
local arRecoilAmount = 7
local arRecoilInterval = 1

-- Tap
local autoTap_key = nil
local tapRecoilAmount = 12
local tapRecoilInterval = 1


---This is the button used to turn off the script (default:6) - G502
local set_of_key = nil

local autoTap = "OFF"

---This is the button used to turn on the fast loot
local fastloot_key = nil
mouseX1 = 10000 -- Mouse is at (10000, 9000)
mouseY1 = 9000
mouseX2 = 50000 -- Mouse is at (50000, 9000)
mouseY2 = 20000

--[[MASTER SCRIPT ENABLE/DISABLE SETTING]]
--
--------------------------------------------------------------------------------------------------------------

local scriptToggleKey = "scrolllock" --TURN ON/OFF SCRIPT.

--[[NO RECOIL SETTINGS]]
--
--------------------------------------------------------------------------------------------------------------

local recoilAmount   = 0 --HOW MANY PIXELS THE MOUSE IS MOVED DOWN DEFAULT: 5
local recoilInterval = 1 --INTERVAL BETWEEN MOUSE MOVEMENTS DEFAULT: 40
local recoilDelay    = 0 --DELAY BEFORE STARTING MOUSE MOVEMENTS EACH TIME DEFAULT: 0
local originalRecoil
--[[FUNCTIONS]]
--
--------------------------------------------------------------------------------------------------------------

function applyRecoil(recoilAmount, recoilInterval)
    Sleep(recoilDelay)
    repeat
        MoveMouseRelative(0, recoilAmount)
        Sleep(recoilInterval)
    until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)
end

-- Auto Tap
function applyAutoTap(recoilAmount, recoilInterval)
    repeat
        PressMouseButton(1)
        Sleep(5)
        ReleaseMouseButton(1)
        Sleep(recoilInterval)
        MoveMouseRelative(0, recoilAmount)
    until not IsMouseButtonPressed(3)
end

-- Check mouse
function mousePosition()
    x, y = GetMousePosition();
    OutputLogMessage("Mouse is at %d, %d\n", x, y);
end

-- Fast Loot
function fastLoot()
    for i = 1, 3 do
        MoveMouseTo(mouseX1, mouseY1 + 6000)
        PressMouseButton(1)
        MoveMouseTo(mouseX2, mouseY2)
        Sleep(20)
        ReleaseMouseButton(1)
        Sleep(25)

        MoveMouseTo(mouseX1, mouseY1 + 3000)
        PressMouseButton(1)
        MoveMouseTo(mouseX2, mouseY2)
        Sleep(20)
        ReleaseMouseButton(1)
        Sleep(25)

        MoveMouseTo(mouseX1, mouseY1)
        PressMouseButton(1)
        MoveMouseTo(mouseX2, mouseY2)
        Sleep(20)
        ReleaseMouseButton(1)
        Sleep(25)
    end
    PressAndReleaseKey("Tab")
end

-- Notification function
function logMessage()
    ClearLog()
    OutputLogMessage(
        "\n|-------------------------------------------------------------------------------------------------------|\n")
    OutputLogMessage("|\tToday:\t %s\n", GetDate())
    OutputLogMessage(
        "|-------------------------------------------------------------------------------------------------------|\n")
    OutputLogMessage(
        "| \tCurrent weapon: " ..
        current_weapon ..
        " | recoilAmount : " ..
        recoilAmount .. " | recoilInterval: " .. recoilInterval .. " | autoMode: " .. autoTap .. "\n")
    OutputLogMessage(
        "|-------------------------------------------------------------------------------------------------------|")
    OutputLogMessage("\n\tCreated: " .. Created .. "| By: TienNguyen")
    OutputLogMessage(
        "\n|-------------------------------------------------------------------------------------------------------|\n\n")
end

-- Auto Tap
function NotificationAutotTap(autoMode)
    if autoMode == true then autoTap = "ON" else autoTap = "OFF" end
end

--[[MAIN ONEVENT FOR SCRIPT FUNCTIONALITY]]
--
--------------------------------------------------------------------------------------------------------------

function OnEvent(event, arg)
    -- Script Toggle
    if not IsKeyLockOn(scriptToggleKey) then
        EnablePrimaryMouseButtonEvents(false)
    else
        EnablePrimaryMouseButtonEvents(true)
    end
    -- Mouse position check
    if (event == "MOUSE_BUTTON_PRESSED") then
        -- mousePosition()
    end
    -- Activate and Deactivate Script
    if (event == "PROFILE_ACTIVATED") then
        EnablePrimaryMouseButtonEvents(true)
        click = 0
        current_weapon = "None"
        autoMode = false
        recoilAmount = 0 --HOW MANY PIXELS THE MOUSE IS MOVED DOWN DEFAULT: 5
    elseif event == "PROFILE_DEACTIVATED" then
        ReleaseMouseButton(1)
        OutputLogMessage("PROFILE_DEACTIVATED")
    end
    -- Fast Loot
    if (event == "MOUSE_BUTTON_PRESSED" and arg == fastloot_key) then
        fastLoot()
    end

    -- Select recoilAmount
    if (event == "MOUSE_BUTTON_PRESSED" and arg == set_of_key) then
        recoilAmount = 0
        recoilInterval = 0
        autoMode = false
        current_weapon = "None"
        NotificationAutotTap(autoMode)
        logMessage()
    elseif (event == "MOUSE_BUTTON_PRESSED" and arg == ar_key) then
        recoilAmount = arRecoilAmount
        recoilInterval = arRecoilInterval
        autoMode = false
        current_weapon = "AR"
        NotificationAutotTap(autoMode)
        logMessage()
    elseif (event == "MOUSE_BUTTON_PRESSED" and arg == autoTap_key) then
        recoilAmount = tapRecoilAmount
        recoilInterval = tapRecoilInterval
        autoMode = true
        current_weapon = "Tap"
        NotificationAutotTap(autoMode)
        logMessage()
    end

    -- Recoil
    if event == "MOUSE_BUTTON_PRESSED" then
        if arg == 1 and current_weapon ~= "None" then
            if IsMouseButtonPressed(3) then
                if autoMode == false then
                    applyRecoil(recoilAmount, recoilInterval)
                else
                    applyAutoTap(recoilAmount, recoilInterval)
                end
            end
        end
    end
end
