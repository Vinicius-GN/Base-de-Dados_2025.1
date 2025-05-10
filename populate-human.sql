SET session_replication_role = 'replica';

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

-- Reset sequence values
ALTER SEQUENCE seq_localizacao_id RESTART WITH 1;
ALTER SEQUENCE seq_pontointeresse_id RESTART WITH 1;
ALTER SEQUENCE seq_propriedade_id RESTART WITH 1;
ALTER SEQUENCE seq_quarto_id RESTART WITH 1;
ALTER SEQUENCE seq_comodidade_id RESTART WITH 1;
ALTER SEQUENCE seq_regra_id RESTART WITH 1;
ALTER SEQUENCE seq_reserva_id RESTART WITH 1;
ALTER SEQUENCE seq_avaliacao_id RESTART WITH 1;
ALTER SEQUENCE seq_mensagemaval_id RESTART WITH 1;
ALTER SEQUENCE seq_foto_id RESTART WITH 1;

-- Populate non-relationship tables with at least 15 rows each

-- 1. localizacao
INSERT INTO localizacao (cidade, estado, pais, cep, bairro)
VALUES
  ('São Paulo', 'São Paulo', 'Brasil', '04578-000', 'Vila Olímpia'),
  ('Rio de Janeiro', 'Rio de Janeiro', 'Brasil', '22031-001', 'Copacabana'),
  ('Curitiba', 'Paraná', 'Brasil', '80010-010', 'Centro'),
  ('Salvador', 'Bahia', 'Brasil', '40010-020', 'Pelourinho'),
  ('Belo Horizonte', 'Minas Gerais', 'Brasil', '30130-110', 'Savassi'),
  ('Porto Alegre', 'Rio Grande do Sul', 'Brasil', '90010-280', 'Moinhos de Vento'),
  ('Recife', 'Pernambuco', 'Brasil', '50030-230', 'Boa Viagem'),
  ('Florianópolis', 'Santa Catarina', 'Brasil', '88015-200', 'Centro'),
  ('Brasília', 'Distrito Federal', 'Brasil', '70070-120', 'Asa Sul'),
  ('Fortaleza', 'Ceará', 'Brasil', '60175-045', 'Meireles'),
  ('New York', 'New York', 'United States', '10001', 'Manhattan'),
  ('Paris', 'Île-de-France', 'France', '75001', 'Le Marais'),
  ('London', 'England', 'United Kingdom', 'SW1A 1AA', 'Westminster'),
  ('Tokyo', 'Tokyo', 'Japan', '100-0001', 'Chiyoda'),
  ('Lisboa', 'Lisboa', 'Portugal', '1000-001', 'Baixa');

-- 2. usuario (15 users alternating types)
INSERT INTO usuario (cpf, nome, sobrenome, data_nascimento, endereco, sexo, telefone, email, senha, tipo, loc_id)
VALUES
  ('12345678901', 'Pedro', 'Santos', '1990-05-15', 'Rua Augusta, 789', 'M', '11987654321', 'pedro.santos@email.com', 'senha123', 'locador', 1),
  ('23456789012', 'Maria', 'Oliveira', '1988-03-22', 'Av. Paulista, 1000', 'F', '11976543210', 'maria.oliveira@email.com', 'senha456', 'hospede', 2),
  ('34567890123', 'Carlos', 'Ferreira', '1985-07-10', 'Rua Copacabana, 234', 'M', '21987654322', 'carlos.ferreira@email.com', 'senha789', 'locador', 3),
  ('45678901234', 'Ana', 'Costa', '1992-11-30', 'Av. Boa Viagem, 567', 'F', '81976543211', 'ana.costa@email.com', 'senha321', 'hospede', 4),
  ('56789012345', 'Lucas', 'Rodrigues', '1987-09-25', 'Rua das Flores, 890', 'M', '41987654323', 'lucas.rodrigues@email.com', 'senha654', 'locador', 5),
  ('67890123456', 'Julia', 'Lima', '1995-02-18', 'Av. Beira Mar, 123', 'F', '85976543212', 'julia.lima@email.com', 'senha987', 'hospede', 6),
  ('78901234567', 'Rafael', 'Almeida', '1983-06-07', 'Rua da Praia, 456', 'M', '51987654324', 'rafael.almeida@email.com', 'senha147', 'locador', 7),
  ('89012345678', 'Beatriz', 'Martins', '1993-04-12', 'Av. Atlântica, 789', 'F', '21976543213', 'beatriz.martins@email.com', 'senha258', 'hospede', 8),
  ('90123456789', 'Fernando', 'Pereira', '1989-08-20', 'Rua XV, 1011', 'M', '41987654325', 'fernando.pereira@email.com', 'senha369', 'locador', 9),
  ('01234567890', 'Carolina', 'Souza', '2005-12-05', 'Av. Brasil, 1213', 'F', '61976543214', 'carolina.souza@email.com', 'senha741', 'hospede', 10),
  ('12345098765', 'Gabriel', 'Carvalho', '1986-10-28', 'Rua das Palmeiras, 1415', 'M', '11987654326', 'gabriel.carvalho@email.com', 'senha852', 'locador', 11),
  ('23450987654', 'Mariana', 'Ribeiro', '1994-01-15', 'Av. Central, 1617', 'F', '21976543215', 'mariana.ribeiro@email.com', 'senha963', 'hospede', 12),
  ('34509876543', 'Ricardo', 'Gomes', '1984-03-08', 'Rua do Sol, 1819', 'M', '81987654327', 'ricardo.gomes@email.com', 'senha159', 'locador', 13),
  ('45098765432', 'Amanda', 'Silva', '1991-07-22', 'Av. Principal, 2021', 'F', '31976543216', 'amanda.silva@email.com', 'senha357', 'hospede', 14),
  ('50987654321', 'Thiago', 'Santos', '1988-05-17', 'Rua da Lua, 2223', 'M', '11987654328', 'thiago.santos@email.com', 'senha456', 'locador', 15);
  
-- 3. locador (all users with tipo = 'locador')
INSERT INTO locador (cpf)
SELECT cpf FROM usuario WHERE tipo = 'locador';
INSERT INTO locador (cpf)
VALUES 
  ('23456789012'), 
  ('45098765432');

-- 4. hospede (all users with tipo = 'hospede')
INSERT INTO hospede (cpf)
SELECT cpf FROM usuario WHERE tipo = 'hospede';

-- 5. conta_bancaria (one account per locador)
INSERT INTO conta_bancaria (numero_conta, agencia, tipo_conta, locador_cpf)
VALUES
  ('12345-6', '1234', 'corrente', '12345678901'),  -- Pedro Santos
  ('98765-4', '3456', 'poupanca', '34567890123'),  -- Carlos Ferreira
  ('45678-9', '2789', 'corrente', '56789012345'),  -- Lucas Rodrigues
  ('74125-8', '4567', 'poupanca', '78901234567'),  -- Rafael Almeida
  ('36985-2', '5678', 'corrente', '90123456789'),  -- Fernando Pereira
  ('14725-3', '6789', 'poupanca', '12345098765'),  -- Gabriel Carvalho
  ('95175-7', '7890', 'corrente', '34509876543'),  -- Ricardo Gomes
  ('75395-1', '8901', 'poupanca', '50987654321');  -- Thiago Santos

-- 6. ponto_interesse (15 points)
INSERT INTO ponto_interesse (descricao, loc_id)
VALUES
  ('Parque Ibirapuera', 1),                    -- São Paulo
  ('Praia de Copacabana', 2),                  -- Rio de Janeiro
  ('Jardim Botânico', 3),                      -- Curitiba
  ('Pelourinho', 4),                           -- Salvador
  ('Mercado Central', 5),                      -- Belo Horizonte
  ('Parque Farroupilha', 6),                   -- Porto Alegre
  ('Praia de Boa Viagem', 7),                  -- Recife
  ('Praia de Jurerê', 8),                      -- Florianópolis
  ('Catedral Metropolitana', 9),               -- Brasília
  ('Beach Park', 10),                          -- Fortaleza
  ('Central Park', 11),                        -- New York
  ('Torre Eiffel', 12),                        -- Paris
  ('Big Ben', 13),                             -- London
  ('Templo Senso-ji', 14),                     -- Tokyo
  ('Torre de Belém', 15);                      -- Lisboa

-- 7. propriedade (15 properties)
INSERT INTO propriedade (nome, endereco, tipo, num_quartos, num_banheiros, preco_noite, max_hospedes, min_noites, max_noites, taxa_limpeza, checkin_hora, checkout_hora, locador_cpf, loc_id)
VALUES
  ('Apartamento Vila Olímpia', 'Rua Gomes de Carvalho 1200', 'casa_inteira', 3, 2, 450, 6, 2, 14, 150, '15:00', '11:00', '12345678901', 1),
  ('Suite Copacabana', 'Av. Atlântica 2000', 'quarto_privativo', 1, 1, 200, 2, 1, 7, 80, '14:00', '12:00', '34567890123', 2),
  ('Casa Centro Histórico', 'Rua XV de Novembro 500', 'casa_inteira', 4, 3, 600, 8, 2, 10, 200, '15:00', '11:00', '56789012345', 3),
  ('Quarto Pelourinho', 'Largo do Pelourinho 123', 'quarto_compartilhado', 1, 1, 100, 1, 1, 5, 50, '14:00', '11:00', '78901234567', 4),
  ('Flat Savassi', 'Rua Pernambuco 1100', 'casa_inteira', 2, 1, 300, 4, 2, 14, 120, '14:00', '12:00', '90123456789', 5),
  ('Studio Moinhos', 'Rua Padre Chagas 300', 'quarto_privativo', 1, 1, 180, 2, 1, 7, 70, '15:00', '11:00', '12345098765', 6),
  ('Suite Beira Mar', 'Av. Beira Mar Norte 1800', 'quarto_privativo', 1, 1, 220, 2, 1, 7, 80, '15:00', '12:00', '50987654321', 8),
  ('Flat Asa Sul', 'SQS 308 Bloco C', 'casa_inteira', 2, 2, 350, 4, 2, 14, 130, '14:00', '11:00', '12345678901', 9),
  ('Quarto Meireles', 'Av. Beira Mar 2500', 'quarto_compartilhado', 1, 1, 120, 1, 1, 5, 50, '14:00', '12:00', '34567890123', 10),
  ('Manhattan Loft', '5th Avenue 1234', 'casa_inteira', 2, 2, 800, 4, 3, 14, 250, '15:00', '11:00', '56789012345', 11),
  ('Studio Le Marais', 'Rue des Rosiers 45', 'quarto_privativo', 1, 1, 300, 2, 2, 7, 100, '15:00', '11:00', '78901234567', 12),
  ('Westminster Flat', 'Baker Street 221B', 'casa_inteira', 3, 2, 700, 6, 2, 10, 200, '14:00', '12:00', '90123456789', 13),
  ('Chiyoda Apartment', 'Chiyoda-ku 1-1', 'quarto_privativo', 1, 1, 250, 2, 1, 7, 90, '15:00', '11:00', '12345098765', 14),
  ('Apartamento Baixa', 'Rua Augusta 100', 'casa_inteira', 2, 1, 280, 4, 2, 14, 100, '14:00', '12:00', '34509876543', 15);

-- 7.1  Novas PROPRIEDADES com campos NULL

INSERT INTO propriedade (nome, endereco, tipo, num_quartos, num_banheiros, preco_noite, max_hospedes, min_noites, max_noites, taxa_limpeza, checkin_hora, checkout_hora, locador_cpf, loc_id)
VALUES
('Cabana Vista Serra', 'Estr. Alto da Serra, 100', 'casa_inteira', 2, 1, 320, 4, 2, 10, NULL, '16:00', NULL,'90123456789', 16),
('Quarto Centro Velho', 'Rua Antiga 12', 'quarto_privativo', 1, 1, 110, 2, 1, 5, 50, '15:00', '11:00', '90123456789', 17);



-- 8. quarto (quartos para todas as propriedades)
INSERT INTO quarto (prop_id, num_camas, tipo_cama, banheiro_privativo)
VALUES
  -- Apartamento Vila Olímpia (3 quartos)
  (1, 1, 'casal', true),        -- master
  (1, 2, 'solteiro', true),     -- segundo quarto
  (1, 1, 'solteiro', false),    -- terceiro quarto

  -- Suite Copacabana (1 quarto)
  (2, 1, 'casal', true),        -- suite única

  -- Casa Centro Histórico (4 quartos)
  (3, 1, 'casal', true),        -- master
  (3, 2, 'solteiro', true),     -- segundo quarto
  (3, 2, 'beliche', false),     -- quarto crianças
  (3, 1, 'casal', false),       -- quarto visitas

  -- Quarto Pelourinho (1 quarto)
  (4, 2, 'solteiro', false),    -- quarto compartilhado

  -- Flat Savassi (2 quartos)
  (5, 1, 'casal', true),        -- quarto principal
  (5, 2, 'solteiro', false),    -- segundo quarto

  -- Studio Moinhos (1 quarto)
  (6, 1, 'casal', true),        -- quarto único

  -- Apartamento Boa Viagem (3 quartos)
  (7, 1, 'casal', true),        -- master
  (7, 2, 'solteiro', true),     -- segundo quarto
  (7, 1, 'solteiro', false),    -- terceiro quarto

  -- Suite Beira Mar (1 quarto)
  (8, 1, 'casal', true),        -- suite única

  -- Flat Asa Sul (2 quartos)
  (9, 1, 'casal', true),        -- quarto principal
  (9, 2, 'solteiro', true),     -- segundo quarto

  -- Quarto Meireles (1 quarto)
  (10, 2, 'solteiro', false),   -- quarto compartilhado

  -- Manhattan Loft (2 quartos)
  (11, 1, 'casal', true),       -- master
  (11, 2, 'solteiro', true),    -- segundo quarto

  -- Studio Le Marais (1 quarto)
  (12, 1, 'casal', true),       -- suite única

  -- Westminster Flat (3 quartos)
  (13, 1, 'casal', true),       -- master
  (13, 2, 'solteiro', true),    -- segundo quarto
  (13, 2, 'solteiro', false),   -- terceiro quarto

  -- Chiyoda Apartment
  (14, 1, 'casal', true),       -- quarto único

  -- Apartamento Baixa (2 quartos)
  (15, 1, 'casal', true),       -- quarto principal
  (15, 2, 'solteiro', false);   -- segundo quarto

-- 9. comodidade (15 amenities)
INSERT INTO comodidade (descricao)
VALUES
  ('Wi-Fi de alta velocidade'),
  ('Ar condicionado'),
  ('TV Smart 4K'),
  ('Cozinha completa'),
  ('Máquina de lavar'),
  ('Piscina'),
  ('Academia'),
  ('Estacionamento gratuito'),
  ('Churrasqueira'),
  ('Varanda'),
  ('Área de trabalho'),
  ('Secadora'),
  ('Elevador'),
  ('Portaria 24h'),
  ('Aquecimento central');

-- 10. regra (15 rules)
INSERT INTO regra (descricao)
VALUES
  ('Não é permitido fumar'),
  ('Não são permitidos animais de estimação'),
  ('Check-in após as 15:00'),
  ('Check-out até as 11:00'),
  ('Proibido festas ou eventos'),
  ('Silêncio das 22:00 às 08:00'),
  ('Não é permitido sublocação'),
  ('Máximo de visitantes: 2 por dia'),
  ('Descarte correto do lixo obrigatório'),
  ('Proibido som alto'),
  ('Documentos de identificação necessários'),
  ('Depósito caução obrigatório'),
  ('Idade mínima do titular: 18 anos'),
  ('Proibido alterar móveis de lugar'),
  ('Respeitar normas do condomínio');

-- Populate relationship tables with sufficient tuples

-- propriedade_comodidade (cada propriedade recebe entre 3 e 8 comodidades aleatórias)
INSERT INTO propriedade_comodidade (prop_id, comod_id)
VALUES
  -- Apartamento Vila Olímpia
  (1, 1),  -- Wi-Fi
  (1, 2),  -- Ar condicionado
  (1, 3),  -- TV Smart
  (1, 4),  -- Cozinha completa
  (1, 11), -- Área de trabalho
  
  -- Suite Copacabana
  (2, 1),  -- Wi-Fi
  (2, 2),  -- Ar condicionado
  (2, 3),  -- TV Smart
  (2, 14), -- Portaria 24h
  
  -- Casa Centro Histórico
  (3, 1),  -- Wi-Fi
  (3, 2),  -- Ar condicionado
  (3, 3),  -- TV Smart
  (3, 4),  -- Cozinha completa
  (3, 5),  -- Máquina de lavar
  (3, 9),  -- Churrasqueira
  (3, 10), -- Varanda
  
  -- Quarto Pelourinho
  (4, 1),  -- Wi-Fi
  (4, 2),  -- Ar condicionado
  (4, 3),  -- TV Smart
  
  -- Flat Savassi
  (5, 1),  -- Wi-Fi
  (5, 2),  -- Ar condicionado
  (5, 3),  -- TV Smart
  (5, 4),  -- Cozinha completa
  (5, 13), -- Elevador
  (5, 14), -- Portaria 24h
  
  -- Studio Moinhos
  (6, 1),  -- Wi-Fi
  (6, 2),  -- Ar condicionado
  (6, 3),  -- TV Smart
  (6, 11), -- Área de trabalho
  
  -- Apartamento Boa Viagem
  (7, 1),  -- Wi-Fi
  (7, 2),  -- Ar condicionado
  (7, 3),  -- TV Smart
  (7, 4),  -- Cozinha completa
  (7, 6),  -- Piscina
  (7, 10), -- Varanda
  
  -- Suite Beira Mar
  (8, 1),  -- Wi-Fi
  (8, 2),  -- Ar condicionado
  (8, 3),  -- TV Smart
  (8, 10), -- Varanda
  
  -- Flat Asa Sul
  (9, 1),  -- Wi-Fi
  (9, 2),  -- Ar condicionado
  (9, 3),  -- TV Smart
  (9, 4),  -- Cozinha completa
  (9, 13), -- Elevador
  (9, 14), -- Portaria 24h
  
  -- Quarto Meireles
  (10, 1), -- Wi-Fi
  (10, 2), -- Ar condicionado
  (10, 3), -- TV Smart
  
  -- Manhattan Loft
  (11, 1), -- Wi-Fi
  (11, 2), -- Ar condicionado
  (11, 3), -- TV Smart
  (11, 4), -- Cozinha completa
  (11, 7), -- Academia
  (11, 13),-- Elevador
  (11, 14),-- Portaria 24h
  (11, 15),-- Aquecimento central
  
  -- Studio Le Marais
  (12, 1), -- Wi-Fi
  (12, 2), -- Ar condicionado
  (12, 3), -- TV Smart
  (12, 15),-- Aquecimento central
  
  -- Westminster Flat
  (13, 1), -- Wi-Fi
  (13, 2), -- Ar condicionado
  (13, 3), -- TV Smart
  (13, 4), -- Cozinha completa
  (13, 13),-- Elevador
  (13, 15),-- Aquecimento central
  
  -- Chiyoda Apartment
  (14, 1), -- Wi-Fi
  (14, 2), -- Ar condicionado
  (14, 3), -- TV Smart
  (14, 13),-- Elevador
  
  -- Apartamento Baixa
  (15, 1), -- Wi-Fi
  (15, 2), -- Ar condicionado
  (15, 3), -- TV Smart
  (15, 4), -- Cozinha completa
  (15, 13);-- Elevador

-- propriedade_regra (cada propriedade recebe um conjunto apropriado de regras)
INSERT INTO propriedade_regra (prop_id, regra_id)
VALUES
  -- Apartamento Vila Olímpia
  (1, 1),  -- Não fumar
  (1, 5),  -- Sem festas
  (1, 6),  -- Silêncio noturno
  (1, 15), -- Normas do condomínio
  
  -- Suite Copacabana
  (2, 1),  -- Não fumar
  (2, 8),  -- Limite visitantes
  (2, 11), -- Documentos necessários
  
  -- Casa Centro Histórico
  (3, 1),  -- Não fumar
  (3, 2),  -- Sem pets
  (3, 5),  -- Sem festas
  (3, 12), -- Caução
  
  -- Quarto Pelourinho
  (4, 1),  -- Não fumar
  (4, 8),  -- Limite visitantes
  (4, 13), -- Idade mínima
  
  -- Flat Savassi
  (5, 1),  -- Não fumar
  (5, 6),  -- Silêncio
  (5, 15), -- Normas condomínio
  
  -- Studio Moinhos
  (6, 1),  -- Não fumar
  (6, 2),  -- Sem pets
  (6, 11), -- Documentos
  
  -- Apartamento Boa Viagem
  (7, 1),  -- Não fumar
  (7, 5),  -- Sem festas
  (7, 12), -- Caução
  (7, 15), -- Normas condomínio
  
  -- Suite Beira Mar
  (8, 1),  -- Não fumar
  (8, 8),  -- Limite visitantes
  (8, 11), -- Documentos
  
  -- Flat Asa Sul
  (9, 1),  -- Não fumar
  (9, 6),  -- Silêncio
  (9, 15), -- Normas condomínio
  
  -- Quarto Meireles
  (10, 1), -- Não fumar
  (10, 8), -- Limite visitantes
  (10, 13),-- Idade mínima
  
  -- Manhattan Loft
  (11, 1), -- Não fumar
  (11, 5), -- Sem festas
  (11, 12),-- Caução
  (11, 15),-- Normas condomínio
  
  -- Studio Le Marais
  (12, 1), -- Não fumar
  (12, 2), -- Sem pets
  (12, 11),-- Documentos
  
  -- Westminster Flat
  (13, 1), -- Não fumar
  (13, 5), -- Sem festas
  (13, 12),-- Caução
  (13, 15),-- Normas condomínio
  
  -- Chiyoda Apartment
  (14, 1), -- Não fumar
  (14, 6), -- Silêncio
  (14, 15),-- Normas condomínio
  
  -- Apartamento Baixa
  (15, 1), -- Não fumar
  (15, 5), -- Sem festas
  (15, 12),-- Caução
  (15, 15);-- Normas condomínio

-- Populate resto das não-relacionamento com pelo menos 15 tuplas

-- 11. reserva (15 bookings)
INSERT INTO reserva (hospede_cpf, prop_id, data_reserva, data_checkin, data_checkout, num_hospedes, imposto_pago, preco_total, preco_total_impostos, taxa_limpeza, status, status_data)
VALUES
  -- Reservas confirmadas (passadas)
  ('23456789012', 1, '2023-12-01', '2023-12-15', '2023-12-20', 4, 225.00, 2250.00, 2475.00, 150.00, 'confirmada', '2023-12-01 14:30:00'),
  ('45678901234', 3, '2023-12-05', '2023-12-22', '2023-12-26', 6, 300.00, 3000.00, 3300.00, 200.00, 'confirmada', '2023-12-05 10:15:00'),
  ('67890123456', 5, '2023-12-10', '2023-12-24', '2023-12-28', 3, 150.00, 1500.00, 1650.00, 120.00, 'confirmada', '2023-12-10 16:45:00'),
  ('12345678901', 1, '2023-11-01', '2023-11-15', '2023-11-20', 4, 225.00, 2250.00, 2475.00, 150.00, 'confirmada',' 2023-11-01 09:00:00'), 
  ('32165498700', 1, '2023-10-01', '2023-10-10', '2023-10-15', 3, 200.00, 2000.00, 2200.00, 150.00, 'confirmada', '2023-10-01 11:15:00'), 
  ('65498732100', 1, '2023-09-05', '2023-09-20', '2023-09-25', 2, 150.00, 1500.00, 1650.00, 120.00, 'confirmada', '2023-09-05 14:45:00'), 
  ('98765432100', 1, '2023-08-10', '2023-08-25', '2023-08-30', 5, 300.00, 3000.00, 3300.00, 200.00, 'confirmada', '2023-08-10 16:30:00'),

  
  -- Reservas confirmadas (futuras)
  ('89012345678', 2, '2025-04-25', '2025-05-10', '2025-05-15', 2, 100.00, 1000.00, 1100.00, 80.00, 'confirmada', '2024-01-05 09:20:00'),
  ('01234567890', 4, '2025-04-26', '2025-05-14', '2025-05-16', 1, 50.00, 500.00, 550.00, 50.00, 'confirmada', '2024-01-10 11:30:00'),
  ('23450987654', 6, '2025-04-27', '2025-06-20', '2025-06-25', 2, 90.00, 900.00, 990.00, 70.00, 'confirmada', '2024-01-15 13:45:00'),
  
  -- Reservas pendentes
  ('45098765432', 7, '2025-04-20', '2025-06-01', '2025-06-05', 4, 200.00, 2000.00, 2200.00, 150.00, 'pendente', '2024-01-20 15:10:00'),
  ('23456789012', 8, '2025-04-22', '2025-07-10', '2025-07-15', 2, 110.00, 1100.00, 1210.00, 80.00, 'pendente', '2024-01-22 17:25:00'),
  ('45678901234', 9, '2025-04-23', '2025-08-20', '2025-08-25', 3, 175.00, 1750.00, 1925.00, 130.00, 'pendente', '2024-01-25 14:50:00'),
  
  -- Reservas canceladas
  ('67890123456', 10, '2023-12-15', '2024-01-05', '2024-01-10', 1, 60.00, 600.00, 660.00, 50.00, 'cancelada', '2023-12-20 10:30:00'),
  ('89012345678', 11, '2023-12-20', '2024-01-15', '2024-01-20', 3, 400.00, 4000.00, 4400.00, 250.00, 'cancelada', '2023-12-22 12:45:00'),
  ('01234567890', 12, '2023-12-25', '2024-01-25', '2024-01-30', 2, 150.00, 1500.00, 1650.00, 100.00, 'cancelada', '2023-12-26 16:15:00'),
  
  -- Mais reservas confirmadas (variação)
  ('23450987654', 13, '2024-01-02', '2024-02-05', '2024-02-12', 4, 350.00, 3500.00, 3850.00, 200.00, 'confirmada', '2024-01-02 11:20:00'),
  ('45098765432', 14, '2024-01-07', '2024-02-15', '2024-02-18', 2, 125.00, 1250.00, 1375.00, 90.00, 'confirmada', '2024-01-07 13:40:00'),
  ('23456789012', 15, '2024-01-12', '2024-02-25', '2024-03-01', 3, 140.00, 1400.00, 1540.00, 100.00, 'confirmada', '2024-01-12 15:55:00');

-- 12. avaliacao (12 reviews)
INSERT INTO avaliacao (reserva_id, hospede_cpf, prop_id, texto, nota_limpeza, nota_estrutura, nota_comunicacao, nota_localizacao, nota_valor)
SELECT
  i,
  (SELECT reserva.hospede_cpf FROM reserva WHERE reserva.id = i),
  (SELECT reserva.prop_id   FROM reserva WHERE reserva.id = i),
  CASE i
    WHEN 1 THEN 'Ótimo apartamento, muito bem localizado. Limpeza impecável e boa comunicação com o anfitrião.'
    WHEN 2 THEN 'Casa espaçosa e confortável. Alguns detalhes de manutenção precisam ser revistos, mas no geral foi uma boa experiência.'
    WHEN 3 THEN 'Flat muito aconchegante, adorei a estadia. Localização excelente e preço justo.'
    WHEN 4 THEN 'Quarto pequeno mas confortável. Ótimo custo-benefício para viagens curtas.'
    WHEN 5 THEN 'Apartamento incrível, vista maravilhosa. Vale cada centavo!'
    WHEN 6 THEN 'Estadia agradável, anfitrião muito atencioso. Voltaria com certeza.'
    WHEN 7 THEN 'Localização privilegiada, estrutura completa. Recomendo fortemente.'
    WHEN 8 THEN 'Boa experiência no geral. Alguns problemas com o Wi-Fi, mas o resto foi ótimo.'
    WHEN 9 THEN 'Apartamento bem equipado e limpo. Comunicação rápida e eficiente.'
    WHEN 10 THEN 'Excelente localização, próximo a tudo. Estrutura um pouco antiga mas bem conservada.'
    WHEN 11 THEN 'Vista incrível, apartamento luxuoso. Vale o investimento!'
    WHEN 12 THEN 'Studio charmoso e bem localizado. Único problema foi o barulho da rua.'
    WHEN 13 THEN 'Flat espaçoso e bem decorado. Ótima experiência.'
    WHEN 14 THEN 'Localização perfeita, apartamento clean e moderno.'
    WHEN 15 THEN 'Ótima experiência, anfitrião muito prestativo. Recomendo!'
  END,
  CASE i
    WHEN 2 THEN 3  -- avaliação mais baixa para limpeza
    WHEN 8 THEN 4  -- boa limpeza
    ELSE 5         -- excelente limpeza para o resto
  END,
  CASE i
    WHEN 2 THEN 4  -- boa estrutura
    WHEN 10 THEN 3 -- estrutura antiga
    ELSE 5         -- excelente estrutura para o resto
  END,
  CASE i
    WHEN 8 THEN 4  -- boa comunicação
    ELSE 5         -- excelente comunicação para o resto
  END,
  CASE i
    WHEN 12 THEN 4 -- boa localização mas barulhenta
    ELSE 5         -- excelente localização para o resto
  END,
  CASE i
    WHEN 11 THEN 4 -- bom valor mas caro
    WHEN 4 THEN 5  -- ótimo custo-benefício
    ELSE 4         -- bom valor para o resto
  END
FROM generate_series(1,15) AS s(i)
WHERE i IN (1, 4, 5, 6, 7, 8, 9, 10, 11, 12);  -- apenas algumas reservas têm avaliações

-- 13. mensagem_aval (12 messages about reviews)
INSERT INTO mensagem_aval (remetente_cpf, destinatario_cpf, ts, texto, aval_id)
VALUES
  -- Hóspedes avaliando as propriedades
  ('23456789012', '12345678901', CURRENT_TIMESTAMP - INTERVAL '14 hours', 
   'Apartamento excelente! Muito bem localizado e limpo. A comunicação com o anfitrião foi perfeita.', 1),
   
  ('45678901234', '34567890123', CURRENT_TIMESTAMP - INTERVAL '12 hours',
   'Casa espaçosa e confortável, mas alguns detalhes de manutenção precisam ser revistos.', 3),
   
  ('67890123456', '56789012345', CURRENT_TIMESTAMP - INTERVAL '10 hours',
   'Localização perfeita! O flat é muito aconchegante e o preço é justo.', 4),
   
  ('89012345678', '78901234567', CURRENT_TIMESTAMP - INTERVAL '8 hours',
   'Boa experiência no geral, mas tivemos alguns problemas com o Wi-Fi.', 8),
   
  ('01234567890', '90123456789', CURRENT_TIMESTAMP - INTERVAL '6 hours',
   'Apartamento muito bem equipado e limpo. O anfitrião foi super atencioso.', 9),
   
  ('23450987654', '12345098765', CURRENT_TIMESTAMP - INTERVAL '4 hours',
   'A estrutura é um pouco antiga, mas bem conservada. Localização excelente.', 10);

-- 14. foto (15 photos linked to reviews)
INSERT INTO foto (url, aval_id)
SELECT
  'https://exemplo.com/foto_' || i || '.jpg',
  ((i - 1) % 12) + 1
FROM generate_series(1,12) AS s(i);

-- 15. mensagem_chat (15 chat messages)
INSERT INTO mensagem_chat (id, remetente_cpf, destinatario_cpf, ts, texto)
VALUES
  -- Conversa 1: Sobre localização e check-in
  (1, '23456789012', '12345678901', CURRENT_TIMESTAMP - INTERVAL '5 hours',
   'Olá! O apartamento fica perto de mercados?'),
  (2, '12345678901', '23456789012', CURRENT_TIMESTAMP - INTERVAL '4 hours',
   'Sim! Tem um mercado a 2 quadras e uma padaria na esquina.'),
  (3, '23456789012', '12345678901', CURRENT_TIMESTAMP - INTERVAL '3 hours',
   'Ótimo! E qual o horário do check-in?'),
  (4, '12345678901', '23456789012', CURRENT_TIMESTAMP - INTERVAL '2 hours',
   'O check-in é a partir das 15h. Posso te encontrar na portaria!'),

  -- Conversa 2: Sobre estacionamento
  (5, '45678901234', '34567890123', CURRENT_TIMESTAMP - INTERVAL '8 hours',
   'Boa tarde! Tem vaga de garagem disponível?'),
  (6, '34567890123', '45678901234', CURRENT_TIMESTAMP - INTERVAL '7 hours',
   'Sim, temos uma vaga coberta reservada para o apartamento.'),

  -- Conversa 3: Sobre Wi-Fi
  (7, '67890123456', '56789012345', CURRENT_TIMESTAMP - INTERVAL '12 hours',
   'Por favor, qual a senha do Wi-Fi?'),
  (8, '56789012345', '67890123456', CURRENT_TIMESTAMP - INTERVAL '11 hours',
   'A senha é AirBnb2024. Está anotada também no manual do apartamento.'),

  -- Conversa 4: Sobre check-out tardio
  (9, '89012345678', '78901234567', CURRENT_TIMESTAMP - INTERVAL '24 hours',
   'Seria possível fazer late check-out amanhã?'),
  (10, '78901234567', '89012345678', CURRENT_TIMESTAMP - INTERVAL '23 hours',
   'Sim, pode ficar até 14h sem custo adicional.'),

  -- Conversa 5: Sobre equipamentos
  (11, '01234567890', '90123456789', CURRENT_TIMESTAMP - INTERVAL '36 hours',
   'O apartamento tem secador de cabelo?'),
  (12, '90123456789', '01234567890', CURRENT_TIMESTAMP - INTERVAL '35 hours',
   'Sim, tem secador no banheiro da suíte!'),

  -- Conversa 6: Sobre chegada
  (13, '23450987654', '12345098765', CURRENT_TIMESTAMP - INTERVAL '48 hours',
   'Chegarei por volta das 22h. Tem problema?'),
  (14, '12345098765', '23450987654', CURRENT_TIMESTAMP - INTERVAL '47 hours',
   'Não tem problema. A portaria funciona 24h.'),
  (15, '23450987654', '12345098765', CURRENT_TIMESTAMP - INTERVAL '46 hours',
   'Perfeito, obrigado!');


SET session_replication_role = 'origin';