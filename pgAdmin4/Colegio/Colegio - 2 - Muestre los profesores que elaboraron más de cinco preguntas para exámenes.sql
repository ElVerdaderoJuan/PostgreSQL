-- Implícito
-- Muestre los profesores que elaboraron más de cinco preguntas para exámenes.
SELECT pro.*, COUNT(pro.ide_pro) AS Cantidad_preguntas
FROM profesor pro, examen ex, pregunta pre
WHERE ex.fk_ide_pro = pro.ide_pro
AND pre.fk_cod_exa = ex.cod_exa
GROUP BY pro.ide_pro
HAVING COUNT(pro.ide_pro) > 5



-- Explícito
-- Muestre los profesores que elaboraron más de cinco preguntas para exámenes.
SELECT pro.*, COUNT(pro.ide_pro) AS Cantidad_preguntas
FROM profesor pro
JOIN examen ex ON ex.fk_ide_pro = pro.ide_pro
JOIN pregunta pre ON pre.fk_cod_exa = ex.cod_exa
GROUP BY pro.ide_pro
HAVING COUNT(pro.ide_pro) > 5
