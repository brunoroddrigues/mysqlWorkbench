-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE sistema_vendas;
USE sistema_vendas;

-- 1. Tabela de Produtos
CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY, -- ID do produto
  nome VARCHAR(100) NOT NULL, -- Nome do produto
  preco DECIMAL(10, 2) NOT NULL -- Preço do produto
);

-- 2. Tabela de Clientes
CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY, -- ID do cliente
  nome VARCHAR(100) NOT NULL, -- Nome do cliente
  email VARCHAR(100) -- Email do cliente
);

-- 3. Tabela de Vendas
CREATE TABLE vendas (
  id INT AUTO_INCREMENT PRIMARY KEY, -- ID da venda
  cliente_id INT NOT NULL, -- ID do cliente
  produto_id INT NOT NULL, -- ID do produto
  quantidade INT NOT NULL, -- Quantidade comprada
  data_venda DATE NOT NULL, -- Data da venda
  valor_total DECIMAL(10, 2) NOT NULL, -- Valor total da venda
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- INSERÇÃO DE DADOS EXEMPLO

-- 1. Produtos
INSERT INTO produtos (nome, preco) VALUES
('Notebook', 2500.00),
('Mouse', 50.00),
('Teclado', 100.00);

-- 2. Clientes
INSERT INTO clientes (nome, email) VALUES
('João Silva', 'joao@gmail.com'),
('Maria Santos', 'maria@hotmail.com');

-- 3. Vendas
INSERT INTO vendas (cliente_id, produto_id, quantidade, data_venda, valor_total) VALUES
(1, 1, 1, '2024-12-01', 2500.00), -- João comprou 1 Notebook
(2, 2, 2, '2024-12-01', 100.00); -- Maria comprou 2 Mouses

-- CONSULTAS SIMPLES PARA ADAPTAÇÃO

-- 1. Listar todos os produtos
SELECT * FROM produtos;

-- 2. Listar todos os clientes
SELECT * FROM clientes;

-- 3. Listar todas as vendas
SELECT * FROM vendas;

-- 4. Exibir vendas com nome do cliente e do produto
SELECT 
  v.id AS venda_id, 
  c.nome AS cliente, 
  p.nome AS produto, 
  v.quantidade, 
  v.valor_total, 
  v.data_venda 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN produtos p ON v.produto_id = p.id;

-- 5. Listar clientes que fizeram compras acima de um valor específico (exemplo: R$ 1000)
SELECT 
  c.nome, 
  SUM(v.valor_total) AS total_gasto 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
GROUP BY c.nome
HAVING total_gasto > 1000;

-- 6. Exibir o produto mais vendido
SELECT 
  p.nome AS produto, 
  SUM(v.quantidade) AS total_vendido 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome
ORDER BY total_vendido DESC
LIMIT 1;

-- 7. Listar vendas realizadas em um intervalo de datas
SELECT 
  v.id AS venda_id, 
  c.nome AS cliente, 
  p.nome AS produto, 
  v.quantidade, 
  v.valor_total, 
  v.data_venda 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN produtos p ON v.produto_id = p.id
WHERE v.data_venda BETWEEN '2024-12-01' AND '2024-12-31';

-- 8. Exibir o valor total das vendas por produto
SELECT 
  p.nome AS produto, 
  SUM(v.valor_total) AS total_vendas 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome;

-- 9. Exibir a quantidade total de produtos vendidos
SELECT 
  p.nome AS produto, 
  SUM(v.quantidade) AS quantidade_vendida 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome;

-- 10. Listar clientes que compraram produtos específicos (exemplo: Mouse)
SELECT 
  c.nome AS cliente, 
  p.nome AS produto, 
  v.quantidade 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN produtos p ON v.produto_id = p.id
WHERE p.nome = 'Mouse';
