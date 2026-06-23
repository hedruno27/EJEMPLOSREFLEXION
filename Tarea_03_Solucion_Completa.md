# Tarea 03: Reflexión en Lenguajes Orientados a Objetos

## 1. Cómo Java y Python implementan Reflexión

### Java - Reflexión mediante `java.lang.reflect`

Java implementa reflexión a través del paquete `java.lang.reflect` y la clase `Class`.

```java
import java.lang.reflect.*;

public class ReflexionJava {
    public static void main(String[] args) throws Exception {
        System.out.println("=== REFLEXIÓN EN JAVA ===\n");

        // Forma 1: Obtener la clase usando .class
        Class<?> clase = String.class;

        // Forma 2: Obtener la clase usando forName()
        Class<?> clase2 = Class.forName("java.lang.String");

        // Obtener información de la clase
        System.out.println("1. INFORMACIÓN DE LA CLASE");
        System.out.println("   Nombre de clase: " + clase.getName());
        System.out.println("   Nombre (via forName): " + clase2.getName());
        System.out.println("   Simple Name: " + clase.getSimpleName());
        System.out.println("   Modificadores: " + Modifier.toString(clase.getModifiers()));

        // Obtener métodos
        System.out.println("\n2. MÉTODOS DE STRING");
        Method[] metodos = clase.getDeclaredMethods();
        for (int i = 0; i < Math.min(5, metodos.length); i++) {
            System.out.println("   - " + metodos[i].getName());
        }

        // Obtener constructores y campos
        Constructor<?>[] constructores = String.class.getConstructors();
        Field[] campos = String.class.getDeclaredFields();

        // Invocar método dinámicamente
        String texto = "Hola Mundo";
        Method metodoLength = String.class.getMethod("length");
        int longitud = (int) metodoLength.invoke(texto);

        // Crear instancia dinámicamente
        Constructor<?> constructor = String.class.getConstructor(String.class);
        String nuevaInstancia = (String) constructor.newInstance("Creado con reflexión");

        // Acceso a campo privado con reflexión
        class CuentaBancaria {
            private double saldo = 5000;

            public double getSaldo() {
                return saldo;
            }

            public void setSaldo(double saldo) {
                this.saldo = saldo;
            }
        }

        CuentaBancaria cuenta = new CuentaBancaria();
        Field campoSaldo = CuentaBancaria.class.getDeclaredField("saldo");
        campoSaldo.setAccessible(true);
        campoSaldo.set(cuenta, 999999);

        System.out.println("\n7. PELIGRO: ACCESO A CAMPOS PRIVADOS");
        System.out.println("   Saldo modificado (ILEGAL): $" + cuenta.getSaldo());
    }
}
```

### Python - Reflexión mediante funciones built-in

Python implementa reflexión de forma nativa con funciones como `type()`, `dir()`, `getattr()`, `setattr()`, `hasattr()`, `inspect`.

```python
import inspect
from typing import get_type_hints

class Persona:
    def __init__(self, nombre, edad):
        self.nombre = nombre
        self.edad = edad
    
    def saludar(self):
        return f"Hola, soy {self.nombre}"

# Obtener información de la clase
print("=== REFLEXIÓN EN PYTHON ===")
print(f"Tipo: {type(Persona)}")
print(f"Nombre de clase: {Persona.__name__}")
print(f"Módulo: {Persona.__module__}")

# Obtener todos los atributos y métodos
print("\nAtributos y métodos:")
for item in dir(Persona):
    if not item.startswith('_'):
        print(f"  - {item}")

# Verificar si existe un atributo
print(f"\n¿Tiene método 'saludar'? {hasattr(Persona, 'saludar')}")

# Obtener un atributo dinámicamente
metodo = getattr(Persona, 'saludar')
print(f"Método obtenido: {metodo}")

# Invocar método dinámicamente
persona = Persona("Juan", 30)
resultado = getattr(persona, 'saludar')()
print(f"Resultado: {resultado}")

# Obtener información de métodos con inspect
print("\nInformación de método 'saludar':")
print(f"  Es método: {inspect.ismethod(metodo)}")
print(f"  Es función: {inspect.isfunction(metodo)}")

# Obtener firma del método
sig = inspect.signature(Persona.__init__)
print(f"  Firma: {sig}")

# Crear instancia dinámicamente
print("\nCreando instancia dinámicamente:")
ClasePersona = Persona
nueva_persona = ClasePersona("María", 25)
print(f"Nueva persona: {nueva_persona.saludar()}")

# Modificar atributos dinámicamente
setattr(persona, 'ciudad', 'Lima')
print(f"\nNuevo atributo: {getattr(persona, 'ciudad', 'No existe')}")
```

---

## 2. Diferencias entre Static Typing (Java) y Dynamic Typing (Python) en Reflexión

| Aspecto | Java (Static Typing) | Python (Dynamic Typing) |
|--------|----------------------|------------------------|
| **Verificación de tipos** | En tiempo de compilación | En tiempo de ejecución |
| **Reflexión** | Necesaria para operaciones dinámicas | Natural, integrada en el lenguaje |
| **Overhead** | Mayor costo de reflexión (más segura) | Menor costo (menos verificaciones) |
| **Flexibilidad** | Limitada por tipos estáticos | Alta flexibilidad |
| **Métodos dinámicos** | Complicado (requiere `Method.invoke()`) | Simple (`getattr()`, `setattr()`) |
| **Duck Typing** | No nativo | Nativo |
| **API de reflexión** | Compleja (java.lang.reflect) | Simple (built-in) |

### Comparación de código:

```java
// JAVA - Requiere reflexión explícita
Object obj = "Hola";
Method metodo = obj.getClass().getMethod("length");
int resultado = (int) metodo.invoke(obj);
```

```python
# PYTHON - Reflexión implícita
obj = "Hola"
resultado = len(obj)  # O también: obj.__len__()
```

---

## 3. Frameworks de Java que usan Reflexión

### Framework 1: Spring Framework

**Cómo lo usa:**
- **Dependency Injection (DI)**: Usa reflexión para escanear clases con anotaciones `@Component`, `@Service`, `@Repository`, `@Controller`
- **Inyección de dependencias**: Utiliza reflexión para encontrar constructores y setters
- **Mapeo de propiedades**: Convierte JSON/XML a objetos automáticamente

```java
// Spring usa reflexión internamente
@Service
@RequiredArgsConstructor  // Lombok usa reflexión para generar constructor
public class UsuarioService {
    private final UsuarioRepository repository;  // Spring inyecta via reflexión
    
    public Usuario findById(Long id) {
        return repository.findById(id).orElse(null);
    }
}

// Spring busca esto con reflexión:
// 1. Clases anotadas con @Service
// 2. Campos con @Autowired
// 3. Constructores con parámetros
// 4. Métodos con @Bean
```

**Ventajas:** Reduce código boilerplate, configuración automática, inversión de control.

### Framework 2: Hibernate ORM

**Cómo lo usa:**
- **Mapeo Objeto-Relacional**: Usa reflexión para analizar la estructura de clases con anotaciones `@Entity`, `@Column`, `@Id`
- **Getters/Setters**: Dinámicamente invoca getters y setters para persistencia
- **Lazy Loading**: Crea proxies dinámicos de entidades usando reflexión

```java
@Entity
@Table(name = "usuarios")
public class Usuario {
    @Id
    @GeneratedValue
    private Long id;
    
    @Column(name = "nombre", nullable = false)
    private String nombre;
    
    @Column(name = "email")
    private String email;
}

// Hibernate usa reflexión para:
// 1. Leer anotaciones @Entity, @Column, @Id
// 2. Obtener nombres de campos (Field.getName())
// 3. Invocar setters (setProperty via reflexión)
// 4. Crear consultas SQL automáticamente
// 5. Crear proxies para lazy loading
```

---

## 4. Frameworks de Python que usan Reflexión

### Framework 1: Django

**Cómo lo usa:**
- **ORM (Modelos)**: Usa reflexión para analizar atributos de modelos y generar tablas SQL
- **URLs dinámicas**: Mapea URLs a vistas usando reflexión
- **Formularios automáticos**: Genera formularios basados en modelos

```python
# models.py
from django.db import models

class Usuario(models.Model):
    nombre = models.CharField(max_length=100)
    email = models.EmailField()
    creado = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.nombre

# Django usa reflexión para:
# 1. Inspeccionar atributos de la clase (dir(), getattr())
# 2. Detectar tipos de campos (CharField, EmailField, etc.)
# 3. Generar migraciones SQL automáticamente
# 4. Crear formularios: ModelForm usa reflexión en el modelo

# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('usuarios/', views.UsuarioListView.as_view(), name='lista-usuarios'),
]
# Django usa reflexión para mapear dinámicamente URLs a vistas
```

### Framework 2: Flask + SQLAlchemy

**Cómo lo usa:**
- **Decoradores**: `@app.route()` usa reflexión para registrar rutas dinámicamente
- **SQLAlchemy ORM**: Similar a Hibernate, inspecciona clases para mapeo relacional

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
db = SQLAlchemy(app)

class Producto(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100))
    precio = db.Column(db.Float)

@app.route('/productos')
def listar_productos():
    return Producto.query.all()

# Flask usa reflexión para:
# 1. Registrar rutas dinámicamente con @app.route()
# 2. SQLAlchemy inspecciona la clase Producto
# 3. Mapea atributos a columnas de BD
# 4. Genera consultas SQL dinámicamente
# 5. Serializa objetos a JSON automáticamente (inspect.__dict__)
```

---

## 5. ¿Por qué la Reflexión puede ser Peligrosa?

### 1. **Seguridad - Acceso a campos privados**
```java
// Java - Acceder a campos privados
class CuentaBancaria {
    private double saldo = 5000;
}

// Un atacante puede hacer esto:
CuentaBancaria cuenta = new CuentaBancaria();
Field campo = CuentaBancaria.class.getDeclaredField("saldo");
campo.setAccessible(true);  // ¡PELIGRO!
campo.set(cuenta, 999999);  // Modificó el saldo
```

### 2. **Performance - Overhead significativo**
```python
# Reflexión es mucho más lenta
import time

class Persona:
    def __init__(self, nombre):
        self.nombre = nombre

p = Persona("Juan")

# Método directo (rápido)
start = time.time()
for _ in range(1000000):
    _ = p.nombre
print(f"Acceso directo: {time.time() - start:.4f}s")

# Reflexión (lento)
start = time.time()
for _ in range(1000000):
    _ = getattr(p, 'nombre')
print(f"Con reflexión: {time.time() - start:.4f}s")
# La reflexión es 10-100x más lenta
```

### 3. **Dificultad para refactorizar**
```python
# Cambiar un nombre de método rompe el código
class Usuario:
    def obtener_email(self):  # Cambió de get_email a obtener_email
        return "user@email.com"

# Código que usa reflexión sigue buscando el nombre antiguo
email = getattr(usuario, 'get_email', None)  # None - método no existe
```

### 4. **Errores en tiempo de ejecución**
```java
// Java - Errores que no se detectan en compilación
Method metodo = String.class.getMethod("metodoQueNoExiste");
// NoSuchMethodException - solo en runtime
```

### 5. **Complejidad y mantenibilidad**
```python
# Código reflexivo es difícil de entender y mantener
def procesar_dinamicamente(obj, nombre_metodo, *args):
    if hasattr(obj, nombre_metodo):
        metodo = getattr(obj, nombre_metodo)
        if callable(metodo):
            return metodo(*args)
    return None

# ¿Qué métodos se pueden llamar? ¿Cuántos parámetros aceptan?
# Es oscuro y propenso a errores
```

---

## 6. Duck Typing en Ruby - Explicación y 3 Ejemplos

**Duck Typing**: "Si camina como un pato, nada como un pato y grazna como un pato, entonces es un pato."

En Ruby, no importa el tipo; solo importa que el objeto tenga los métodos necesarios.

### Ejemplo 1: Método `quack()` - Cualquier objeto puede hacerlo

```ruby
class Pato
  def quack
    puts "¡Cuac cuac!"
  end
end

class Persona
  def quack
    puts "Hola, estoy fingiendo que soy un pato"
  end
end

class Juguete
  def quack
    puts "Sonido de juguete: beep boop"
  end
end

def hacer_quack(objeto)
  objeto.quack  # No importa la clase, solo que tenga el método quack
end

# Funciona con cualquier objeto que tenga quack()
hacer_quack(Pato.new)      # ¡Cuac cuac!
hacer_quack(Persona.new)   # Hola, estoy fingiendo...
hacer_quack(Juguete.new)   # Sonido de juguete: beep boop
```

### Ejemplo 2: Método `length()` - Polimorfismo sin interfaces

```ruby
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
    @duracion  # Duración en minutos
  end
end

class Cancion
  def initialize(duracion)
    @duracion = duracion
  end
  
  def length
    @duracion  # Duración en segundos
  end
end

def mostrar_duracion(objeto)
  puts "Duración: #{objeto.length}"
end

# Todos tienen length() pero significan cosas diferentes
mostrar_duracion(Texto.new("Hola mundo"))       # Duración: 11
mostrar_duracion(Video.new(120))                # Duración: 120
mostrar_duracion(Cancion.new(180))              # Duración: 180
```

### Ejemplo 3: Método `save()` - Comportamiento polimórfico

```ruby
class Usuario
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    puts "Guardando usuario: #{@nombre} en BD"
  end
end

class Archivo
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    puts "Guardando archivo: #{@nombre} en disco"
  end
end

class ConfiguracionCloud
  def initialize(nombre)
    @nombre = nombre
  end
  
  def save
    puts "Sincronizando configuración: #{@nombre} en la nube"
  end
end

def guardar_todo(objetos)
  objetos.each { |obj| obj.save }
end

objetos = [
  Usuario.new("Juan"),
  Archivo.new("documento.pdf"),
  ConfiguracionCloud.new("settings.yml")
]

guardar_todo(objetos)
# Guardando usuario: Juan en BD
# Guardando archivo: documento.pdf en disco
# Sincronizando configuración: settings.yml en la nube
```

---

## 7. ¿Es Duck Typing beneficioso para Reflexión y Metaprogramming en Ruby?

**Respuesta: SÍ, extremadamente beneficioso.**

### Por qué Duck Typing favorece Reflexión:

1. **No hay tipos estáticos que validar**
2. **El lenguaje ya es dinámico por naturaleza**
3. **La reflexión es más natural y poderosa**

### Ejemplo: Metaprogramming con Duck Typing

```ruby
# Sin Duck Typing (lenguajes estáticos), esto sería complicado:
# Con Duck Typing en Ruby, es elegante:

class Clase1
  def metodo_a
    "Método A"
  end
end

class Clase2
  def metodo_b
    "Método B"
  end
end

class Clase3
  def metodo_c
    "Método C"
  end
end

# METAPROGRAMMING 1: Agregar métodos dinámicamente a cualquier clase
def agregar_toString(clase)
  clase.define_method(:to_string) do
    "Instancia de #{self.class.name}"
  end
end

agregar_toString(Clase1)
agregar_toString(Clase2)

obj1 = Clase1.new
obj2 = Clase2.new
puts obj1.to_string  # Instancia de Clase1
puts obj2.to_string  # Instancia de Clase2

# METAPROGRAMMING 2: method_missing - Manejo de métodos no definidos
class PeticionDinamica
  def method_missing(metodo, *args)
    puts "Se llamó a #{metodo} con argumentos: #{args.inspect}"
    "Resultado dinámico"
  end
end

obj = PeticionDinamica.new
obj.hacer_algo(1, 2, 3)  # Se llamó a hacer_algo con argumentos: [1, 2, 3]

# METAPROGRAMMING 3: Crear getters y setters automáticamente
class Persona
  def self.crear_atributos(*nombres)
    nombres.each do |nombre|
      define_method(nombre) { instance_variable_get("@#{nombre}") }
      define_method("#{nombre}=") { |valor| instance_variable_set("@#{nombre}", valor) }
    end
  end
  
  crear_atributos :nombre, :edad, :email
end

persona = Persona.new
persona.nombre = "Juan"
persona.edad = 30
puts persona.nombre  # Juan
puts persona.edad    # 30

# METAPROGRAMMING 4: Inspeccionar dinámicamente
class API
  def obtener_datos
    "datos"
  end
  
  def procesar_datos
    "procesado"
  end
end

api = API.new
# Duck Typing + Reflexión = poder absoluto
metodos = api.methods.select { |m| m.to_s.start_with?('obtener', 'procesar') }
puts "Métodos disponibles: #{metodos}"
metodos.each { |m| puts "Ejecutando #{m}: #{api.send(m)}" }
```

**Ventaja clave**: Duck Typing permite que Ruby sea reflexivo sin perder seguridad de tipos. Si algo tiene el método, funciona. Punto.

---

## 8. Cómo Ruby on Rails se ha beneficiado de Reflexión y Duck Typing

### 1. **Active Record - Mapeo Objeto-Relacional**

```ruby
# app/models/usuario.rb
class Usuario < ApplicationRecord
  validates :email, presence: true
  has_many :posts
  has_one :perfil
end

# Rails usa reflexión para:
# 1. Leer el nombre de la tabla (usuarios - plural de Usuario)
# 2. Leer estructura de BD y generar métodos dinámicamente
# 3. id, nombre, email - son métodos creados por reflexión
# 4. Crear validaciones basadas en tipos de columnas

usuario = Usuario.new(email: "user@example.com")
usuario.save  # Rails inspecciona las columnas y valida automáticamente
```

### 2. **Convención sobre Configuración**

```ruby
# Sin reflexión, tendrías que hacer esto:
routes.rb
get '/usuarios' => 'usuarios#index'
get '/usuarios/:id' => 'usuarios#show'
post '/usuarios' => 'usuarios#create'

# Con reflexión/Duck Typing, Rails lo hace automáticamente:
resources :usuarios  # ¡Una sola línea!
# Rails inspecciona la clase UsuariosController y crea todas las rutas
```

### 3. **Asociaciones dinámicas**

```ruby
class Usuario < ApplicationRecord
  has_many :posts
  has_one :perfil
  belongs_to :empresa
end

# Rails crea dinámicamente:
usuario.posts      # SELECT * FROM posts WHERE usuario_id = ?
usuario.perfil     # SELECT * FROM perfil WHERE usuario_id = ?
usuario.empresa    # SELECT * FROM empresa WHERE id = ?

# Todo esto se crea via reflexión en las asociaciones
```

### 4. **Validaciones dinámicas**

```ruby
class Usuario < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :nombre, length: { minimum: 3 }
  validate :email_debe_ser_valido
  
  private
  def email_debe_ser_valido
    # Validación personalizada
  end
end

# Rails inspecciona los validadores y los aplica automáticamente
# cuando llamas a save() o valid?
```

### 5. **Callbacks automáticos**

```ruby
class Usuario < ApplicationRecord
  before_save :normalizar_email
  after_create :enviar_email_bienvenida
  before_destroy :archivar_datos
  
  private
  def normalizar_email
    self.email = email.downcase
  end
  
  def enviar_email_bienvenida
    # Enviar email
  end
  
  def archivar_datos
    # Guardar en archivo
  end
end

# Rails usa method_missing y reflexión para:
# 1. Detectar métodos before_save, after_create, etc.
# 2. Ejecutarlos en el momento apropiado automáticamente
```

### 6. **Métodos dinámicos de búsqueda**

```ruby
# Sin reflexión:
usuario = Usuario.find_by(email: 'user@example.com')

# Con reflexión, Rails entiende cualquier patrón:
usuario = Usuario.find_by_email('user@example.com')
usuarios = Usuario.find_all_by_empresa_id(5)
usuario = Usuario.find_by_email_and_estado('user@example.com', 'activo')

# Rails analiza el nombre del método y construye la query automáticamente
```

**Conclusión**: Rails es eficiente porque combina:
- **Reflexión**: Para inspeccionar clases y generar código
- **Duck Typing**: Para tratamiento flexible de objetos
- **Convención sobre Configuración**: Para minimizar código boilerplate

---

## 9. Polimorfismo en Lenguajes de Tipos Estáticos (Java)

**¿Es la Reflexión un mecanismo apropiado para polimorfismo en Java?**

**Respuesta: NO. Java usa otros mecanismos más seguros.**

### Mecanismos principales de Polimorfismo en Java:

### 1. **Polimorfismo de Herencia (método overriding)**
```java
// Este es el mecanismo PRIMARY en Java
abstract class Animal {
    abstract void sonido();
}

class Perro extends Animal {
    @Override
    void sonido() {
        System.out.println("Guau");
    }
}

class Gato extends Animal {
    @Override
    void sonido() {
        System.out.println("Miau");
    }
}

// Polimorfismo - sin reflexión
Animal perro = new Perro();
Animal gato = new Gato();
perro.sonido();  // Guau
gato.sonido();   // Miau
```

### 2. **Polimorfismo de Interfaces (contrato)**
```java
interface Vehiculo {
    void acelerar();
    void frenar();
}

class Auto implements Vehiculo {
    @Override
    public void acelerar() { System.out.println("Auto acelera"); }
    
    @Override
    public void frenar() { System.out.println("Auto frena"); }
}

class Moto implements Vehiculo {
    @Override
    public void acelerar() { System.out.println("Moto acelera"); }
    
    @Override
    public void frenar() { System.out.println("Moto frena"); }
}

// Polimorfismo a través de interfaz
Vehiculo auto = new Auto();
Vehiculo moto = new Moto();
auto.acelerar();  // Auto acelera
moto.acelerar();  // Moto acelera
```

### 3. **Polimorfismo Paramétrico (Generics)**
```java
// Polimorfismo de tipos
class Caja<T> {
    private T contenido;
    
    public void guardar(T objeto) {
        this.contenido = objeto;
    }
    
    public T obtener() {
        return contenido;
    }
}

Caja<String> cajaTexto = new Caja<>();
Caja<Integer> cajaNumero = new Caja<>();
```

### 4. **Enfoque Contractual (lo que pide la pregunta)**
```java
// Una clase que espera un cierto "contrato" de métodos
// Sin necesidad de herencia o interfaz (pero no es recomendado)

class ProcesadorGenerico {
    public void procesar(Object objeto) {
        // Usar reflexión para procesar sin saber el tipo
        Method[] metodos = objeto.getClass().getMethods();
        for (Method m : metodos) {
            if (m.getName().startsWith("procesar")) {
                try {
                    m.invoke(objeto);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

// ¡MALO! - No es seguro, no es comprobable en compilación
```

### **¿Por qué Java NO usa reflexión para polimorfismo?**

1. **Verificación en compilación**: Las interfaces y herencia se verifican en tiempo de compilación
2. **Performance**: No hay overhead de reflexión en runtime
3. **Seguridad**: Errores se detectan temprano
4. **Claridad**: El código es más legible y mantenible

**Conclusión**: Java usa **Herencia, Interfaces y Generics** para polimorfismo, NO reflexión.

---

## 10. Polimorfismo en Lenguajes de Tipos Dinámicos (Python y Ruby)

**¿Es la Reflexión un mecanismo apropiado para polimorfismo en lenguajes dinámicos?**

**Respuesta: SÍ, naturalmente, porque Duck Typing DEPENDE de reflexión.**

### Python: Duck Typing como Polimorfismo

```python
# No hay interfaces ni herencia necesaria
# Solo importa que el objeto tenga los métodos

class Pajaro:
    def volar(self):
        return "El pájaro vuela"

class Avion:
    def volar(self):
        return "El avión vuela"

class Superman:
    def volar(self):
        return "Superman vuela"

def hacer_volar(objeto):
    # Duck Typing - si tiene volar(), lo usamos
    if hasattr(objeto, 'volar') and callable(getattr(objeto, 'volar')):
        return objeto.volar()
    return "No puede volar"

print(hacer_volar(Pajaro()))    # El pájaro vuela
print(hacer_volar(Avion()))     # El avión vuela
print(hacer_volar(Superman()))  # Superman vuela
print(hacer_volar("string"))    # No puede volar

# AQUÍ LA REFLEXIÓN (hasattr, getattr, callable) ES POLIMORFISMO
```

### Ruby: Duck Typing + Reflexión = Polimorfismo perfecto

```ruby
# En Ruby, ni siquiera necesitas verificar - confía en Duck Typing

class Cantante
  def cantar
    "Cantando una canción"
  end
end

class Loro
  def cantar
    "¡Squawk! ¡Squawk!"
  end
end

class Caja
  def cantar
    "Haciendo ruido: bip bop"
  end
end

def concierto(artistas)
  artistas.each do |artista|
    puts artista.cantar  # Si tiene cantar(), funciona. Punto.
  end
end

concierto([Cantante.new, Loro.new, Caja.new])
# Cantando una canción
# ¡Squawk! ¡Squawk!
# Haciendo ruido: bip bop

# LA REFLEXIÓN IMPLÍCITA DE RUBY HACE QUE ESTO FUNCIONE
# method_missing permite incluso métodos no definidos
```

### Comparación: Static vs Dynamic

```java
// JAVA - Polimorfismo sin reflexión (seguro en compilación)
interface Volador {
    void volar();
}

class Pajaro implements Volador {
    public void volar() { }
}

// Error de compilación si no implementas la interfaz
class Gato implements Volador { }  // ERROR: debe implementar volar()
```

```python
# PYTHON - Polimorfismo con reflexión implícita (flexible en runtime)
class Pajaro:
    def volar(self): pass

class Gato:
    def volar(self): pass  # Puedes tener cualquier cosa

def hacer_volar(obj):
    obj.volar()  # AttributeError solo en runtime
```

### Enfoque contractual en lenguajes dinámicos

```python
from abc import ABC, abstractmethod

# Python introduce verificación de contrato opcional
class AnimalVolador(ABC):
    @abstractmethod
    def volar(self):
        pass

class Pajaro(AnimalVolador):
    def volar(self):
        return "Volando"

# Pero incluso sin ABC, Duck Typing sigue siendo válido
```

### **¿Por qué la Reflexión es apropiada en lenguajes dinámicos?**

1. **Está integrada**: No es un costo adicional
2. **Es natural**: Duck Typing depende de ella
3. **Flexible**: Permite código más adaptable
4. **Menos código boilerplate**: No necesitas interfaces

**Conclusión**: 
- **Java (estático)**: Polimorfismo via Herencia e Interfaces - SEGURO
- **Python/Ruby (dinámico)**: Polimorfismo via Duck Typing + Reflexión implícita - FLEXIBLE

---

## Resumen General

| Concepto | Java | Python | Ruby |
|----------|------|--------|------|
| **Reflexión** | Explícita (java.lang.reflect) | Implícita (built-in) | Implícita (method_missing) |
| **Duck Typing** | ❌ No | ✅ Sí | ✅ Sí |
| **Polimorfismo principal** | Interfaces/Herencia | Duck Typing | Duck Typing |
| **Metaprogramming** | Limitado | Posible | Poderoso (Rails) |
| **Performance** | Rápido (sin reflexión) | Flexible | Flexible |
| **Frameworks clave** | Spring, Hibernate | Django, Flask | Rails |

---

## Recomendaciones para tu Presentación

### Diapositiva 1: Introducción
- Define Reflexión
- Muestra que todos los lenguajes la tienen, pero diferente

### Diapositiva 2: Ejemplos de código
- Código Java con java.lang.reflect
- Código Python con getattr/setattr
- Código Ruby con method_missing

### Diapositiva 3: Duck Typing
- Los 3 ejemplos de Ruby
- Muestra por qué es poderoso

### Diapositiva 4: Peligros
- Seguridad (campos privados)
- Performance
- Errores en runtime

### Diapositiva 5: Frameworks
- Spring + Hibernate (Java)
- Django + Flask (Python)
- Rails (Ruby)
- Muestra código

### Preguntas esperadas:
- "¿Por qué Java usa reflexión si es peligrosa?"
  - Respuesta: Spring la usa para DI, pero es controlada
- "¿Ruby es más peligroso por Duck Typing?"
  - Respuesta: No, es más flexible si lo usas bien
- "¿Cuándo usar reflexión?"
  - Respuesta: Frameworks, herramientas, código dinámico

---

## Comandos para ejecutar ejemplos

```bash
# Java
javac ReflexionJava.java
java ReflexionJava

# Python
python3 ejemplos_reflexion.py

# Ruby
ruby ejemplos_reflexion.rb
```

¡Buena suerte en tu presentación! 🚀
