local module = {}

module.SSID = {}

-- configure SSID 
module.SSID["<SSID_NAME>"] = "<SSID_PASSWORD>"

-- configure MQTT broker
module.HOST = "<IP_ADDRESS>"  
module.PORT = 1883
module.USERNAME = "<MQTT_USERNAME>"
module.PASSWORD = "<MQTT_PASSWORD>"
module.ID = node.chipid()

-- configure topic endpoint
module.ENDPOINT = "nodemcu1"  

return module  
