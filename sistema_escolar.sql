-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE sistema_escolar;
USE sistema_escolar;

-- TABELAS

-- 1. Tabela de Alunos
-- Contém os dados dos alunos matriculados no sistema
CREATE TABLE alunos (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do aluno
  nome VARCHAR(100) NOT NULL, -- Nome completo do aluno
  data_nascimento DATE NOT NULL, -- Data de nascimento do aluno
  email VARCHAR(100), -- Email do aluno (opcional)
  telefone VARCHAR(15) -- Telefone do aluno (opcional)
);

-- 2. Tabela de Cursos
-- Contém os dados dos cursos oferecidos pela instituição
CREATE TABLE cursos (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do curso
  nome VARCHAR(100) NOT NULL, -- Nome do curso
  descricao TEXT, -- Descrição detalhada do curso
  carga_horaria INT NOT NULL -- Carga horária do curso em horas
);

-- 3. Tabela de Matrículas
-- Relaciona os alunos com os cursos em que estão matriculados
CREATE TABLE matriculas (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único da matrícula
  aluno_id INT NOT NULL, -- Identificador do aluno matriculado
  curso_id INT NOT NULL, -- Identificador do curso escolhido
  data_matricula DATE NOT NULL, -- Data em que a matrícula foi realizada
  STATUS ENUM('Ativo', 'Inativo') DEFAULT 'Ativo', -- Status da matrícula
  FOREIGN KEY (aluno_id) REFERENCES alunos(id), -- Chave estrangeira para alunos
  FOREIGN KEY (curso_id) REFERENCES cursos(id) -- Chave estrangeira para cursos
);

-- 4. Tabela de Professores
-- Contém os dados dos professores da instituição
CREATE TABLE professores (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do professor
  nome VARCHAR(100) NOT NULL, -- Nome completo do professor
  especialidade VARCHAR(100), -- Especialidade do professor (ex: Matemática, Física)
  salario DECIMAL(10, 2) -- Salário do professor
);

-- 5. Tabela de Aulas
-- Contém as informações sobre as aulas ministradas
CREATE TABLE aulas (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único da aula
  curso_id INT NOT NULL, -- Curso ao qual a aula pertence
  professor_id INT NOT NULL, -- Professor responsável pela aula
  data_aula DATE NOT NULL, -- Data da aula
  conteudo TEXT, -- Conteúdo programático da aula
  FOREIGN KEY (curso_id) REFERENCES cursos(id), -- Chave estrangeira para cursos
  FOREIGN KEY (professor_id) REFERENCES professores(id) -- Chave estrangeira para professores
);

-- INSERÇÃO DE DADOS

-- 1. Inserção de Alunos
INSERT INTO alunos (nome, data_nascimento, email, telefone) VALUES
('Ana Silva', '2002-05-15', 'ana.silva@gmail.com', '11988887777'),
('Carlos Almeida', '1998-11-30', 'carlos.almeida@yahoo.com', '11977776666'),
('Beatriz Rocha', '2001-07-21', NULL, '11966665555'),
('Marcos Santos', '1995-02-10', 'marcos.santos@hotmail.com', NULL);

-- 2. Inserção de Cursos
INSERT INTO cursos (nome, descricao, carga_horaria) VALUES
('Matemática Básica', 'Curso introdutório de matemática para iniciantes', 40),
('Física Avançada', 'Estudo avançado de mecânica e eletromagnetismo', 60),
('História Geral', 'Abordagem histórica global com foco em eventos mundiais', 50);

-- 3. Inserção de Matrículas
INSERT INTO matriculas (aluno_id, curso_id, data_matricula) VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-12'),
(3, 1, '2024-01-15'),
(4, 3, '2024-01-18');

-- 4. Inserção de Professores
INSERT INTO professores (nome, especialidade, salario) VALUES
('João Pereira', 'Matemática', 3500.00),
('Maria Fernandes', 'Física', 4000.00),
('Luciana Costa', 'História', 3000.00);

-- 5. Inserção de Aulas
INSERT INTO aulas (curso_id, professor_id, data_aula, conteudo) VALUES
(1, 1, '2024-02-01', 'Introdução à Aritmética'),
(2, 2, '2024-02-02', 'Leis de Newton'),
(3, 3, '2024-02-03', 'História Antiga'),
(1, 1, '2024-02-04', 'Geometria Básica');

-- CONSULTAS EXEMPLOS

-- 1. Listar os alunos matriculados em cada curso
SELECT 
  c.nome AS curso, 
  a.nome AS aluno
FROM matriculas m
INNER JOIN cursos c ON m.curso_id = c.id
INNER JOIN alunos a ON m.aluno_id = a.id;

-- 2. Listar os cursos com carga horária superior a 40 horas
SELECT nome, carga_horaria 
FROM cursos
WHERE carga_horaria > 40;

-- 3. Exibir as aulas programadas para um professor específico
SELECT 
  p.nome AS professor, 
  a.data_aula, 
  a.conteudo 
FROM aulas a
INNER JOIN professores p ON a.professor_id = p.id
WHERE p.nome = 'João Pereira';

-- 4. Exibir o número de alunos matriculados em cada curso
SELECT 
  c.nome AS curso, 
  COUNT(m.id) AS total_alunos
FROM cursos c
LEFT JOIN matriculas m ON c.id = m.curso_id
GROUP BY c.nome;

-- 5. Calcular o salário médio dos professores
SELECT AVG(salario) AS salario_medio 
FROM professores;

-- 6. Listar todos os alunos que não têm email cadastrado
SELECT nome 
FROM alunos
WHERE email IS NULL;

-- 7. Criar uma visão para listar os cursos e suas respectivas cargas horárias
CREATE VIEW vw_cursos_carga_horaria AS
SELECT nome, carga_horaria 
FROM cursos;

-- 8. Exibir as aulas de um curso específico
SELECT 
  c.nome AS curso, 
  a.data_aula, 
  a.conteudo 
FROM aulas a
INNER JOIN cursos c ON a.curso_id = c.id
WHERE c.nome = 'Matemática Básica';

-- 9. Exibir a quantidade de aulas ministradas por cada professor
SELECT 
  p.nome AS professor, 
  COUNT(a.id) AS total_aulas
FROM professores p
LEFT JOIN aulas a ON p.id = a.professor_id
GROUP BY p.nome;

-- 10. Criar uma visão para listar alunos e seus cursos
CREATE VIEW vw_alunos_cursos AS
SELECT 
  a.nome AS aluno, 
  c.nome AS curso
FROM matriculas m
INNER JOIN alunos a ON m.aluno_id = a.id
INNER JOIN cursos c ON m.curso_id = c.id;
