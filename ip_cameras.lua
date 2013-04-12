-- Script descriptor, called when the extensions are scanned
desired_interval = 10.00
hport = 80
hhost = "localhost"
userAgentHTTP = "VLC_player"

function descriptor()
    return { title = "Веб камеры" ;
             version = "0.1. alpha" ;
             author = "Вельмисов Олег" ;
             url = 'http://rosaski.com';
             shortdesc = "Веб камеры";
             description = "<center><b>Веб камеры</b></center><br />";
             capabilities = { "input-listener", "meta-listener", "playing-listener" } }
end
-- Activation 
function activate()
  input_callback("add")
 
end
function deactivate()
  input_callback("delete")
end

function input_changed()
  input_callback("add")
  
end

function input_callback(action)
  assert(action == "add" or action == "delete")

  local input = vlc.object.input()
  if input and action == "add" then
    vlc.var.add_callback(input, "intf-event", my_callback, "Hello world!")
  elseif input and action == "delete" then
    vlc.var.del_callback(input, "intf-event", my_callback, "Hello world!")
  end
  --"intf-event" triggers about 5x/second.
end


last_call = 0
function my_callback(var_name, old_value, new_value, user_data)
  --Ordinarily one would do this to only act every N seconds.
  if os.clock() - last_call < desired_interval then return end
  last_call = os.clock()
  --Do something periodically
     get_data()
end


function get_data()

    item = vlc.item or vlc.input.item()      		
    local metas = item:metas()			
	local name = metas["title"]
    get( hhost , hport, "/feed/?cam="..name)

end
   
 function get(host, hport, path)
                  
       local header = {
          "GET "..path.." HTTP/1.1",
          "Host: "..host,
          "User-Agent: "..userAgentHTTP,
          "",
          ""
       }
       local request = table.concat(header, "\r\n")         
       local response = http_req(host, hport, request)       
     
       return response
end

function http_req(host, port, request)
        
       local fd = vlc.net.connect_tcp(host, port)
       if fd >= 0 then       
          local pollfds = {}
          pollfds[fd] = vlc.net.POLLIN
          vlc.net.send(fd, request)
          vlc.net.poll(pollfds)
          response = vlc.net.recv(fd, 1024)
          vlc.net.close(fd)         
          return response
		  
       end
       
end

--[[
function save_to_xml()

 item = vlc.item or vlc.input.item()
		   	
          local metas = item:metas()
	
			local name = metas["title"]
			
			--vlc.osd.message(name);
	 fh = io.open('C:/nimp/htdocs/CS5/test_xml/test.xml', "w")
     fh:write("<title>"..name.."</title>")
     fh:flush()
     fh:close()
end --]]
