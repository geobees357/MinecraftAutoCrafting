-- ugh

--[[

goofy ahh computer waits for a redstone signal, GRABS THE GIT REPO, AND EXECS THE STRING AS CODE???!
fucking dumb.

--]]


print("bruh?")

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

function Integrator:get()
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

attackPiston = 
usePiston = 
deployerTrigger = 

chest = 
funnel = 
outputChest = 

returnHopper = 
giveHopper = 

modem = peripheral.wrap("top")
channel = 5
modem.open(channel)

function transmitMessage(message)
    modem.transmit(channel, channel, message)
end

function checkForMessageEvent()
    local event, side, recivedChannel, requestChannel, message, distance = os.pullEvent("modem_message")
    return(message)
end






function main()



end

while true do 
    main()
end




