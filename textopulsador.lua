local textoPulsador = {}
local textoPulsador_mt = {__index = textoPulsador}
 
function textoPulsador.new(texto,posicaoX,posicaoY,fonte,fonteTama,oGroup)
      local campodetexto = display.newText(texto,posicaoX,posicaoY,fonte,fonteTama)
       
local newtextoPulsador = {
    campodetexto = campodetexto}

    oGroup:insert(campodetexto)                                             
    return setmetatable(newtextoPulsador,textoPulsador_mt)
end
 
function textoPulsador:colocarCor(r,b,g)
  self.campodetexto:setFillColor(r,g,b)
end
 
function textoPulsador:pulsar()
    transition.to( self.campodetexto, { xScale=4.0, yScale=4.0, time=1500, iterations = -1} )
end
 
return textoPulsador