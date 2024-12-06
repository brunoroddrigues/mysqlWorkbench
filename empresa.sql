-- Criação do Banco de Dados 'empresa'
CREATE DATABASE empresa;
USE empresa;

-- Criação das Tabelas
CREATE TABLE departamentos (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada departamento
    nome VARCHAR(100) NOT NULL,                      -- Nome do departamento
    localizacao VARCHAR(100)                        -- Localização do departamento
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,  -- ID único para cada funcionário
    nome VARCHAR(100) NOT NULL,                      -- Nome do funcionário
    email VARCHAR(100) UNIQUE NOT NULL,              -- E-mail do funcionário
    telefone VARCHAR(15),                            -- Telefone do funcionário
    id_departamento INT,                            -- Departamento ao qual o funcionário pertence
    data_admissao DATE NOT NULL,                    -- Data de admissão
    salario DECIMAL(10, 2) NOT NULL,                 -- Salário do funcionário
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)  -- Relacionamento com a tabela departamentos
);

CREATE TABLE projetos (
    id_projeto INT PRIMARY KEY AUTO_INCREMENT,      -- ID único para cada projeto
    nome VARCHAR(100) NOT NULL,                      -- Nome do projeto
    descricao TEXT,                                  -- Descrição do projeto
    data_inicio DATE NOT NULL,                       -- Data de início do projeto
    data_fim DATE,                                   -- Data de fim do projeto (opcional)
    id_departamento INT,                             -- Departamento responsável pelo projeto
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)  -- Relacionamento com a tabela departamentos
);

CREATE TABLE alocacoes (
    id_alocacao INT PRIMARY KEY AUTO_INCREMENT,     -- ID único para cada alocação
    id_funcionario INT,                              -- ID do funcionário alocado ao projeto
    id_projeto INT,                                  -- ID do projeto ao qual o funcionário está alocado
    data_inicio DATE NOT NULL,                       -- Data de início da alocação no projeto
    data_fim DATE,                                   -- Data de término da alocação (opcional)
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(id_funcionario),  -- Relacionamento com a tabela funcionarios
    FOREIGN KEY (id_projeto) REFERENCES projetos(id_projeto)  -- Relacionamento com a tabela projetos
);

-- Inserção de Departamentos
INSERT INTO departamentos (nome, localizacao) VALUES 
('Recursos Humanos', 'São Paulo'),
('TI', 'Rio de Janeiro'),
('Financeiro', 'Belo Horizonte');

-- Inserção de Funcionários
INSERT INTO funcionarios (nome, email, telefone, id_departamento, data_admissao, salario) VALUES 
('Ana Souza', 'ana.souza@email.com', '11987654321', 1, '2020-05-15', 4500.00),
('Carlos Silva', 'carlos.silva@email.com', '11999887766', 2, '2021-03-10', 6000.00),
('Juliana Costa', 'juliana.costa@email.com', '11988776655', 3, '2022-07-25', 4000.00);

-- Inserção de Projetos
INSERT INTO projetos (nome, descricao, data_inicio, id_departamento) VALUES 
('Desenvolvimento Sistema', 'Desenvolvimento de sistema corporativo', '2024-01-01', 2),
('Campanha de Marketing', 'Campanha de marketing digital para 2024', '2024-02-01', 1);

-- Inserção de Alocações
INSERT INTO alocacoes (id_funcionario, id_projeto, data_inicio, data_fim) VALUES 
(1, 1, '2024-01-01', NULL),  -- Ana Souza alocada no projeto 'Desenvolvimento Sistema'
(2, 2, '2024-02-01', NULL),  -- Carlos Silva alocado no projeto 'Campanha de Marketing'
(3, 1, '2024-01-01', '2024-06-01');  -- Juliana Costa alocada no projeto 'Desenvolvimento Sistema'

-- Exemplo 1: Consulta de Funcionários por Departamento
-- Exibe todos os funcionários de um departamento específico (exemplo: TI).
SELECT f.nome AS funcionario, f.email, f.salario, d.nome AS departamento
FROM funcionarios f
INNER JOIN departamentos d ON f.id_departamento = d.id_departamento
WHERE d.nome = 'TI';

-- Exemplo 2: Consulta de Projetos por Departamento
-- Exibe todos os projetos de um departamento específico (exemplo: Recursos Humanos).
SELECT p.nome AS projeto, p.descricao, p.data_inicio, p.data_fim, d.nome AS departamento
FROM projetos p
INNER JOIN departamentos d ON p.id_departamento = d.id_departamento
WHERE d.nome = 'Recursos Humanos';

-- Exemplo 3: Consulta de Funcionários Alocados em Projetos
-- Exibe os funcionários alocados em um projeto específico (exemplo: 'Desenvolvimento Sistema').
SELECT f.nome AS funcionario, a.data_inicio, a.data_fim
FROM alocacoes a
INNER JOIN funcionarios f ON a.id_funcionario = f.id_funcionario
INNER JOIN projetos p ON a.id_projeto = p.id_projeto
WHERE p.nome = 'Desenvolvimento Sistema';

-- Exemplo 4: Consulta de Salários por Departamento
-- Exibe a média de salários dos funcionários por departamento.
SELECT d.nome AS departamento, AVG(f.salario) AS media_salarios
FROM funcionarios f
INNER JOIN departamentos d ON f.id_departamento = d.id_departamento
GROUP BY d.id_departamento;

-- Exemplo 5: Consulta de Funcionários e Projetos Alocados
-- Exibe os funcionários e os projetos em que estão alocados, incluindo datas de início e fim.
SELECT f.nome AS funcionario, p.nome AS projeto, a.data_inicio, a.data_fim
FROM alocacoes a
INNER JOIN funcionarios f ON a.id_funcionario = f.id_funcionario
INNER JOIN projetos p ON a.id_projeto = p.id_projeto;

-- Exemplo 6: Atualização de Data de Término de Alocação
-- Atualiza a data de término da alocação de um funcionário em um projeto.
UPDATE alocacoes
SET data_fim = '2024-07-01'
WHERE id_funcionario = 3 AND id_projeto = 1;

-- Exemplo 7: Consulta de Funcionários Não Alocados em Projetos
-- Exibe os funcionários que não estão alocados em nenhum projeto.
SELECT f.nome AS funcionario
FROM funcionarios f
LEFT JOIN alocacoes a ON f.id_funcionario = a.id_funcionario
WHERE a.id_projeto IS NULL;

-- Exemplo 8: Consulta de Departamentos com Número de Funcionários
-- Exibe os departamentos e o número de funcionários em cada um.
SELECT d.nome AS departamento, COUNT(f.id_funcionario) AS num_funcionarios
FROM departamentos d
LEFT JOIN funcionarios f ON f.id_departamento = d.id_departamento
GROUP BY d.id_departamento;

-- Exemplo 9: Consulta de Funcionários com Salário Acima da Média
-- Exibe os funcionários que têm salário acima da média do departamento.
SELECT f.nome AS funcionario, f.salario, d.nome AS departamento
FROM funcionarios f
INNER JOIN departamentos d ON f.id_departamento = d.id_departamento
WHERE f.salario > (SELECT AVG(salario) FROM funcionarios WHERE id_departamento = f.id_departamento);

-- Exemplo 10: Criação de uma View para Funcionários e Seus Projetos
-- Cria uma visualização para exibir funcionários e os projetos em que estão alocados.
CREATE VIEW vw_funcionarios_projetos AS
SELECT f.nome AS funcionario, p.nome AS projeto, a.data_inicio, a.data_fim
FROM alocacoes a
INNER JOIN funcionarios f ON a.id_funcionario = f.id_funcionario
INNER JOIN projetos p ON a.id_projeto = p.id_projeto;
