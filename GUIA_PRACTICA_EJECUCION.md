# GUÍA PRÁCTICA - Tarea 03: Reflexión en OOP



---

## ▶️ ESTADO ACTUAL DEL PROYECTO

Los archivos del proyecto actuales son:
- [ReflexionJava.java](ReflexionJava.java): ejemplo principal de reflexión en Java.
- [reflexion_python.py](reflexion_python.py): ejemplo equivalente en Python.
- [reflexion_ruby.rb](reflexion_ruby.rb): ejemplo equivalente en Ruby.
- [Tarea_03_Solucion_Completa.md](Tarea_03_Solucion_Completa.md): guía de referencia de la tarea.

---

## ▶️ CÓMO EJECUTAR LOS EJEMPLOS

### Java
```bash
# Compilar
javac ReflexionJava.java

# Ejecutar
java ReflexionJava
```

**Salida esperada (actual):**
```text
=== REFLEXIÓN EN JAVA ===

1. INFORMACIÓN DE LA CLASE
   Nombre de clase: java.lang.String
   Nombre (via forName): java.lang.String
   Simple Name: String
   Modificadores: public final

2. MÉTODOS DE STRING
   Total de métodos: 104
   - clone
   - equals
   - hashCode
   - toString
   - length
```

El ejemplo actual incluye:
- obtención de la clase con `.class` y `Class.forName()`
- inspección de métodos, constructores y campos
- invocación dinámica de métodos
- creación dinámica de instancias
- acceso reflexivo a un campo privado dentro de una clase interna `CuentaBancaria`

---

### Python
```bash
# Ejecutar directamente
python3 reflexion_python.py
```

### Ruby
```bash
# Ejecutar directamente
ruby reflexion_ruby.rb
```

---

## 📊 TABLA COMPARATIVA (Para tus diapositivas)

### Reflexión: Java vs Python vs Ruby

| Aspecto | Java | Python | Ruby |
|---------|------|--------|------|
| **Acceso a métodos** | `obj.getClass().getMethod()` | `getattr(obj, 'metodo')` | `obj.method(:metodo)` |
| **Invocar método** | `method.invoke(obj)` | `method()` | `obj.send(:metodo)` |
| **Crear instancia** | `constructor.newInstance()` | `Clase()` | `Clase.new` |
| **Atributos dinámicos** | No (sistema de tipos) | Sí (`setattr`) | Sí (`instance_variable_set`) |
| **Duck Typing nativo** | ❌ | ✅ | ✅ |
| **Overhead reflexión** | Alto | Medio | Bajo |

---

## 🎯 RESPUESTAS CLAVE PARA MEMORIZAR

### Pregunta 1: ¿Cómo Java y Python implementan Reflexión?

**Java:**
```java
Class<?> c = Class.forName("java.lang.String");
Method m = c.getMethod("length");
int resultado = (int) m.invoke("Hola");
```
**Java usa:** `java.lang.reflect` - Explícito y controlado

**Python:**
```python
class Persona:
    def metodo(self): pass
    
getattr(Persona, 'metodo')  # Obtener
setattr(Persona, 'nuevo', lambda self: None)  # Crear
```
**Python usa:** Funciones built-in - Implícito e integrado

---

### Pregunta 2: Static vs Dynamic Typing en Reflexión

| Java (Static) | Python (Dynamic) |
|---|---|
| Verificación en compilación | Verificación en runtime |
| Reflexión = excepción | Reflexión = norma |
| Segura pero compleja | Flexible pero peligrosa |
| `Class.forName()` necesario | Innato en el lenguaje |

---

### Pregunta 3: Frameworks Java con Reflexión

1. **Spring Framework**
   - `@Autowired` busca campos con reflexión
   - `@Component` escanea clases automáticamente
   - Inyección de dependencias via reflexión

2. **Hibernate ORM**
   - `@Entity` mapea clases a tablas
   - Lee atributos con `Field.get()`
   - Crea proxies dinámicamente

---

### Pregunta 4: Frameworks Python con Reflexión

1. **Django**
   - Modelos → Tablas automáticamente
   - `inspect` analiza campos de modelo
   - Genera SQL basado en estructura

2. **Flask + SQLAlchemy**
   - `@app.route()` registra dinámicamente
   - ORM inspecciona clases
   - Serialización automática a JSON

---

### Pregunta 5: ¿Por qué es peligrosa la Reflexión?

1. **Seguridad:** Acceso a campos privados
   ```java
   field.setAccessible(true);  // Bypass de privacidad
   ```

2. **Performance:** Mucho más lenta
   ```
   Acceso directo: 0.0001s
   Con reflexión: 0.001s (10x más lento)
   ```

3. **Refactorización:** Nombres hardcoded rompen el código
   ```python
   getattr(obj, 'metodo_antiguo')  # Falla silenciosamente
   ```

4. **Errores en runtime:** No se detectan en compilación
   ```java
   NoSuchMethodException - Solo cuando se ejecuta
   ```

---

### Pregunta 6: Duck Typing (3 ejemplos)

**Ejemplo 1:** Método `quack()`
```ruby
class Pato; def quack; "¡Cuac!"; end; end
class Persona; def quack; "Quack falso"; end; end

def hacer_quack(obj)
  obj.quack  # Funciona con cualquiera que tenga quack()
end
```

**Ejemplo 2:** Método `length()`
```ruby
class Texto; def length; "tamaño texto"; end; end
class Video; def length; "duración video"; end; end
class Audio; def length; "duración audio"; end; end

# Todos respondidéndose a length() pero significan cosas diferentes
```

**Ejemplo 3:** Método `save()`
```ruby
Usuario.new.save     # → BD
Archivo.new.save     # → Disco
Config.new.save      # → Cloud
# Cada uno se guarda diferente
```

---

### Pregunta 7: ¿Duck Typing es beneficioso para Reflexión en Ruby?

**SÍ, extremadamente:**

1. **Ya es dinámico:** No necesitas pensar en tipos
2. **Metaprogramming natural:** `define_method`, `method_missing`
3. **Código más flexible:** Cambios sin romper interfaces
4. **Rails posible:** Sin todas las anotaciones de Java

```ruby
# Ruby + Duck Typing = Metaprogramming poderoso
class Modelo
  def self.crear_atributos(*nombres)
    nombres.each { |n| define_method(n) { instance_variable_get("@#{n}") } }
  end
end

Modelo.crear_atributos :nombre, :email, :telefono
# ¡Getters creados automáticamente!
```

---

### Pregunta 8: Ruby on Rails y Reflexión

**Rails maximiza Reflexión:**

1. **Active Record:** Lee estructura BD automáticamente
   ```ruby
   Usuario.where(activo: true).map(&:enviar_email)
   # Rails inspecciona la tabla y crea dinámicamente
   ```

2. **Convención sobre Configuración:**
   ```ruby
   resources :usuarios  # Una línea genera todas las rutas
   # Rails inspecciona UsuariosController y crea:
   # GET    /usuarios
   # GET    /usuarios/:id
   # POST   /usuarios
   # PATCH  /usuarios/:id
   # DELETE /usuarios/:id
   ```

3. **Callbacks automáticos:**
   ```ruby
   class Usuario < ApplicationRecord
     before_save :normalizar
     after_create :enviar_bienvenida
   end
   # Rails busca estos métodos con reflection y los ejecuta
   ```

4. **Validaciones dinámicas:**
   ```ruby
   validates :email, presence: true, uniqueness: true
   # Rails inspecciona y aplica automáticamente en save()
   ```

5. **Duck Typing:**
   ```ruby
   # No necesitas interfaces:
   usuario.save
   archivo.save
   config.save
   # Cada uno sabe cómo guardarse
   ```

---

### Pregunta 9: Polimorfismo en Java (lenguajes estáticos)

**¿Es Reflexión mecanismo para polimorfismo?**

**NO.** Java usa:

1. **Herencia:**
   ```java
   abstract class Animal { abstract void sonar(); }
   class Perro extends Animal { void sonar() {...} }
   ```

2. **Interfaces:**
   ```java
   interface Volador { void volar(); }
   class Pajaro implements Volador { void volar() {...} }
   ```

3. **Generics:**
   ```java
   class Caja<T> { T get() {...} }
   ```

**¿Por qué NO Reflexión?**
- Verificación en compilación → Segura
- Performance → Sin overhead
- Claridad → Código legible

Reflexión sería problemática en Java para polimorfismo.

---

### Pregunta 10: Polimorfismo en Python/Ruby (dinámicos)

**¿Es Reflexión mecanismo para polimorfismo?**

**SÍ, naturalmente:**

```python
# Python - Duck Typing ES polimorfismo
def procesar(objeto):
    objeto.procesar()  # Si tiene procesar(), funciona

procesar(Usuario())     # ✅
procesar(Archivo())     # ✅
procesar(Config())      # ✅
procesar("string")      # ❌ AttributeError en runtime
```

```ruby
# Ruby - Duck Typing ES polimorfismo
def guardar(objeto)
  objeto.save  # Si tiene save(), funciona
end

# Reflexión implícita - method_missing maneja lo que falta
```

**Ventaja:** Más flexible, menos código

**Desventaja:** Errores en runtime

---

## 💡 CONSEJOS PARA LA PRESENTACIÓN

### Antes de la presentación:
1. ✅ **Ejecuta todos los ejemplos** - Verifica que funcionen
2. ✅ **Prepara diapositivas** - No más de 15 diapositivas
3. ✅ **Memoriza respuestas clave** - Ve las secciones arriba
4. ✅ **Ten código listo** - En caso pregunten "muéstrame código"

### Durante la presentación:
1. 🎤 **Habla claro** - Pronuncia "Reflexión" correctamente
2. 📊 **Usa la tabla comparativa** - Visual es mejor que texto
3. 💻 **Muestra código** - Al menos 1-2 ejemplos ejecutándose
4. ⏱️ **Tómate tu tiempo** - No apures, explica bien
5. 🤝 **Mira a los jueces** - Establece contacto visual

### Si te sorprenden con preguntas:
- Pregunta 1: Habla de `java.lang.reflect` vs `getattr()` en Python
- Pregunta 2: Compara Java (seguro) vs Python (flexible)
- Pregunta 3: Spring usa `@Autowired`, Hibernate usa `@Entity`
- Pregunta 4: Django inspecciona modelos, Flask usa decoradores
- Pregunta 5: Seguridad (campos privados), Performance, Runtime errors
- Pregunta 6: Quack, Length, Save (3 ejemplos claritos)
- Pregunta 7: Sí, porque Ruby ya es dinámico
- Pregunta 8: Rails automáticamente via reflexión
- Pregunta 9: Interfaces e Herencia, NO reflexión
- Pregunta 10: Sí, Duck Typing ES polimorfismo dinámico

---

## 📋 CHECKLIST FINAL

- [ ] Ejecuté ReflexionJava.java sin errores
- [ ] Ejecuté reflexion_python.py sin errores  
- [ ] Ejecuté reflexion_ruby.rb sin errores
- [ ] Leí completamente Tarea_03_Solucion_Completa.md
- [ ] Preparé 10-15 diapositivas
- [ ] Memoricé las 10 respuestas principales
- [ ] Tengo ejemplos de código listos
- [ ] Practiqué la presentación en voz alta

---

## 🚀 ¡ÉXITO EN TU PRESENTACIÓN!

**Recuerda:**
- Reflexión = Introspección + Manipulación dinámicas
- Java: Explícita y segura
- Python: Implícita y flexible
- Ruby: Duck Typing poderoso

¡Tú puedes! 💪

---

## RECURSOS ADICIONALES

### Para investigar más:
1. **Java Reflection API:** https://docs.oracle.com/javase/tutorial/reflect/
2. **Python inspect:** https://docs.python.org/3/library/inspect.html
3. **Ruby Metaprogramming:** https://www.ruby-lang.org/en/documentation/
4. **Rails Reflection:** https://guides.rubyonrails.org/

### Búsquedas útiles:
- "Java reflection tutorial"
- "Python getattr setattr examples"
- "Ruby method_missing metaprogramming"
- "Duck typing examples"
- "Rails active record reflection"

---
