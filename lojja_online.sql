-- Criação do banco de dados 'loja_online'
CREATE DATABASE loja_online;
USE loja_online;

-- Criação da tabela 'produtos' para armazenar os dados dos produtos vendidos na loja
CREATE TABLE produtos (
  id_produto INT PRIMARY KEY AUTO_INCREMENT,  -- ID único do produto
  nome VARCHAR(100) NOT NULL,                  -- Nome do produto (Ex: Celular, Laptop)
  descricao TEXT,                              -- Descrição do produto
  preco DECIMAL(10, 2) NOT NULL,               -- Preço do produto
  quantidade_estoque INT NOT NULL              -- Quantidade disponível em estoque
);

-- Criação da tabela 'clientes' para armazenar as informações dos clientes da loja
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do cliente
  nome VARCHAR(100) NOT NULL,                   -- Nome do cliente
  email VARCHAR(100) NOT NULL UNIQUE,           -- E-mail do cliente (único)
  telefone VARCHAR(15),                         -- Telefone do cliente
  endereco VARCHAR(255)                         -- Endereço do cliente
);

-- Criação da tabela 'vendas' para registrar as vendas feitas na loja
CREATE TABLE vendas (
  id_venda INT PRIMARY KEY AUTO_INCREMENT,     -- ID único da venda
  id_cliente INT,                              -- ID do cliente que realizou a compra (chave estrangeira)
  data_venda DATE NOT NULL,                    -- Data em que a venda foi realizada
  total DECIMAL(10, 2) NOT NULL,                -- Valor total da venda
  STATUS VARCHAR(50) NOT NULL,                  -- Status da venda (Ex: Pendente, Finalizada, Cancelada)
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)  -- Chave estrangeira para 'clientes'
);

-- Criação da tabela 'itens_venda' para armazenar os itens comprados em cada venda
CREATE TABLE itens_venda (
  id_item INT PRIMARY KEY AUTO_INCREMENT,      -- ID único do item na venda
  id_venda INT,                                -- ID da venda (chave estrangeira)
  id_produto INT,                              -- ID do produto (chave estrangeira)
  quantidade INT NOT NULL,                     -- Quantidade do produto comprado
  preco_unitario DECIMAL(10, 2) NOT NULL,      -- Preço unitário do produto
  FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),  -- Chave estrangeira para 'vendas'
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)  -- Chave estrangeira para 'produtos'
);

-- Criação da tabela 'pagamentos' para registrar os pagamentos realizados pelos clientes
CREATE TABLE pagamentos (
  id_pagamento INT PRIMARY KEY AUTO_INCREMENT,  -- ID único do pagamento
  id_venda INT,                                 -- ID da venda que foi paga (chave estrangeira)
  valor_pago DECIMAL(10, 2) NOT NULL,           -- Valor pago
  data_pagamento DATE NOT NULL,                 -- Data do pagamento
  metodo_pagamento VARCHAR(50) NOT NULL,        -- Método de pagamento (Ex: Cartão de Crédito, Boleto)
  FOREIGN KEY (id_venda) REFERENCES vendas(id_venda)  -- Chave estrangeira para 'vendas'
);

-- Inserção de dados de exemplo na tabela 'produtos'
INSERT INTO produtos (nome, descricao, preco, quantidade_estoque) VALUES
('Celular', 'Smartphone com tela de 6.5 polegadas, 128GB', 1500.00, 50),
('Laptop', 'Laptop com 8GB de RAM, 512GB SSD', 4000.00, 20),
('Fone de Ouvido', 'Fone de ouvido sem fio Bluetooth', 200.00, 100),
('Teclado', 'Teclado mecânico RGB', 250.00, 30);

-- Inserção de dados de exemplo na tabela 'clientes'
INSERT INTO clientes (nome, email, telefone, endereco) VALUES
('Carlos Silva', 'carlos@exemplo.com', '1234567890', 'Rua A, 123'),
('Ana Oliveira', 'ana@exemplo.com', '0987654321', 'Rua B, 456'),
('Paulo Souza', 'paulo@exemplo.com', '1122334455', 'Rua C, 789');

-- Inserção de dados de exemplo na tabela 'vendas'
INSERT INTO vendas (id_cliente, data_venda, total, STATUS) VALUES
(1, '2024-11-01', 1700.00, 'Finalizada'),
(2, '2024-11-02', 2500.00, 'Pendente'),
(3, '2024-11-03', 200.00, 'Cancelada');

-- Inserção de dados de exemplo na tabela 'itens_venda'
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1500.00),
(2, 2, 1, 4000.00),
(3, 3, 1, 200.00);

-- Inserção de dados de exemplo na tabela 'pagamentos'
INSERT INTO pagamentos (id_venda, valor_pago, data_pagamento, metodo_pagamento) VALUES
(1, 1700.00, '2024-11-01', 'Cartão de Crédito'),
(2, 2500.00, '2024-11-02', 'Boleto'),
(3, 200.00, '2024-11-03', 'Cartão de Crédito');

-- Exemplo 1: Listar todos os produtos e suas quantidades em estoque
SELECT nome, quantidade_estoque
FROM produtos;

-- Exemplo 2: Listar todos os clientes e seus e-mails
SELECT nome, email
FROM clientes;

-- Exemplo 3: Consultar vendas pendentes (onde o status é 'Pendente')
SELECT v.id_venda, c.nome AS cliente, v.data_venda, v.total
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.status = 'Pendente';

-- Exemplo 4: Contar o total de vendas por status (Finalizada, Pendente, Cancelada)
SELECT STATUS, COUNT(id_venda) AS total_vendas
FROM vendas
GROUP BY STATUS;

-- Exemplo 5: Consultar os produtos mais vendidos (quantidade total de cada produto vendido)
SELECT p.nome AS produto, SUM(iv.quantidade) AS total_vendido
FROM itens_venda iv
INNER JOIN produtos p ON iv.id_produto = p.id_produto
GROUP BY p.nome;

-- Exemplo 6: Consultar os pagamentos realizados com cartão de crédito
SELECT p.id_pagamento, v.id_venda, p.valor_pago, p.data_pagamento, p.metodo_pagamento
FROM pagamentos p
INNER JOIN vendas v ON p.id_venda = v.id_venda
WHERE p.metodo_pagamento = 'Cartão de Crédito';

-- Exemplo 7: Criar uma VIEW para mostrar os clientes que compraram produtos acima de R$1000,00
CREATE VIEW clientes_acima_1000 AS
SELECT c.nome AS cliente, v.total
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.total > 1000;

-- Exemplo 8: Consultar a quantidade total de produtos vendidos por cliente
SELECT c.nome AS cliente, SUM(iv.quantidade) AS total_produtos
FROM itens_venda iv
INNER JOIN vendas v ON iv.id_venda = v.id_venda
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.nome;

-- Exemplo 9: Consultar vendas e produtos por status 'Finalizada'
SELECT v.id_venda, c.nome AS cliente, p.nome AS produto, iv.quantidade, v.total
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN itens_venda iv ON v.id_venda = iv.id_venda
INNER JOIN produtos p ON iv.id_produto = p.id_produto
WHERE v.status = 'Finalizada';

-- Exemplo 10: Consultar os pagamentos feitos em um mês específico (novembro de 2024)
SELECT p.id_pagamento, v.id_venda, p.valor_pago, p.data_pagamento
FROM pagamentos p
INNER JOIN vendas v ON p.id_venda = v.id_venda
WHERE MONTH(p.data_pagamento) = 11 AND YEAR(p.data_pagamento) = 2024;

-- **Views Adicionadas**:

-- 1. VIEW: Exibe os clientes que gastaram acima de R$1000 em suas compras
CREATE VIEW clientes_acima_1000 AS
SELECT c.nome AS cliente, v.total
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.total > 1000;

-- 2. VIEW: Exibe os produtos mais vendidos com a quantidade total de vendas por produto
CREATE VIEW produtos_mais_vendidos AS
SELECT p.nome AS produto, SUM(iv.quantidade) AS total_vendido
FROM itens_venda iv
INNER JOIN produtos p ON iv.id_produto = p.id_produto
GROUP BY p.nome;

-- 3. VIEW: Exibe as vendas realizadas no mês de novembro de 2024
CREATE VIEW vendas_novembro_2024 AS
SELECT v.id_venda, c.nome AS cliente, v.total, v.data_venda
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE MONTH(v.data_venda) = 11 AND YEAR(v.data_venda) = 2024;

-- Consultando as views
SELECT * FROM clientes_acima_1000;
SELECT * FROM produtos_mais_vendidos;
SELECT * FROM vendas_novembro_2024;
