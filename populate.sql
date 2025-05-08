-- Truncate all tables
DO
$$
DECLARE
  t RECORD;
BEGIN
  FOR t IN
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public'
  LOOP
    EXECUTE format(
      'TRUNCATE TABLE %I.%I RESTART IDENTITY CASCADE;',
      'public',
      t.tablename
    );
  END LOOP;
END
$$;

-- Populate non-relationship tables with at least 15 rows each

-- 1. localizacao
INSERT INTO localizacao (cidade, estado, pais, cep, bairro)
SELECT
  'Cidade' || i,
  'Estado' || i,
  'Pais' || i,
  LPAD(i::text, 8, '0'),
  'Bairro' || i
FROM generate_series(1,15) AS s(i);

-- 2. usuario (15 users alternating types)
INSERT INTO usuario (cpf, nome, sobrenome, data_nascimento, endereco, sexo, telefone, email, senha, tipo, loc_id)
SELECT
  LPAD(i::text, 11, '0'),
  'Nome' || i,
  'Sobrenome' || i,
  DATE '1980-01-01' + (i * INTERVAL '100 day'),
  'Rua ' || i || ', Número ' || i,
  CASE WHEN i % 2 = 0 THEN 'M' ELSE 'F' END,
  '119000000' || LPAD(i::text, 2, '0'),
  'user' || i || '@exemplo.com',
  'senha' || i,
  CASE WHEN i % 2 = 0 THEN 'hospede' ELSE 'locador' END,
  ((i - 1) % 15) + 1
FROM generate_series(1,15) AS s(i);

-- 3. locador (all users with tipo = 'locador')
INSERT INTO locador (cpf)
SELECT cpf FROM usuario WHERE tipo = 'locador';

-- 4. hospede (all users with tipo = 'hospede')
INSERT INTO hospede (cpf)
SELECT cpf FROM usuario WHERE tipo = 'hospede';

-- 5. conta_bancaria (15 accounts, random locador)
INSERT INTO conta_bancaria (numero_conta, agencia, tipo_conta, locador_cpf)
SELECT
  'ACC' || LPAD(i::text, 5, '0'),
  'AG' || LPAD(i::text, 4, '0'),
  CASE WHEN i % 2 = 0 THEN 'corrente' ELSE 'poupanca' END,
  (SELECT cpf FROM locador ORDER BY RANDOM() LIMIT 1)
FROM generate_series(1,15) AS s(i);

-- 6. ponto_interesse (15 points)
INSERT INTO ponto_interesse (descricao, loc_id)
SELECT
  'PontoInteress' || i,
  ((i - 1) % 15) + 1
FROM generate_series(1,15) AS s(i);

-- 7. propriedade (15 properties)
INSERT INTO propriedade (nome, endereco, tipo, num_quartos, num_banheiros, preco_noite, max_hospedes, min_noites, max_noites, taxa_limpeza, checkin_hora, checkout_hora, locador_cpf, loc_id)
SELECT
  'Prop' || i,
  'Endereço Prop ' || i,
  CASE (i % 3)
    WHEN 0 THEN 'casa_inteira'
    WHEN 1 THEN 'quarto_privativo'
    ELSE 'quarto_compartilhado'
  END,
  ((i % 5) + 1),
  ((i % 3) + 1),
  (50 + i * 5),
  ((i % 6) + 1),
  1 + (i % 2),
  7 + (i % 5),
  (20 + i),
  TIME '14:00',
  TIME '11:00',
  (SELECT cpf FROM locador ORDER BY RANDOM() LIMIT 1),
  ((i - 1) % 15) + 1
FROM generate_series(1,15) AS s(i);

-- 8. quarto (15 rooms)
INSERT INTO quarto (prop_id, num_camas, tipo_cama, banheiro_privativo)
SELECT
  ((i - 1) % 15) + 1,
  ((i % 4) + 1),
  CASE (i % 3)
    WHEN 0 THEN 'solteiro'
    WHEN 1 THEN 'casal'
    ELSE 'beliche'
  END,
  (i % 2 = 0)
FROM generate_series(1,15) AS s(i);

-- 9. comodidade (15 amenities)
INSERT INTO comodidade (descricao)
SELECT 'Comodidade ' || i
FROM generate_series(1,15) AS s(i);

-- 10. regra (15 rules)
INSERT INTO regra (descricao)
SELECT 'Regra ' || i
FROM generate_series(1,15) AS s(i);

-- Populate relationship tables with sufficient tuples

-- propriedade_comodidade (each property gets 3 random amenities)
INSERT INTO propriedade_comodidade (prop_id, comod_id)
SELECT
  ((i - 1) % 15) + 1,
  ((j - 1) % 15) + 1
FROM generate_series(1,15) AS s(i), generate_series(1,3) AS t(j);

-- propriedade_regra (each property gets 2 random rules)
INSERT INTO propriedade_regra (prop_id, regra_id)
SELECT
  ((i - 1) % 15) + 1,
  ((j - 1) % 15) + 1
FROM generate_series(1,15) AS s(i), generate_series(1,2) AS t(j);

-- Populate resto das não-relacionamento com pelo menos 15 tuplas

-- 11. reserva (15 bookings)
INSERT INTO reserva (hospede_cpf, prop_id, data_reserva, data_checkin, data_checkout, num_hospedes, imposto_pago, preco_total, preco_total_impostos, taxa_limpeza, status, status_data)
SELECT
  (SELECT cpf FROM hospede ORDER BY RANDOM() LIMIT 1),
  ((i - 1) % 15) + 1,
  CURRENT_DATE - (15 - i),
  CURRENT_DATE - (15 - i) + INTERVAL '7 day',
  CURRENT_DATE - (15 - i) + INTERVAL '10 day',
  ((i % 4) + 1),
  (10 + i),
  (100 + i * 10),
  (110 + i * 10),
  (15 + i),
  CASE (i % 3)
    WHEN 0 THEN 'pendente'
    WHEN 1 THEN 'confirmada'
    ELSE 'cancelada'
  END,
  CURRENT_TIMESTAMP - ((15 - i) * INTERVAL '1 day')
FROM generate_series(1,15) AS s(i);

-- 12. avaliacao (15 reviews)
INSERT INTO avaliacao (reserva_id, hospede_cpf, prop_id, texto, nota_limpeza, nota_estrutura, nota_comunicacao, nota_localizacao, nota_valor)
SELECT
  i,
  (SELECT reserva.hospede_cpf FROM reserva WHERE reserva.id = i),
  (SELECT reserva.prop_id   FROM reserva WHERE reserva.id = i),
  'Texto de avaliação ' || i,
  ((i % 5) + 1),
  ((i % 5) + 1),
  ((i % 5) + 1),
  ((i % 5) + 1),
  ((i % 5) + 1)
FROM generate_series(1,15) AS s(i);

-- 13. mensagem_aval (15 messages about reviews)
INSERT INTO mensagem_aval (remetente_cpf, destinatario_cpf, ts, texto, aval_id)
SELECT
  (SELECT cpf FROM usuario ORDER BY RANDOM() LIMIT 1),
  (SELECT cpf FROM usuario ORDER BY RANDOM() LIMIT 1),
  CURRENT_TIMESTAMP - ((15 - i) * INTERVAL '2 hours'),
  'Mensagem sobre avaliação ' || i,
  ((i - 1) % 15) + 1
FROM generate_series(1,15) AS s(i);

-- 14. foto (15 photos linked to reviews)
INSERT INTO foto (url, aval_id)
SELECT
  'https://exemplo.com/foto_' || i || '.jpg',
  ((i - 1) % 15) + 1
FROM generate_series(1,15) AS s(i);

-- 15. mensagem_chat (15 chat messages)
INSERT INTO mensagem_chat (id, remetente_cpf, destinatario_cpf, ts, texto)
SELECT
  i,
  (SELECT cpf FROM usuario ORDER BY RANDOM() LIMIT 1),
  (SELECT cpf FROM usuario ORDER BY RANDOM() LIMIT 1),
  CURRENT_TIMESTAMP - ((15 - i) * INTERVAL '1 hour'),
  'Chat message ' || i
FROM generate_series(1,15) AS s(i);
