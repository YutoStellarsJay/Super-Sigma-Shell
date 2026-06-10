local isLinuxy = package.config:sub(1, 1) == "/"

local function Play(index)
    if isLinuxy then
        os.execute("afplay phonk/" .. tostring(index) .. ".mp3 &")
    else
        os.execute("start /B wmplayer \"phonk\\" .. tostring(index) .. ".mp3\"")
    end
end
local function Sleep(amount)
    if isLinuxy then
        os.execute("sleep " .. tostring(amount))
    else
        os.execute("timeout " .. tostring(amount))
    end
end
local function ClearCons()
    if isLinuxy then
        os.execute("clear")
    else
        os.execute("cls")
    end
end
local function Round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

local SleepTimes = {}

for line in io.lines("lengths") do
    table.insert(SleepTimes, tonumber(line))
end

local input

local lastImage = 0
local lastSound = 0

while true do
    if isLinuxy then
        local read = io.popen("pwd", "r"):read("a")
        local temp = string.find(string.reverse(read), "/")
        if not temp then return end
        temp = temp - 2
        io.write("💀:\\🗣️  " .. string.sub(read, #read - temp, #read - 1) .. " % ")
    else
        io.write("🗿@🤫 ")
    end
    input = io.read()
    if input == "exit" then
        goto exit
    end
    local temp = math.random(1, 8)
    while temp == lastImage do
        temp = math.random(1, 8)
    end
    lastImage = temp
    local ascii = io.open("imageAscii/" .. tostring(temp)):read("a")
    local _, count = string.gsub(ascii, "\n", "")
    temp = math.random(1, 11)
    while temp == lastSound do
        temp = math.random(1, 11)
    end
    lastSound = temp
    Play(temp)
    for i = 0, 50 do
        ClearCons()
        io.write(string.rep("\n", 6 + Round((math.sin(i)) * math.min((i - 45) * 0.1, 0))))
        --6+(\sin(x))\cdot\min\left((x-30)\cdot0.1,0\right) for desmos graph (absolute goat)
        print(ascii)
        Sleep(SleepTimes[temp] / 50)
    end
    ClearCons()
    os.execute(input)
end
::exit::
