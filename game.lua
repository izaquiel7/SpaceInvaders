

local composer = require("composer")
local scene = composer.newScene()
local geradorEstelar = require("geradorestelar")
local textoPulsador = require("textopulsador")
local physics = require("physics")
local gameDados = require( "gamedados" )
physics.start()
local geradorE
local nave
local naveH = 105
local naveW = 150
local invasorSize = 100 -- altura e largura do invasor
local margemL = 20 -- margem esquerda
local margemR = display.contentWidth - 20 -- a margem direita
local invasorMetade = 16
local invasores = {} -- guarda todos os invasores
local invasorVeloci = 2.5
local balasNave = {} -- guarda as balas da nave
local podeAtirar = true
local invasorAtirador = {} -- guarda invasores atiradores
local balasInvasores = {}
local nVidas = 3
local naveImortal = false
local linhaInvasoresAtiradores = 5
local invasorTimerTiro -- timer usado para atira as balas dos invasores
local fimDeGame = false;
local botoes = {}  -- botão que move a nave, so pra teste
local ativaTimerTiro -- timer para deixar nave atirar

function scene:create(event)
    local group = self.view
    geradorE= geradorEstelar.new(200,group,3)
    configurarNave()
  --  botoes()
    configurarInvasor()
end

function scene:show(event)
    local phase = event.phase
    local cenaAnterior = composer.getSceneName( "previous" )
    composer.removeScene(cenaAnterior)
    local group = self.view
    if ( phase == "did" ) then
    	Runtime:addEventListener("enterFrame", gameLoop)
    	Runtime:addEventListener("enterFrame", geradorE)
    	Runtime:addEventListener("tap", atirarBalasNave)
    	Runtime:addEventListener("collision", onCollision)
        invasorTimerTiro =    timer.performWithDelay(1500, atirarBalasInvasor,-1)
     end
end

function scene:hide(event)
    local phase = event.phase
    local group = self.view
    if ( phase == "will" ) then
    	Runtime:removeEventListener("enterFrame", gameLoop)
        Runtime:removeEventListener("enterFrame", geradorE)
        Runtime:removeEventListener("tap", atirarBalasNave)
        Runtime:removeEventListener("collision", onCollision)
        timer.cancel(invasorTimerTiro)
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

function configurarNave()
    local options = { width = naveW, height = naveH, numFrames = 2}
    nave = display.newImage("ship_r.png", display.contentCenterX, display.contentCenterY-300, options)
    nave.name = "nave"
    nave.x = display.contentCenterX- naveW/10
    nave.y = display.contentHeight - naveH +50
   -- nave:play()
   nave.width = naveW
   nave.height = naveH
   scene.view:insert(nave)

    physics.addBody( nave, "shapedefs")
    nave.gravityScale = 0
end

local function onAccelerate(event)  -- No celular se vc virar o cell a nave se movimenta.
nave.x = display.contentCenterX + (display.contentCenterX * (event.xGravity*2))
end
system.setAccelerometerInterval( 60 )
Runtime:addEventListener ("accelerometer", onAccelerate)
--[[
function botoes()
    local function moverNave(event)
        if event.target.name == "esquerda" then
            nave.x = nave.x - 10
        elseif event.target.name == "direita" then
            nave.x = nave.x + 10
        end
    end

    local esquerda = display.newRect(60,700,50,50)
    esquerda.name = "esquerda"
    scene.view:insert(esquerda)
    local direita = display.newRect(display.contentWidth-60,700,50,50)
    direita.name = "direita"
    scene.view:insert(direita)
    esquerda:addEventListener("touch", moverNave)
    direita:addEventListener("touch", moverNave) 

end]]

function atirarBalasNave()
    if podeAtirar == true then
        local laser = display.newImage("laser.png", nave.x, nave.y - naveH/ 2)
        laser.name = "laser"
        scene.view:insert(laser)
        physics.addBody(laser, "dynamic" )
        laser.gravityScale = 0
        laser.isBullet = true
        laser.isSensor = true
        laser:setLinearVelocity( 0,-400)
        table.insert(balasNave,laser)

        podeAtirar = false
 
    else
        return
    end

    local function ativarLasers()
        podeAtirar = true
    end
    
    timer.performWithDelay(500,ativarLasers,1)
end

function checarBalasNaveForaLimite()
    if #balasNave > 0 then
        for i=#balasNave,1,-1 do
            if balasNave[i].y < 0 then
                balasNave[i]:removeSelf()
                balasNave[i] = nil
                table.remove(balasNave,i)
            end
        end
    end
end


function gameLoop()
	checarBalasNaveForaLimite()
    moverInvasores()
    checarBalasInvasoresForaLimite()
end


---
---- Criando Invasores -->
---

function configurarInvasor()
    local xPosicaoInicio = display.contentCenterX - invasorMetade - (gameDados.numInvasor *(invasorSize + 10))
    local nInvasores = gameDados.numInvasor *2+1 
    for i = 1, gameDados.linhaDeInvasores do
        for j = 1, nInvasores do
            local tinvasor = display.newImage("invader_1.png",xPosicaoInicio + ((invasorSize+10)*(j-1)), i * 80 )
            tinvasor.name = "invasor"
            tinvasor.width = invasorSize
            tinvasor.height = invasorSize
            if i== gameDados.linhaDeInvasores then
                table.insert(invasorAtirador,tinvasor)
            end
            physics.addBody(tinvasor, "dynamic" )
            tinvasor.gravityScale = 0
            tinvasor.isSensor = true
            scene.view:insert(tinvasor)
            table.insert(invasores,tinvasor)
        end
    end
end

function moverInvasores()
    local mudaDirecao = false
    for i=1, #invasores do
          invasores[i].x = invasores[i].x + invasorVeloci
        if invasores[i].x > margemR - invasorMetade or invasores[i].x < margemL + invasorMetade then
            mudaDirecao = true;
        end
     end
    if mudaDirecao == true then
        invasorVeloci = invasorVeloci*-1
        for j = 1, #invasores do
            invasores[j].y = invasores[j].y+ 46
        end
        mudaDirecao = false;
    end 
end

--
--- Tratando colisões --->
--

function onCollision(event)
	local function removerNaveEinvasoresBalas(event)
    
    local params = event.source.params
    local indiceInvasor = table.indexOf(invasores,params.oInvasor)
    local invasoresPorLinha = gameDados.numInvasor *2+1
        if indiceInvasor > invasoresPorLinha  then
            table.insert(invasorAtirador, invasores[indiceInvasor - invasoresPorLinha])
    	end
        params.oInvasor.isVisible = false
        physics.removeBody(params.oInvasor)
        table.remove(invasorAtirador, table.indexOf(invasorAtirador, params.oInvasor))
         
        if table.indexOf(balasNave,params.asBalasNave)~=nil then
            physics.removeBody(params.asBalasNave)
            table.remove(balasNave,table.indexOf(balasNave,params.asBalasNave))
            display.remove(params.asBalasNave)
            params.asBalasNave = nil
        end
    end
       
    	if  event.phase == "began"  then
            
            if event.object1.name == "invasor" and event.object2.name == "laser" then
                local tm = timer.performWithDelay(10, removerNaveEinvasoresBalas,1)
                tm.params = {oInvasor = event.object1 , asBalasNave = event.object2}
            end
            if event.object1.name == "laser" and event.object2.name == "invasor"  then
                local tm = timer.performWithDelay(10, removerNaveEinvasoresBalas,1)
                tm.params = {oInvasor = event.object2 , asBalasNave = event.object1}
            end
end
            if(event.object1.name == "nave" and event.object2.name == "laseri") then
            table.remove(balasInvasores,table.indexOf(balasInvasores,event.object2))
            event.object2:removeSelf()
            event.object2 = nil
            if(naveImortal == false) then
            destruirNave()
            end
               if(event.object1.name == "laseri" and event.object2.name == "nave") then
            table.remove(balasInvasores,table.indexOf(balasInvasores,event.object1))
            event.object1:removeSelf()
            event.object1 = nil
            if(naveImortal == false) then
                destruirNave()
            end
        

           if(event.object1.name == "nave" and event.object2.name == "invasor") then
            nVidas = 0
            destruirNave()
        end
         
         if(event.object1.name == "invasor" and event.object2.name == "nave") then
            nVidas = 0
            destruirNave()
            end
        end
    end
end

function destruirNave()
    nVidas = nVidas- 1;
      if(nVidas <= 0) then
        gameDados.invaderNum  = 1
        composer.gotoScene("inicio")
    else
        naveImortal = true
        invocarNovaNave()
    end
end

function invocarNovaNave()
    local nVezesFadeNave = 5
    local nVezesFoiFaded = 0
     
    local  function transparecerNave()
        nave.alpha = 0;
        transition.to( nave, {time=400, alpha=1,  })
        nVezesFoiFaded = nVezesFoiFaded+ 1
        if nVezesFoiFaded == nVezesFadeNave then
            naveImortal = false
        end
    end
     
  transparecerNave()
  timer.performWithDelay(400, transparecerNave,nVezesFadeNave)
end 

function atirarBalasInvasor()
    if #invasorAtirador >0  then
        local randomIndice = math.random(#invasorAtirador)
        local randomInvasor = invasorAtirador[randomIndice]
        local tlaserl = display.newImage("laser.png", randomInvasor.x , randomInvasor.y + invasorSize/2)
        tlaserl.name = "laseri"
        scene.view:insert(tlaserl)
        physics.addBody(tlaserl, "dynamic" )
        tlaserl.gravityScale = 0
        tlaserl.isBullet = true
        tlaserl.isSensor = true
        tlaserl:setLinearVelocity( 0,400)
        table.insert(balasInvasores, tlaserl)
    else
        completarNivel()
    end  
end

function checarBalasInvasoresForaLimite() -- impede que a bala do invasor continue para o infinito e alem. *_*
    if (#balasInvasores > 0) then
        for i=#balasInvasores,1,-1 do
            if(balasInvasores[i].y > display.contentHeight) then
                balasInvasores[i]:removeSelf()
                balasInvasores[i] = nil
                table.remove(balasInvasores,i)
            end
        end
    end
end

function completarNivel()
    gameDados.numInvasor  = gameDados.numInvasor  + 1
    if gameDados.numInvasor  <= gameDados.maxLevels  then
         composer.gotoScene("gameover")
    else
        gameDados.numInvasor  = 1
        composer.gotoScene("inicio")
     end
end


--
---code acima do return
return scene