/*Where
1. Mostrar el nombre, altura y peso de los Pokémon cuya altura sea menor a 0.5.
Tablas: pokemon
Campos: nombre, peso, altura
2. Mostrar los nombres, descripciones, potencia y precisión de los movimientos cuya potencia esté entre 70 y 100, la precisión sea mayor a 80.
Tablas: movimiento
Campos: nombre, descripcion, potencia, precision_mov
*/
SELECT nombre, altura, peso
FROM pokemon
WHERE altura < 0.5;

SELECT nombre, descripcion, potencia, precision_mov
FROM movimiento
WHERE potencia BETWEEN 70 AND 100
  AND precision_mov > 80;

/*Operadores & joins
1. Mostrar los nombres y potencia de los movimientos que tienen una potencia entre 50 y 80, junto con el nombre del tipo al que pertenecen.
Tablas: movimiento, tipo
Campos: m.nombre, t.nombre, potencia
2. Mostrar los nombre, potencia y tipo de los movimientos que tienen un tipo de ataque "Físico" y una precisión mayor a 85.
Tablas: tipo, tipo_ataque, movimiento
Campos: m.nombre, m.potencia, m.precision_mov, ta.tipo
*/
SELECT m.nombre, t.nombre AS tipo, m.potencia
FROM movimiento m
JOIN tipo t ON m.id_tipo = t.id_tipo
WHERE m.potencia BETWEEN 50 AND 80;

SELECT m.nombre, m.potencia, ta.tipo
FROM movimiento m
JOIN tipo t ON m.id_tipo = t.id_tipo
JOIN tipo_ataque ta ON t.id_tipo_ataque = ta.id_tipo_ataque
WHERE ta.tipo = 'Físico' AND m.precision_mov > 85;

/*Order by
1. Mostrar los nombres y números de Pokédex de los Pokémon en orden descendente según su número de Pokédex.
Tablas: pokemon
Campos: numero_pokedex, nombre
2. Mostrar numero de pokedex, nombre y altura de los Pokémon de tipo "Roca", ordenados por altura de forma ascendente.
Tablas: pokemon, pokemon_tipo, tipo
Campos: numero_pokedex, nombre, altura
 */
 SELECT numero_pokedex, nombre
FROM pokemon
ORDER BY numero_pokedex DESC;

SELECT p.numero_pokedex, p.nombre, p.altura
FROM pokemon p
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
JOIN tipo t ON pt.id_tipo = t.id_tipo
WHERE t.nombre = 'Roca'
ORDER BY p.altura ASC;

/*Funciones de agregación
1.¿Cuántos Pokémon tienen una defensa superior a 100?
	Tablas: estadisticas_base
Campos: defensa
2.¿Cuál es la potencia promedio de todos los movimientos en la base de datos? ¿Cuáles son los valores máximos y mínimos de la potencia?
Tablas: movimiento
Campos: potencia
 */
 SELECT COUNT(*) AS cantidad_pokemon
FROM estadisticas_base
WHERE defensa > 100;

SELECT AVG(potencia) AS potencia_promedio,
       MAX(potencia) AS potencia_maxima,
       MIN(potencia) AS potencia_minima
FROM movimiento;

/*Group by
1. Muestra los nombres de los tipos de Pokémon junto con la velocidad promedio de los Pokémon de cada tipo.
Tablas: estadisticas_base, pokemon_tipo, tipo
Campos: t.nombre, eb.velocidad
2. Muestra los nombres de los tipos de Pokémon junto con la potencia máxima de movimientos de cualquier tipo que tienen una potencia superior a 80.
Tablas: movimiento, tipo
Campos: t.nombre, m.potencia
 */
 SELECT t.nombre AS tipo, AVG(eb.velocidad) AS velocidad_promedio
FROM estadisticas_base eb
JOIN pokemon_tipo pt ON eb.numero_pokedex = pt.numero_pokedex
JOIN tipo t ON pt.id_tipo = t.id_tipo
GROUP BY t.nombre;

SELECT t.nombre AS tipo, MAX(m.potencia) AS potencia_maxima
FROM movimiento m
JOIN tipo t ON m.id_tipo = t.id_tipo
WHERE m.potencia > 80
GROUP BY t.nombre;

/*Having
1. Muestra los nombres de los tipos de Pokémon junto con la cantidad de Pokémon de cada tipo que tienen una precisión promedio mayor a 80 en sus movimientos.
Tablas: tipo, pokemon_tipo, movimiento
Campos: t.nombre, m.precision_mov
2. Muestra los nombres de los Pokémon que tienen un promedio de ataque superior a 70 y más de un tipo.
Tablas: pokemon, pokemon_tipo, estadisticas_base
Campos: p.nombre, eb.ataque, pt.id_tipo
 */
SELECT t.nombre tipo, COUNT(m.nombre) cantidad_pokemon, m.precision_mov
FROM movimiento m 
JOIN tipo t
ON m.id_tipo = t.id_tipo
JOIN pokemon_tipo pt
ON t.id_tipo = pt.id_tipo
GROUP BY t.nombre, m.precision_mov
HAVING AVG(m.precision_mov) > 80;

SELECT p.nombre
FROM pokemon p
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
JOIN estadisticas_base eb ON p.numero_pokedex = eb.numero_pokedex
GROUP BY p.nombre
HAVING AVG(eb.ataque) > 70 AND COUNT(DISTINCT pt.id_tipo) > 1;

/*Registros
1. Muestra el nombre de cada Pokémon junto con su tipo y velocidad base. Ordena los resultados por el nombre del Pokémon en orden descendente.
	Tablas: pokemon, estadisticas_base, pokemon_tipo, tipo
Campos: p.nombre, t.nombre, eb.velocidad
2. Muestra los nombres de los tipos de Pokémon junto con la cantidad de Pokémon de cada tipo que tienen una velocidad promedio superior a 60 y una precisión promedio mayor a 85 en sus movimientos.
	Tablas: movimiento, tipo_ataque, pokemon_tipo, tipo, estadisticas_base, pokemon 
Campos: t.nombre
3. Muestra los nombres de los movimientos de tipo "Fuego" junto con los nombres de los Pokémon que pueden aprenderlos y el promedio de su altura. Solo incluye los movimientos con una potencia promedio mayor a 50.
		Tablas: movimiento, tipo_ataque, pokemon_tipo, tipo, pokemon
Campos: m.nombre, p.nombre, p.altura
 */
SELECT p.nombre, t.nombre AS tipo, eb.velocidad
FROM pokemon p
JOIN estadisticas_base eb ON p.numero_pokedex = eb.numero_pokedex
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
JOIN tipo t ON pt.id_tipo = t.id_tipo
ORDER BY p.nombre DESC;

SELECT 
	 t.nombre Tipo, COUNT(p.nombre) Cantidad, round(AVG(eb.velocidad),2) Velocidad_Promedio, round(AVG(m.precision_mov),2) Precisión_Promedio
FROM 
	movimiento m
JOIN 
	tipo t ON m.id_tipo= t.id_tipo
JOIN
	pokemon_tipo pt ON t.id_tipo=pt.id_tipo
JOIN 
	pokemon p ON pt.numero_pokedex = p.numero_pokedex
JOIN 
	estadisticas_base eb ON p.numero_pokedex=eb.numero_pokedex
JOIN
	tipo_ataque ta ON t.id_tipo_ataque=ta.id_tipo_ataque
GROUP BY 
	t.nombre, m.precision_mov
HAVING 
	AVG(eb.velocidad)>60 AND AVG(m.precision_mov)>85;
    
    SELECT 
	 t.nombre Tipo,m.nombre Movimiento,  p.nombre Pokemon, round(AVG(p.altura),2) Altura, m.potencia Potencia_Promedio
FROM 
	movimiento m
JOIN 
	tipo t ON m.id_tipo= t.id_tipo
JOIN
	pokemon_tipo pt ON t.id_tipo=pt.id_tipo
JOIN 
	pokemon p ON pt.numero_pokedex = p.numero_pokedex
JOIN
	tipo_ataque ta ON t.id_tipo_ataque=ta.id_tipo_ataque 
GROUP BY 
	t.nombre, m.nombre, p.nombre, m.potencia
HAVING 
	t.nombre="Fuego" AND AVG(m.potencia)> 50;



 











