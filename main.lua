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

function Integrator:set(val)
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    if val then
        self.peripheral.setOutput(self.side, val)
    else
        self.device.setOutput(self.side, true)
    end
    sleepTick()
end

function Integrator:reset()
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    self.device.setOutput(self.side, false)
    sleepTick()
end

function Integrator:pulse()
    --assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    self.set(not self.defaultVal)
    sleepTick() -- one redstone tick, should be enough?
    self.set(self.defaultVal)
    sleepTick()
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
    obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- define vars
    self.device = peripheral.wrap(device)
    
    assert(self.device ~= nil, "the fucking perirejasfdi be null du,basdfhsujifksdghasidfol ui")

    self.side = side 
    self.defaultVal = defaultVal

    -- setup
    if defaultVal then
        self.set(self.defaultVal)
    end

    return obj
end

Container = {}

function Container:list()
    return self.device.list()
end

function Container:size()
    return self.size
end

function Container:pushItem(other, from, to)
    self.device.pushItems(peripheral.getName(other.device), from, 64, to)
end

function Container:getItemDetail(slot)
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
    local obj = setmetatable({}, self)
    self.__index = self

    

    -- define vars
    self.device = peripheral.wrap(device)
    assert(device ~= nil, "the fucking contiainer be null du,basdfhsujifksdghasidfol ui")
    self.size = self.device.size()

    return obj
end

-- integrators

attackPiston = Integrator:new("redstoneIntegrator_11"), "back", false) -- piston for the attack deployer
usePiston = Integrator:new("redstoneIntegrator_7", "back", false) -- piston for the use deployer

deployerTrigger = Integrator:new("redstoneIntegrator_10", "bottom", true) -- redstone for triging the deployer

funnel = Integrator:new("redstoneIntegrator_9", "bottom", false)  -- trigs the funnel
outputBufferSend = Integrator:new("redstoneIntegrator_8", "front", true) -- trig the sending of item from output buffer

-- containers

recipeChest = Container:new("barrel_2")
outputBuffer = Container:new("barrel_1")

returnHopper = Container:new("hopper_0")
giveHopper = Container:new("hopper_1")

-- init

modem = peripheral.wrap("top")
channel = 5
modem.open(channel)

checkSlotIDs = {1,2,3,10,11,12,19,20,21}

function trigDeployer(piston) -- trigs the deployer (assuming ones currently there)
    piston:set()
    deployerTrigger:pulse()
    sleep(3) -- is this a good amount of time?
    piston:reset()
end

function doAttack() -- does a round of the attack deployer
    trigDeployer(attackPiston)
end

function doUse() -- does a round of the use deployer
    trigDeployer(usePiston) 
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
    for i=1,9 do 
        newItems[math.ceil(i/3)][i%3] = recipeChest:getItemDetail(checkSlotIDs[i])
    end
    return newItems
end

function constructTable(list)
    local nList = {{false,false,false},{false,false,false},{false,false,false}}
    for i=1,9 do
        if list[i] == nil then
            nList[math.ceil(i/3)][i%3] = true
        end
    end
    return nList
end

function checkSendWait()
    transmitMessage(constructTable(gridContents()))
    print(checkForMessageEvent())
end

function main()

    checkSendWait()

end

while true do 
    main()
end





