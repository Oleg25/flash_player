vlc.msg.info( "starting..." )

  
   function get_title()       
      local item = vlc.input.item()
      local metas = item:metas()	
      name = metas["title"]      
      return name;       
    end

     function get_ip()
       local item = vlc.input.item()
       return string.sub(item:name(),8,18)
      end


    function get_time()
      local input = vlc.object.input()
      t = math.floor(vlc.var.get( input, "time" ))
      return t
     end


 function get(host, hport, path)
                  
       local header = {
          "GET "..path.." HTTP/1.1",
          "Authorization: Basic YWRtaW46bWVpbnNt",
          "Host: "..host,
          "User-Agent: VLC",
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
                    
          vlc.net.send(fd, request)
          response = vlc.net.recv(fd, 1024)
          vlc.net.close(fd)
          return response
                
      end      
  end
  
  function check_cam()
   
     v1 = get_time()
     name = get_title()
     os.execute("sleep 3")
     v2 = get_time()
       
      if (v1 == 0 and v2 == 0) then 
       vlc.msg.info("zero")

      elseif v1 == v2 then
      
        vlc.msg.err("Camera on"..name.."not respond in time... try to reboot camera")
        url = get_url()
        get(url  ,"80", "/admin/rcontrol?action=reboot")
        
      else
     
     vlc.msg.info("good")
     
    end
  end  


    
  os.execute("sleep 15")
 
  --get("172.19.1.10"  ,"80", "/admin/rcontrol?action=reboot")

    while vlc.input.item() do
      
      os.execute("sleep 25")
      --vlc.msg.info( get_url() );
      check_cam()
    end
