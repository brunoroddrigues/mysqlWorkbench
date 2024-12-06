-- Criação do banco de dados 'escola'
CREATE DATABASE escola;
USE escola;

-- Criação da tabela 'alunos' para armazenar informações dos alunos
CREATE TABLE alunos (
  id_aluno INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do aluno
  nome VARCHAR(100) NOT NULL,                 -- Nome do aluno
  data_nascimento DATE,                       -- Data de nascimento do aluno
  endereco VARCHAR(255),                      -- Endereço do aluno
  telefone VARCHAR(15)                        -- Telefone do aluno
);

-- Criação da tabela 'professores' para armazenar informações dos professores
CREATE TABLE professores (
  id_professor INT PRIMARY KEY AUTO_INCREMENT, -- ID único do professor
  nome VARCHAR(100) NOT NULL,                   -- Nome do professor
  especialidade VARCHAR(100),                   -- Área de especialidade do professor (ex: Matemática, História)
  salario DECIMAL(10, 2),                       -- Salário do professor
  data_admissao DATE                            -- Data de admissão
);

-- Criação da tabela 'disciplinas' para armazenar as disciplinas da escola
CREATE TABLE disciplinas (
  id_disciplina INT PRIMARY KEY AUTO_INCREMENT, -- ID único da disciplina
  nome VARCHAR(100) NOT NULL,                    -- Nome da disciplina
  carga_horaria INT,                             -- Carga horária da disciplina
  id_professor INT,                              -- ID do professor responsável pela disciplina (chave estrangeira)
  FOREIGN KEY (id_professor) REFERENCES professores(id_professor) -- Chave estrangeira para a tabela 'professores'
);

-- Criação da tabela 'matriculas' para armazenar as matrículas dos alunos nas disciplinas
CREATE TABLE matriculas (
  id_matricula INT PRIMARY KEY AUTO_INCREMENT,    -- ID único da matrícula
  id_aluno INT,                                   -- ID do aluno (chave estrangeira)
  id_disciplina INT,                              -- ID da disciplina (chave estrangeira)
  data_matricula DATE,                            -- Data da matrícula
  FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),       -- Chave estrangeira para a tabela 'alunos'
  FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina) -- Chave estrangeira para a tabela 'disciplinas'
);

-- Criação da tabela 'notas' para armazenar as notas dos alunos nas disciplinas
CREATE TABLE notas (
  id_nota INT PRIMARY KEY AUTO_INCREMENT,     -- ID único da nota
  id_matricula INT,                            -- ID da matrícula (chave estrangeira)
  nota DECIMAL(5, 2),                          -- Nota do aluno (valor entre 0 e 10)
  FOREIGN KEY (id_matricula) REFERENCES matriculas(id_matricula) -- Chave estrangeira para a tabela 'matriculas'
);

-- Inserção de dados de exemplo na tabela 'alunos'
INSERT INTO alunos (nome, data_nascimento, endereco, telefone) VALUES
('Ana Souza', '2005-05-14', 'Rua das Flores, 78', '1112233445'),
('Carlos Pereira', '2004-08-30', 'Av. Central, 234', '3322114455'),
('Mariana Costa', '2006-12-22', 'Rua dos Lirios, 432', '4433225566');

-- Inserção de dados de exemplo na tabela 'professores'
INSERT INTO professores (nome, especialidade, salario, data_admissao) VALUES
('Roberto Silva', 'Matemática', 3000.00, '2015-02-20'),
('Fernanda Alves', 'História', 2800.00, '2016-08-10'),
('Paulo Santos', 'Biologia', 3200.00, '2017-06-15');

-- Inserção de dados de exemplo na tabela 'disciplinas'
INSERT INTO disciplinas (nome, carga_horaria, id_professor) VALUES
('Matemática 1', 60, 1),
('História 1', 45, 2),
('Biologia 1', 50, 3),
('Matemática 2', 60, 1),
('História 2', 45, 2);

-- Inserção de dados de exemplo na tabela 'matriculas'
INSERT INTO matriculas (id_aluno, id_disciplina, data_matricula) VALUES
(1, 1, '2024-03-15'),
(1, 2, '2024-03-16'),
(2, 1, '2024-03-17'),
(2, 3, '2024-03-18'),
(3, 2, '2024-03-19'),
(3, 3, '2024-03-20');

-- Inserção de dados de exemplo na tabela 'notas'
INSERT INTO notas (id_matricula, nota) VALUES
(1, 8.5),
(2, 7.0),
(3, 9.0),
(4, 6.5),
(5, 7.5),
(6, 8.0);

-- Exemplo 1: Consultar a lista de alunos e suas respectivas disciplinas
SELECT a.nome AS nome_aluno, d.nome AS nome_disciplina
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN disciplinas d ON m.id_disciplina = d.id_disciplina;

-- Exemplo 2: Consultar todos os professores e suas especialidades
SELECT nome, especialidade
FROM professores;

-- Exemplo 3: Consultar as notas dos alunos em uma disciplina específica
SELECT a.nome AS nome_aluno, n.nota
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id_matricula
INNER JOIN alunos a ON m.id_aluno = a.id_aluno
WHERE m.id_disciplina = 1;  -- Disciplina de Matemática 1

-- Exemplo 4: Consultar a média das notas dos alunos em cada disciplina
SELECT d.nome AS nome_disciplina, AVG(n.nota) AS media_notas
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id_matricula
INNER JOIN disciplinas d ON m.id_disciplina = d.id_disciplina
GROUP BY d.id_disciplina;

-- Exemplo 5: Consultar o total de alunos matriculados por disciplina
SELECT d.nome AS nome_disciplina, COUNT(m.id_matricula) AS total_alunos
FROM disciplinas d
INNER JOIN matriculas m ON d.id_disciplina = m.id_disciplina
GROUP BY d.id_disciplina;

-- Exemplo 6: Consultar os professores que possuem mais de uma disciplina
SELECT p.nome AS nome_professor, COUNT(d.id_disciplina) AS total_disciplinas
FROM professores p
INNER JOIN disciplinas d ON p.id_professor = d.id_professor
GROUP BY p.id_professor
HAVING COUNT(d.id_disciplina) > 1;

-- Exemplo 7: Consultar os alunos que possuem nota maior que 8.0 em qualquer disciplina
SELECT a.nome AS nome_aluno, n.nota
FROM notas n
INNER JOIN matriculas m ON n.id_matricula = m.id_matricula
INNER JOIN alunos a ON m.id_aluno = a.id_aluno
WHERE n.nota > 8.0;

-- Exemplo 8: Consultar a quantidade de matrículas feitas por aluno
SELECT a.nome AS nome_aluno, COUNT(m.id_matricula) AS total_matriculas
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
GROUP BY a.id_aluno;

-- Exemplo 9: Consultar a lista de alunos e suas notas nas disciplinas de História
SELECT a.nome AS nome_aluno, n.nota
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN notas n ON m.id_matricula = n.id_matricula
WHERE m.id_disciplina = 2; -- Disciplina de História 1

-- Exemplo 10: Consultar o aluno com a maior média de notas
SELECT a.nome AS nome_aluno, AVG(n.nota) AS media_notas
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY a.id_aluno
ORDER BY media_notas DESC
LIMIT 1;

-- Criando uma VIEW para mostrar a lista de alunos e suas disciplinas
CREATE VIEW alunos_disciplinas AS
SELECT a.nome AS nome_aluno, d.nome AS nome_disciplina
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN disciplinas d ON m.id_disciplina = d.id_disciplina;

-- Criando uma VIEW para mostrar os alunos e suas notas em cada disciplina
CREATE VIEW alunos_notas AS
SELECT a.nome AS nome_aluno, d.nome AS nome_disciplina, n.nota
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN notas n ON m.id_matricula = n.id_matricula
INNER JOIN disciplinas d ON m.id_disciplina = d.id_disciplina;

-- Criando uma VIEW para consultar a média de notas por aluno
CREATE VIEW media_notas_alunos AS
SELECT a.nome AS nome_aluno, AVG(n.nota) AS media_notas
FROM alunos a
INNER JOIN matriculas m ON a.id_aluno = m.id_aluno
INNER JOIN notas n ON m.id_matricula = n.id_matricula
GROUP BY a.id_aluno;

-- Exemplo de consulta usando a VIEW 'alunos_disciplinas'
SELECT * FROM alunos_disciplinas;

-- Exemplo de consulta usando a VIEW 'alunos_notas'
SELECT * FROM alunos_notas;

-- Exemplo de consulta usando a VIEW 'media_notas_alunos'
SELECT * FROM media_notas_alunos;
