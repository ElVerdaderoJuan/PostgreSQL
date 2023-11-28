-- Implícito
-- Muestre la cantidad de horas a invertir en cada curso teniendo en cuenta las asignaturas que la componen.
SELECT cur.cod_cur, cur.nom_cur, SUM(asi.dur_asi) AS Horas_a_invertir
FROM profesor pro, asignatura asi, curso cur
WHERE asi.fk_cod_cur = cur.cod_cur
AND asi.fk_ide_pro = pro.ide_pro
GROUP BY cur.cod_cur
ORDER BY horas_a_invertir



-- Explícito
-- Muestre la cantidad de horas a invertir en cada curso teniendo en cuenta las asignaturas que la componen.
SELECT cur.cod_cur, cur.nom_cur, SUM(asi.dur_asi) AS Horas_a_invertir
FROM curso cur
JOIN asignatura asi ON asi.fk_cod_cur = cur.cod_cur
JOIN profesor pro ON asi.fk_ide_pro = pro.ide_pro
GROUP BY cur.cod_cur
ORDER BY horas_a_invertir
