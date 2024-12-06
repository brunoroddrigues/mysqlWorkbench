-- Criação do banco de dados 'cinema'
CREATE DATABASE cinema;
USE cinema;

-- Criação da tabela 'atores' para armazenar informações sobre os atores
CREATE TABLE atores (
  id_ator INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do ator
  nome VARCHAR(100) NOT NULL,                -- Nome do ator
  nacionalidade VARCHAR(50),                 -- Nacionalidade do ator
  data_nascimento DATE                       -- Data de nascimento
);

-- Criação da tabela 'categorias' para armazenar as categorias dos filmes
CREATE TABLE categorias (
  id_categoria INT PRIMARY KEY AUTO_INCREMENT,   -- ID único da categoria
  nome VARCHAR(50) NOT NULL                     -- Nome da categoria (Ex: Drama, Ação, Comédia)
);

-- Criação da tabela 'filmes' para armazenar informações sobre os filmes
CREATE TABLE filmes (
  id_filme INT PRIMARY KEY AUTO_INCREMENT,    -- ID único do filme
  titulo VARCHAR(100) NOT NULL,                -- Título do filme
  id_categoria INT,                            -- ID da categoria do filme (chave estrangeira)
  id_ator INT,                                 -- ID do ator principal (chave estrangeira)
  ano_lancamento INT,                         -- Ano de lançamento
  quantidade INT,                              -- Quantidade de exemplares disponíveis para empréstimo
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),  -- Chave estrangeira para a tabela 'categorias'
  FOREIGN KEY (id_ator) REFERENCES atores(id_ator)                   -- Chave estrangeira para a tabela 'atores'
);

-- Criação da tabela 'clientes' para armazenar informações sobre os clientes
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,  -- ID único do cliente
  nome VARCHAR(100) NOT NULL,                 -- Nome do cliente
  endereco VARCHAR(255),                      -- Endereço do cliente
  telefone VARCHAR(15)                        -- Telefone do cliente
);

-- Criação da tabela 'emprestimos' para armazenar os empréstimos de filmes
CREATE TABLE emprestimos (
  id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,  -- ID único do empréstimo
  id_filme INT,                                 -- ID do filme emprestado (chave estrangeira)
  id_cliente INT,                               -- ID do cliente (chave estrangeira)
  data_emprestimo DATE,                         -- Data do empréstimo
  data_devolucao DATE,                         -- Data de devolução
  FOREIGN KEY (id_filme) REFERENCES filmes(id_filme),  -- Chave estrangeira para a tabela 'filmes'
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)  -- Chave estrangeira para a tabela 'clientes'
);

-- Inserção de dados de exemplo na tabela 'atores'
INSERT INTO atores (nome, nacionalidade, data_nascimento) VALUES
('Leonardo DiCaprio', 'Americana', '1974-11-11'),
('Meryl Streep', 'Americana', '1949-06-22'),
('Morgan Freeman', 'Americana', '1937-06-01'),
('Scarlett Johansson', 'Americana', '1984-11-22');

-- Inserção de dados de exemplo na tabela 'categorias'
INSERT INTO categorias (nome) VALUES
('Drama'),
('Ação'),
('Comédia'),
('Suspense');

-- Inserção de dados de exemplo na tabela 'filmes'
INSERT INTO filmes (titulo, id_categoria, id_ator, ano_lancamento, quantidade) VALUES
('Titanic', 1, 1, 1997, 5),
('The Avengers', 2, 4, 2012, 10),
('The Shawshank Redemption', 1, 3, 1994, 3),
('Scarlett Johansson: The Black Widow', 2, 4, 2021, 8);

-- Inserção de dados de exemplo na tabela 'clientes'
INSERT INTO clientes (nome, endereco, telefone) VALUES
('Carlos Silva', 'Rua das Palmeiras, 45', '999888777'),
('Juliana Oliveira', 'Av. Brasil, 1350', '888777666'),
('Roberta Lima', 'Rua do Sol, 89', '777666555');

-- Inserção de dados de exemplo na tabela 'emprestimos'
INSERT INTO emprestimos (id_filme, id_cliente, data_emprestimo, data_devolucao) VALUES
(1, 1, '2024-10-01', NULL),  -- Empréstimo de "Titanic"
(2, 2, '2024-10-02', '2024-10-10'),  -- Empréstimo de "The Avengers"
(3, 3, '2024-10-05', NULL),  -- Empréstimo de "The Shawshank Redemption"
(4, 1, '2024-10-06', NULL);  -- Empréstimo de "Scarlett Johansson: The Black Widow"

-- Exemplo 1: Listar todos os filmes e seus respectivos atores
SELECT f.titulo AS filme, a.nome AS ator
FROM filmes f
INNER JOIN atores a ON f.id_ator = a.id_ator;

-- Exemplo 2: Listar todos os filmes disponíveis (com quantidade > 0)
SELECT titulo
FROM filmes
WHERE quantidade > 0;

-- Exemplo 3: Consultar empréstimos ativos (não devolvidos)
SELECT e.id_emprestimo, f.titulo AS filme, c.nome AS cliente, e.data_emprestimo
FROM emprestimos e
INNER JOIN filmes f ON e.id_filme = f.id_filme
INNER JOIN clientes c ON e.id_cliente = c.id_cliente
WHERE e.data_devolucao IS NULL;

-- Exemplo 4: Contagem de filmes por categoria
SELECT c.nome AS categoria, COUNT(f.id_filme) AS total_filmes
FROM filmes f
INNER JOIN categorias c ON f.id_categoria = c.id_categoria
GROUP BY c.id_categoria;

-- Exemplo 5: Contar quantos filmes estão disponíveis (quantidade total de exemplares)
SELECT SUM(quantidade) AS total_exemplares
FROM filmes;

-- Exemplo 6: Listar os empréstimos ainda não devolvidos, incluindo o nome do filme e do cliente
SELECT f.titulo AS filme, c.nome AS cliente, e.data_emprestimo
FROM emprestimos e
INNER JOIN filmes f ON e.id_filme = f.id_filme
INNER JOIN clientes c ON e.id_cliente = c.id_cliente
WHERE e.data_devolucao IS NULL;

-- Exemplo 7: Criar uma VIEW para identificar os atores que têm mais de 1 filme cadastrado
CREATE VIEW atores_com_mais_de_um_filme AS
SELECT a.nome AS ator, COUNT(f.id_filme) AS total_filmes
FROM filmes f
INNER JOIN atores a ON f.id_ator = a.id_ator
GROUP BY a.id_ator
HAVING COUNT(f.id_filme) > 1;

-- Exemplo 8: Mostrar os filmes lançados após o ano de 2000 com mais de 5 exemplares disponíveis
SELECT titulo
FROM filmes
WHERE ano_lancamento > 2000 AND quantidade > 5;

-- Exemplo 9: Listar os clientes que emprestaram filmes de atores americanos (Usar DISTINCT)
SELECT DISTINCT c.nome AS cliente
FROM emprestimos e
INNER JOIN filmes f ON e.id_filme = f.id_filme
INNER JOIN atores a ON f.id_ator = a.id_ator
INNER JOIN clientes c ON e.id_cliente = c.id_cliente
WHERE a.nacionalidade = 'Americana';

-- Exemplo 10: Contar o número de empréstimos feitos em cada mês (Usar MONTH() para extrair o mês de data_emprestimo)
SELECT MONTH(data_emprestimo) AS mes, COUNT(id_emprestimo) AS total_emprestimos
FROM emprestimos
GROUP BY MONTH(data_emprestimo);
