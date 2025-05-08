# Base-de-Dados_2025.1

Este repositório contém o código do projeto de banco de dados da disciplina de Banco de Dados do ICMC-USP.

### Comandos úteis para o banco de dados

Para iniciar o banco de dados (PostgreSQL):
```bash
docker run -d \
  --name postgres_db \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=postgres \
  -v postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres
```
> Caso já tenha rodado o banco de dados anteriormente, você precisa remover o container antes de rodar o comando acima. Para isso use o comando abaixo.

Para parar e remover o banco de dados:
```bash
docker rm -f postgres_db
```

Para acessar o banco de dados com `psql`:
```bash
docker exec -it postgres_db psql -U postgres
```

Para rodar um script SQL no banco de dados:
```bash
docker exec -i postgres_db psql -U postgres -d postgres < ./script.sql
```

Para acessar o banco de dados com um cliente gráfico (DBeaver, pgAdmin, etc.), use as seguintes configurações:
- Host: localhost
- Porta: 5432
- Usuário: postgres
- Senha: postgres