WITH RECURSIVE tipo_jerarquia AS (
    SELECT
        c.id_cerveza,
        c.nombre_cerveza,
        tc.id_tipo_cerveza,
        tc.nombre AS tipo_nombre,
        tc.tipo_padre_id,
        0 AS nivel
    FROM Cerveza c
    JOIN Tipo_Cerveza tc ON c.id_tipo_cerveza = tc.id_tipo_cerveza

    UNION ALL

    SELECT
        tj.id_cerveza,
        tj.nombre_cerveza,
        tc.id_tipo_cerveza,
        tc.nombre AS tipo_nombre,
        tc.tipo_padre_id,
        tj.nivel + 1
    FROM tipo_jerarquia tj
    JOIN Tipo_Cerveza tc ON tj.tipo_padre_id = tc.id_tipo_cerveza
)
SELECT
    tj.id_cerveza,
    tj.nombre_cerveza,
    STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Color' THEN ce.valor END, ', ') AS color,
    STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Graduación alcohólica' AND RIGHT(TRIM(ce.valor), 1) = '%' THEN ce.valor END, '-') AS graduacion_alcoholica,
    STRING_AGG(DISTINCT CASE WHEN car.tipo_caracteristica = 'Amargor' AND ce.valor IN ('Bajo', 'Medio', 'Alto', 'Muy alto') THEN ce.valor END, ', ') AS amargor
FROM tipo_jerarquia tj
JOIN Caracteristica_Especifica ce ON tj.id_tipo_cerveza = ce.id_tipo_cerveza
JOIN Caracteristica car ON ce.id_caracteristica = car.id_caracteristica
WHERE car.tipo_caracteristica IN ('Color', 'Graduación alcohólica', 'Amargor')
GROUP BY tj.id_cerveza, tj.nombre_cerveza
ORDER BY tj.id_cerveza;