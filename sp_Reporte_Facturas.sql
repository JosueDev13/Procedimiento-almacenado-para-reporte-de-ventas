
GO

/****** Object:  StoredProcedure [dbo].[sp_Reporte_Facturas]    Script Date: 5/8/2025 21:24:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_Reporte_Facturas]
@fecha datetime, 
@cliente varchar(12)
as
begin
select 
c.Emisor, 
c.Tarjeta,
c.abono, 
c.cargo, 
c.cheque, 
c.cliente, 
c.cobrador,
c.codCtaBanco,
c.codOperBanco,
c.codbanco, 
c.codsucursal,
c.concepto,
c.conceptocxc,
c.condpago,
c.departamento, 
c.efectivo,
c.es_venta, 
c.fechaCreacion,
c.fechaRemesa,
c.fechaVence,
c.fechach,
c.numCxC, 
c.numFactura,
c.numdoc,
c.numero,
c.numeroch, 
c.remesa, 
c.saldo,
c.salfec,
c.valor,
c.vendedor,
DATEDIFF(day, c.fechaCreacion, @fecha) as DiasDesdeEmision,
DATEDIFF(day, fechaVence, @fecha) AS DiasDesdeVencimiento,
t.nombrecli,
f.dir_cliente, 
f.valortot, 
f.iva,
v.nombre_vend,
t.cliente,
f.afecta,
f.numero,
f.tipofact,
	case when 
	f.condpago = 2 
		then 'CRÉDITO'
		else  'CONTRA ENTREGA'end as condicion_pago,
case when DATEDIFF(DAY, c.fechaVence, @fecha) < 0 then c.saldo 
else 0 
end as no_vencido,
case when DATEDIFF(DAY, c.fechaVence, @fecha) BETWEEN 1 AND 30 then c.saldo 
else 0 
end as Saldo_1_a_30,
case when DATEDIFF(DAY, c.fechaVence, @fecha) BETWEEN 31 AND 60 then c.saldo 
else 0 
end as Saldo_31_a_60,
case when DATEDIFF(DAY, c.fechaVence, @fecha) BETWEEN 61 AND 90 then c.saldo 
else 0 
end as Saldo_61_a_90,
case when DATEDIFF(DAY, c.fechaVence, @fecha) BETWEEN 91 AND 120 then c.saldo 
else 0 
end as Saldo_91_a_120,
case when DATEDIFF(DAY, c.fechaVence, @fecha) > 120 then c.saldo 
else 0
end as Saldo_Mas_120
from cxc as c
inner join facturas as f on c.numCxC =  f.numero and c.concepto = f.tipofact
inner join Clientes as t on f.cliente = t.Cliente
inner join vendedores as v on f.idvendedor = v.idVendedor
--inner join movCxc as mv on mv.tipoFactura = c.concepto and mv.numeroFactura = c.numCxC
WHERE (c.fechaCreacion <= @fecha) AND (c.cliente = @cliente) AND (c.es_venta = 1) and  (f.anulado = 0) and (c.saldo <> 0)-- and (mv.cancelado <> 1)

end
GO

