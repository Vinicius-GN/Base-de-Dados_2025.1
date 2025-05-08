------ SEQUENCES BEGIN --------

CREATE SEQUENCE seq_localizacao_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_pontointeresse_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_propriedade_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_quarto_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_comodidade_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_regra_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_reserva_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_avaliacao_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_mensagemaval_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

CREATE SEQUENCE seq_foto_id
START WITH 1
INCREMENT BY 1
NO CYCLE;

------ SEQUENCES END --------

CREATE TABLE localizacao (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_localizacao_id'),
  cidade varchar NOT NULL,
  estado varchar NOT NULL,
  pais varchar NOT NULL,
  cep varchar NOT NULL,
  bairro varchar
);

CREATE TABLE usuario (
  cpf varchar PRIMARY KEY,
  nome varchar NOT NULL,
  sobrenome varchar NOT NULL,
  data_nascimento date NOT NULL,
  endereco varchar NOT NULL,
  sexo varchar NOT NULL,
  telefone varchar UNIQUE NOT NULL,
  email varchar UNIQUE NOT NULL,
  senha varchar NOT NULL,

  tipo VARCHAR(10) NOT NULL,  
  CHECK (tipo IN ('hospede', 'locador')),

  loc_id int NOT NULL,
  FOREIGN KEY (loc_id) REFERENCES localizacao (id)
);

CREATE TABLE ponto_interesse (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_pontointeresse_id'), 
  descricao varchar,
  loc_id int NOT NULL,
  FOREIGN KEY (loc_id) REFERENCES localizacao (id)
);

CREATE TABLE locador (
  cpf varchar PRIMARY KEY,
  FOREIGN KEY (cpf) REFERENCES usuario (cpf)
);

CREATE TABLE hospede (
  cpf varchar PRIMARY KEY,
  FOREIGN KEY (cpf) REFERENCES usuario (cpf)
);

CREATE TABLE conta_bancaria (
  numero_conta varchar PRIMARY KEY,
  agencia varchar NOT NULL,
  tipo_conta varchar NOT NULL,
  locador_cpf varchar NOT NULL,
  FOREIGN KEY (locador_cpf) REFERENCES locador (cpf)
);

CREATE TABLE propriedade (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_propriedade_id'),
  nome varchar NOT NULL,
  endereco varchar NOT NULL,

  tipo VARCHAR(20) NOT NULL,
  CHECK (tipo IN ('casa_inteira', 'quarto_privativo', 'quarto_compartilhado')),

  num_quartos int NOT NULL,
  num_banheiros int NOT NULL,
  preco_noite decimal NOT NULL,
  max_hospedes int NOT NULL,
  min_noites int NOT NULL,
  max_noites int NOT NULL,
  taxa_limpeza decimal,
  checkin_hora time,
  checkout_hora time,
  locador_cpf varchar NOT NULL,
  loc_id int NOT NULL,
  FOREIGN KEY (locador_cpf) REFERENCES locador (cpf),
  FOREIGN KEY (loc_id) REFERENCES localizacao (id)
);

CREATE TABLE quarto (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_quarto_id'),
  prop_id int NOT NULL,
  num_camas int NOT NULL,
  tipo_cama varchar NOT NULL,
  banheiro_privativo boolean NOT NULL,
  FOREIGN KEY (prop_id) REFERENCES propriedade (id)
);

CREATE TABLE comodidade (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_comodidade_id'),
  descricao varchar
);

CREATE TABLE propriedade_comodidade (
  prop_id int NOT NULL,
  comod_id int NOT NULL,
  PRIMARY KEY (prop_id, comod_id),
  FOREIGN KEY (prop_id) REFERENCES propriedade (id),
  FOREIGN KEY (comod_id) REFERENCES comodidade (id)
);

CREATE TABLE regra (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_regra_id'),
  descricao varchar
);

CREATE TABLE propriedade_regra (
  prop_id int NOT NULL,
  regra_id int NOT NULL,
  PRIMARY KEY (prop_id, regra_id),
  FOREIGN KEY (prop_id) REFERENCES propriedade (id),
  FOREIGN KEY (regra_id) REFERENCES regra (id)
);

CREATE TABLE reserva (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_reserva_id'),
  hospede_cpf varchar NOT NULL,
  prop_id int NOT NULL,
  data_reserva date NOT NULL,
  data_checkin date NOT NULL,
  data_checkout date NOT NULL,
  num_hospedes int NOT NULL,
  imposto_pago decimal,
  preco_total decimal,
  preco_total_impostos decimal,
  taxa_limpeza decimal,

  status varchar(15) NOT NULL,
  CHECK (status IN ('pendente', 'confirmada', 'cancelada')),

  status_data timestamp DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (hospede_cpf) REFERENCES hospede (cpf),
  FOREIGN KEY (prop_id) REFERENCES propriedade (id),
  CHECK (status_data IS NULL OR status_data < data_checkin)
);

CREATE TABLE avaliacao (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_avaliacao_id'),
  reserva_id int,
  hospede_cpf varchar NOT NULL,
  prop_id int NOT NULL,
  texto varchar NOT NULL,
  nota_limpeza int,
  nota_estrutura int,
  nota_comunicacao int,
  nota_localizacao int,
  nota_valor int,
  FOREIGN KEY (reserva_id) REFERENCES reserva (id),
  FOREIGN KEY (hospede_cpf) REFERENCES hospede (cpf),
  FOREIGN KEY (prop_id) REFERENCES propriedade (id)
);

CREATE TABLE mensagem_aval (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_mensagemaval_id'),
  remetente_cpf varchar NOT NULL,
  destinatario_cpf varchar NOT NULL,
  ts timestamp DEFAULT CURRENT_TIMESTAMP,
  texto varchar NOT NULL,
  aval_id int NOT NULL,
  FOREIGN KEY (remetente_cpf) REFERENCES usuario (cpf),
  FOREIGN KEY (destinatario_cpf) REFERENCES usuario (cpf),
  FOREIGN KEY (aval_id) REFERENCES avaliacao (id)
);

CREATE TABLE foto (
  id INT PRIMARY KEY DEFAULT NEXTVAL('seq_foto_id'),
  url varchar NOT NULL,
  aval_id int NOT NULL,
  FOREIGN KEY (aval_id) REFERENCES avaliacao (id)
);

CREATE TABLE mensagem_chat (
  id int PRIMARY KEY,
  remetente_cpf varchar NOT NULL,
  destinatario_cpf varchar NOT NULL,
  ts timestamp DEFAULT CURRENT_TIMESTAMP,
  texto varchar NOT NULL,
  FOREIGN KEY (remetente_cpf) REFERENCES usuario (cpf),
  FOREIGN KEY (destinatario_cpf) REFERENCES usuario (cpf)
);