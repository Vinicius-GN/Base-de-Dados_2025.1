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

-- Locações confirmadas com data de entrada a partir de 01/01/2024
SELECT
    r.id AS reserva_id,
    r.hospede_cpf,
    r.prop_id,
    r.data_checkin,
    r.data_checkout,
    r.status,
    (r.data_checkout - r.data_checkin) AS dias_locados,
    u_hospede.nome AS nome_hospede,
    u_locador.nome AS nome_locador,
    p.preco_noite
FROM reserva r
JOIN propriedade p ON r.prop_id = p.id
JOIN usuario u_hospede ON r.hospede_cpf = u_hospede.cpf
JOIN usuario u_locador ON p.locador_cpf = u_locador.cpf
WHERE r.status = 'confirmada'
  AND r.data_checkin >= DATE '2024-01-01';

-- Quais regras aparecem com mais frequência nas propriedades?
SELECT 
  r.descricao,
  COUNT(pr.prop_id) AS vezes_utilizada
FROM regra r
JOIN propriedade_regra pr ON r.id = pr.regra_id
GROUP BY r.descricao
ORDER BY vezes_utilizada DESC;

-- Quais anfitriões tiveram pelo menos 2 locações, mostrando:
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
HAVING COUNT(r.id) >= 2;

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
