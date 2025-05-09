# Projeto de Banco de Dados — ICMC-USP 2025.1

## 👥 Integrantes do Grupo

| Nome                            | Matrícula   |
|---------------------------------|-------------|
| Shogo Shima                     | 12675145    |
| José Carlos Andrade do Nascimento | 12549450 |
| Vinicius Gustierrez Neves       | 14749363    |
| Thales Sena de Queiroz          | 14608873    |

---

## 📊 Resultados das Consultas SQL

### 1. Relação completa de propriedades

Esta consulta seleciona todas as colunas da tabela propriedade, retornando a lista completa de imóveis cadastrados no sistema, com detalhes como tipo, número de quartos, valor da diária e CPF do locador.

```
| id | nome                     | endereco                   | tipo                 | num_quartos | num_banheiros | preco_noite | max_hospedes | min_noites | max_noites | taxa_limpeza | checkin_hora | checkout_hora | locador_cpf | loc_id |
|----|--------------------------|----------------------------|----------------------|-------------|---------------|-------------|--------------|------------|------------|--------------|--------------|---------------|--------------|--------|
|  1 | Apartamento Vila Olímpia | Rua Gomes de Carvalho 1200 | casa_inteira         |           3 |             2 |         450 |            6 |          2 |         14 |          150 | 15:00:00     | 11:00:00      | 12345678901 |      1 |
|  2 | Suite Copacabana         | Av. Atlântica 2000         | quarto_privativo     |           1 |             1 |         200 |            2 |          1 |          7 |           80 | 14:00:00     | 12:00:00      | 34567890123 |      2 |
|  3 | Casa Centro Histórico    | Rua XV de Novembro 500     | casa_inteira         |           4 |             3 |         600 |            8 |          2 |         10 |          200 | 15:00:00     | 11:00:00      | 56789012345 |      3 |
|  4 | Quarto Pelourinho        | Largo do Pelourinho 123    | quarto_compartilhado |           1 |             1 |         100 |            1 |          1 |          5 |           50 | 14:00:00     | 11:00:00      | 78901234567 |      4 |
|  5 | Flat Savassi             | Rua Pernambuco 1100        | casa_inteira         |           2 |             1 |         300 |            4 |          2 |         14 |          120 | 14:00:00     | 12:00:00      | 90123456789 |      5 |
|  6 | Studio Moinhos           | Rua Padre Chagas 300       | quarto_privativo     |           1 |             1 |         180 |            2 |          1 |          7 |           70 | 15:00:00     | 11:00:00      | 12345098765 |      6 |
|  7 | Suite Beira Mar          | Av. Beira Mar Norte 1800   | quarto_privativo     |           1 |             1 |         220 |            2 |          1 |          7 |           80 | 15:00:00     | 12:00:00      | 50987654321 |      8 |
|  8 | Flat Asa Sul             | SQS 308 Bloco C            | casa_inteira         |           2 |             2 |         350 |            4 |          2 |         14 |          130 | 14:00:00     | 11:00:00      | 12345678901 |      9 |
|  9 | Quarto Meireles          | Av. Beira Mar 2500         | quarto_compartilhado |           1 |             1 |         120 |            1 |          1 |          5 |           50 | 14:00:00     | 12:00:00      | 34567890123 |     10 |
| 10 | Manhattan Loft           | 5th Avenue 1234            | casa_inteira         |           2 |             2 |         800 |            4 |          3 |         14 |          250 | 15:00:00     | 11:00:00      | 56789012345 |     11 |
| 11 | Studio Le Marais         | Rue des Rosiers 45         | quarto_privativo     |           1 |             1 |         300 |            2 |          2 |          7 |          100 | 15:00:00     | 11:00:00      | 78901234567 |     12 |
| 12 | Westminster Flat         | Baker Street 221B          | casa_inteira         |           3 |             2 |         700 |            6 |          2 |         10 |          200 | 14:00:00     | 12:00:00      | 90123456789 |     13 |
| 13 | Chiyoda Apartment        | Chiyoda-ku 1-1             | quarto_privativo     |           1 |             1 |         250 |            2 |          1 |          7 |           90 | 15:00:00     | 11:00:00      | 12345098765 |     14 |
| 14 | Apartamento Baixa        | Rua Augusta 100            | casa_inteira         |           2 |             1 |         280 |            4 |          2 |         14 |          100 | 14:00:00     | 12:00:00      | 34509876543 |     15 |

```

---

### 2. Média de preço por tipo de propriedade

Agrupa os imóveis pelo tipo (casa_inteira, quarto_privativo, etc.) e calcula o valor médio da diária (preco_noite) usando a função AVG, permitindo análise comparativa entre categorias.

```
| tipo                 | media_preco |
|----------------------|-------------|
| quarto_compartilhado |      110.00 |
| casa_inteira         |      497.14 |
| quarto_privativo     |      230.00 |
```

---

### 3. Quantidade de propriedades por cidade

Relaciona a tabela propriedade com localizacao e agrupa por cidade, contando o número de imóveis cadastrados em cada uma usando COUNT.

```
| cidade         | quantidade |
|----------------|------------|
| Belo Horizonte |          1 |
| Salvador       |          1 |
| Porto Alegre   |          1 |
| Florianópolis  |          1 |
| Curitiba       |          1 |
| Fortaleza      |          1 |
| Lisboa         |          1 |
| Rio de Janeiro |          1 |
| Paris          |          1 |
| New York       |          1 |
| Tokyo          |          1 |
| Brasília       |          1 |
| London         |          1 |
| São Paulo      |          1 |
```

---

### 4. Locações confirmadas a partir de 01/01/2024

Seleciona reservas com status confirmada cuja data de check-in é posterior a 01/01/2024. Também calcula o total de dias locados e exibe informações do hóspede, locador e valor da diária.

```
| reserva_id | hospede_cpf | prop_id | data_checkin | data_checkout | status     | dias_locados | nome_hospede | nome_locador | preco_noite |
|------------|--------------|---------|--------------|---------------|------------|---------------|---------------|---------------|--------------|
| 4          | 89012345678  | 2       | 2024-02-10   | 2024-02-15    | confirmada | 5             | Beatriz      | Carlos        | 200          |
| 5          | 01234567890  | 4       | 2024-02-14   | 2024-02-16    | confirmada | 2             | Carolina     | Rafael        | 100          |
| 6          | 23450987654  | 6       | 2024-02-20   | 2024-02-25    | confirmada | 5             | Mariana      | Gabriel       | 180          |
| 13         | 23450987654  | 13      | 2024-02-05   | 2024-02-12    | confirmada | 7             | Mariana      | Gabriel       | 250          |
| 14         | 45098765432  | 14      | 2024-02-15   | 2024-02-18    | confirmada | 3             | Amanda       | Ricardo       | 280          |

```

---

### 5. Regras mais utilizadas em propriedades

Agrupa as regras cadastradas (regra) e conta quantas vezes cada uma foi associada a uma propriedade (propriedade_regra), permitindo identificar as regras mais comuns aplicadas pelos anfitriões.

```
| descricao                               | vezes_utilizada |
|-----------------------------------------|-----------------|
| Não é permitido fumar                   | 15              |
| Respeitar normas do condomínio          | 8               |
| Proibido festas ou eventos              | 6               |
| Depósito caução obrigatório             | 5               |
| Máximo de visitantes: 2 por dia         | 4               |
| Documentos de identificação necessários | 4               |
| Silêncio das 22:00 às 08:00             | 4               |
| Não são permitidos animais de estimação | 3               |
| Idade mínima do titular: 18 anos        | 2               |
```

---

### 6. Locadores com pelo menos 2 locações e múltiplos imóveis

Faz junções entre locador, propriedade, reserva e usuario, agrupando por locador. Conta o número de imóveis e de locações, retornando apenas aqueles com pelo menos 2 locações (HAVING COUNT >= 2).

```
| nome     | cidade         | num_imoveis | total_locoes |
|----------|----------------|-------------|---------------|
| Gabriel  | New York       | 2           | 2             |
| Pedro    | São Paulo      | 2           | 2             |
| Carlos   | Curitiba       | 2           | 2             |
| Lucas    | Belo Horizonte | 2           | 2             |
| Rafael   | Recife         | 2           | 2             |
| Fernando | Brasília       | 2           | 2             |
```

---

### 7. Total de reservas e gasto por hóspede

Agrupa as reservas por hóspede e calcula o número total de reservas realizadas e o gasto total (SUM(preco_total)), útil para identificar usuários mais ativos ou lucrativos.

```
| cpf          | nome     | num_reservas | total_gasto |
|--------------|----------|--------------|-------------|
| 89012345678  | Beatriz  | 2            | 5000.00     |
| 45678901234  | Ana      | 2            | 4750.00     |
| 23456789012  | Maria    | 3            | 4750.00     |
| 23450987654  | Mariana  | 2            | 4400.00     |
| 45098765432  | Amanda   | 2            | 3250.00     |
| 67890123456  | Julia    | 2            | 2100.00     |
| 01234567890  | Carolina | 2            | 2000.00     |
```

---

### 8. Propriedades com melhores avaliações

Calcula a média aritmética das notas de avaliação para cada propriedade, com ROUND((nota1 + ... + nota5)/5.0, 2), e ordena em ordem decrescente da média.

```
| prop_id | nome                     | media_avaliacao |
|---------|--------------------------|-----------------|
| 2       | Suite Copacabana         | 5.00            |
| 4       | Quarto Pelourinho        | 4.80            |
| 11      | Studio Le Marais         | 4.80            |
| 7       | Suite Beira Mar          | 4.80            |
| 1       | Apartamento Vila Olímpia | 4.80            |
| 9       | Quarto Meireles          | 4.80            |
| 6       | Studio Moinhos           | 4.80            |
| 12      | Westminster Flat         | 4.60            |
| 10      | Manhattan Loft           | 4.40            |
| 8       | Flat Asa Sul             | 4.40            |
```

---

### 9. Locadores sem nenhuma avaliação recebida

Seleciona locadores cujas propriedades não possuem nenhuma avaliação associada. Usa NOT EXISTS com subconsulta para verificar ausência de avaliações por propriedade.

```
| cpf          | nome     |
|--------------|----------|
| 56789012345  | Lucas    |
| 90123456789  | Fernando |
| 12345098765  | Gabriel  |
| 34509876543  | Ricardo  |
```

---

