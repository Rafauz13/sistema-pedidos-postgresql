-- CONSULTAS SQL

-- (a) Quantidade de itens do pedido 005
SELECT p.codigo_pedido, SUM(i.quantidade) AS total_itens
FROM pedidos p
JOIN itens_pedido i ON p.id = i.pedido_id
WHERE p.codigo_pedido = '005'
GROUP BY p.codigo_pedido;

-- (b) Pedidos do cliente Ricardo
WITH ric AS (
    SELECT id FROM clientes WHERE nome = 'Ricardo'
)
SELECT *
FROM pedidos
WHERE cliente_id = (SELECT id FROM ric)
AND (SELECT COUNT(*) FROM pedidos WHERE cliente_id = (SELECT id FROM ric)) = 5;

-- (c) Produtos que Ricardo já comprou
SELECT DISTINCT pr.nome
FROM produtos pr
JOIN itens_pedido ip ON pr.id = ip.produto_id
JOIN pedidos pe ON pe.id = ip.pedido_id
JOIN clientes c ON c.id = pe.cliente_id
WHERE c.nome = 'Ricardo';

-- (d) Pedidos pendentes de outubro e novembro
SELECT *
FROM pedidos
WHERE situacao = 'Pendente'
AND EXTRACT(MONTH FROM data_pedido) IN (10,11)
AND EXTRACT(YEAR FROM data_pedido) = 2025;
