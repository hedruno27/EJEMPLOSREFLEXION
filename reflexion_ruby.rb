puts "=== REFLEXIÓN Y DUCK TYPING EN RUBY ===\n"

# Definir clases
class Persona
  attr_accessor :nombre, :edad
  
  def initialize(nombre, edad)
    @nombre = nombre
    @edad = edad
  end
  
  def saludar
    "Hola, soy #{@nombre}"
  end
  
  def cumplir_años
    @edad += 1
    "Ahora tengo #{@edad} años"
  end
end

# 1. OBTENER INFORMACIÓN DE LA CLASE
puts "1. INFORMACIÓN DE LA CLASE"
puts "   Nombre: #{Persona.name}"
puts "   Clase de la clase: #{Persona.class}"
puts "   Superclase: #{Persona.superclass}"

# 2. OBTENER MÉTODOS
puts "\n2. MÉTODOS DE LA CLASE"
metodos = Persona.instance_methods(false)  # false = sin métodos heredados
puts "   Métodos propios: #{metodos.inspect}"

# 3. VERIFICAR SI EXISTE MÉTODO
puts "\n3. VERIFICAR EXISTENCIA DE MÉTODO"
puts "   ¿Tiene método 'saludar'? #{Persona.instance_methods(false).include?(:saludar)}"
puts "   ¿Tiene método 'volar'? #{Persona.instance_methods(false).include?(:volar)}"

# 4. INVOCAR MÉTODO DINÁMICAMENTE CON send()
puts "\n4. INVOCAR MÉTODO DINÁMICAMENTE"
persona = Persona.new("Juan", 30)
resultado = persona.send(:saludar)
puts "   Resultado: #{resultado}"

# Llamar método sin saber el nombre hasta runtime
nombre_metodo = "cumplir_años"
puts "   Llamando #{nombre_metodo}: #{persona.send(nombre_metodo.to_sym)}"

# 5. OBTENER INFORMACIÓN DEL OBJETO
puts "\n5. INFORMACIÓN DEL OBJETO"
puts "   Clase: #{persona.class}"
puts "   Métodos (primeros 5): #{persona.methods(false).first(5).inspect}"
puts "   Variables de instancia: #{persona.instance_variables.inspect}"

# 6. ACCEDER A VARIABLES DE INSTANCIA DINÁMICAMENTE
puts "\n6. ACCESO DINÁMICO A VARIABLES DE INSTANCIA"
puts "   @nombre actual: #{persona.instance_variable_get(:@nombre)}"
persona.instance_variable_set(:@nombre, "Carlos")
puts "   @nombre modificada: #{persona.instance_variable_get(:@nombre)}"

# 7. OBTENER VARIABLES DE INSTANCIA Y SUS VALORES
puts "\n7. VARIABLES DE INSTANCIA Y SUS VALORES"
persona.instance_variables.each do |var|
  valor = persona.instance_variable_get(var)
  puts "   #{var} = #{valor}"
end

# 8. AGREGAR MÉTODOS DINÁMICAMENTE CON define_method
puts "\n8. AGREGAR MÉTODOS DINÁMICAMENTE"
class Clase1
end

Clase1.define_method(:saludar) do
  "Hola desde método dinámico"
end

obj = Clase1.new
puts "   #{obj.saludar}"

# 9. method_missing - Manejar métodos no definidos
puts "\n9. METHOD_MISSING - MÉTODOS DINÁMICOS"
class PeticionDinamica
  def method_missing(metodo, *args)
    "Se llamó a #{metodo} con argumentos: #{args.inspect}"
  end
end

dinamico = PeticionDinamica.new
puts "   #{dinamico.hacer_algo(1, 2, 3)}"
puts "   #{dinamico.procesar_datos('archivo.txt')}"

# 10. DUCK TYPING - Ejemplo 1: quack()
puts "\n10. DUCK TYPING - EJEMPLO 1: quack()"
class Pato
  def quack
    "¡Cuac cuac!"
  end
end

class Persona2
  def quack
    "Hola, estoy fingiendo ser un pato"
  end
end

class Juguete
  def quack
    "Sonido de juguete: beep boop"
  end
end

def hacer_quack(objeto)
  objeto.quack  # No importa la clase
end

puts "   Pato: #{hacer_quack(Pato.new)}"
puts "   Persona: #{hacer_quack(Persona2.new)}"
puts "   Juguete: #{hacer_quack(Juguete.new)}"

# 11. DUCK TYPING - Ejemplo 2: length()
puts "\n11. DUCK TYPING - EJEMPLO 2: length()"
class Texto
  def initialize(contenido)
    @contenido = contenido
  end
  
  def length
    @contenido.length
  end
end

class Video
  def initialize(duracion)
    @duracion = duracion
  end
  
  def length
    @duracion
  end
end

class Cancion
  def initialize(duracion)
    @duracion = duracion
  end
  
  def length
    @duracion
  end
end

def mostrar_duracion(objeto)
  puts "   Duración: #{objeto.length}"
end

mostrar_duracion(Texto.new("Hola mundo"))
mostrar_duracion(Video.new(120))
mostrar_duracion(Cancion.new(180))

# 12. DUCK TYPING - Ejemplo 3: save()
puts "\n12. DUCK TYPING - EJEMPLO 3: save()"
class Usuario
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    "Guardando usuario: #{@nombre} en BD"
  end
end

class Archivo
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    "Guardando archivo: #{@nombre} en disco"
  end
end

class ConfiguracionCloud
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    "Sincronizando configuración: #{@nombre} en la nube"
  end
end

def guardar_todo(objetos)
  objetos.each { |obj| puts "   #{obj.save}" }
end

objetos = [
  Usuario.new("Juan"),
  Archivo.new("documento.pdf"),
  ConfiguracionCloud.new("settings.yml")
]

guardar_todo(objetos)

# 13. METAPROGRAMMING - Crear getters y setters automáticamente
puts "\n13. METAPROGRAMMING - CREAR GETTERS/SETTERS AUTOMÁTICAMENTE"
class Empleado
  def self.crear_atributos(*nombres)
    nombres.each do |nombre|
      define_method(nombre) { instance_variable_get("@#{nombre}") }
      define_method("#{nombre}=") { |valor| instance_variable_set("@#{nombre}", valor) }
    end
  end
  
  crear_atributos :nombre, :salario, :departamento
end

empleado = Empleado.new
empleado.nombre = "Carlos"
empleado.salario = 5000
empleado.departamento = "Ventas"

puts "   Empleado: #{empleado.nombre}"
puts "   Salario: $#{empleado.salario}"
puts "   Departamento: #{empleado.departamento}"

# 14. METAPROGRAMMING - Ejecutar métodos dinámicamente
puts "\n14. METAPROGRAMMING - EJECUTAR MÉTODOS DINÁMICAMENTE"
class API
  def obtener_datos
    "Datos obtenidos"
  end
  
  def procesar_datos
    "Datos procesados"
  end
  
  def guardar_datos
    "Datos guardados"
  end
  
  def generar_reporte
    "Reporte generado"
  end
end

api = API.new

# Encontrar y ejecutar métodos que empiezan con "obtener" u "procesar"
metodos = api.methods(false).select { |m| m.to_s.start_with?('obtener', 'procesar') }
puts "   Métodos encontrados: #{metodos.inspect}"
metodos.each do |m|
  resultado = api.send(m)
  puts "   Ejecutando #{m}: #{resultado}"
end

# 15. SEGURIDAD - Peligro de reflexión
puts "\n15. PELIGRO - ACCESO A DATOS PRIVADOS"
class CuentaBancaria
  def initialize(saldo)
    @saldo = saldo
  end
  
  private
  
  def ver_saldo
    @saldo
  end
end

cuenta = CuentaBancaria.new(5000)
puts "   Saldo original (privado): #{cuenta.instance_variable_get(:@saldo)}"
cuenta.instance_variable_set(:@saldo, 999999)
puts "   Saldo modificado (¡PELIGRO!): #{cuenta.instance_variable_get(:@saldo)}"

# 16. Reflexión con respond_to?
puts "\n16. VERIFICAR SI RESPONDE A MÉTODO"
class Instrumento
  def sonar
    "Sonido"
  end
end

instrumento = Instrumento.new
puts "   ¿Responde a 'sonar'? #{instrumento.respond_to?(:sonar)}"
puts "   ¿Responde a 'tocar'? #{instrumento.respond_to?(:tocar)}"

puts "\n✅ Ejemplos completados\n"
