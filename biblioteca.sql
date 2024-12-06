CREATE DATABASE biblioteca;
USE biblioteca;


CREATE TABLE autores (
 id INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(100) NOT NULL,
 nacionalidade VARCHAR(50)
);

CREATE TABLE livros (
 id INT PRIMARY KEY AUTO_INCREMENT,
 titulo VARCHAR(200) NOT NULL,
 autor_id INT,
 ano_publicacao INT,
 quantidade_disponivel INT DEFAULT 0,
 FOREIGN KEY (autor_id) REFERENCES autores(id)
);

CREATE TABLE emprestimos (
 id INT PRIMARY KEY AUTO_INCREMENT,
 livro_id INT,
 nome_leitor VARCHAR(100),
 data_emprestimo DATE,
 data_devolucao DATE,
 devolvido BOOLEAN DEFAULT FALSE, 
 FOREIGN KEY (livro_id) REFERENCES livros(id) 
);



INSERT INTO autores (nome, nacionalidade) VALUES 
('Machado de Assis', 'Brasileira'), 
('José Saramago', 'Portuguesa'), 
('George Orwell', 'Britânica'), 
('Graciliano Ramos', 'Brasileira'), 
('J.K. Rowling', 'Britânica'), 
('George Orwell', 'Britânica'), 
('Gabriel García Márquez', 'Colombiana'), 
('Clarice Lispector', 'Brasileira'), 
('J.R.R. Tolkien', 'Britânica'), 
('Franz Kafka', 'Tcheca'), 
('Fiódor Dostoiévski', 'Russa'), 
('Jane Austen', 'Britânica'), 
('Haruki Murakami', 'Japonesa'); 


INSERT INTO livros (titulo, autor_id, ano_publicacao, quantidade_disponivel) VALUES 
('Dom Casmurro', 1, 1899, 5), 
('O Alienista', 1, 1882, 5), 
('Ensaio sobre a Cegueira', 2, 1995, 3), 
('O Evangelho segundo Jesus', 2, 1991, 3), 
('1984', 3, 1949, 4), 
('Por que Escrevo', 3, 1946, 4), 
('Vidas Secas', 4, 1938, 10), 
('Harry Potter e a Pedra Filosofal', 2, 1997, 7), 
('1984', 3, 1949, 4), 
('Cem Anos de Solidão', 4, 1967, 6),
('A Hora da Estrela', 5, 1977, 3), 
('O Senhor dos Anéis', 6, 1954, 10), 
('A Metamorfose', 7, 1915, 8), 
('Crime e Castigo', 8, 1866, 2), 
('Orgulho e Preconceito', 9, 1813, 9), 
('Kafka à Beira-Mar', 10, 2002, 5); 


INSERT INTO emprestimos (livro_id, nome_leitor, data_emprestimo, data_devolucao, devolvido) 
VALUES 
(1, 'João Silva', '2024-11-01', '2024-11-15', TRUE), 
(2, 'Maria Oliveira', '2024-11-02', '2024-11-16', FALSE), 
(3, 'Carlos Santos', '2024-11-03', '2024-11-17', FALSE), 
(4, 'Ana Lima', '2024-11-04', '2024-11-18', TRUE), 
(5, 'Paulo Rocha', '2024-11-05', '2024-11-19', TRUE), 
(6, 'Clara Souza', '2024-11-06', '2024-11-20', FALSE), 
(7, 'Pedro Almeida', '2024-11-07', '2024-11-21', TRUE), 
(8, 'Fernanda Costa', '2024-11-08', '2024-11-22', FALSE), 
(9, 'Lucas Martins', '2024-11-09', '2024-11-23', TRUE), 
(10, 'Julia Pereira', '2024-11-10', '2024-11-24', FALSE), 
(11, 'Sergio', '2024-01-12', '2024-11-17', FALSE), 
(12, 'Rildo', '2024-10-10', CURDATE(), FALSE); 
 
 
 -- ex 1 --
 SELECT  l.titulo AS nome_livro,  a.nome AS nome_autor
FROM livros l
INNER JOIN autores a ON l.autor_id = a.id;
    
    
 -- ex 2 --
 SELECT titulo, quantidade_disponivel
FROM livros
WHERE quantidade_disponivel > 0;
    
    
-- ex 3 --
SELECT e.id, l.titulo AS nome_livro, e.nome_leitor, e.data_emprestimo, e.data_devolucao
FROM emprestimos e
INNER JOIN livros l ON e.livro_id = l.id
WHERE e.devolvido = FALSE;
    

-- ex 4 --
SELECT a.nacionalidade, COUNT(l.id) AS total_livros
FROM livros l
INNER JOIN autores a ON l.autor_id = a.id
GROUP BY a.nacionalidade;
    
    
-- ex 5 --
SELECT SUM(quantidade_disponivel) AS total_exemplares_disponiveis
FROM livros;
    
    
-- ex 6 --
SELECT e.id, l.titulo AS nome_livro, e.nome_leitor, e.data_emprestimo, e.data_devolucao
FROM emprestimos e 
INNER JOIN livros l ON e.livro_id = l.id
WHERE e.devolvido = FALSE;


-- EX 7 --
CREATE VIEW vw_autores_com_mais_de_um_livro AS
SELECT a.nome AS nome_autor, COUNT(l.id) AS total_livros
FROM autores a
INNER JOIN livros l ON a.id = l.autor_id
GROUP BY a.id
HAVING COUNT(l.id) > 1;




-- 8 -- 
SELECT titulo, ano_publicacao, quantidade_disponivel
FROM livros
WHERE ano_publicacao > 1990 AND quantidade_disponivel > 1;



-- 9 -- 
SELECT DISTINCT e.nome_leitor
FROM emprestimos e
INNER JOIN livros l ON e.livro_id = l.id
INNER JOIN autores a ON l.autor_id = a.id
WHERE a.nacionalidade = 'Brasileira';

-- 10 --
SELECT MONTH(data_emprestimo) AS mes, COUNT(id) AS total_emprestimos  
FROM emprestimos  
GROUP BY MONTH(data_emprestimo)  
ORDER BY mes; 


-- 11 -- 
SELECT l.titulo AS nome_livro, e.data_emprestimo
FROM emprestimos e
INNER JOIN livros l ON e.livro_id = l.id
WHERE e.devolvido = TRUE;
    
    
-- 12 -- 
CREATE VIEW vw_livros_nunca_emprestados AS
SELECT l.id, l.titulo
FROM livros l
WHERE l.id NOT IN (SELECT DISTINCT livro_id FROM emprestimos);
    
    
-- 13 --
SELECT a.nome AS nome_autor, COUNT(e.id) AS total_emprestimos
FROM emprestimos e
INNER JOIN livros l ON e.livro_id = l.id 
INNER JOIN autores a ON l.autor_id = a.id 
GROUP BY a.id
ORDER BY total_emprestimos DESC
LIMIT 1;




-- 14 --
SELECT AVG(DATEDIFF(e.data_devolucao, e.data_emprestimo)) AS tempo_medio_devolucao
FROM emprestimos e
WHERE e.devolvido = TRUE;





 
