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
        System.out.println("   Total de métodos: " + metodos.length);
        for (int i = 0; i < Math.min(5, metodos.length); i++) {
            System.out.println("   - " + metodos[i].getName());
        }

        // Obtener constructores
        System.out.println("\n3. CONSTRUCTORES DE STRING");
        Constructor<?>[] constructores = String.class.getConstructors();
        System.out.println("   Total: " + constructores.length);
        if (constructores.length > 0) {
            System.out.println("   Primer constructor: " + constructores[0]);
        }

        // Obtener campos
        System.out.println("\n4. CAMPOS DE STRING");
        Field[] campos = String.class.getDeclaredFields();
        System.out.println("   Total de campos privados: " + campos.length);
        for (Field f : campos) {
            System.out.println("   - " + f.getName() + " (" + f.getType().getSimpleName() + ")");
        }

        // Invocar método dinámicamente
        System.out.println("\n5. INVOCAR MÉTODO DINÁMICAMENTE");
        String texto = "Hola Mundo";
        Method metodoLength = String.class.getMethod("length");
        int longitud = (int) metodoLength.invoke(texto);
        System.out.println("   Texto: '" + texto + "'");
        System.out.println("   Longitud (via reflexión): " + longitud);

        Method metodoToUpperCase = String.class.getMethod("toUpperCase");
        String mayuscula = (String) metodoToUpperCase.invoke(texto);
        System.out.println("   A mayúsculas: " + mayuscula);

        // Crear instancia dinámicamente
        System.out.println("\n6. CREAR INSTANCIA DINÁMICAMENTE");
        Constructor<?> constructor = String.class.getConstructor(String.class);
        String nuevaInstancia = (String) constructor.newInstance("Creado con reflexión");
        System.out.println("   Nueva instancia: '" + nuevaInstancia + "'");

        // Peligro: acceso a campos privados
        System.out.println("\n7. PELIGRO: ACCESO A CAMPOS PRIVADOS");
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
        try {
            Field campoSaldo = CuentaBancaria.class.getDeclaredField("saldo");
            campoSaldo.setAccessible(true);
            System.out.println("   Saldo original: $" + cuenta.getSaldo());
            campoSaldo.set(cuenta, 999999);
            System.out.println("   Saldo modificado (ILEGAL): $" + cuenta.getSaldo());
            cuenta.setSaldo(5000);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Verificar si existe un método
        System.out.println("\n8. VERIFICAR SI EXISTE UN MÉTODO");
        System.out.println("   ¿String tiene length()? " + tieneMetodo(String.class, "length"));
        System.out.println("   ¿String tiene nonExistent()? " + tieneMetodo(String.class, "nonExistent"));
    }

    static boolean tieneMetodo(Class<?> clase, String nombreMetodo) {
        try {
            clase.getMethod(nombreMetodo);
            return true;
        } catch (NoSuchMethodException e) {
            return false;
        }
    }
}
