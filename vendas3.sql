-- Criação do Banco de Dados 'sistema_vendas'
CREATE DATABASE sistema_vendas;
USE sistema_vendas;

-- Criação das Tabelas
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada produto
    nome VARCHAR(100) NOT NULL,         -- Nome do produto
    preco DECIMAL(10, 2) NOT NULL,      -- Preço do produto
    quantidade_estoque INT DEFAULT 0    -- Quantidade disponível no estoque
);

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada cliente
    nome VARCHAR(100) NOT NULL,         -- Nome do cliente
    email VARCHAR(100) UNIQUE NOT NULL, -- E-mail do cliente
    telefone VARCHAR(15)               -- Telefone do cliente
);

CREATE TABLE vendas (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada venda
    id_cliente INT,                     -- ID do cliente, referência à tabela de clientes
    data_venda DATE,                    -- Data da venda
    total DECIMAL(10, 2),                -- Valor total da venda
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)  -- Relacionamento com a tabela de clientes
);

CREATE TABLE itens_venda (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada item
    id_venda INT,                       -- ID da venda, referência à tabela vendas
    id_produto INT,                     -- ID do produto, referência à tabela produtos
    quantidade INT,                     -- Quantidade de produtos vendidos
    preco_unitario DECIMAL(10, 2),      -- Preço unitário do produto na venda
    FOREIGN KEY (id_venda) REFERENCES vendas(id),   -- Relacionamento com a tabela vendas
    FOREIGN KEY (id_produto) REFERENCES produtos(id) -- Relacionamento com a tabela produtos
);

-- Inserção de Produtos
INSERT INTO produtos (nome, preco, quantidade_estoque) VALUES 
('Camiseta', 39.99, 100), 
('Calça Jeans', 99.90, 50), 
('Tênis', 149.90, 30), 
('Boné', 29.90, 150), 
('Jaqueta', 199.90, 20);

-- Inserção de Clientes
INSERT INTO clientes (nome, email, telefone) VALUES 
('João Silva', 'joao.silva@email.com', '11987654321'),
('Maria Oliveira', 'maria.oliveira@email.com', '11999887766'),
('Carlos Santos', 'carlos.santos@email.com', '11888776655');

-- Inserção de Vendas
INSERT INTO vendas (id_cliente, data_venda, total) VALUES 
(1, '2024-11-01', 179.80), 
(2, '2024-11-02', 249.80), 
(3, '2024-11-03', 119.90);

-- Inserção de Itens de Venda
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES 
(1, 1, 2, 39.99),   -- Venda 1: 2 Camisetas
(1, 4, 1, 29.90),   -- Venda 1: 1 Boné
(2, 2, 1, 99.90),   -- Venda 2: 1 Calça Jeans
(2, 3, 1, 149.90),  -- Venda 2: 1 Tênis
(3, 1, 1, 39.99);   -- Venda 3: 1 Camiseta

-- Exemplo 1: Consulta de Produtos em Estoque
-- Aqui estamos listando todos os produtos que têm quantidade no estoque maior que zero.
SELECT nome, quantidade_estoque
FROM produtos
WHERE quantidade_estoque > 0;

-- Exemplo 2: Consulta de Vendas Realizadas
-- Exibe todos os detalhes das vendas realizadas, com o nome do cliente e o valor total da venda.
SELECT v.id AS id_venda, c.nome AS nome_cliente, v.data_venda, v.total 
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id;

-- Exemplo 3: Consulta de Itens de Venda com Detalhes do Produto
-- Aqui estamos juntando as tabelas 'itens_venda' e 'produtos' para mostrar os produtos vendidos em cada venda.
SELECT iv.id_venda, p.nome AS nome_produto, iv.quantidade, iv.preco_unitario
FROM itens_venda iv
INNER JOIN produtos p ON iv.id_produto = p.id;

-- Exemplo 4: Consulta do Total de Vendas por Cliente
-- Aqui estamos agrupando as vendas por cliente e somando o total de vendas de cada cliente.
SELECT c.nome AS nome_cliente, SUM(v.total) AS total_vendas
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id
GROUP BY c.id;

-- Exemplo 5: Atualização de Estoque após Venda
-- Atualiza o estoque de produtos após a venda, subtraindo a quantidade vendida de cada produto.
UPDATE produtos p
JOIN itens_venda iv ON p.id = iv.id_produto
SET p.quantidade_estoque = p.quantidade_estoque - iv.quantidade
WHERE iv.id_venda = 1;

-- Exemplo 6: Consulta de Produtos com Menor Quantidade em Estoque
-- Exibe os produtos que têm quantidade em estoque menor que 50.
SELECT nome, quantidade_estoque
FROM produtos
WHERE quantidade_estoque < 50;

-- Exemplo 7: Consulta de Vendas por Período
-- Aqui, estamos consultando as vendas feitas no mês de novembro de 2024.
SELECT v.id AS id_venda, c.nome AS nome_cliente, v.data_venda, v.total
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id
WHERE v.data_venda BETWEEN '2024-11-01' AND '2024-11-30';

-- Exemplo 8: Consulta de Clientes que Compraram Certos Produtos
-- Aqui, estamos consultando os clientes que compraram camisetas.
SELECT DISTINCT c.nome AS nome_cliente
FROM vendas v
INNER JOIN itens_venda iv ON v.id = iv.id_venda
INNER JOIN produtos p ON iv.id_produto = p.id
INNER JOIN clientes c ON v.id_cliente = c.id
WHERE p.nome = 'Camiseta';

-- Exemplo 9: Consulta do Produto Mais Vendido
-- Exibe o produto que foi mais vendido, baseado na quantidade.
SELECT p.nome AS nome_produto, SUM(iv.quantidade) AS quantidade_vendida
FROM itens_venda iv
INNER JOIN produtos p ON iv.id_produto = p.id
GROUP BY p.id
ORDER BY quantidade_vendida DESC
LIMIT 1;

-- Exemplo 10: Criação de uma View para Vendas Detalhadas
-- Cria uma visualização com informações detalhadas de vendas, incluindo cliente e produtos vendidos.
CREATE VIEW vw_vendas_detalhadas AS
SELECT v.id AS id_venda, c.nome AS nome_cliente, v.data_venda, p.nome AS nome_produto, iv.quantidade, iv.preco_unitario
FROM vendas v
INNER JOIN clientes c ON v.id_cliente = c.id
INNER JOIN itens_venda iv ON v.id = iv.id_venda
INNER JOIN produtos p ON iv.id_produto = p.id;
