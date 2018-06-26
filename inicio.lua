--
---start.lua esta na hierarquia de composer, ou seja, é um filho.
--
local composer = require("composer")

local scene = composer.newScene()

local startBtn -- usado para iniciar o jogo
local textoPulsador = require("textopulsador") -- modulo que fornece um efeito para o texto *.*
local geradorEstelar = require("geradorestelar") -- gera campo gerador de estrelas.
local geradorE -- 
function scene:create( event )
    local group = self.view
    geradorE =  geradorEstelar.new(200,group,5) -- gera estrelas na tela
    startBtn = display.newImage("new_game_btn.png",display.contentCenterX,display.contentCenterY+100)
    startBtn.width = 420
    startBtn.height = 130
    group:insert(startBtn)

    local textoI =  textoPulsador.new("   SPACE\nINVADERS",display.contentCenterX,display.contentCenterY-200,"Conquest", 20, group)
    textoI:colocarCor( 0, 1, 1 )
    textoI:pulsar()
end

function scene:show( event )
    local phase = event.phase
    local cenaAnterior = composer.getSceneName( "previous" )
    if cenaAnterior~=nil then
        composer.removeScene(cenaAnterior)
    end
   if  phase == "did"  then -- fase did é chamada quando a scena esta na tela, aqui o code funciona.
   		Runtime:addEventListener("enterFrame", geradorE)
   		startBtn:addEventListener("tap",iniciarGame)
   end
end

function scene:hide( event )
    local phase = event.phase
    if  phase == "will"  then -- fase will é chamada antes da scena esta na tela.
        startBtn:removeEventListener("tap",iniciarGame) -- aqui vamos remover o que estava na tela.
        Runtime:removeEventListener("enterFrame", geradorE) -- remover as estrelas da tela.
    end
end

function iniciarGame()
    composer.gotoScene("game") -- gamelevel é filho de composer.
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

--
---todos os codigos devem vir acima deste return.
return scene