--[[
Copyright (c) 2013, Registry
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of autoinvite nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Registry BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
]]

_addon.name = 'Dig it out'
_addon.author = 'Cliff, Arjis(Testing)'
_addon.version = '1.1.0'
_addon.commands = {'dio'}

require('logger')

local remount = false

windower.register_event('addon command', function(command, ...)
    if command =="start" then
        if windower.ffxi.get_player()['status'] == 0 then
            windower.send_command('input /item '.. windower.to_shift_jis('チョコボホイッスル')..' <me>')
        elseif windower.ffxi.get_player()['status'] == 5 then
            go()
        end
    elseif command =="stop" then
        windower.send_command('input //fsd stop')
        windower.send_command('input //repeater stop')
        remount = true
    end
end)

function go()
    if remount then
        windower.send_command('input //fsd c')
        remount = false
    else
        windower.send_command('input //fsd loop choco')
    end
    
    windower.send_command('input //repeater command input /dig')
    windower.send_command('input //repeater delay 11')
    windower.send_command('input //repeater start')
end

windower.register_event('status change', function(new, old)
    -- log(new)
    -- log(old)
    
    if new == 5 and old == 0 then
        coroutine.sleep(5)
        go()
    elseif new == 0 and old == 5 then
        remount = true
        windower.send_command('input //fsd stop')
        windower.send_command('input //repeater stop')
        log('wait 5 seconds to re-ride...')
        coroutine.sleep(5)
        windower.send_command('input /item '.. windower.to_shift_jis('チョコボホイッスル')..' <me>')
    end
end)

windower.register_event('load', function()
    windower.send_command("input //lua r fsd")
    windower.send_command("input //lua r repeater")
end)

windower.register_event('unload', function()
    windower.send_command("input //lua u fsd")
    windower.send_command("input //lua u repeater")
end)