-- ugh

--[[

goofy ahh computer waits for a redstone signal, GRABS THE GIT REPO, AND EXECS THE STRING AS CODE???!
fucking dumb.

--]]


--print("bruh?")

Integrator = {}

function Integrator:set(val)
    assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    self.peripheral.setOutput(self.side, val)
end

function Integrator:pulse()
    assert(self.defaultVal ~= nil, "defaultVal was nil, and shouldnt be for a input integrator!")
    self.set(not self.defaultVal)
    sleep(0.1) -- one redstone tick, should be enough?
    self.set(self.defaultVal)
end

function Integrator:get() -- not actually needed anymore,, but yea
    assert(self.defaultVal == nil, "defaultVal was not nil, and needs to be for a input integrator!")
    return self.peripheral.getInput(self.side)
end

-- defaultVal is the default value. pass in NIL if this is an input
function Integrator:new(peripheral, side, defaultVal)
    
    -- wtf?
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- define vars
    self.peripheral = peripheral
    self.side = side 
    self.defaultVal = defaultVal

    -- setup
    if defaultVal then
        self.set(self.defaultVal)
    end

    return obj
end

function Container:list()
    return self.peripheral.list()
end

function Container:size()
    return self.size
end

function Container:pushItem(other, from, to)
    self.peripheral.pushItems(peripheral.getName(other), from, 64, to)
end

function Container:getItemDetail(slot)
    return self.peripheral.getItemDetail(slot)
end

function Container:new(peripheral)
    
    -- wtf?
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- define vars
    self.peripheral = peripheral
    self.size = peripheral.size()

    return obj
end

-- integrators

attackPiston = Integrator:new(peripheral.wrap("redstoneIntegrator_11"), "back", false) -- piston for the attack deployer
usePiston = Integrator:new(peripheral.wrap("redstoneIntegrator_7"), "back", false) -- piston for the use deployer

deployerTrigger = Integrator:new(peripheral.wrap("redstoneIntegrator_10"), "bottom", true) -- redstone for triging the deployer

funnel = Integrator:new(peripheral.wrap("redstoneIntegrator_9"), "bottom", false)  -- trigs the funnel
outputBufferSend = Integrator:new(peripheral.wrap("redstoneIntegrator_8"), "front", true) -- trig the sending of item from output buffer

-- containers

recipeChest = Container:new(peripheral.wrap("barrel_2"))
outputBuffer = Container:new(peripheral.wrap("barrel_1"))

returnHopper = Container:new(peripheral.wrap("hopper_0"))
giveHopper = Container:new(peripheral.wrap("hopper_1"))

-- init

modem = peripheral.wrap("top")
channel = 5
modem.open(channel)

checkSlotIDs = {1,2,3,10,11,12,19,20,21}
slotToCraft = { -- index based map of what slot to where in the "crafter"
    {1, 1},


}

function transmitMessage(message)
    modem.transmit(channel, channel, message)
end

function checkForMessageEvent()
    local event, side, recivedChannel, requestChannel, message, distance = os.pullEvent("modem_message")
    return message
end


--check items in choosen slots 
function gridContents(slot)
    local newItems = {}


    for i=1,9 do 
        recipeChest.getItemDetail
    end
    return newItems
end



function main()



end

while true do 
    main()
end




