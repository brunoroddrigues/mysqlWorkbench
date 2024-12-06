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
('Smartphone', 1500.00),
('Tablet', 1200.00),
('Cadeira Gamer', 600.00);

-- 2. Clientes
INSERT INTO clientes (nome, email) VALUES
('Carlos Oliveira', 'carlos@gmail.com'),
('Ana Pereira', 'ana@hotmail.com');

-- 3. Vendas
INSERT INTO vendas (cliente_id, produto_id, quantidade, data_venda, valor_total) VALUES
(1, 1, 2, '2024-12-01', 3000.00), -- Carlos comprou 2 Smartphones
(2, 3, 1, '2024-12-01', 600.00); -- Ana comprou 1 Cadeira Gamer

-- CONSULTAS SIMPLES PARA ADAPTAÇÃO

-- 1. Listar todos os produtos (caso peçam todos os produtos)
SELECT * FROM produtos; -- Aqui você pode listar todos os produtos no sistema

-- 2. Listar todos os clientes (caso peçam todos os clientes)
SELECT * FROM clientes; -- Aqui você pode listar todos os clientes registrados

-- 3. Listar todas as vendas (caso precisem ver todas as vendas)
SELECT * FROM vendas; -- Aqui você pode ver todas as vendas realizadas

-- 4. Exibir vendas com o nome do cliente e o produto comprado
-- Se pedirem para mostrar vendas com cliente e produto, utilize a consulta abaixo.
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

-- 5. Listar clientes que compraram produtos com valor acima de um limite
-- Se pedirem para mostrar clientes que gastaram mais de um valor específico (exemplo: R$ 1000)
SELECT 
  c.nome, 
  SUM(v.valor_total) AS total_gasto 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
GROUP BY c.nome
HAVING total_gasto > 1000; -- Aqui você pode alterar o valor (1000) conforme solicitado na prova

-- 6. Exibir o produto mais vendido
-- Caso perguntem qual o produto mais vendido, use esta consulta.
SELECT 
  p.nome AS produto, 
  SUM(v.quantidade) AS total_vendido 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome
ORDER BY total_vendido DESC
LIMIT 1; -- Aqui você pode modificar para ver os top N produtos, se solicitado

-- 7. Listar vendas em um intervalo de datas específico
-- Caso solicitem as vendas em um período, modifique as datas conforme o pedido.
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
WHERE v.data_venda BETWEEN '2024-12-01' AND '2024-12-31'; -- Aqui altere as datas conforme solicitado

-- 8. Exibir a quantidade total vendida por produto
-- Se pedirem a quantidade total de cada produto vendido, use essa consulta.
SELECT 
  p.nome AS produto, 
  SUM(v.quantidade) AS quantidade_vendida 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome;

-- 9. Exibir o total vendido por produto (valor total de vendas)
-- Caso seja solicitado o total vendido por cada produto, essa consulta será útil.
SELECT 
  p.nome AS produto, 
  SUM(v.valor_total) AS total_vendas 
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY p.nome;

-- 10. Listar os clientes que compraram um produto específico
-- Se pedirem os clientes que compraram, por exemplo, o 'Tablet', basta mudar o nome do produto na consulta.
SELECT 
  c.nome AS cliente, 
  p.nome AS produto, 
  v.quantidade 
FROM vendas v
INNER JOIN clientes c ON v.cliente_id = c.id
INNER JOIN produtos p ON v.produto_id = p.id
WHERE p.nome = 'Tablet'; -- Aqui você pode alterar o nome do produto conforme necessário
