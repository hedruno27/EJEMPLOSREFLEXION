import inspect
import time

print("=== REFLEXIÓN EN PYTHON ===\n")

# Definir clases para ejemplos
class Persona:
    def __init__(self, nombre, edad):
        self.nombre = nombre
        self.edad = edad
    
    def saludar(self):
        return f"Hola, soy {self.nombre}"
    
    def cumplir_años(self):
        self.edad += 1
        return f"Ahora tengo {self.edad} años"

# 1. OBTENER INFORMACIÓN DE LA CLASE
print("1. INFORMACIÓN DE LA CLASE")
print(f"   Tipo: {type(Persona)}")
print(f"   Nombre: {Persona.__name__}")
print(f"   Módulo: {Persona.__module__}")
print(f"   Es clase: {inspect.isclass(Persona)}")

# 2. OBTENER ATRIBUTOS Y MÉTODOS
print("\n2. ATRIBUTOS Y MÉTODOS (sin los privados)")
for item in dir(Persona):
    if not item.startswith('_'):
        print(f"   - {item}")

# 3. VERIFICAR SI EXISTE ATRIBUTO
print("\n3. VERIFICAR EXISTENCIA DE ATRIBUTOS")
print(f"   ¿Tiene método 'saludar'? {hasattr(Persona, 'saludar')}")
print(f"   ¿Tiene método 'volar'? {hasattr(Persona, 'volar')}")

# 4. OBTENER ATRIBUTO DINÁMICAMENTE
print("\n4. OBTENER ATRIBUTO DINÁMICAMENTE")
metodo = getattr(Persona, 'saludar')
print(f"   Método obtenido: {metodo}")
print(f"   ¿Es método? {inspect.ismethod(metodo)}")
print(f"   ¿Es función? {inspect.isfunction(metodo)}")

# 5. INVOCAR MÉTODO DINÁMICAMENTE
print("\n5. INVOCAR MÉTODO DINÁMICAMENTE")
persona = Persona("Juan", 30)
metodo = getattr(persona, 'saludar')
resultado = metodo()
print(f"   Resultado: {resultado}")

otro_metodo = getattr(persona, 'cumplir_años')
print(f"   {otro_metodo()}")

# 6. OBTENER FIRMA DE MÉTODO
print("\n6. FIRMA DE MÉTODO (inspect)")
sig = inspect.signature(Persona.__init__)
print(f"   __init__: {sig}")

sig2 = inspect.signature(Persona.saludar)
print(f"   saludar: {sig2}")

# 7. CREAR INSTANCIA DINÁMICAMENTE
print("\n7. CREAR INSTANCIA DINÁMICAMENTE")
ClasePersona = Persona
nueva_persona = ClasePersona("María", 25)
print(f"   Nueva persona: {nueva_persona.saludar()}")

# 8. MODIFICAR ATRIBUTOS DINÁMICAMENTE
print("\n8. MODIFICAR ATRIBUTOS DINÁMICAMENTE")
print(f"   Nombre original: {persona.nombre}")
setattr(persona, 'nombre', 'Carlos')
print(f"   Nombre modificado: {persona.nombre}")

# Agregar atributo nuevo
setattr(persona, 'ciudad', 'Lima')
print(f"   Nuevo atributo 'ciudad': {getattr(persona, 'ciudad', 'No existe')}")

# 9. COMPARACIÓN: Acceso directo vs Reflexión
print("\n9. PERFORMANCE: ACCESO DIRECTO VS REFLEXIÓN")
class TestRendimiento:
    valor = 42

obj = TestRendimiento()

# Acceso directo (rápido)
start = time.time()
for _ in range(1000000):
    _ = obj.valor
tiempo_directo = time.time() - start
print(f"   Acceso directo (1M veces): {tiempo_directo:.4f}s")

# Reflexión (lento)
start = time.time()
for _ in range(1000000):
    _ = getattr(obj, 'valor')
tiempo_reflexion = time.time() - start
print(f"   Con getattr (1M veces): {tiempo_reflexion:.4f}s")
print(f"   Factor de lentitud: {tiempo_reflexion/tiempo_directo:.1f}x más lento")

# 10. DUCK TYPING - Ejemplo 1
print("\n10. DUCK TYPING - EJEMPLO 1: quack()")
class Pato:
    def quack(self):
        return "¡Cuac cuac!"

class Persona2:
    def quack(self):
        return "Hola, estoy fingiendo ser pato"

def hacer_quack(objeto):
    # No importa el tipo, solo que tenga quack()
    return objeto.quack()

print(f"   Pato: {hacer_quack(Pato())}")
print(f"   Persona: {hacer_quack(Persona2())}")

# 11. DUCK TYPING - Ejemplo 2
print("\n11. DUCK TYPING - EJEMPLO 2: length()")
class Texto:
    def __init__(self, contenido):
        self._contenido = contenido
    
    def length(self):
        return len(self._contenido)

class Video:
    def __init__(self, duracion):
        self._duracion = duracion
    
    def length(self):
        return self._duracion

def mostrar_duracion(objeto):
    return f"Duración: {objeto.length()}"

print(f"   {mostrar_duracion(Texto('Hola mundo'))}")
print(f"   {mostrar_duracion(Video(120))}")

# 12. DUCK TYPING - Ejemplo 3
print("\n12. DUCK TYPING - EJEMPLO 3: save()")
class Usuario:
    def __init__(self, nombre):
        self.nombre = nombre
    
    def save(self):
        return f"Guardando usuario: {self.nombre} en BD"

class Archivo:
    def __init__(self, nombre):
        self.nombre = nombre
    
    def save(self):
        return f"Guardando archivo: {self.nombre} en disco"

class Config:
    def __init__(self, nombre):
        self.nombre = nombre
    
    def save(self):
        return f"Sincronizando: {self.nombre} en la nube"

def guardar_todo(objetos):
    for obj in objetos:
        print(f"   {obj.save()}")

objetos = [
    Usuario("Juan"),
    Archivo("documento.pdf"),
    Config("settings.yml")
]
guardar_todo(objetos)

# 13. Información de objetos
print("\n13. INFORMACIÓN COMPLETA DE OBJETO")
print(f"   Clase: {persona.__class__.__name__}")
print(f"   Atributos de instancia: {persona.__dict__}")
print(f"   Métodos disponibles: {[m for m in dir(persona) if not m.startswith('_')]}")

print("\n✅ Ejemplos completados\n")
