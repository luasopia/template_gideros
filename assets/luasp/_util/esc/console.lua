local luasp = _luasopia
local esclayer = luasp.esclayer
local Disp = Display
local infocolor = Color.LIGHT_PINK
local fontsize0 = 40

--------------------------------------------------------------------------------
_require0('luasp._util.file')

luasp.console = Group():addto(esclayer):setxy(0,0)

--------------------------------------------------------------------------------

local xgap = luasp.config.gridxgap
local ygap = luasp.config.gridygap
local color = Color.DARK_SLATE_GRAY
local width = 2

local gridlines = Group():addto(luasp.console):setxy(0,0)
luasp.console.gridlines = gridlines

for x = xgap, screen.width0, xgap do
    local g = Line1(x, 0, x, screen.height0, {width=width, color=color})
    -- g:addto(esclayer)
    g:addto(gridlines)
    if _Corona then g:setxy(x,0) end
end

for y = ygap, screen.height0, ygap do
    local g = Line1(0, y, screen.width0, y, {width=width, color=color})
    -- g:addto(esclayer)
    g:addto(gridlines)
    if _Corona then g:setxy(0,y) end
end

--------------------------------------------------------------------------------

local getTxtMem
if _Gideros then
		
    getTxtMem = function()
        return _Gideros.application:getTextureMemoryUsage()
    end


    function Group:__numTotalChildren__()

        local total = 0

        for k = self.__bd:getNumChildren(),1,-1 do

            total = total + 1

            local dobj = self.__bd:getChildAt(k).__obj 
            if isobject(dobj, Group) then
                total = total + dobj:__numTotalChildren__()
            end

        end

        return total

    end


elseif _Corona then
    
    getTxtMem = function()
        return system.getInfo("textureMemoryUsed") / 1000
    end

    function Group:__numTotalChildren__()

        local total = 0

        for k = self.__bd.numChildren,1,-1 do

            total = total + 1

            local dobj = self.__bd[k].__obj 
            if isobject(dobj, Group) then
                total = total + dobj:__numTotalChildren__()
            end

        end

        return total

    end

end

--------------------------------------------------------------------------------

local infotxts = Group():addto(luasp.console):setxy(0,75)
luasp.console.infotxts = infotxts

local txtopt = {color=infocolor, fontsize=fontsize0}
local memtxt = Text1("",txtopt):addto(infotxts):setxy(10, 40)
local objtxt = Text1("",txtopt):addto(infotxts):setxy(10, 80)


local etctxt1 = Text1("",txtopt):addto(infotxts):setxy(10, screen.endy-85-80)
etctxt1:setstrf('(content) resolution : %d x %d',screen.width, screen.height)

local etctxt2 = Text1("",txtopt):addto(infotxts):setxy(10, screen.endy-85-40)
etctxt2:setstrf('(deivce) resolution : %d x %d',screen.devicewidth, screen.deviceheight)

local etctxt3 = Text1("",txtopt):addto(infotxts):setxy(10, screen.endy-85)
etctxt3:setstrf("orientation:'%s', fps:%d", screen.orientation, screen.fps)

local updInfo = function(self, e)

    local txtmem = getTxtMem()
    local mem = collectgarbage('count')
    memtxt:setstrf('memory:%d kb, texture memory:%d kb', mem, txtmem)
    -- local ndisp = Disp.__getNumObjs() -- - logf.__getNumObjs() - 2
    local ndisp = luasp.stage:__numTotalChildren__()
    objtxt:setstrf('fps:%3d, #Display:%d, #Timer:%d, #Scene:1', 1/e.deltaTime, ndisp, Timer.__getNumObjs())
        
end

screen:__addupd12__(updInfo)
-- updateInfo()
-- local tmrInfo = Timer(200, updateInfo, INF)
-- tmrInfo.__nocnt = true

--------------------------------------------------------------------------------


function luasp.console:show()

    luasp.stdout:setalpha(0.4)
    esclayer:show()
    
    local h = luasp.console.toolbar.height
    local tmshift=180
    luasp.console.toolbar:sety(-h):shift{time=tmshift,y=0}
    luasp.console.infotxts:setalpha(0):shift{time=tmshift,alpha=1}
    luasp.console.gridlines:setalpha(0):shift{time=tmshift,alpha=1}
    
    luasp.console.isactive = true
    screen:__addupd12__(updInfo)

end
        
function luasp.console:hide()

    luasp.stdout:setalpha(1)
    esclayer:hide()
    screen:__rmupd12__(updInfo)
    luasp.console.isactive = false

end
--------------------------------------------------------------------------------

local toolbar = _require0('luasp._util.esc.toolbar')
luasp.console:add(toolbar)
luasp.console.toolbar = toolbar