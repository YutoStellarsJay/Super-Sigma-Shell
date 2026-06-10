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

local function EditFreeze(soundInd, asciiInd, editText)
    local loadingAscii = io.open("imageAscii/" .. tostring(asciiInd))
    if not loadingAscii then return end
    local ascii = loadingAscii:read("a")
    loadingAscii:close()
    Play(soundInd)
    local _, count = string.gsub(ascii, "\n", "")
    local firstNewline = utf8.len(ascii) / count
    local centeringSpaces = string.rep(" ", Round((firstNewline / 2) - ((string.len(editText)) / 2)) - 1)
    for i = 0, 50 do
        ClearCons()
        io.write(centeringSpaces .. editText)
        io.write(string.rep("\n", 6 + Round((math.sin(i)) * math.min((i - 45) * 0.11, 0))))
        --6+(\sin(x))\cdot\min\left((x-30)\cdot0.12,0\right) for desmos graph (absolute goat)
        print(ascii)
        Sleep(SleepTimes[soundInd] / 50)
    end
    ClearCons()
end

while true do
    if isLinuxy then
        local location = io.popen("pwd", "r")
        if not location then return end
        local out = location:read("a")
        location:close()
        local temp = string.find(string.reverse(out), "/")
        if not temp then return end
        temp = temp - 2
        io.write("💀:\\🗣️  " .. string.sub(out, #out - temp, #out - 1) .. " % ")
    else
        io.write("🗿@🤫 ")
    end
    input = io.read()
    if input == "exit" then
        goto exit
    end
    local asciiInd = math.random(1, 11)
    while asciiInd == lastImage do
        asciiInd = math.random(1, 11)
    end
    lastImage = asciiInd
    local soundInd = math.random(1, 12)
    while soundInd == lastSound do
        soundInd = math.random(1, 12)
    end
    lastSound = soundInd
    local message = "\"" .. input .. "\""
    if string.find(input, "echo", 1, true) == 1 or string.find(input, "Write-Host", 1, true) == 1 then
        message = "Bro is talking"
    elseif string.find(input, "pwd", 1, true) == 1 then
        message = "He need location"
    elseif string.find(input, "dir", 1, true) == 1 or string.find(input, "ls", 1, true) == 1 then
        message = "Bro is searching"
    elseif string.find(input, "cat", 1, true) == 1 or string.find(input, "type", 1, true) == 1 or string.find(input, "Get-Content", 1, true) == 1 then
        message = "Bro is reading the file"
    end
    EditFreeze(soundInd, asciiInd, message)
    os.execute(input)
end
::exit::
