-- Criação do banco de dados 'loja_eletronicos'
CREATE DATABASE loja_eletronicos;
USE loja_eletronicos;

-- Criação da tabela 'categorias' para armazenar as categorias de produtos
CREATE TABLE categorias (
  id_categoria INT PRIMARY KEY AUTO_INCREMENT,   -- ID único da categoria
  nome VARCHAR(100) NOT NULL                     -- Nome da categoria (Ex: Smartphones, Laptops)
);

-- Criação da tabela 'produtos' para armazenar os produtos disponíveis na loja
CREATE TABLE produtos (
  id_produto INT PRIMARY KEY AUTO_INCREMENT,     -- ID único do produto
  nome VARCHAR(100) NOT NULL,                     -- Nome do produto (Ex: iPhone 12, Dell XPS 13)
  preco DECIMAL(10, 2) NOT NULL,                  -- Preço do produto
  id_categoria INT,                               -- ID da categoria (chave estrangeira)
  quantidade_estoque INT NOT NULL,                -- Quantidade disponível em estoque
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)  -- Chave estrangeira para 'categorias'
);

-- Criação da tabela 'clientes' para armazenar informações dos clientes
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,     -- ID único do cliente
  nome VARCHAR(100) NOT NULL,                     -- Nome do cliente
  endereco VARCHAR(255),                          -- Endereço do cliente
  telefone VARCHAR(15)                            -- Telefone do cliente
);

-- Criação da tabela 'vendas' para registrar as vendas realizadas
CREATE TABLE vendas (
  id_venda INT PRIMARY KEY AUTO_INCREMENT,       -- ID único da venda
  id_cliente INT,                                 -- ID do cliente (chave estrangeira)
  data_venda DATE,                                -- Data da venda
  total DECIMAL(10, 2) NOT NULL,                  -- Total da venda
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)  -- Chave estrangeira para 'clientes'
);

-- Criação da tabela 'itens_venda' para registrar os itens comprados em cada venda
CREATE TABLE itens_venda (
  id_item INT PRIMARY KEY AUTO_INCREMENT,        -- ID único do item
  id_venda INT,                                  -- ID da venda (chave estrangeira)
  id_produto INT,                                -- ID do produto (chave estrangeira)
  quantidade INT NOT NULL,                       -- Quantidade do produto comprado
  preco_unitario DECIMAL(10, 2) NOT NULL,        -- Preço unitário do produto
  FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),  -- Chave estrangeira para 'vendas'
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)  -- Chave estrangeira para 'produtos'
);

-- Inserção de dados de exemplo na tabela 'categorias'
INSERT INTO categorias (nome) VALUES
('Smartphones'),
('Laptops'),
('Tablets'),
('Acessórios');

-- Inserção de dados de exemplo na tabela 'produtos'
INSERT INTO produtos (nome, preco, id_categoria, quantidade_estoque) VALUES
('iPhone 12', 4999.99, 1, 50),
('Dell XPS 13', 8999.99, 2, 30),
('iPad Air', 3499.99, 3, 40),
('AirPods Pro', 1899.99, 4, 100);

-- Inserção de dados de exemplo na tabela 'clientes'
INSERT INTO clientes (nome, endereco, telefone) VALUES
('Carlos Oliveira', 'Rua das Palmeiras, 150', '987654321'),
('Maria Santos', 'Avenida Central, 300', '912345678'),
('Pedro Silva', 'Rua da Liberdade, 450', '934567890');

-- Inserção de dados de exemplo na tabela 'vendas'
INSERT INTO vendas (id_cliente, data_venda, total) VALUES
(1, '2024-11-10', 5999.98),
(2, '2024-11-12', 8999.99),
(3, '2024-11-13', 3499.99);

-- Inserção de dados de exemplo na tabela 'itens_venda'
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 4999.99),
(1, 4, 1, 1899.99),
(2, 2, 1, 8999.99),
(3, 3, 1, 3499.99);

-- Consultas e views criadas para análise de dados:

-- Exemplo 1: Listar todos os produtos e suas respectivas categorias
SELECT p.nome AS produto, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.id_categoria = c.id_categoria;

-- Exemplo 2: Listar todos os produtos em estoque com sua quantidade e preço
SELECT nome, quantidade_estoque, preco
FROM produtos
WHERE quantidade_estoque > 0;

-- Exemplo 3: Consultar todas as vendas realizadas em um determinado período
SELECT v.id_venda, v.data_venda, v.total, c.nome AS cliente
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.data_venda BETWEEN '2024-11-01' AND '2024-11-30';

-- Exemplo 4: Contagem de produtos vendidos por categoria
SELECT c.nome AS categoria, COUNT(iv.id_item) AS total_itens_vendidos
FROM itens_venda iv
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY c.id_categoria;

-- Exemplo 5: Mostrar os clientes que compraram produtos com preço superior a 3000
SELECT DISTINCT cl.nome AS cliente
FROM clientes cl
JOIN vendas v ON cl.id_cliente = v.id_cliente
JOIN itens_venda iv ON v.id_venda = iv.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
WHERE p.preco > 3000;

-- Exemplo 6: Criar uma VIEW para listar os produtos e suas respectivas categorias
CREATE VIEW produtos_categoria AS
SELECT p.nome AS produto, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.id_categoria = c.id_categoria;

-- Exemplo 7: Criar uma VIEW para listar as vendas realizadas e o total de cada venda
CREATE VIEW vendas_totais AS
SELECT v.id_venda, v.data_venda, v.total, c.nome AS cliente
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente;

-- Exemplo 8: Criar uma VIEW para mostrar o total de vendas de cada cliente
CREATE VIEW total_vendas_cliente AS
SELECT c.nome AS cliente, SUM(v.total) AS total_vendas
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente;

-- Exemplo 9: Mostrar todos os produtos com estoque abaixo de 10 unidades
SELECT nome, quantidade_estoque
FROM produtos
WHERE quantidade_estoque < 10;

-- Exemplo 10: Contar quantos produtos foram vendidos por mês (por ano e mês)
SELECT YEAR(v.data_venda) AS ano, MONTH(v.data_venda) AS mes, COUNT(iv.id_item) AS total_produtos_vendidos
FROM vendas v
JOIN itens_venda iv ON v.id_venda = iv.id_venda
GROUP BY YEAR(v.data_venda), MONTH(v.data_venda);

-- Exemplo 11: Mostrar todos os produtos vendidos com o nome do cliente e preço unitário
SELECT iv.id_item, p.nome AS produto, cl.nome AS cliente, iv.quantidade, iv.preco_unitario
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN clientes cl ON v.id_cliente = cl.id_cliente
JOIN produtos p ON iv.id_produto = p.id_produto;
