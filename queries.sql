-- Mostrar a relação inteira de propriedades
SELECT * FROM propriedade;

-- Mostre a média de preço por noite (preco_noite) para cada tipo de propriedade
SELECT tipo, ROUND(AVG(preco_noite), 2) AS media_preco
FROM propriedade
GROUP BY tipo;

-- Quantas propriedades existem em cada cidade
SELECT l.cidade, COUNT(*) AS quantidade
FROM propriedade p
JOIN localizacao l ON p.loc_id = l.id
GROUP BY l.cidade;

-- Locações confirmadas com data de entrada a partir de 24/04/2025
SELECT
  r.hospede_cpf,
  p.locador_cpf,          -- chave do locador (item 3.4 a)
  r.prop_id,
  r.data_checkin,
  r.data_checkout,
  r.status,
  (r.data_checkout - r.data_checkin) AS dias_locados,       -- item 3.4 b
  hu.nome  AS nome_hospede,                                 -- item 3.4 c
  lu.nome  AS nome_locador,
  p.preco_noite                                              -- item 3.4 d
FROM   reserva      r
JOIN   propriedade  p  ON p.id = r.prop_id
JOIN   usuario      hu ON hu.cpf = r.hospede_cpf
JOIN   usuario      lu ON lu.cpf = p.locador_cpf
WHERE  r.status = 'confirmada'
  AND  r.data_checkin >= DATE '2025-04-24'      -- ajuste pedido
ORDER  BY r.data_checkin;


-- Quais regras aparecem com mais frequência nas propriedades?
SELECT 
  r.descricao,
  COUNT(pr.prop_id) AS vezes_utilizada
FROM regra r
JOIN propriedade_regra pr ON r.id = pr.regra_id
GROUP BY r.descricao
ORDER BY vezes_utilizada DESC;

-- Quais anfitriões tiveram pelo menos 5 locações, mostrando:
-- nome, cidade, número de imóveis e total de locações
SELECT
    u.nome,
    lz.cidade,
    COUNT(DISTINCT p.id) AS num_imoveis,
    COUNT(r.id) AS total_locoes
FROM locador l 
JOIN usuario u ON u.cpf = l.cpf
JOIN localizacao lz ON u.loc_id = lz.id
JOIN propriedade p ON p.locador_cpf = l.cpf
JOIN reserva r ON r.prop_id = p.id
GROUP BY u.cpf, u.nome, lz.cidade
HAVING COUNT(r.id) >= 5;

-- Mostre o número de reservas realizadas por cada hóspede, com o total gasto em todas as locações.
SELECT
    u.cpf,
    u.nome,
    COUNT(r.id) AS num_reservas,
    SUM(r.preco_total) AS total_gasto
FROM usuario u  
JOIN hospede h ON u.cpf = h.cpf
JOIN reserva r ON h.cpf = r.hospede_cpf
GROUP BY u.cpf, u.nome
ORDER BY total_gasto DESC;

-- Liste as propriedades com as maiores notas de avaliação (média das 5 notas), ordenadas da melhor para a pior.
SELECT
    a.prop_id,
    p.nome,
    ROUND((
        a.nota_limpeza + a.nota_estrutura + a.nota_comunicacao + a.nota_localizacao + a.nota_valor
    ) / 5.0, 2) AS media_avaliacao
FROM avaliacao a
JOIN propriedade p ON a.prop_id = p.id
ORDER BY media_avaliacao DESC;

-- Liste os locadores que nunca receberam uma avaliação.
SELECT 
    u.cpf, u.nome
FROM usuario u
JOIN locador l ON l.cpf = u.cpf
JOIN propriedade p ON p.locador_cpf = l.cpf
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacao a
    WHERE a.prop_id = p.id
);

-- Usuário que é Locatario e Anfitriao ao mesmo tempo
SELECT DISTINCT u.cpf, u.nome
FROM   usuario u
JOIN   hospede  h USING (cpf)
JOIN   locador  l USING (cpf);

-- Valor médio das diárias de cada propriedade, considerando apenas as reservas confirmadas.

SELECT
  TO_CHAR(DATE_TRUNC('month', r.data_checkin), 'YYYY-MM') AS mes,
  ROUND(AVG(p.preco_noite), 2)                           AS preco_medio_todas,
  ROUND(AVG(CASE WHEN r.status = 'confirmada'
                 THEN p.preco_noite END), 2)             AS preco_medio_confirmadas
FROM   reserva r
JOIN   propriedade p ON p.id = r.prop_id
GROUP  BY DATE_TRUNC('month', r.data_checkin)
ORDER  BY mes;

--Locatários mais jovens que algum anfitrião (3.5 d)

SELECT DISTINCT hu.cpf, hu.nome, hu.data_nascimento
FROM   hospede h
JOIN   usuario hu ON hu.cpf = h.cpf
WHERE  hu.data_nascimento >                -- data_nasc “maior” = mais jovem
       (SELECT MIN(u2.data_nascimento)
        FROM   locador l2
        JOIN   usuario u2 ON u2.cpf = l2.cpf);

-- Locatários mais velhos que algum anfitrião (3.5 e)

SELECT DISTINCT hu.cpf, hu.nome, hu.data_nascimento
FROM   hospede h
JOIN   usuario hu ON hu.cpf = h.cpf
WHERE  hu.data_nascimento >                -- mais jovem do que o MAIS jovem anfitrião
       (SELECT MAX(u2.data_nascimento)
        FROM   locador l2
        JOIN   usuario u2 ON u2.cpf = l2.cpf);