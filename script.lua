-- game values
local score = 0
local multiplier = 1
local cookiesPerClick = 1

-- clicker elements
local clicker = get("clicker")
local cookieDisplay = get("cookie-display")
local clickerIcon = get("clicker-icon")

-- farmer upgrade
local cookieFarmerBtn = get("cookie-farmer-upgrade-btn")
local cookieFarmerLbl = get("cookie-farmer-lbl")

local farmers = {} :: {thread}

-- more cookie upgrade
local moreCookieBtn = get("more-cookie-upgrade-btn")
local moreCookieLbl = get("more-cookie-upgrade-lbl")

-- multiplier upgrade
local multiplierBtn = get("multiplier-upgrade-btn")
local mutliplierLbl = get("multiplier-upgrade-lbl")

-- stats
local farmerStats = get("stats-farmers")
local clickStats = get("stats-click")
local multiplierStats = get("stats-multiplier")

-- constants
local FARMER_DELAY = 1 * 1000
local BASE_MULTIPLIER_COST = 10000
local BASE_FARMER_COST = 100
local BASE_CLICK_COST = 1000

-- costs
local multiplierCost = BASE_MULTIPLIER_COST
local farmerCost = BASE_FARMER_COST
local clickCost = BASE_CLICK_COST

-- settings buttons
local toggleFlashing = get("toggleFlashing")

-- settings
local flashingEnabled = true

-- icons
local COOKIE_ICON = "https://cdn.discordapp.com/attachments/907306705090646066/1247801909717504012/cookie.png?ex=66615996&is=66600816&hm=0082fd292c36f23427a42af5c930adef738f57b8c9e61666619bfce73f481b0c&"
local PRESSED_COOKIE_ICON = "https://cdn.discordapp.com/attachments/1246880258649620514/1247825906483859477/clicked_cookie.png?ex=66616fef&is=66601e6f&hm=df1f64e3e3de385e8b40e82a5fe2bc7f29253bde2a0979756d628c49574d4cd7&"

-- for cleanup
local lastSplash: Timeout = nil

local function splashEffect(element: HtmlElement): Timeout
    element.set_opacity(0.5)
    
    return set_timeout(function()
        element.set_opacity(1)
    end, 10)
end

local function updateCosts()
    farmerCost = (table.maxn(farmers)) * 100 +  BASE_FARMER_COST
    multiplierCost = multiplier^10 * BASE_MULTIPLIER_COST
    clickCost = BASE_CLICK_COST * cookiesPerClick
    displayUpgrades()
    displayStats()
end

local function farmerLoop()
    click()

    set_timeout(farmerLoop, FARMER_DELAY)
    --print("Looped")
end

local function addFarmer()
    local thread = coroutine.create(farmerLoop)
    coroutine.resume(thread)

    table.insert(farmers, thread)

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
    moreCookieLbl.set_content(`+1 Cookie per click: {clickCost}`)
    mutliplierLbl.set_content(`+1 Multiplier: {multiplierCost}`)
end

function displayStats()
    farmerStats.set_content(`Cookie Farmers: {table.maxn(farmers)}`)
    clickStats.set_content(`Cookies per click: {cookiesPerClick}`)
    multiplierStats.set_content(`Cookies Multiplier: {multiplier}`)
end

function click()
    score += cookiesPerClick * multiplier

    if flashingEnabled then
        if lastSplash then
            clear_timeout(lastSplash)
        end
    
        lastSplash = splashEffect(clickerIcon)
    end

    display()
end

clicker.on_click(click)

cookieFarmerBtn.on_click(function()
    if score >= farmerCost then
        print("Bought farmer")
        score -= farmerCost
        addFarmer()
        display()
        updateCosts()
    else
        print(`Cant afford farmer | Cost: {farmerCost} | Score: {score}`)
    end
end)

moreCookieBtn.on_click(function()
    if score >= clickCost then
        print("Bought +1 cookie")
        score -= clickCost
        cookiesPerClick += 1
        display()
        updateCosts()
    else
        print(`Cant afford more cookies | Cost: {clickCost} | Score: {score}`)
    end
end)

multiplierBtn.on_click(function()
    if score >= multiplierCost then
        print("Bought +1 multiplier")
        score -= multiplierCost
        multiplier += 1
        display()
        updateCosts()
    else
        print(`Cant afford multiplier | Cost: {multiplierCost} | Score: {score}`)
    end
end)

toggleFlashing.on_click(function()
    flashingEnabled = not flashingEnabled

    if flashingEnabled then
        toggleFlashing.set_content("Turn Off Flashing")
    else
        toggleFlashing.set_content("Turn On Flashing")
    end
end)

print(window.link)

function render()
    display()
    displayUpgrades()
    displayStats()
end

render()