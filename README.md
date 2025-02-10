# Desafio Projeto Lógico de Banco de Dados E-commerce

# E-commerce Database Schema

Este documento descreve o esquema lógico do banco de dados **ecommerce**. Abrange todas as tabelas, chaves primárias, chaves estrangeiras e suas relações. O objetivo é fornecer uma visão clara de como os dados estão organizados e relacionados no sistema.

---

## 📌 Estrutura do Banco de Dados

O banco de dados **ecommerce** é composto por tabelas que representam diferentes entidades de um sistema de comércio eletrônico, como clientes, fornecedores, produtos, pedidos, pagamentos etc. Cada tabela possui colunas, restrições e relacionamentos específicos.

---

## 🗂 Tabelas e Relacionamentos

### 1️⃣ Cliente (`cliente`)
Armazena informações sobre os clientes da plataforma.

| Campo         | Tipo                             | Restrição                                        |
|---------------|-----------------------------------|--------------------------------------------------|
| **id**        | INT                               | PRIMARY KEY, AUTO_INCREMENT                      |
| **nome**      | VARCHAR(255)                      | NOT NULL                                         |
| **email**     | VARCHAR(255)                      | UNIQUE, NOT NULL                                 |
| **telefone**  | CHAR(11)                          | NULL                                             |
| **tipo**      | ENUM('PF','PJ')                   | NOT NULL                                         |
| **criado_em** | DATETIME                          | DEFAULT CURRENT_TIMESTAMP                        |
| **atualizado_em** | DATETIME                      | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

**Observações**:
- Armazena dados básicos de contato e o tipo de cliente (Pessoa Física ou Pessoa Jurídica).
- A coluna `email` é única, prevenindo duplicidade.

---

### 2️⃣ Cliente Cartão (`cliente_cartao`)
Armazena cartões de clientes de forma segura.

| Campo             | Tipo                                        | Restrição                                           |
|-------------------|---------------------------------------------|-----------------------------------------------------|
| **id**            | INT                                         | PRIMARY KEY, AUTO_INCREMENT                         |
| **cliente_id**    | INT                                         | FOREIGN KEY → `cliente.id` (ON DELETE CASCADE)      |
| **numero_cartao** | VARBINARY(255)                              | NOT NULL                                            |
| **ultimos_digitos** | CHAR(4)                                   | NOT NULL                                            |
| **nome_titular**  | VARCHAR(255)                                | NOT NULL                                            |
| **validade**      | DATE                                        | NOT NULL                                            |
| **cvv**           | VARBINARY(255)                              | NOT NULL                                            |
| **bandeira**      | ENUM('visa','mastercard','amex','elo','outros') | NOT NULL                                       |
| **principal**     | TINYINT(1)                                  | DEFAULT 0                                           |
| **criado_em**     | DATETIME                                    | DEFAULT CURRENT_TIMESTAMP                           |
| **atualizado_em** | DATETIME                                    | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

**Observações**:
- Cada cartão pertence a um cliente.
- A exclusão do cliente resulta em exclusão em cascata do cartão.
- A coluna `principal` indica se o cartão é o principal do cliente.

---

### 3️⃣ Cliente Endereço (`cliente_endereco`)
Associa clientes a endereços.

| Campo         | Tipo   | Restrição                                        |
|---------------|--------|--------------------------------------------------|
| **id**        | INT    | PRIMARY KEY, AUTO_INCREMENT                       |
| **cliente_id** | INT   | FOREIGN KEY → `cliente.id` (ON DELETE CASCADE)    |
| **endereco_id** | INT  | FOREIGN KEY → `endereco.id` (ON DELETE CASCADE)   |
| **principal**  | TINYINT(1) | DEFAULT 0                                    |

**Observações**:
- Estabelece o relacionamento *1:N* entre clientes e seus endereços.
- A coluna `principal` pode sinalizar o endereço principal.

---

### 4️⃣ Cliente PF (`cliente_pf`)
Armazena informações adicionais de clientes Pessoa Física.

| Campo         | Tipo    | Restrição                                                 |
|---------------|---------|-----------------------------------------------------------|
| **id**        | INT     | PRIMARY KEY, AUTO_INCREMENT                                |
| **cliente_id** | INT    | FOREIGN KEY → `cliente.id` (ON DELETE CASCADE), UNIQUE     |
| **cpf**       | CHAR(14) | UNIQUE, NOT NULL                                         |

**Observações**:
- Relaciona-se de forma *1:1* com `cliente`, pois cada cliente PF terá somente um registro.
- `cpf` é único e não permite valores nulos.

---

### 5️⃣ Cliente PJ (`cliente_pj`)
Armazena informações adicionais de clientes Pessoa Jurídica.

| Campo         | Tipo         | Restrição                                                 |
|---------------|-------------|------------------------------------------------------------|
| **id**        | INT          | PRIMARY KEY, AUTO_INCREMENT                                |
| **cliente_id** | INT         | FOREIGN KEY → `cliente.id` (ON DELETE CASCADE), UNIQUE     |
| **cnpj**      | CHAR(18)     | UNIQUE, NOT NULL                                          |
| **razao_social** | VARCHAR(255) | NOT NULL                                              |

**Observações**:
- Relaciona-se de forma *1:1* com `cliente`, pois cada cliente PJ terá somente um registro.
- `cnpj` é único e não permite valores nulos.

---

### 6️⃣ Endereço (`endereco`)
Armazena endereços utilizados no sistema.

| Campo         | Tipo                              | Restrição                                        |
|---------------|-----------------------------------|--------------------------------------------------|
| **id**        | INT                               | PRIMARY KEY, AUTO_INCREMENT                      |
| **logradouro** | VARCHAR(255)                     | NOT NULL                                         |
| **numero**    | VARCHAR(10)                       | NULL                                             |
| **complemento** | VARCHAR(255)                    | NULL                                             |
| **bairro**    | VARCHAR(100)                      | NULL                                             |
| **cidade**    | VARCHAR(100)                      | NOT NULL                                         |
| **estado**    | CHAR(2)                           | NOT NULL                                         |
| **cep**       | CHAR(8)                           | NOT NULL                                         |
| **tipo_endereco** | ENUM('residencial','comercial','entrega','cobranca') | DEFAULT 'comercial' |
| **criado_em** | DATETIME                          | DEFAULT CURRENT_TIMESTAMP                        |
| **atualizado_em** | DATETIME                      | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

**Observações**:
- Usada tanto para endereços de clientes quanto de fornecedores.
- Pode ser residencial, comercial etc.

---

### 7️⃣ Entrega (`entrega`)
Contém informações sobre a entrega do pedido.

| Campo            | Tipo                                                     | Restrição                                     |
|------------------|---------------------------------------------------------|-----------------------------------------------|
| **id**           | INT                                                      | PRIMARY KEY, AUTO_INCREMENT                  |
| **pedido_id**    | INT                                                      | FOREIGN KEY → `pedido.id` (ON DELETE CASCADE) |
| **codigo_rastreio** | VARCHAR(50)                                          | NULL                                          |
| **status**       | ENUM('em processamento','enviado','entregue','cancelado') | NOT NULL                                  |

**Observações**:
- Relaciona-se *1:1* com `pedido`.
- Armazena informações de rastreamento e status.

---

### 8️⃣ Estoque (`estoque`)
Gerencia a quantidade de um produto em estoque.

| Campo          | Tipo   | Restrição                                       |
|----------------|--------|-------------------------------------------------|
| **id**         | INT    | PRIMARY KEY, AUTO_INCREMENT                     |
| **produto_id** | INT    | FOREIGN KEY → `produto.id` (ON DELETE CASCADE)  |
| **quantidade** | INT    | NOT NULL                                        |

**Observações**:
- Relacionado a um determinado `produto`.
- Controla o estoque disponível.

---

### 9️⃣ Fornecedor (`fornecedor`)
Armazena informações sobre fornecedores.

| Campo                  | Tipo                                                            | Restrição                                       |
|------------------------|----------------------------------------------------------------|-------------------------------------------------|
| **id**                 | INT                                                             | PRIMARY KEY, AUTO_INCREMENT                     |
| **nome**               | VARCHAR(255)                                                    | NOT NULL                                        |
| **tipo**               | ENUM('proprio','terceiro')                                      | NOT NULL                                        |
| **cnpj**               | CHAR(18)                                                        | UNIQUE, NOT NULL                                |
| **razao_social**       | VARCHAR(255)                                                    | NOT NULL                                        |
| **nome_fantasia**      | VARCHAR(255)                                                    | NULL                                            |
| **email**              | VARCHAR(255)                                                    | UNIQUE, NOT NULL                                |
| **telefone_principal** | CHAR(11)                                                        | NOT NULL                                        |
| **telefone_secundario**| CHAR(11)                                                        | NULL                                            |
| **website**            | VARCHAR(255)                                                    | NULL                                            |
| **status**             | ENUM('ativo','inativo','suspenso')                              | DEFAULT 'ativo'                                 |
| **categoria**          | ENUM('alimentos','eletronicos','vestuario','servicos','outros') | NOT NULL                                        |
| **criado_em**          | DATETIME                                                        | DEFAULT CURRENT_TIMESTAMP                       |
| **atualizado_em**      | DATETIME                                                        | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| **avaliacao**          | DECIMAL(3,2)                                                    | DEFAULT NULL, CHECK (avaliacao BETWEEN 0 AND 5) |

**Observações**:
- Fornece produtos para o sistema.
- Possui restrição de avaliação para valores entre 0 e 5.
- `cnpj` e `email` são únicos.

---

### 🔟 Fornecedor Endereço (`fornecedor_endereco`)
Associa fornecedores a endereços.

| Campo            | Tipo   | Restrição                                        |
|------------------|--------|--------------------------------------------------|
| **id**           | INT    | PRIMARY KEY, AUTO_INCREMENT                      |
| **fornecedor_id** | INT   | FOREIGN KEY → `fornecedor.id` (ON DELETE CASCADE) |
| **endereco_id**  | INT    | FOREIGN KEY → `endereco.id` (ON DELETE CASCADE)   |
| **principal**    | TINYINT(1) | DEFAULT 0                                     |

**Observações**:
- Semelhante a `cliente_endereco`, mas voltado para fornecedores.
- Permite identificar o endereço principal do fornecedor.

---

### 1️⃣1️⃣ Produto (`produto`)
Armazena os produtos disponíveis na loja.

| Campo                  | Tipo           | Restrição                                        |
|------------------------|---------------|--------------------------------------------------|
| **id**                 | INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| **nome**               | VARCHAR(255)  | NOT NULL                                         |
| **descricao**          | TEXT          | NULL                                             |
| **preco**              | DECIMAL(10,2) | NOT NULL                                         |
| **quantidade_disponivel** | INT       | DEFAULT 0                                        |
| **criado_em**          | DATETIME      | DEFAULT CURRENT_TIMESTAMP                        |
| **atualizado_em**      | DATETIME      | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

**Observações**:
- É a tabela principal para produtos.
- O campo `preco` define o valor unitário de cada produto.

---

### 1️⃣2️⃣ Produto Fornecedor (`produto_fornecedor`)
Faz a relação *N:M* entre produtos e fornecedores.

| Campo           | Tipo           | Restrição                                                     |
|-----------------|---------------|----------------------------------------------------------------|
| **produto_id**  | INT           | PRIMARY KEY (composto), FOREIGN KEY → `produto.id` (CASCADE)   |
| **fornecedor_id**| INT          | PRIMARY KEY (composto), FOREIGN KEY → `fornecedor.id` (CASCADE)|
| **preco**       | DECIMAL(10,2) | NULL                                                           |

**Observações**:
- Permite registrar a lista de fornecedores para cada produto.
- Possibilidade de ter preço diferenciado por fornecedor.

---

### 1️⃣3️⃣ Pedido (`pedido`)
Registra pedidos feitos pelos clientes.

| Campo          | Tipo           | Restrição                                                 |
|----------------|---------------|-----------------------------------------------------------|
| **id**         | INT           | PRIMARY KEY, AUTO_INCREMENT                               |
| **cliente_id** | INT           | FOREIGN KEY → `cliente.id` (ON DELETE CASCADE)             |
| **vendedor_id**| INT           | FOREIGN KEY → `vendedor.id` (ON DELETE SET NULL)           |
| **data_pedido**| DATETIME      | DEFAULT CURRENT_TIMESTAMP                                 |
| **status**     | ENUM('pendente','aprovado','cancelado','entregue') | NOT NULL            |
| **total_pedido** | DECIMAL(10,2)| DEFAULT 0.00                                              |

**Observações**:
- Cada pedido é associado a um cliente e a um vendedor.
- A remoção de um cliente resulta na remoção em cascata dos pedidos.
- Se o vendedor for removido, o campo `vendedor_id` fica `NULL`.

---

### 1️⃣4️⃣ Pedido Produto (`pedido_produto`)
Tabela de associação que relaciona pedidos e produtos.

| Campo            | Tipo           | Restrição                                                 |
|------------------|---------------|-----------------------------------------------------------|
| **id**           | INT           | PRIMARY KEY, AUTO_INCREMENT                               |
| **pedido_id**    | INT           | FOREIGN KEY → `pedido.id` (ON DELETE CASCADE)              |
| **produto_id**   | INT           | FOREIGN KEY → `produto.id` (ON DELETE CASCADE)             |
| **fornecedor_id**| INT           | FOREIGN KEY → `fornecedor.id` (ON DELETE CASCADE)          |
| **quantidade**   | INT           | NOT NULL                                                  |
| **preco_unitario**| DECIMAL(10,2)| NOT NULL                                                  |

**Observações**:
- Relaciona-se *N:M* com pedido e produto, contendo informações sobre quantidade e preço unitário.
- Também referencia o fornecedor que forneceu o produto para aquele pedido.

---

### 1️⃣5️⃣ Pagamento (`pagamento`)
Contém as informações gerais de pagamento associadas a um pedido.

| Campo         | Tipo           | Restrição                                              |
|---------------|---------------|--------------------------------------------------------|
| **id**        | INT           | PRIMARY KEY, AUTO_INCREMENT                            |
| **pedido_id** | INT           | FOREIGN KEY → `pedido.id` (ON DELETE CASCADE)           |
| **status**    | ENUM('pendente','aprovado','cancelado') | DEFAULT 'pendente'          |
| **valor_total** | DECIMAL(10,2)| NOT NULL                                               |
| **criado_em** | DATETIME      | DEFAULT CURRENT_TIMESTAMP                              |
| **atualizado_em** | DATETIME  | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  |

**Observações**:
- Cada pedido tem seu registro de pagamento correspondente.
- Inclui status do pagamento (pendente, aprovado ou cancelado).

---

### 1️⃣6️⃣ Método Pagamento (`metodo_pagamento`)
Detalha os métodos de pagamento vinculados a um pagamento.

| Campo            | Tipo                                 | Restrição                                              |
|------------------|--------------------------------------|--------------------------------------------------------|
| **id**           | INT                                  | PRIMARY KEY, AUTO_INCREMENT                            |
| **pagamento_id** | INT                                  | FOREIGN KEY → `pagamento.id` (ON DELETE CASCADE)       |
| **tipo**         | ENUM('cartao','boleto','pix')         | NOT NULL                                               |
| **valor**        | DECIMAL(10,2)                        | NOT NULL                                               |
| **cliente_cartao_id** | INT                             | FOREIGN KEY → `cliente_cartao.id` (ON DELETE SET NULL) |
| **codigo_pix**   | VARCHAR(255)                         | NULL                                                   |

**Observações**:
- Armazena qual método de pagamento foi utilizado (cartão, boleto, pix).
- Pode referenciar um cartão já cadastrado em `cliente_cartao`.

---

### 1️⃣7️⃣ Vendedor (`vendedor`)
Representa os vendedores responsáveis pelos pedidos.

| Campo            | Tipo                 | Restrição                                        |
|------------------|----------------------|--------------------------------------------------|
| **id**           | INT                 | PRIMARY KEY, AUTO_INCREMENT                      |
| **nome**         | VARCHAR(255)        | NOT NULL                                         |
| **email**        | VARCHAR(255)        | UNIQUE, NOT NULL                                 |
| **telefone**     | CHAR(11)            | NULL                                             |
| **cpf**          | CHAR(14)            | UNIQUE, NOT NULL                                 |
| **data_contratacao** | DATE           | NOT NULL                                         |
| **status**       | ENUM('ativo','inativo') | DEFAULT 'ativo'                                 |
| **criado_em**    | DATETIME            | DEFAULT CURRENT_TIMESTAMP                        |
| **atualizado_em**| DATETIME            | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

**Observações**:
- Associado a `pedido` como chave estrangeira.
- Quando um vendedor é removido, os pedidos vinculados ficam com `vendedor_id = NULL`.

---

## 🔗 Relacionamentos Principais

1. **Cliente** → **Pedido** (*1:N*) → Um cliente pode fazer vários pedidos.  
2. **Pedido** → **Pagamento** (*1:1*) → Cada pedido tem um registro de pagamento.  
3. **Pedido** → **Entrega** (*1:1*) → Cada pedido tem informações de entrega.  
4. **Pedido** ↔ **Produto** (*N:M*) → Muitos produtos em um pedido, e um produto pode estar em vários pedidos (por meio de `pedido_produto`).  
5. **Cliente** → **Cliente Cartão** (*1:N*) → Vários cartões para um cliente.  
6. **Cliente** → **Cliente Endereço** (*1:N*) → Vários endereços por cliente.  
7. **Fornecedor** → **Produto** (*N:M*) → Um fornecedor pode fornecer vários produtos e um produto pode ter vários fornecedores (por meio de `produto_fornecedor`).  
8. **Cliente** → **Cliente PF** ou **Cliente PJ** (*1:1*) → Um cliente pode ser PF ou PJ.  

---

## 📌 Considerações

- **Chaves Primárias**: Todas as tabelas possuem `id` como chave primária (exceto quando uma PK composta é definida, como em `produto_fornecedor`).  
- **Chaves Estrangeiras**: Relações em cascata (CASCADE) auxiliam a manter a integridade referencial.  
- **Índices**: Campos como `email`, `cpf`, `cnpj` são únicos para evitar duplicidades.  
- **Integridade**: Há CHECK constraints para avaliar campos como `avaliacao` em `fornecedor`.  

---

## 📖 Licença
Este esquema de banco de dados está disponível sob a licença **MIT**. Sinta-se livre para utilizá-lo e modificá-lo conforme necessário.

---

## 📑 Observações sobre a Abordagem

1. **Organização**: Cada tabela foi documentada em um formato de tabela Markdown para clareza.  
2. **Manutenção**: Uso de `ON DELETE CASCADE` e `ON DELETE SET NULL` para gerenciar dependências.  
3. **Performance**: Índices em campos críticos (e.g., `email`, `cpf`, `cnpj`) ajudam a otimizar buscas.  
4. **Segurança**: Campos como `numero_cartao` e `cvv` são armazenados como `VARBINARY` para maior controle.  

---

📌 **Autor**: [Daniel P Monteiro]
