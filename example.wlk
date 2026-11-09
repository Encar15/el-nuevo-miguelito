class Comida {
    method aptoCeliaco()
    method valoracion()
    method esEspecial()
    method precioBase() = self.valoracion() * 300
    method precio() {
        if (self.aptoCeliaco()){
            return self.precioBase() + 1200
        }
        else {
            return self.precioBase()
        }
    } 
}

class Provoleta inherits Comida{
    const peso
    method tieneEmpanado()
    override method aptoCeliaco() = !self.tieneEmpanado() 
    override method esEspecial() = peso > 250 && self.tieneEmpanado()
    override method valoracion() = if (self.esEspecial()) return 120 else return 80
}

class BurgaDeCarne inherits Comida {
    var pesoMedallon
    var pan

    method peso() = pan.peso() + pesoMedallon
    override method aptoCeliaco() = pan.aptoCeliaco()
    override method valoracion() = self.peso() / 10
    override method esEspecial() = self.peso() > 250
}

object panIndustrial {
    method peso() = 60
    method aptoCeliaco() = false
}

object panCasero {
    method peso() = 100
    method aptoCeliaco() = true
}

object panDeMaiz{
    method peso() = 30
    method aptoCeliaco() = true
}
    
class DobleBurga inherits BurgaDeCarne {
    override method peso() = pan.peso() + pesoMedallon * 2
    override method esEspecial() = self.peso() > 500
}

class CorteDeCarne inherits Comida {
    var plato
    var estado 
    var property peso

    override method esEspecial() = self.peso() > 250 && estado == "a punto"
    override method aptoCeliaco() = true
    override method valoracion() = 100
}

class Parrillada inherits Comida {
    const componentes

    method peso() = componentes.sum({componente => componente.peso()})
    override method esEspecial() = self.peso() > 250 && componentes.size() >= 3
    override method aptoCeliaco() = componentes.all({ componente => componente.aptoCeliaco() })
    override method valoracion() = componentes.map({componente => componente.valoracion()}).max()
}

class Comensal {
    var dinero
    var property tipoComensal

    method comprar(comida){
        dinero -= comida.valoracion()
        parrilla.vender(comida, self)
    }

    method platosQuePuedeComprar(parrilla) = parrilla.platos().filter({plato => plato.valoracion() <= dinero}) 

    method leAgrada(comida) = tipoComensal.leAgrada(comida)
    
    method darseUnGusto(parrilla) {
        if(self.platosQuePuedeComprar(parrilla).isEmpty()){
            self.error("No hay platos que puedan ser comprados")
        }
        else {
            self.comprar(parrilla.platoMejorValorado(self))
        }

    }

    method cambiarTipo(nuevoHabito){
		tipoComensal = nuevoHabito
	}

    method tenerProblemasGastricos(){
		self.cambiarTipo(celiaco)
	}

    method puedeCambiarATodoTerreno() = tipoComensal.puedeCambiarATodoTerreno()
}

object celiaco{
    method leAgrada(comida) = comida.aptoCeliaco()
}

object paladarFino{
    method leAgrada(comida) = comida.esEspecial() or comida.valoracion() > 100
}

object todoTerreno {
    method leAgrada(_) = true
}

object parrilla {
    const platos = []
    var ingresos = 0
    const comensales = [] 
    
    method platoMejorValorado(cliente) = cliente.platosQuePuedeComprar(self).max({plato => plato.valoracion()})
    method vender(plato, cliente){
        ingresos += plato.valoracion()
        comensales.add(cliente)
    }

    method hacerPromocion(dineroADar){
		comensales.forEach({comensal => comensal.recibirDinero(dineroADar)})
	}

    method agregarPlatoAlMenu(plato){
		platos.add(plato)
	}
}
