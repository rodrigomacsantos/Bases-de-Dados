-- =========================================================
-- Autores: Autores: Lourenço Luís (a22406954), Rodrigo Santos (22306575), Lucas Moura (a22305109), Filipe Condeça (22306955), Rúben Graça (22307816)
-- Projeto: Sistema de Gestão Documental (SGD)
-- Fase 2: Inserção de Dados e Funcionalidades Básicas
-- =========================================================

USE projeto;

-- Exercício 2.6: Tabela específica para Fatura com campos requeridos
CREATE TABLE Fatura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    documento_id INT UNIQUE NOT NULL,
    numero_documento VARCHAR(50) NOT NULL,
    nipc_vendedor VARCHAR(20) NOT NULL,
    nif_comprador VARCHAR(20) NOT NULL,
    data_fatura DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    requer_dupla_aprovacao BOOLEAN GENERATED ALWAYS AS (valor_total > 5000) STORED,
    FOREIGN KEY (documento_id) REFERENCES Documento(id)
);

-- Exercício 2.7: Tabela específica para Certidão com campos requeridos
CREATE TABLE Certidao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    documento_id INT UNIQUE NOT NULL,
    numero_documento VARCHAR(50) NOT NULL,
    nome_certidao VARCHAR(100) NOT NULL,
    data_expiracao DATE NOT NULL,
    FOREIGN KEY (documento_id) REFERENCES Documento(id)
);

-- Exercício 2.2: Inserção de 5 estados diferentes
INSERT INTO EstadoDocumento (nome, descricao, ordem) VALUES 
('Novo', 'Documento recém criado no sistema', 1),
('Em Processamento', 'Documento em análise', 2),
('Aprovado', 'Documento aprovado', 3),
('Rejeitado', 'Documento rejeitado', 4),
('Arquivado', 'Documento arquivado', 5);

-- Exercício 2.1: Inserção de 5 tipos de documentos diferentes
INSERT INTO TipoDocumento (nome, descricao, requer_aprovacao) VALUES 
('Fatura', 'Documento fiscal', TRUE),
('Nota Informativa', 'Comunicação interna', FALSE),
('Relatório', 'Documento de análise', TRUE),
('Certidão', 'Documento oficial', TRUE),
('Comunicado Interno', 'Comunicação geral', FALSE);

-- Exercício 2.3: Inserção de 5 Unidades Orgânicas
INSERT INTO UnidadeOrganica (nome, codigo) VALUES 
('Departamento Financeiro', 'DF'),
('Recursos Humanos', 'RH'),
('Marketing', 'MKT'),
('Tecnologia da Informação', 'TI'),
('Jurídico', 'JUR');

-- Exercício 2.4: Inserção de 10 utilizadores
INSERT INTO Utilizador (nome, email, unidade_organica_id, cargo, nivel_acesso) VALUES 
('João Silva', 'joao.silva@empresa.com', 1, 'Diretor Financeiro', 3),
('Maria Santos', 'maria.santos@empresa.com', 2, 'Gerente RH', 2),
('Pedro Oliveira', 'pedro.oliveira@empresa.com', 3, 'Coordenador', 2),
('Ana Costa', 'ana.costa@empresa.com', 4, 'Analista', 1),
('Carlos Mendes', 'carlos.mendes@empresa.com', 5, 'Advogado', 2),
('Mariana Rocha', 'mariana.rocha@empresa.com', 1, 'Analista Financeiro', 1),
('Ricardo Ferreira', 'ricardo.ferreira@empresa.com', 2, 'Assistente', 1),
('Sofia Martins', 'sofia.martins@empresa.com', 3, 'Designer', 1),
('André Pereira', 'andre.pereira@empresa.com', 4, 'Desenvolvedor', 1),
('Inês Almeida', 'ines.almeida@empresa.com', 5, 'Estagiário', 1);

-- Exercício 2.5: Inserção de 10 documentos com diferentes estados
INSERT INTO Documento (numero_documento, tipo_documento_id, estado_documento_id, unidade_organica_id, descricao) VALUES 
('DOC001', 1, 1, 1, 'Fatura de Serviços de Consultoria'),
('DOC002', 2, 2, 2, 'Nota Informativa sobre Reunião'),
('DOC003', 3, 3, 3, 'Relatório Trimestral de Marketing'),
('DOC004', 4, 4, 4, 'Certidão de Propriedade Intelectual'),
('DOC005', 5, 5, 5, 'Comunicado Interno de Gestão'),
('DOC006', 1, 2, 1, 'Fatura de Equipamentos'),
('DOC007', 2, 2, 2, 'Nota de Esclarecimento'),
('DOC008', 3, 3, 3, 'Relatório de Desempenho'),
('DOC009', 4, 3, 4, 'Certidão Negativa'),
('DOC010', 5, 5, 5, 'Comunicado de Procedimentos');

-- Exercício 2.6: Inserção de Faturas
INSERT INTO Fatura (documento_id, numero_documento, nipc_vendedor, nif_comprador, data_fatura, valor_total) VALUES 
(1, 'FAT001', '123456789', '987654321', '2024-01-15', 5500.00),
(6, 'FAT002', '234567890', '876543210', '2024-02-20', 7200.50);

-- Exercício 2.7: Inserção de Certidões
INSERT INTO Certidao (documento_id, numero_documento, nome_certidao, data_expiracao) VALUES 
(4, 'CERT001', 'Certidão de Propriedade', '2025-12-31'),
(9, 'CERT002', 'Certidão Negativa de Débitos', '2025-06-30');

-- Exercício 2.8: Registros adicionais para consistência
INSERT INTO LogAtividade (documento_id, acao, utilizador_id) VALUES
(1, 'Documento criado', 1),
(2, 'Documento em processamento', 2),
(3, 'Documento aprovado', 3);

INSERT INTO Notificacao (documento_id, destinatario_id, mensagem) VALUES
(1, 2, 'Novo documento para revisão'),
(2, 3, 'Documento requer sua atenção'),
(3, 4, 'Documento aprovado para seu conhecimento');

-- Exercício 3.1: Vista para documentos de uma UO com estados
CREATE VIEW DocumentosUOEstados AS
SELECT 
    d.numero_documento,
    uo.nome as unidade_organica,
    ed.nome as estado
FROM Documento d
JOIN UnidadeOrganica uo ON d.unidade_organica_id = uo.id
JOIN EstadoDocumento ed ON d.estado_documento_id = ed.id;

-- Exercício 3.2 a 3.8: Procedures para consultas
DELIMITER //

CREATE PROCEDURE DocumentosPorEstado(IN estado_nome VARCHAR(50))
BEGIN
    SELECT 
        d.numero_documento,
        uo.nome as unidade_organica
    FROM Documento d
    JOIN UnidadeOrganica uo ON d.unidade_organica_id = uo.id
    JOIN EstadoDocumento ed ON d.estado_documento_id = ed.id
    WHERE ed.nome = estado_nome;
END //

-- Exercício 3.3: Workflow completo de documento
CREATE PROCEDURE WorkflowDocumento(IN doc_numero VARCHAR(50))
BEGIN
    SELECT 
        la.data_hora,
        la.acao,
        u.nome as utilizador
    FROM LogAtividade la
    JOIN Documento d ON la.documento_id = d.id
    JOIN Utilizador u ON la.utilizador_id = u.id
    WHERE d.numero_documento = doc_numero
    ORDER BY la.data_hora;
END //

-- Exercício 3.4: Documentos por data
CREATE PROCEDURE DocumentosPorData(IN data_entrada DATE)
BEGIN
    SELECT 
        numero_documento,
        tipo_documento_id,
        estado_documento_id
    FROM Documento
    WHERE DATE(data_insercao) = data_entrada;
END //

DELIMITER ;