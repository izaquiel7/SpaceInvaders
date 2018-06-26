local composer = require("composer")
local scene = composer.newScene()
local geradorEstelar = require("geradorestelar")
local textoPulsador = require("textopulsador")
local proximoBut
local geradorE
function scene:create( event )
    local group = {}  
    group  = self.view
    geradorE =  geradorEstelar.new(200,group,5)
    local   textoI =  textoPulsador.new("NIVEL COMPLETO", display.contentCenterX, display.contentCenterY-200,"Conquest", 20,group )
    textoI:colocarCor( 1, 1, 1 )
    textoI:pulsar()
    proximoBut = display.newImage("next_level_btn.png",display.contentCenterX, display.contentCenterY)
    proximoBut.width = 320
    proximoBut.height = 150
    group:insert(proximoBut)
 end
 
function scene:show( event )
    local phase = event.phase
    composer.removeScene("game" )
    if ( phase == "did" ) then
      proximoBut:addEventListener("tap",iniciarNovoGame)
      Runtime:addEventListener ( "enterFrame", geradorE)
    end
end
 
function scene:hide(event )
    local phase = event.phase
    if ( phase == "will" ) then
        Runtime:removeEventListener("enterFrame", geradorE)
        proximoBut:removeEventListener("tap",iniciarNovoGame)
    end
end
 
 
function iniciarNovoGame()
    composer.gotoScene("game")
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
 
return scene