local score = 999
local multiplier = 1

local clicker = get("clicker")
local cookieDisplay = get("cookie-display")

local farmers = {} :: {thread}
local cookieFarmerBtn = get("cookie-farmer-upgrade-btn")
local cookieFarmerLbl = get("cookie-farmer-lbl")

local FARMER_DELAY = 1 * 1000

local multiplierCost = 10000
local farmerCost = 100
local clickCost = 1000

local function updateCosts()
    farmerCost = (table.maxn(farmers)) * 100 + 100
    displayUpgrades()
    displayStats()
end

local function farmerLoop()
    click()
    set_timeout(farmerLoop, FARMER_DELAY * 1000)
    print("Looped")
end

local function addFarmer()
    local thread = coroutine.create(farmerLoop)
    coroutine.resume(thread)

    table.insert(farmers, thread)

    updateCosts()

    return thread
end

local function separateThousands(number)
    local formattedNumber = tostring(number)
    local length = #formattedNumber
    local separatedNumber = ""

    for i = 1, length do
        local charIndex = length - i + 1
        separatedNumber = formattedNumber:sub(charIndex, charIndex) .. separatedNumber
        if i % 3 == 0 and i ~= length then
            separatedNumber = "," .. separatedNumber
        end
    end

    return separatedNumber
end

function display()
    cookieDisplay.set_content(separateThousands(score))
end

function displayUpgrades()
    cookieFarmerLbl.set_content(`Cookie Farmer (+1 Cookies): {farmerCost}`)
end

function displayStats()
    
end

function click()
    score += 1 * multiplier
    display()
end

clicker.on_click(click)

display()
displayUpgrades()

cookieFarmerBtn.on_click(function()
    if score >= farmerCost then
        print("Bought farmer")
        score -= farmerCost
        addFarmer()
    else
        print(`Cant afford farmer | Cost: {farmerCost} | Score: {score}`)
    end
end)

print(window.link)