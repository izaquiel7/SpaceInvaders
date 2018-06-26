local geradorEstelar= {}
local geradorEstelar_mt = {__index = geradorEstelar}
 
function geradorEstelar.new(nEstrelas,aView,estrelaVelocidade)
    local eGroup = display.newGroup()
    local todasEstrelas     ={} 
 
    for i=0, nEstrelas do
        local estrela = display.newCircle(math.random(display.contentWidth), math.random(display.contentHeight), math.random(2,8))
        estrela:setFillColor(1,1,1)
        eGroup:insert(estrela)
        table.insert(todasEstrelas,estrela)
    end
     
   aView:insert(eGroup)
     
    local newGeradorEstelar = {
        todasEstrelas    =  todasEstrelas,
        estrelaVelocidade = estrelaVelocidade
    }
    return setmetatable(newGeradorEstelar,geradorEstelar_mt)
end
 
 
function geradorEstelar:enterFrame()
    self:moverEstrelas()
    self:checarEstrelasNoLimite()
end
 
 
function geradorEstelar:moverEstrelas()
        for i=1, #self.todasEstrelas do
              self.todasEstrelas[i].y = self.todasEstrelas[i].y+self.estrelaVelocidade
        end
 
end
function  geradorEstelar:checarEstrelasNoLimite()
    for i=1, #self.todasEstrelas do
        if(self.todasEstrelas[i].y > display.contentHeight) then
            self.todasEstrelas[i].x  = math.random(display.contentWidth)
            self.todasEstrelas[i].y = 0
        end
    end
end
 
return geradorEstelar