-- this line being here is important, dont remove it
-- this line aswell
-- OH MY GODS
-- end me :)
-- PLEASE actually?
-- ugh

--[[

goofy ahh computer waits for a redstone signal, GRABS THE GIT REPO, AND EXECS THE STRING AS CODE???!
fucking dumb. 
when getting in the thing,,, make sure to have ? and then the time so things are unique and the cache doesnt fuck us?

obj:func() is SO STUPID.

--]]


--print("bruh?")

function sleepTick(val)
    -- goofy ahh default param
    val = val or 1
    sleep(val * 0.1)
end

Integrator = {}

local Integrator_mt = { __index = Integrator }

function Integrator:set(val)
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")

    --print("self:", self)
    --print("self.device:", self.device)

    if val == nil then
        val = true
    end

    self.device.setOutput(self.side, val)

    sleepTick()
end

function Integrator:reset()
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    --self.device.setOutput(self.side, false)
    --sleepTick()
    self:set(false)
end

function Integrator:pulse()
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    self:set(not self.defaultVal)
    sleepTick(2) -- one redstone tick, should be enough?
    self:set(self.defaultVal)
    sleepTick(2)
end

function Integrator:get() -- not actually needed anymore,, but yea
    --assert(self.defaultVal == nil, "defaultVal was not nil, and needs to be for a input integrator!")
    return self.device.getInput(self.side)
end

-- defaultVal is the default value. pass in NIL if this is an input
function Integrator:new(device, side, defaultVal)
    
    -- wtf?
    --local obj = {}
    --setmetatable(obj, self)
    --local obj = setmetatable({}, self)
    --self.__index = self
    --local  obj = {}
    --setmetatable(obj, self)
    --self.__index = self

    local self = setmetatable({}, Integrator_mt)

    -- define vars
    self.device = peripheral.wrap(device)
    
    self.deviceName = device

    assert(self.device ~= nil, "the fucking integrator be null du,basdfhsujifksdghasidfol ui " .. device)

    self.side = side 
    self.defaultVal = defaultVal

    -- setup
    self:set(self.defaultVal)

    assert(type(self.device) == type({}), "WHAT THE FUCK" .. device)

    
    return self 
end

Container = {}

local Container_mt = { __index = Container }

function Container:list()
    return self.device.list()
end

function Container:size()
    return self.size
end

function Container:pushItem(other, from, to)
    self.device.pushItems(peripheral.getName(other.device), from, 64, to)
    sleepTick(2)
end

function Container:getItemDetail(slot)
    
    --print(self.deviceName)

    local temp = self.device.getItemDetail(slot)
    
    if temp then
       return temp.name 
    end
    
    return nil
end

function Container:new(device)
    
    -- wtf?
    --local obj = {}
    --setmetatable(obj, self)
    --local obj = setmetatable({}, self)
    --self.__index = self

    --local obj = {}
    --setmetatable(obj, self)
    --self.__index = self

    local self = setmetatable({}, Container_mt)

    self.deviceName = device

    -- define vars
    self.device = peripheral.wrap(device)
    assert(self.device ~= nil, "the fucking contiainer be null du,basdfhsujifksdghasidfol ui " .. device)
    self.size = self.device.size()

    return self
end

-- chatbox

chatBox = peripheral.wrap("chatBox_0")
assert(chatBox ~= nil, "the fucking chatBox_0 be null du,basdfhsujifksdghasidfol ui")

function errorChat(s)
    chatBox.sendMessage(s, "autocrafter")
    error(s)
end


-- integrators

attackPiston = Integrator:new("redstoneIntegrator_11", "back", false) -- piston for the attack deployer
usePiston = Integrator:new("redstoneIntegrator_7", "back", false) -- piston for the use deployer

deployerTrigger = Integrator:new("redstoneIntegrator_10", "bottom", true) -- redstone for triging the deployer

funnel = Integrator:new("redstoneIntegrator_9", "bottom", false)  -- trigs the funnel
recipeBufferSend = Integrator:new("redstoneIntegrator_8", "front", true) -- trig the sending of item from output buffer

-- containers

recipeChest = Container:new("minecraft:barrel_2")
recipeBuffer = Container:new("minecraft:barrel_1")

returnHopper = Container:new("minecraft:hopper_0")
giveHopper = Container:new("minecraft:hopper_1")

outputBuffer = Container:new("minecraft:barrel_3")
outputChest = Container:new("ironchest:diamond_chest_0")

-- init

modem = peripheral.wrap("top")
channel = 5
modem.open(channel)

--errorChat("sdwm")

--checkSlotIDs = {{1,2,3},{10,11,12},{19,20,21}}
checkSlotIDs = {{1,10,19},{2,11,20},{3,12,21}}

function trigDeployer(piston) -- trigs the deployer (assuming ones currently there)
    piston:set()
    deployerTrigger:pulse()
    sleep(0.1) -- is this a good amount of time?
    piston:reset()
end

function getItem(slot)

    if recipeChest:getItemDetail(slot) == nil then
        return
    end
    
    recipeChest:pushItem(giveHopper, slot, 1)
    
    trigDeployer(usePiston) 

    funnel:pulse()

    local res = recipeBuffer:getItemDetail(1)
    for i=1,100 do
        res = recipeBuffer:getItemDetail(1)
        if res ~= nil then
            break
        end
        sleep(0.05)
    end

    if res == nil then
        errorChat("funnel was unable to get an item! fric!")
    end

    recipeBufferSend:pulse()

    trigDeployer(attackPiston)

    sleep(0.1)

    res = returnHopper:getItemDetail(1)
    for i=1,100 do
        res = returnHopper:getItemDetail(1)
        if res ~= nil then
            break
        end
        sleep(0.05)
    end

    if res == nil then
        errorChat("returnHopper unable to get an item! fric!")
    end

    returnHopper:pushItem(recipeChest, 1, slot)

    sleep(0.1)

end

function craft() 
    
    for y=1,3 do
        for x=1,3 do
            getItem(checkSlotIDs[x][y])
        end
    end

    -- crafting will just,,, occur over here automatically??

    sleep(2)

    local res = outputBuffer:getItemDetail(1)

    if res == nil then
        errorChat("craft failed somehow? fric!")
    end

    outputBuffer:pushItem(outputChest, 1)
    
end

function transmitMessage(message)
    modem.transmit(channel, channel, message)
end  

function checkForMessageEvent()
    local event, side, recivedChannel, requestChannel, message, distance = os.pullEvent("modem_message")
    return message
end


--check items in choosen slots 
function gridContents()
    local newItems = {{"","",""},{"","",""},{"","",""}}
    for i=1,3 do 
        for e=1,3 do
            newItems[i][e] = recipeChest:getItemDetail(checkSlotIDs[i][e])
        end
    end
    return newItems
end

function constructTable(list)
    local nList = {{false,false,false},{false,false,false},{false,false,false}}
    for i=1,3 do
        for e=1,3 do
            if list[i][e] == nil then
                nList[i][e] = true
            end
        end
    end
    return nList
end

function checkSendWait()

    local temp = constructTable(gridContents())

    print("transmitting:")

    for y=1,3 do
        for x=1,3 do
            if temp[x][y] then
                write(string.char(8))
            else
                write("_")
            end
        end
        write("\n")
    end

    transmitMessage(temp)
    print(checkForMessageEvent())
end

function main()

    checkSendWait()


    craft()


end

while true do 
    local success, error_message = xpcall(main, debug.traceback)

    if not success then
        print("FUCK: " .. error_message)
    end

    break
end





