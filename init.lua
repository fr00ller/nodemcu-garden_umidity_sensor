--- Need to compile data befor load ---
---------------------------------------

_SSID = ""
_WIFI_PASSWORD = ""

_MQTT_PASSWORD = ""
_MQTT_USERNAME = "" 
_MQTT_CLIENTID = ""
_MQTT_SERVER = ""

_TOPIC_PUBLISHING = "raw/Garden/SoilMoinsture/Sersor/001"
_TOPIC_SUBSCRIBING = "raw/Garden/SoilMoinsture/Sersor/Get/001"

--------------------------------------- 

__VALUE_GPIO = 0

--- Wireless connection ---
--- Additional Fix :
--- Try catch retry for wireless connection meccanism
--- ((Led light))??? for correct connection visual control  


wifi.setmode(wifi.STATION)
wifi.sta.config(_SSID,_WIFI_PASSWORD)
wifi.sta.connect()
print("Waiting for Wifi Network connection .... ")
tmr.delay(8000000)   -- wait 8,000,000 us = 8 second
if wifi.sta.status() == 5 then
    print("Connected Wifi Successfully")
else
    print("Connection Wifi Problem - Error Code :" .. wifi.sta.status())
end

--- MQTT setup and handling prepare --- 
--- Additional Fix :
--- Encription using MQTT builtin certificate 
--- Implementing Callback for message recived on subscibed topic and handle request of onetime_read, status ...???


m = mqtt.Client(_MQTT_CLIENTID, 120, _MQTT_USERNAME, _MQTT_PASSWORD)

m:on("connect", function(con) print ("Connected to MQTT server at " .. _MQTT_SERVER ) end)
m:on("offline", function(con) print ("offline") end)

m:connect(_MQTT_SERVER, 1883, 0, function(conn) print("Connected to MQTT server at " .. _MQTT_SERVER) end)
tmr.delay(8000000)
m:subscribe(_TOPIC_SUBSCRIBING,0, function(conn) print("Subscribe Topic : " .. _TOPIC_SUBSCRIBING .. " . SUCCESS ") end)



--- Logical Loop ---
--- Additional Fix :
--- Separate code on multiple function (if it's possible ??? ) I'm a noob of nodemcu, every comment/suggestion is appreciate :-((
--- Implementing deep_sleep for reduce power consumpition
--- At moment this code is not testing Iìm waiting for a ESP07 board that have an AD0 port needed for interface my analog sensor


gpio.mode(2, gpio.INPUT) --- setting GPIO0 to Input (usable only for simple test) 


while(true)
do
    __REF = gpio.read(0)
    if  __REF ~= __VALUE then
        
        m:publish("_TOPIC_PUBLISHING",__REF,0,0, function(conn) print("Sent Value  " .. __REF) end)
    end

    node.dsleep(3000000)

end



