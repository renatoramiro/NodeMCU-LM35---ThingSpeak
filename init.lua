temp = 0;

-- Conectando-se ao roteador
wifi.setmode(wifi.STATION)
-- SSID e senha do roteador
wifi.sta.config("TESTE VIRUS","winarrel")
-- Exibe o IP da conexao realizada
print(wifi.sta.getip())

function send_data()
    get_temp()
    
    conn=net.createConnection(net.TCP,0)
    conn:on("receive", function(sck, c) print(c) end )
        conn:connect(80, "184.106.153.149")
        conn:send("GET /update?key=PU7H1P01437FY16Q&field1="..string.format("%04d", temp).." HTTP/1.1\r\n")
        conn:send("Host: api.thingspeak.com\r\n")
        conn:send("Accept: */*\r\n")
        conn:send("User-Agent: Mozilla/41.0.2 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
        conn:send("\r\n")
        
    conn:on("sent",function(conn)
        print("Closing connection")
        conn:close()
    end)
    
    conn:on("disconnection", function(conn)
        print("Got disconnection...")
    end)
end

-- Timer: Executa a funcao send_data a cada 600000 ms (1 minuto)
tmr.alarm(0, 600000, 1, function() send_data() end )

-- Funcao para converter o valor lido pelo ADC no valor da temperatura
function get_temp()
    val = adc.read(0);
    temp = val*161/512;
    print(temp);
    print(string.format("%04d", temp));
end

