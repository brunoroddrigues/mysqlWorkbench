-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE sistema_vendas;
USE sistema_vendas;

-- TABELAS

-- 1. Tabela de Produtos
CREATE TABLE produtos (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do produto
  nome VARCHAR(100) NOT NULL, -- Nome do produto
  descricao TEXT, -- Descrição do produto
  preco DECIMAL(10, 2) NOT NULL, -- Preço do produto
  estoque INT DEFAULT 0 -- Quantidade disponível em estoque
);

-- 2. Tabela de Clientes
CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do cliente
  nome VARCHAR(100) NOT NULL, -- Nome completo do cliente
  email VARCHAR(100) UNIQUE, -- Email do cliente
  telefone VARCHAR(15), -- Telefone do cliente
  endereco TEXT -- Endereço completo do cliente
);

-- 3. Tabela de Vendas
CREATE TABLE vendas (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único da venda
  cliente_id INT NOT NULL, -- Identificador do cliente
  data_venda DATE NOT NULL, -- Data em que a venda foi realizada
  total DECIMAL(10, 2) NOT NULL, -- Valor total da venda
  FOREIGN KEY (cliente_id) REFERENCES clientes(id) -- Chave estrangeira para clientes
);

-- 4. Tabela de Itens Vendidos
CREATE TABLE itens_venda (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do item
  venda_id INT NOT NULL, -- Identificador da venda
  produto_id INT NOT NULL, -- Identificador do produto
  quantidade INT NOT NULL, -- Quantidade vendida
  preco_unitario DECIMAL(10, 2) NOT NULL, -- Preço unitário do produto
  FOREIGN KEY (venda_id) REFERENCES vendas(id), -- Chave estrangeira para vendas
  FOREIGN KEY (produto_id) REFERENCES produtos(id) -- Chave estrangeira para produtos
);

-- 5. Tabela de Funcionários
CREATE TABLE funcionarios (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do funcionário
  nome VARCHAR(100) NOT NULL, -- Nome completo do funcionário
  cargo VARCHAR(50), -- Cargo do funcionário
  salario DECIMAL(10, 2), -- Salário do funcionário
  data_admissao DATE NOT NULL -- Data de admissão
);

-- INSERÇÃO DE DADOS

-- 1. Inserção de Produtos
INSERT INTO produtos (nome, descricao, preco, estoque) VALUES
('Notebook Dell', 'Notebook Core i5, 8GB RAM, SSD 256GB', 4500.00, 10),
('Mouse Logitech', 'Mouse sem fio com alta precisão', 120.00, 50),
('Teclado Mecânico', 'Teclado RGB com switches Cherry MX', 300.00, 20);

-- 2. Inserção de Clientes
INSERT INTO clientes (nome, email, telefone, endereco) VALUES
('Ana Silva', 'ana.silva@gmail.com', '11988887777', 'Rua das Flores, 123'),
('Carlos Oliveira', 'carlos.oliveira@yahoo.com', '11977776666', 'Av. Central, 456'),
('Beatriz Rocha', 'beatriz.rocha@hotmail.com', NULL, 'Travessa das Árvores, 789');

-- 3. Inserção de Funcionários
INSERT INTO funcionarios (nome, cargo, salario, data_admissao) VALUES
('João Pereira', 'Vendedor', 2500.00, '2020-01-15'),
('Maria Santos', 'Gerente', 4500.00, '2018-05-10');

-- 4. Inserção de Vendas
INSERT INTO vendas (cliente_id, data_venda, total) VALUES
(1, '2024-01-10', 4620.00),
(2, '2024-01-12', 300.00);

-- 5. Inserção de Itens Vendidos
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 4500.00),
(1, 2, 1, 120.00),
(2, 3, 1, 300.00);

-- CONSULTAS EXEMPLOS

-- 1. Listar os produtos em estoque
SELECT nome, estoque 
FROM produtos
WHERE estoque > 0;

-- 2. Exibir as vendas realizadas por cada cliente
SELECT 
  c.nome AS cliente, 
  v.data_venda, 
  v.total 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id;

-- 3. Listar os itens vendidos em uma venda específica
SELECT 
  p.nome AS produto, 
  i.quantidade, 
  i.preco_unitario 
FROM itens_venda i
INNER JOIN produtos p ON i.produto_id = p.id
WHERE i.venda_id = 1;

-- 4. Exibir o total de vendas realizadas por cada cliente
SELECT 
  c.nome AS cliente, 
  COUNT(v.id) AS total_vendas, 
  SUM(v.total) AS valor_total
FROM clientes c
LEFT JOIN vendas v ON c.id = v.cliente_id
GROUP BY c.nome;

-- 5. Calcular o valor médio de uma venda
SELECT AVG(total) AS valor_medio_venda 
FROM vendas;

-- 6. Listar os funcionários e seus cargos
SELECT nome, cargo 
FROM funcionarios;

-- 7. Exibir as vendas realizadas por um funcionário específico (assumindo que há um campo futuro para registrar vendas feitas por funcionários)
-- Essa tabela precisaria de relacionamento em um cenário ampliado.

-- 8. Criar uma visão para listar clientes e os produtos que compraram
CREATE VIEW vw_clientes_produtos AS
SELECT 
  c.nome AS cliente, 
  p.nome AS produto, 
  i.quantidade, 
  i.preco_unitario
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN itens_venda i ON v.id = i.venda_id
INNER JOIN produtos p ON i.produto_id = p.id;

-- 9. Listar o total de produtos vendidos por categoria
SELECT 
  p.nome AS produto, 
  SUM(i.quantidade) AS total_vendido
FROM produtos p
INNER JOIN itens_venda i ON p.id = i.produto_id
GROUP BY p.nome;

-- 10. Criar uma visão para listar as vendas com seus respectivos itens
CREATE VIEW vw_vendas_itens AS
SELECT 
  v.id AS venda_id, 
  v.data_venda, 
  v.total AS total_venda, 
  p.nome AS produto, 
  i.quantidade, 
  i.preco_unitario
FROM vendas v
INNER JOIN itens_venda i ON v.id = i.venda_id
INNER JOIN produtos p ON i.produto_id = p.id;
