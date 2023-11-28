/*Mostrar el nombre, peso y altura de los pokémon cuyo peso sea mayor a 150.
Tablas: pokemon
Campos: nombre, peso, altura*/
SELECT nombre, peso, altura FROM pokemon WHERE peso > 150;
/*Muestra los nombres y potencias de los movimientos que tienen una precisión mayor 90.
Tablas: movimiento, tipo
Campos: m.nombre, t.nombre, potencia
*/
SELECT m.nombre, t.nombre, potencia 
FROM movimiento m 
JOIN tipo t ON m.tipo_id = t.id 
WHERE precision_mov > 90;
/*Muestra los nombres de los tipos de Pokémon junto con sus tipos de ataque correspondientes de aquellos cuya potencia sea igual a 0.
Tablas: tipo, tipo_ataque, movimiento
Campos: t.nombre ta.tipo m.potencia
 */
 SELECT t.nombre AS tipo, m.nombre AS movimiento, m.potencia 
FROM movimiento m 
JOIN tipo t ON m.tipo_id = t.id 
WHERE m.potencia >= 120;
/*Muestra los nombres y números de Pokédex de los primeros 10 Pokémon en orden alfabético.
Tablas: pokemon
Campos: numero_pokedex, nombre
*/
SELECT numero_pokedex, nombre 
FROM pokemon 
ORDER BY nombre 
LIMIT 10;
/*Muestra los nombres y alturas de los Pokémon de tipo "Eléctrico", ordenados por altura de forma descendente.
Tablas: pokemon, pokemon_tipo, tipo
Campos: nombre, altura
*/
SELECT p.nombre, p.altura 
FROM pokemon p 
JOIN pokemon_tipo pt ON p.id = pt.pokemon_id 
JOIN tipo t ON pt.tipo_id = t.id 
WHERE t.nombre = 'Eléctrico' 
ORDER BY p.altura DESC;
/*¿Cuál es la suma total de los valores de "Defensa" en todas las estadísticas base?
Tablas: estadisticas_base
Campos: defensa
*/
SELECT SUM(defensa) 
FROM estadisticas_base;
/*¿Cuántos Pokémon tienen el tipo "Fuego"?
	Tablas: pokemon_tipo, tipo
Campos: *
 */
SELECT COUNT(*) 
FROM pokemon_tipo pt 
JOIN tipo t ON pt.tipo_id = t.id 
WHERE t.nombre = 'Fuego';
/* Muestra los nombres de los tipos de Pokémon junto con la cantidad de Pokémon de cada tipo.
Tablas: pokemon_tipo, tipo
Campos: nombre, numero_pokedex
*/
SELECT t.nombre, COUNT(pt.numero_pokedex) AS cantidad 
FROM tipo t 
JOIN pokemon_tipo pt ON t.id = pt.tipo_id 
GROUP BY t.nombre;
/*Muestra los nombres de los tipos de Pokémon junto con el promedio de peso de los Pokémon de cada tipo. Ordena los resultados de manera descendente según el promedio de peso.
Tablas: pokemon, pokemon_tipo, tipo
Campos: t.nombre, p.peso
*/
SELECT t.nombre, AVG(p.peso) AS promedio_peso 
FROM tipo t 
JOIN pokemon_tipo pt ON t.id = pt.tipo_id 
JOIN pokemon p ON pt.numero_pokedex = p.numero_pokedex 
GROUP BY t.nombre 
ORDER BY promedio_peso DESC;
/*Muestra los nombres de los Pokémon que tienen más de un tipo.
Tablas: pokemon, pokemon_tipo
Campos: nombre
*/
SELECT p.nombre 
FROM pokemon p 
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex 
GROUP BY p.nombre 
HAVING COUNT(pt.tipo_id) > 1;
/*Muestra los nombres de los tipos de Pokémon junto con la cantidad de Pokémon de cada tipo que tienen un peso promedio mayor a 10.
Tablas: pokemon, pokemon_tipo, tipo
Campos: nombre, numero_pokedex
*/
SELECT t.nombre, COUNT(p.numero_pokedex) AS cantidad 
FROM tipo t 
JOIN pokemon_tipo pt ON t.id = pt.tipo_id 
JOIN pokemon p ON pt.numero_pokedex = p.numero_pokedex 
GROUP BY t.nombre 
HAVING AVG(p.peso) > 10;
/*Muestra los nombres de los movimientos de tipo de ataque "Especial" con una potencia superior a 10 y una descripción que contenga al menos 20 palabras.
Tablas: movimiento, tipo_ataque
Campos: nombre, potencia, tipo, descripcion
 */
 SELECT m.nombre, m.potencia, ta.tipo, m.descripcion 
FROM movimiento m 
JOIN tipo_ataque ta ON m.tipo_ataque_id = ta.id 
WHERE ta.tipo = 'Especial' AND m.potencia > 10 AND LENGTH(m.descripcion) - LENGTH(REPLACE(m.descripcion, ' ', '')) + 1 >= 20;
/*Muestra los nombres de los tipos de Pokémon junto con la cantidad de Pokémon de cada tipo que tienen una velocidad promedio superior a 80. Solo incluye tipos que tienen al menos 3 Pokémon con esas características.
	Tablas: tipo, pokemon_tipo, estadisticas_base
Campos: t.nombre, *
*/
SELECT t.nombre, COUNT(*) AS cantidad 
FROM tipo t 
JOIN pokemon_tipo pt ON t.id = pt.tipo_id 
JOIN estadisticas_base eb ON pt.numero_pokedex = eb.numero_pokedex 
WHERE eb.velocidad > 80 
GROUP BY t.nombre 
HAVING COUNT(*) >= 3;
/*Muestra el nombre de cada Pokémon junto con su tipo, velocidad base y puntos de salud (PS) base. Ordena los resultados por la velocidad base de forma descendente.
	Tablas: pokemon, estadisticas_base, pokemon_tipo, tipo
Campos: p.nombre, t.nombre, eb.velocidad, eb.ps
*/
SELECT p.nombre, t.nombre AS tipo, eb.velocidad, eb.ps 
FROM pokemon p 
JOIN estadisticas_base eb ON p.numero_pokedex = eb.numero_pokedex 
JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex 
JOIN tipo t ON pt.tipo_id = t.id 
ORDER BY eb.velocidad DESC;
/*Muestra los nombres de los movimientos de tipo "Agua" junto con los nombres de los Pokémon que pueden aprenderlos y el peso promedio de estos Pokémon.
	Tablas: movimiento, tipo_ataque, pokemon_tipo, tipo, pokemon
Campos: m.nombre, p.nombre, peso
*/
SELECT m.nombre AS movimiento, p.nombre AS pokemon, AVG(p.peso) AS peso_promedio 
FROM movimiento m 
JOIN tipo_ataque ta ON m.tipo_ataque_id = ta.id 
JOIN pokemon_tipo pt ON m.id = pt.movimiento_id 
JOIN pokemon p ON pt.numero_pokedex = p.numero_pokedex 
WHERE ta.tipo = 'Agua' 
GROUP BY m.nombre, p.nombre;
