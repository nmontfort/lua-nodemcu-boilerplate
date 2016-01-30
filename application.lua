local module = {}  
m = nil

-- Sends a simple ping to the broker
local function send_ping()  
    m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
end

-- Sends a simple ping to the broker
local function send_temperature()
    pin = 5
    status,temp,humi,temp_decimial,humi_decimial = dht.readxx(pin)
    if( status == dht.OK ) then
      -- Float firmware using this example
      data = '{ "node" : "'..config.ENDPOINT..'", '..'"temperature" : '..temp..', '..'"humidity" : '..humi.. '}'
    elseif( status == dht.ERROR_CHECKSUM ) then
      data = "DHT Checksum error.";
    elseif( status == dht.ERROR_TIMEOUT ) then
      data = "DHT Time out.";
    end  
    m:publish(config.ENDPOINT .."/".. "temperature",data,0,0)
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120, config.USERNAME, config.PASSWORD)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        --tmr.alarm(6, 1000, 1, send_ping)
        tmr.alarm(6, 5000, 1, send_temperature)
    end) 

end

function module.start()  
  mqtt_start()
end

return module
