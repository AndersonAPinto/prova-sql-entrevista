-- Lista de funcionários ordenando pelo salário decrescente
-- Seleciona todos os vendedores ativos, ordenando pelo salário de forma decrescente
 SELECT id_vendedor, nome, cargo, salario, data_admissao FROM VENDEDORES WHERE inativo = false ORDER BY salario DESC;

 -- Lista de pedidos de vendas ordenado por data de emissão
 -- Seleciona todos os pedidos de vendas, ordenando pela data de emissão de forma decrescente
 SELECT id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao FROM PEDIDO ORDER BY data_emissao DESC;

 -- Valor de faturamento por cliente
 -- Calcula o valor total de faturamento por cliente, agrupando por cliente e ordenando pelo faturamento total de forma decrescente
 SELECT C.id_cliente, C.razao_social, SUM(P.valor_total) AS faturamento_total FROM CLIENTES C JOIN PEDIDO P ONC.id_cliente = P.id_cliente
 WHERE C.inativo = false AND P.situacao = 'concluido' GROUP BY C.id_cliente, C.razao_social ORDER BY faturamento_total DESC;

 -- Valor de faturamento por empresa
 -- Calcula o valor total de faturamento por empresa, agrupando por empresa e ordenando pelo faturamento total de forma decrescente
 SELECT E.id_empresa, E.razao_social, SUM(P.valor_total) AS faturamento_total FROM EMPRESA E
 JOIN PEDIDO P ONE.id_empresa = P.id_empresa WHERE E.inativo = false AND P.situacao = 'concluido' GROUP BY E.id_empresa, E.razao_social
 ORDER BY faturamento_total DESC;

 -- Valor de faturamento por vendedor
 -- Calcula o valor total de faturamento por vendedor, agrupando por vendedor e ordenando pelo faturamento total de forma decrescente
 SELECT V.id_vendedor, V.nome, SUM(P.valor_total) AS faturamento_total FROM VENDEDORES V
 JOIN CLIENTES C ON V.id_vendedor = C.id_vendedor JOIN PEDIDO P ONC.id_cliente = P.id_cliente
 WHERE V.inativo = false AND P.situacao = 'concluido' GROUP BY V.id_vendedor, V.nome ORDER BY faturamento_total DESC;

-- Consulta de junção para obter o preço base do produto conforme a regra
-- Consulta para unir produtos e clientes, obtendo o último preço praticado ou o preço mínimo configurado
 SELECT 
    PR.id_produto, 
    PR.descricao, 
    CL.id_cliente, 
    CL.razao_social AS cliente_razao_social, 
    EM.id_empresa,
    EM.razao_social AS empresa_razao_social, 
    VE.id_vendedor, 
    VE.nome AS vendedor_nome, 
    CP.preco_minimo, 
    CP.preco_maximo, 
    COALESCE(
        (
            SELECT IP.preco_praticado
            FROM ITENS_PEDIDO IP
            JOIN PEDIDO PE ON IP.id_pedido = PE.id_pedido
            WHERE IP.id_produto = PR.id_produto
            AND PE.id_cliente = CL.id_cliente
            ORDER BY PE.data_emissao DESC
            LIMIT 1
        ), CP.preco_minimo) AS preco_base
FROM
    PRODUTOS PR
JOIN CONFIG_PRECO_PRODUTO CP ON PR.id_produto = CP.id_produto
JOIN EMPRESA EM ON CP.id_empresa = EM.id_empresa
JOIN CLIENTES CL ON CP.id_empresa = CL.id_empresa
JOIN VENDEDORES VE ON CL.id_vendedor = VE.id_vendedor
WHERE
    PR.inativo = false
    AND CL.inativo = false
    AND EM.inativo = false
ORDER BY
    PR.id_produto, CL.id_cliente;
