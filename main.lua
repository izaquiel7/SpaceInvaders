-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here

display.setStatusBar(display.HiddenStatusBar)-- Esconde barra de status**

--- Define pontos de registros dos objetos**
display.setDefault("anchorX", 0.5)
display.setDefault("anchorY", 0.5)
--*_*--
math.randomseed( os.time())-- Define numeros randomicos

local gamedados = require("gamedados")

--- requere uma biblioteca lua, composer.
--- Este é responsavél por gerenciar e contruir elementos na tela.
local composer = require("composer")

composer.gotoScene("inicio") -- chamando cena sem precisar extender outro arquivo lua.


--- Se precisar de algum somuse isto.
--  local laserSound = audio.loadSound( "laser.mp3" )
--  local laserChannel = audio.play( laserSound )
--  audio.dispose(laserChannel)