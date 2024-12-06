-- Criação do Banco de Dados 'sistema_cursos'
CREATE DATABASE sistema_cursos;
USE sistema_cursos;

-- Criação das Tabelas
CREATE TABLE alunos (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada aluno
    nome VARCHAR(100) NOT NULL,         -- Nome do aluno
    email VARCHAR(100) UNIQUE NOT NULL, -- E-mail do aluno
    telefone VARCHAR(15)               -- Telefone do aluno
);

CREATE TABLE cursos (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada curso
    nome VARCHAR(100) NOT NULL,         -- Nome do curso
    descricao TEXT                     -- Descrição do curso
);

CREATE TABLE matriculas (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada matrícula
    id_aluno INT,                       -- ID do aluno, referência à tabela alunos
    id_curso INT,                       -- ID do curso, referência à tabela cursos
    data_matricula DATE,                -- Data da matrícula
    FOREIGN KEY (id_aluno) REFERENCES alunos(id), -- Relacionamento com a tabela alunos
    FOREIGN KEY (id_curso) REFERENCES cursos(id)  -- Relacionamento com a tabela cursos
);

CREATE TABLE notas (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada nota
    id_matricula INT,                   -- ID da matrícula, referência à tabela matriculas
    nota DECIMAL(5, 2),                  -- Nota do aluno
    FOREIGN KEY (id_matricula) REFERENCES matriculas(id)  -- Relacionamento com a tabela matriculas
);

-- Inserção de Alunos
INSERT INTO alunos (nome, email, telefone) VALUES 
('Lucas Silva', 'lucas.silva@email.com', '11987654321'),
('Fernanda Oliveira', 'fernanda.oliveira@email.com', '11999887766'),
('Marcos Souza', 'marcos.souza@email.com', '11888776655');

-- Inserção de Cursos
INSERT INTO cursos (nome, descricao) VALUES 
('Matemática para Iniciantes', 'Curso básico de matemática para iniciantes, abordando álgebra e geometria.'),
('Programação em Python', 'Curso de introdução à programação usando Python, com foco em lógica de programação e algoritmos.'),
('Marketing Digital', 'Curso sobre estratégias de marketing digital, incluindo SEO, redes sociais e e-mail marketing.');

-- Inserção de Matrículas
INSERT INTO matriculas (id_aluno, id_curso, data_matricula) VALUES 
(1, 1, '2024-08-10'), 
(1, 2, '2024-08-11'), 
(2, 3, '2024-08-12'),
(3, 1, '2024-08-10');

-- Inserção de Notas
INSERT INTO notas (id_matricula, nota) VALUES 
(1, 8.5),    -- Nota para matrícula 1
(2, 9.0),    -- Nota para matrícula 2
(3, 7.0);    -- Nota para matrícula 3

-- Exemplo 1: Consulta de Alunos Matriculados em um Curso
-- Exibe os alunos matriculados no curso 'Programação em Python'.
SELECT a.nome AS nome_aluno, a.email, m.data_matricula
FROM matriculas m
INNER JOIN alunos a ON m.id_aluno = a.id
INNER JOIN cursos c ON m.id_curso = c.id
WHERE c.nome = 'Programação em Python';

-- Exemplo 2: Consulta de Cursos com Alunos e suas Notas
-- Exibe os cursos, alunos e suas respectivas notas.
SELECT c.nome AS nome_curso, a.nome AS nome_aluno, n.nota
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id
INNER JOIN alunos a ON m.id_aluno = a.id
INNER JOIN cursos c ON m.id_curso = c.id;

-- Exemplo 3: Consulta de Notas dos Alunos
-- Exibe a nota de todos os alunos, incluindo o nome do aluno, nome do curso e a nota.
SELECT a.nome AS nome_aluno, c.nome AS nome_curso, n.nota
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id
INNER JOIN alunos a ON m.id_aluno = a.id
INNER JOIN cursos c ON m.id_curso = c.id;

-- Exemplo 4: Consulta de Alunos que Obtiveram Nota Acima de 8
-- Exibe os alunos que tiraram nota maior que 8 nos cursos em que estão matriculados.
SELECT a.nome AS nome_aluno, c.nome AS nome_curso, n.nota
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id
INNER JOIN alunos a ON m.id_aluno = a.id
INNER JOIN cursos c ON m.id_curso = c.id
WHERE n.nota > 8;

-- Exemplo 5: Consulta de Matrículas de um Aluno
-- Exibe todos os cursos nos quais o aluno com ID 1 está matriculado.
SELECT c.nome AS nome_curso, m.data_matricula
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id
WHERE m.id_aluno = 1;

-- Exemplo 6: Atualização da Nota de um Aluno
-- Atualiza a nota de um aluno para 10 no curso de 'Programação em Python'.
UPDATE notas n
INNER JOIN matriculas m ON n.id_matricula = m.id
SET n.nota = 10
WHERE m.id_aluno = 1 AND m.id_curso = 2;

-- Exemplo 7: Consulta de Cursos e a Quantidade de Alunos Matriculados
-- Exibe os cursos e a quantidade de alunos matriculados em cada um.
SELECT c.nome AS nome_curso, COUNT(m.id_aluno) AS quantidade_alunos
FROM matriculas m
INNER JOIN cursos c ON m.id_curso = c.id
GROUP BY c.id;

-- Exemplo 8: Consulta de Alunos que Não Têm Notas
-- Exibe os alunos que não possuem notas registradas.
SELECT a.nome AS nome_aluno
FROM alunos a
LEFT JOIN matriculas m ON a.id = m.id_aluno
LEFT JOIN notas n ON m.id = n.id_matricula
WHERE n.nota IS NULL;

-- Exemplo 9: Consulta de Média de Notas por Aluno
-- Exibe a média das notas de cada aluno nos cursos nos quais estão matriculados.
SELECT a.nome AS nome_aluno, AVG(n.nota) AS media_notas
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id
INNER JOIN alunos a ON m.id_aluno = a.id
GROUP BY a.id;

-- Exemplo 10: Criação de uma View para Matrículas com Notas
-- Cria uma visualização com as matrículas de alunos, cursos e suas notas.
CREATE VIEW vw_matriculas_com_notas AS
SELECT a.nome AS nome_aluno, c.nome AS nome_curso, m.data_matricula, n.nota
FROM matriculas m
INNER JOIN alunos a ON m.id_aluno = a.id
INNER JOIN cursos c ON m.id_curso = c.id
LEFT JOIN notas n ON m.id = n.id_matricula;
