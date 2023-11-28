-- Implícito
-- Muestre la cantidad de asignaturas que hay por cada curso
SELECT curso.cod_cur, curso.nom_cur, COUNT(curso.cod_cur) AS Cantidad
FROM asignatura, curso
WHERE curso.cod_cur = asignatura.fk_cod_cur
GROUP BY curso.cod_cur, curso.nom_cur
ORDER BY Cantidad



-- Explícito
-- Muestre la cantidad de asignaturas que hay por cada curso
SELECT curso.cod_cur, curso.nom_cur, COUNT(curso.cod_cur) AS Cantidad
FROM curso
JOIN asignatura ON curso.cod_cur = asignatura.fk_cod_cur
GROUP BY curso.cod_cur, curso.nom_cur
ORDER BY Cantidad
