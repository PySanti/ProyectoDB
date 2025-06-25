SELECT 
    -- Año y mes de la venta
    EXTRACT(YEAR FROM ce.fecha_hora_asignacion) AS anio,
    EXTRACT(MONTH FROM ce.fecha_hora_asignacion) AS mes,
    
    -- Nombre del mes para mejor visualización
    TO_CHAR(ce.fecha_hora_asignacion, 'Month YYYY') AS periodo,
    
    -- Tipo de venta (Online o Física)
    CASE 
        WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'Online'
        WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'Física'
        ELSE 'Sin definir'
    END AS tipo_venta,
    
    -- Suma de montos totales para este tipo de venta en este mes
    SUM(c.monto_total) AS ingresos_totales,
    
    -- Contador de ventas para este tipo en este mes
    COUNT(*) AS cantidad_ventas
    
FROM Compra c
INNER JOIN Compra_Estatus ce ON c.id_compra = ce.compra_id_compra
WHERE 
    -- Solo ventas con monto total mayor a 0 (ventas reales)
    c.monto_total > 0
    -- Solo estatus "Atendida" (ventas completadas)
    AND ce.estatus_id_estatus = 3
    -- Solo ventas que tienen fecha de asignación
    AND ce.fecha_hora_asignacion IS NOT NULL
    -- Solo ventas que son online o física (excluir ventas sin definir)
    AND (c.tienda_web_id_tienda IS NOT NULL OR c.tienda_fisica_id_tienda IS NOT NULL)
    -- Filtrar por año específico (se puede parametrizar)
    -- AND EXTRACT(YEAR FROM ce.fecha_hora_asignacion) = 2024

GROUP BY 
    EXTRACT(YEAR FROM ce.fecha_hora_asignacion),
    EXTRACT(MONTH FROM ce.fecha_hora_asignacion),
    TO_CHAR(ce.fecha_hora_asignacion, 'Month YYYY'),
    CASE 
        WHEN c.tienda_web_id_tienda IS NOT NULL THEN 'Online'
        WHEN c.tienda_fisica_id_tienda IS NOT NULL THEN 'Física'
        ELSE 'Sin definir'
    END

ORDER BY 
    tipo_venta DESC,
	anio ASC,
    mes ASC;