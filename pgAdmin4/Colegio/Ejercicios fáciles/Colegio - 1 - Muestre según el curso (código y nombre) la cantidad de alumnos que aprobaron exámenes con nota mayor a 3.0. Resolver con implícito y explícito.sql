-- Implícito
-- Muestre según el curso (código y nombre) la cantidad de alumnos que aprobaron exámenes con nota mayor a 3.0
SELECT cu.cod_cur, cu.nom_cur, COUNT(cu.cod_cur) AS Cantidad_alumnos
FROM aplicacion_examen a_e, estudiante es, curso cu
WHERE a_e.fk_ide_alu = es.ide_alu
AND es.fk_cod_cur = cu.cod_cur
AND nta_apl > 3.0
GROUP BY cu.cod_cur, cu.nom_cur
ORDER BY cantidad_alumnos;



-- Explícito
-- Muestre según el curso (código y nombre) la cantidad de alumnos que aprobaron exámenes con nota mayor a 3.0
SELECT cu.cod_cur, cu.nom_cur, COUNT(cu.cod_cur) AS Cantidad_alumnos
FROM curso cu
JOIN estudiante es ON es.fk_cod_cur = cu.cod_cur
JOIN aplicacion_examen a_e ON a_e.fk_ide_alu = es.ide_alu
WHERE a_e.nta_apl > 3.0
GROUP BY cu.cod_cur, cu.nom_cur
ORDER BY cantidad_alumnos
