-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE sistema_hotel;
USE sistema_hotel;

-- TABELAS

-- 1. Tabela de Quartos
CREATE TABLE quartos (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do quarto
  numero INT NOT NULL UNIQUE, -- Número do quarto
  tipo VARCHAR(50) NOT NULL, -- Tipo do quarto (ex.: "Simples", "Luxo", "Suite")
  preco_diaria DECIMAL(10, 2) NOT NULL, -- Preço da diária
  STATUS VARCHAR(20) DEFAULT 'Disponível' -- Status do quarto (Disponível, Ocupado, etc.)
);

-- 2. Tabela de Clientes
CREATE TABLE clientes (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do cliente
  nome VARCHAR(100) NOT NULL, -- Nome completo do cliente
  email VARCHAR(100) UNIQUE, -- Email do cliente
  telefone VARCHAR(15), -- Telefone do cliente
  documento VARCHAR(20) UNIQUE NOT NULL -- Documento (CPF, RG, etc.)
);

-- 3. Tabela de Funcionários
CREATE TABLE funcionarios (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único do funcionário
  nome VARCHAR(100) NOT NULL, -- Nome completo do funcionário
  cargo VARCHAR(50), -- Cargo do funcionário
  salario DECIMAL(10, 2), -- Salário do funcionário
  data_admissao DATE NOT NULL -- Data de admissão
);

-- 4. Tabela de Reservas
CREATE TABLE reservas (
  id INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único da reserva
  cliente_id INT NOT NULL, -- Identificador do cliente
  quarto_id INT NOT NULL, -- Identificador do quarto
  funcionario_id INT, -- Funcionário que realizou a reserva
  data_checkin DATE NOT NULL, -- Data de entrada
  data_checkout DATE NOT NULL, -- Data de saída
  valor_total DECIMAL(10, 2) NOT NULL, -- Valor total da reserva
  STATUS VARCHAR(20) DEFAULT 'Pendente', -- Status da reserva (Pendente, Confirmada, Cancelada)
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (quarto_id) REFERENCES quartos(id),
  FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

-- INSERÇÃO DE DADOS

-- 1. Inserção de Quartos
INSERT INTO quartos (numero, tipo, preco_diaria, STATUS) VALUES
(101, 'Simples', 200.00, 'Disponível'),
(102, 'Luxo', 500.00, 'Disponível'),
(201, 'Suite', 800.00, 'Disponível');

-- 2. Inserção de Clientes
INSERT INTO clientes (nome, email, telefone, documento) VALUES
('Ana Silva', 'ana.silva@gmail.com', '11988887777', '12345678901'),
('Carlos Oliveira', 'carlos.oliveira@yahoo.com', '11977776666', '98765432100'),
('Beatriz Rocha', 'beatriz.rocha@hotmail.com', NULL, '11223344556');

-- 3. Inserção de Funcionários
INSERT INTO funcionarios (nome, cargo, salario, data_admissao) VALUES
('João Pereira', 'Recepcionista', 2500.00, '2020-01-15'),
('Maria Santos', 'Gerente', 4500.00, '2018-05-10');

-- 4. Inserção de Reservas
INSERT INTO reservas (cliente_id, quarto_id, funcionario_id, data_checkin, data_checkout, valor_total, STATUS) VALUES
(1, 101, 1, '2024-12-01', '2024-12-05', 800.00, 'Confirmada'),
(2, 102, 1, '2024-12-03', '2024-12-07', 2000.00, 'Pendente');

-- CONSULTAS EXEMPLOS

-- 1. Listar todos os quartos disponíveis
SELECT * FROM quartos WHERE STATUS = 'Disponível';

-- 2. Exibir todas as reservas e os nomes dos clientes que as realizaram
SELECT 
  r.id AS reserva_id, 
  c.nome AS cliente, 
  q.numero AS quarto, 
  r.data_checkin, 
  r.data_checkout, 
  r.valor_total, 
  r.status 
FROM reservas r
INNER JOIN clientes c ON r.cliente_id = c.id
INNER JOIN quartos q ON r.quarto_id = q.id;

-- 3. Listar clientes que possuem reservas pendentes
SELECT DISTINCT 
  c.nome AS cliente, 
  c.email 
FROM reservas r
INNER JOIN clientes c ON r.cliente_id = c.id
WHERE r.status = 'Pendente';

-- 4. Exibir o total de diárias de cada reserva
SELECT 
  r.id AS reserva_id, 
  c.nome AS cliente, 
  q.numero AS quarto, 
  DATEDIFF(r.data_checkout, r.data_checkin) AS total_diarias 
FROM reservas r
INNER JOIN clientes c ON r.cliente_id = c.id
INNER JOIN quartos q ON r.quarto_id = q.id;

-- 5. Calcular o valor médio das reservas confirmadas
SELECT AVG(valor_total) AS valor_medio 
FROM reservas 
WHERE STATUS = 'Confirmada';

-- 6. Exibir funcionários que realizaram reservas e o número de reservas feitas
SELECT 
  f.nome AS funcionario, 
  COUNT(r.id) AS total_reservas 
FROM funcionarios f
LEFT JOIN reservas r ON f.id = r.funcionario_id
GROUP BY f.nome;

-- 7. Criar uma visão para listar reservas e os detalhes do quarto
CREATE VIEW vw_reservas_quartos AS
SELECT 
  r.id AS reserva_id, 
  c.nome AS cliente, 
  q.numero AS quarto, 
  q.tipo, 
  r.data_checkin, 
  r.data_checkout, 
  r.valor_total 
FROM reservas r
INNER JOIN clientes c ON r.cliente_id = c.id
INNER JOIN quartos q ON r.quarto_id = q.id;

-- 8. Listar os tipos de quartos mais reservados
SELECT 
  q.tipo, 
  COUNT(r.id) AS total_reservas 
FROM quartos q
INNER JOIN reservas r ON q.id = r.quarto_id
GROUP BY q.tipo
ORDER BY total_reservas DESC;

-- 9. Exibir reservas que terminam em um intervalo de datas específico
SELECT 
  r.id AS reserva_id, 
  c.nome AS cliente, 
  r.data_checkout 
FROM reservas r
INNER JOIN clientes c ON r.cliente_id = c.id
WHERE r.data_checkout BETWEEN '2024-12-01' AND '2024-12-31';
