local ipfunc = {}

function ipfunc.getIPNetwork(ip_with_mask)
    local a, b, ip1, ip2, ip3, ip4, mask = ip_with_mask:find( '(%d+).(%d+).(%d+).(%d+)/(%d+)')
    if not a then return print( 'invalid ip' ) end

    local ip = { tonumber( ip1 ), tonumber( ip2 ), tonumber( ip3 ), tonumber( ip4 ) }

    --list masks => wildcard
    local masks = {
        [1] = { 127, 255, 255, 255 },
        [2] = { 63, 255, 255, 255 },
        [3] = { 31, 255, 255, 255 },
        [4] = { 15, 255, 255, 255 },
        [5] = { 7, 255, 255, 255 },
        [6] = { 3, 255, 255, 255 },
        [7] = { 1, 255, 255, 255 },
        [8] = { 0, 255, 255, 255 },
        [9] = { 0, 127, 255, 255 },
        [10] = { 0, 63, 255, 255 },
        [11] = { 0, 31, 255, 255 },
        [12] = { 0, 15, 255, 255 },
        [13] = { 0, 7, 255, 255 },
        [14] = { 0, 3, 255, 255 },
        [15] = { 0, 1, 255, 255 },
        [16] = { 0, 0, 255, 255 },
        [17] = { 0, 0, 127, 255 },
        [18] = { 0, 0, 63, 255 },
        [19] = { 0, 0, 31, 255 },
        [20] = { 0, 0, 15, 255 },
        [21] = { 0, 0, 7, 255 },
        [22] = { 0, 0, 3, 255 },
        [23] = { 0, 0, 1, 255 },
        [24] = { 0, 0, 0, 255 },
        [25] = { 0, 0, 0, 127 },
        [26] = { 0, 0, 0, 63 },
        [27] = { 0, 0, 0, 31 },
        [28] = { 0, 0, 0, 15 },
        [29] = { 0, 0, 0, 7 },
        [30] = { 0, 0, 0, 3 },
        [31] = { 0, 0, 0, 1 }
    }

    --get wildcard
    local wildcard = masks[tonumber( mask )]

    --number of ips in mask
    local ipcount = math.pow( 2, ( 32 - mask ) )

    --network IP (route/bottom IP)
    local bottomip = {}
    for k, v in pairs( ip ) do
        --wildcard = 0?
        if wildcard[k] == 0 then
            bottomip[k] = v
        elseif wildcard[k] == 255 then
            bottomip[k] = 0
        else
            local mod = v % ( wildcard[k] + 1 )
            bottomip[k] = v - mod
        end
    end

    --use network ip + wildcard to get top ip
    local topip = {}
    for k, v in pairs( bottomip ) do
        topip[k] = v + wildcard[k]
    end

    --is input ip = network ip?
    local isnetworkip = ( ip[1] == bottomip[1] and ip[2] == bottomip[2] and ip[3] == bottomip[3] and ip[4] == bottomip[4] )
    local isbroadcastip = ( ip[1] == topip[1] and ip[2] == topip[2] and ip[3] == topip[3] and ip[4] == topip[4] )

    return bottomip[1] .. '.' .. bottomip[2] .. '.' .. bottomip[3] .. '.' .. bottomip[4] .. '/' .. mask;
end

return ipfunc
