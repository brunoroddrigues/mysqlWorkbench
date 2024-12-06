-- Criação do banco de dados 'gestao_compras'
CREATE DATABASE gestao_compras;
USE gestao_compras;

-- Tabela 'fornecedores' para armazenar informações dos fornecedores
CREATE TABLE fornecedores (
  id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,                       -- Nome do fornecedor
  cnpj VARCHAR(18) NOT NULL UNIQUE,                 -- CNPJ do fornecedor
  telefone VARCHAR(15),                             -- Telefone do fornecedor
  endereco VARCHAR(255),                            -- Endereço do fornecedor
  email VARCHAR(100)                                -- E-mail do fornecedor
);

-- Tabela 'produtos' para armazenar informações sobre os produtos
CREATE TABLE produtos (
  id_produto INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,                       -- Nome do produto
  descricao TEXT,                                   -- Descrição do produto
  preco DECIMAL(10,2) NOT NULL,                     -- Preço do produto
  estoque INT NOT NULL,                             -- Quantidade em estoque
  id_fornecedor INT,                               -- ID do fornecedor (chave estrangeira)
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
);

-- Tabela 'pedidos' para armazenar informações sobre os pedidos de compra
CREATE TABLE pedidos (
  id_pedido INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente INT NOT NULL,                          -- ID do cliente que fez o pedido
  data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Data e hora do pedido
  STATUS ENUM('pendente', 'confirmado', 'entregue') DEFAULT 'pendente' -- Status do pedido
);

-- Tabela 'itens_pedido' para armazenar os itens de cada pedido
CREATE TABLE itens_pedido (
  id_item INT PRIMARY KEY AUTO_INCREMENT,
  id_pedido INT,                                    -- ID do pedido (chave estrangeira)
  id_produto INT,                                   -- ID do produto (chave estrangeira)
  quantidade INT NOT NULL,                          -- Quantidade de produtos no pedido
  preco DECIMAL(10,2) NOT NULL,                     -- Preço de cada item do pedido
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Tabela 'pagamentos' para armazenar as informações de pagamento dos pedidos
CREATE TABLE pagamentos (
  id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
  id_pedido INT,                                    -- ID do pedido (chave estrangeira)
  data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data do pagamento
  valor DECIMAL(10,2) NOT NULL,                     -- Valor pago
  forma_pagamento ENUM('cartao', 'boleto', 'dinheiro') NOT NULL, -- Forma de pagamento
  status_pagamento ENUM('pendente', 'pago') DEFAULT 'pendente',  -- Status do pagamento
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

-- Inserção de dados de exemplo na tabela 'fornecedores'
INSERT INTO fornecedores (nome, cnpj, telefone, endereco, email) VALUES
('Fornecedor A', '12.345.678/0001-00', '123456789', 'Rua A, 123', 'fornecedorA@empresa.com'),
('Fornecedor B', '98.765.432/0001-00', '987654321', 'Rua B, 456', 'fornecedorB@empresa.com');

-- Inserção de dados de exemplo na tabela 'produtos'
INSERT INTO produtos (nome, descricao, preco, estoque, id_fornecedor) VALUES
('Produto X', 'Produto de exemplo A', 100.00, 50, 1),
('Produto Y', 'Produto de exemplo B', 200.00, 30, 2),
('Produto Z', 'Produto de exemplo C', 150.00, 20, 1);

-- Inserção de dados de exemplo na tabela 'pedidos'
INSERT INTO pedidos (id_cliente, STATUS) VALUES
(1, 'pendente'),
(2, 'confirmado');

-- Inserção de dados de exemplo na tabela 'itens_pedido'
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco) VALUES
(1, 1, 5, 100.00),
(1, 2, 2, 200.00),
(2, 3, 1, 150.00);

-- Inserção de dados de exemplo na tabela 'pagamentos'
INSERT INTO pagamentos (id_pedido, valor, forma_pagamento, status_pagamento) VALUES
(1, 700.00, 'cartao', 'pago'),
(2, 150.00, 'boleto', 'pendente');

-- Exemplo 1: Consultar todos os pedidos com seus respectivos status
SELECT p.id_pedido, p.data_pedido, p.status, c.nome AS cliente
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente;

-- Exemplo 2: Consultar todos os itens de um pedido específico
SELECT ip.id_item, pr.nome AS produto, ip.quantidade, ip.preco
FROM itens_pedido ip
INNER JOIN produtos pr ON ip.id_produto = pr.id_produto
WHERE ip.id_pedido = 1;

-- Exemplo 3: Consultar pagamentos pendentes
SELECT pa.id_pagamento, p.id_pedido, pa.valor, pa.forma_pagamento
FROM pagamentos pa
INNER JOIN pedidos p ON pa.id_pedido = p.id_pedido
WHERE pa.status_pagamento = 'pendente';

-- Exemplo 4: Consultar todos os produtos de um fornecedor
SELECT pr.nome, pr.preco, pr.estoque, pr.descricao
FROM produtos pr
INNER JOIN fornecedores f ON pr.id_fornecedor = f.id_fornecedor
WHERE f.nome = 'Fornecedor A';

-- Exemplo 5: Consultar todos os pedidos de um cliente
SELECT p.id_pedido, p.data_pedido, p.status
FROM pedidos p
WHERE p.id_cliente = 1;

-- Exemplo 6: Contar quantos produtos estão disponíveis por fornecedor
SELECT f.nome AS fornecedor, COUNT(pr.id_produto) AS total_produtos
FROM fornecedores f
INNER JOIN produtos pr ON f.id_fornecedor = pr.id_fornecedor
GROUP BY f.id_fornecedor;

-- Exemplo 7: Criar uma VIEW para exibir todos os pedidos confirmados com seus itens
CREATE VIEW pedidos_confirmados AS
SELECT p.id_pedido, p.data_pedido, p.status, pr.nome AS produto, ip.quantidade, ip.preco
FROM pedidos p
INNER JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN produtos pr ON ip.id_produto = pr.id_produto
WHERE p.status = 'confirmado';

-- Exemplo 8: Criar uma VIEW para exibir todos os pagamentos pendentes
CREATE VIEW pagamentos_pendentes AS
SELECT pa.id_pagamento, p.id_pedido, pa.valor, pa.forma_pagamento
FROM pagamentos pa
INNER JOIN pedidos p ON pa.id_pedido = p.id_pedido
WHERE pa.status_pagamento = 'pendente';

-- Exemplo 9: Criar uma VIEW para identificar os pedidos com o maior valor
CREATE VIEW pedidos_maior_valor AS
SELECT p.id_pedido, SUM(ip.quantidade * ip.preco) AS total_valor
FROM pedidos p
INNER JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido
HAVING total_valor > 1000;

-- Exemplo 10: Criar uma VIEW para mostrar os produtos com baixa quantidade de estoque
CREATE VIEW produtos_estoque_baixo AS
SELECT pr.nome, pr.estoque
FROM produtos pr
WHERE pr.estoque < 10;

-- Exemplo 11: Consultar pedidos confirmados através da VIEW criada
SELECT * FROM pedidos_confirmados;

-- Exemplo 12: Consultar pagamentos pendentes através da VIEW criada
SELECT * FROM pagamentos_pendentes;

-- Exemplo 13: Consultar pedidos com maior valor através da VIEW criada
SELECT * FROM pedidos_maior_valor;

-- Exemplo 14: Consultar produtos com estoque baixo através da VIEW criada
SELECT * FROM produtos_estoque_baixo;
