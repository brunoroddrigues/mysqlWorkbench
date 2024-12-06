-- Criação do banco de dados 'universidade'
CREATE DATABASE universidade;
USE universidade;

-- Criação da tabela 'estudantes' para armazenar informações sobre os estudantes
CREATE TABLE estudantes (
  id_estudante INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do estudante
  nome VARCHAR(100) NOT NULL,                     -- Nome do estudante
  data_nascimento DATE,                           -- Data de nascimento do estudante
  endereco VARCHAR(255),                          -- Endereço do estudante
  telefone VARCHAR(15)                            -- Telefone do estudante
);

-- Criação da tabela 'professores' para armazenar informações sobre os professores
CREATE TABLE professores (
  id_professor INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do professor
  nome VARCHAR(100) NOT NULL,                     -- Nome do professor
  departamento VARCHAR(100)                      -- Departamento em que o professor leciona
);

-- Criação da tabela 'cursos' para armazenar informações sobre os cursos oferecidos
CREATE TABLE cursos (
  id_curso INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do curso
  nome VARCHAR(100) NOT NULL,                  -- Nome do curso (Ex: Ciências da Computação)
  duracao INT                                  -- Duração do curso em anos
);

-- Criação da tabela 'disciplinas' para armazenar as disciplinas oferecidas
CREATE TABLE disciplinas (
  id_disciplina INT PRIMARY KEY AUTO_INCREMENT,  -- ID único da disciplina
  nome VARCHAR(100) NOT NULL,                     -- Nome da disciplina (Ex: Programação, Banco de Dados)
  id_curso INT,                                  -- ID do curso (chave estrangeira)
  id_professor INT,                               -- ID do professor que leciona a disciplina (chave estrangeira)
  FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),  -- Chave estrangeira para a tabela 'cursos'
  FOREIGN KEY (id_professor) REFERENCES professores(id_professor)  -- Chave estrangeira para a tabela 'professores'
);

-- Criação da tabela 'matriculas' para armazenar as matrículas dos estudantes nas disciplinas
CREATE TABLE matriculas (
  id_matricula INT PRIMARY KEY AUTO_INCREMENT,   -- ID único da matrícula
  id_estudante INT,                              -- ID do estudante (chave estrangeira)
  id_disciplina INT,                             -- ID da disciplina (chave estrangeira)
  ano_letivo INT,                                -- Ano letivo da matrícula
  FOREIGN KEY (id_estudante) REFERENCES estudantes(id_estudante),  -- Chave estrangeira para a tabela 'estudantes'
  FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina)  -- Chave estrangeira para a tabela 'disciplinas'
);

-- Inserção de dados de exemplo na tabela 'estudantes'
INSERT INTO estudantes (nome, data_nascimento, endereco, telefone) VALUES
('Ana Santos', '2000-05-15', 'Rua das Flores, 10', '987654321'),
('Carlos Almeida', '1999-11-22', 'Avenida Central, 200', '912345678'),
('Mariana Costa', '2001-08-30', 'Rua Nova, 50', '934567890');

-- Inserção de dados de exemplo na tabela 'professores'
INSERT INTO professores (nome, departamento) VALUES
('João Silva', 'Computação'),
('Maria Oliveira', 'Matemática'),
('Pedro Souza', 'Física');

-- Inserção de dados de exemplo na tabela 'cursos'
INSERT INTO cursos (nome, duracao) VALUES
('Ciências da Computação', 4),
('Engenharia de Produção', 5),
('Física', 4);

-- Inserção de dados de exemplo na tabela 'disciplinas'
INSERT INTO disciplinas (nome, id_curso, id_professor) VALUES
('Programação', 1, 1),
('Álgebra Linear', 2, 2),
('Física Geral', 3, 3),
('Estruturas de Dados', 1, 1);

-- Inserção de dados de exemplo na tabela 'matriculas'
INSERT INTO matriculas (id_estudante, id_disciplina, ano_letivo) VALUES
(1, 1, 2023),
(2, 2, 2023),
(3, 3, 2023),
(1, 4, 2023);

-- Exemplo 1: Listar todos os estudantes e os cursos em que estão matriculados
SELECT e.nome AS estudante, c.nome AS curso
FROM estudantes e
JOIN matriculas m ON e.id_estudante = m.id_estudante
JOIN disciplinas d ON m.id_disciplina = d.id_disciplina
JOIN cursos c ON d.id_curso = c.id_curso;

-- Exemplo 2: Listar todas as disciplinas de um curso específico
SELECT d.nome AS disciplina
FROM disciplinas d
JOIN cursos c ON d.id_curso = c.id_curso
WHERE c.nome = 'Ciências da Computação';

-- Exemplo 3: Consultar os professores que lecionam disciplinas de um curso específico
SELECT p.nome AS professor
FROM professores p
JOIN disciplinas d ON p.id_professor = d.id_professor
JOIN cursos c ON d.id_curso = c.id_curso
WHERE c.nome = 'Ciências da Computação';

-- Exemplo 4: Contagem de estudantes matriculados em cada curso
SELECT c.nome AS curso, COUNT(m.id_estudante) AS total_estudantes
FROM cursos c
LEFT JOIN disciplinas d ON c.id_curso = d.id_curso
LEFT JOIN matriculas m ON d.id_disciplina = m.id_disciplina
GROUP BY c.id_curso;

-- Exemplo 5: Contar quantas matrículas existem por ano letivo
SELECT ano_letivo, COUNT(id_matricula) AS total_matriculas
FROM matriculas
GROUP BY ano_letivo;

-- Exemplo 6: Listar as disciplinas que têm mais de 1 professor
SELECT d.nome AS disciplina, COUNT(DISTINCT d.id_professor) AS total_professores
FROM disciplinas d
GROUP BY d.id_disciplina
HAVING COUNT(DISTINCT d.id_professor) > 1;

-- Exemplo 7: Criar uma VIEW para listar os cursos e as respectivas disciplinas
CREATE VIEW cursos_disciplinas AS
SELECT c.nome AS curso, d.nome AS disciplina
FROM cursos c
JOIN disciplinas d ON c.id_curso = d.id_curso;

-- Exemplo 8: Mostrar todos os estudantes que estão matriculados em mais de 1 disciplina
SELECT e.nome AS estudante
FROM estudantes e
JOIN matriculas m ON e.id_estudante = m.id_estudante
GROUP BY e.id_estudante
HAVING COUNT(m.id_disciplina) > 1;

-- Exemplo 9: Listar os estudantes que estão matriculados em cursos com duração superior a 4 anos
SELECT e.nome AS estudante
FROM estudantes e
JOIN matriculas m ON e.id_estudante = m.id_estudante
JOIN disciplinas d ON m.id_disciplina = d.id_disciplina
JOIN cursos c ON d.id_curso = c.id_curso
WHERE c.duracao > 4;

-- Exemplo 10: Contar o número de matrículas feitas em cada ano letivo
SELECT ano_letivo, COUNT(id_matricula) AS total_matriculas
FROM matriculas
GROUP BY ano_letivo;

-- View criada para contar o número de estudantes matriculados por curso
CREATE VIEW contagem_estudantes_por_curso AS
SELECT c.nome AS curso, COUNT(m.id_estudante) AS total_estudantes
FROM cursos c
LEFT JOIN disciplinas d ON c.id_curso = d.id_curso
LEFT JOIN matriculas m ON d.id_disciplina = m.id_disciplina
GROUP BY c.id_curso;

-- View criada para mostrar os professores e suas respectivas disciplinas
CREATE VIEW professores_disciplinas AS
SELECT p.nome AS professor, d.nome AS disciplina
FROM professores p
JOIN disciplinas d ON p.id_professor = d.id_professor;

-- View criada para listar os cursos e suas durações
CREATE VIEW cursos_duracao AS
SELECT nome, duracao
FROM cursos;

-- View criada para exibir todos os estudantes e as disciplinas em que estão matriculados
CREATE VIEW estudantes_disciplinas AS
SELECT e.nome AS estudante, d.nome AS disciplina
FROM estudantes e
JOIN matriculas m ON e.id_estudante = m.id_estudante
JOIN disciplinas d ON m.id_disciplina = d.id_disciplina;
