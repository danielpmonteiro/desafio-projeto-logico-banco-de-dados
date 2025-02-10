-- Consultas SQL

-- Recuperações Simples com SELECT
-- Lista todos os clientes
SELECT * FROM cliente;

-- Lista todos os produtos disponíveis
SELECT * FROM produto WHERE quantidade_disponivel > 0;

-- Filtros com WHERE
-- Lista pedidos com status "aprovado"
SELECT * FROM pedido WHERE status = 'aprovado';

-- Lista produtos com preço acima de R$ 100
SELECT * FROM produto WHERE preco > 100;

-- Lista todos os vendedores ativos
SELECT * FROM vendedor WHERE status = 'ativo';

-- Lista pedidos realizados por um vendedor específico
SELECT 
    pe.id AS pedido_id,
    c.nome AS cliente_nome,
    pe.total_pedido
FROM pedido pe
JOIN cliente c ON pe.cliente_id = c.id
WHERE pe.vendedor_id = 1;

-- Expressões para Gerar Atributos Derivados
-- Calcula o valor total dos pedidos (quantidade * preço unitário)
SELECT 
    pp.pedido_id,
    SUM(pp.quantidade * pp.preco_unitario) AS valor_total
FROM pedido_produto pp
GROUP BY pp.pedido_id;

-- Ordenações com ORDER BY
-- Lista produtos ordenados pelo preço (do mais barato ao mais caro)
SELECT * FROM produto ORDER BY preco ASC;

-- Lista pedidos ordenados pela data de criação (mais recente primeiro)
SELECT * FROM pedido ORDER BY data_pedido DESC;
desc pedido;
-- Lista vendedores ordenados pelo total de vendas (maior para menor)
SELECT 
    v.nome AS vendedor_nome,
    SUM(pe.total_pedido) AS total_vendas
FROM pedido pe
JOIN vendedor v ON pe.vendedor_id = v.id
GROUP BY v.nome
ORDER BY total_vendas DESC;

-- Condições de Filtros aos Grupos – HAVING
-- Lista fornecedores com mais de 2 produtos cadastrados
SELECT 
    pf.fornecedor_id,
    COUNT(*) AS total_produtos
FROM produto_fornecedor pf
GROUP BY pf.fornecedor_id
HAVING COUNT(*) > 2;

-- Lista vendedores com vendas totais acima de R$ 1000
SELECT 
    v.nome AS vendedor_nome,
    SUM(pe.total_pedido) AS total_vendas
FROM pedido pe
JOIN vendedor v ON pe.vendedor_id = v.id
GROUP BY v.nome
HAVING SUM(pe.total_pedido) > 1000;

-- Junções entre Tabelas
-- Lista os produtos e seus respectivos fornecedores
SELECT 
    p.nome AS produto,
    f.nome AS fornecedor
FROM produto_fornecedor pf
JOIN produto p ON pf.produto_id = p.id
JOIN fornecedor f ON pf.fornecedor_id = f.id;

-- Lista os pedidos e os clientes que os realizaram
SELECT 
    pe.id AS pedido_id,
    c.nome AS cliente_nome,
    pe.status AS pedido_status
FROM pedido pe
JOIN cliente c ON pe.cliente_id = c.id;

-- Lista os pedidos e os vendedores responsáveis por eles
SELECT 
    pe.id AS pedido_id,
    c.nome AS cliente_nome,
    v.nome AS vendedor_nome,
    pe.status AS pedido_status
FROM pedido pe
JOIN cliente c ON pe.cliente_id = c.id
LEFT JOIN vendedor v ON pe.vendedor_id = v.id;

-- Expressões para Gerar Atributos Derivados
-- Calcula o valor total de vendas por vendedor
SELECT 
    v.nome AS vendedor_nome,
    SUM(pe.total_pedido) AS total_vendas
FROM pedido pe
JOIN vendedor v ON pe.vendedor_id = v.id
GROUP BY v.nome;

-- Lista os pedidos com os respectivos produtos, vendedores, data do pedido, status e total do pedido
SELECT 
	pe.total_pedido AS  "Total Pedido",
    pe.status AS "Status",
    pe.data_pedido AS "Data Pedido",
    pr.nome AS Produto,
    c.nome AS "Cliente Comprador",
    v.nome AS Vendedor  
FROM
	pedido AS pe
INNER JOIN
	pedido_produto AS pp ON pe.id = pp.pedido_id 
INNER JOIN
	produto AS pr ON pr.id = pp.produto_id
INNER JOIN 
	vendedor AS v ON pe.vendedor_id = v.id
INNER JOIN 
	cliente AS c ON pe.cliente_id = c.id 
WHERE 
	pe.status IN ("aprovado", "entregue")
ORDER BY
	pe.data_pedido;
